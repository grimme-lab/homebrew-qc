class Crest < Formula
  desc "Conformer-Rotamer Ensemble Sampling Tool"
  homepage "https://xtb-docs.readthedocs.io/en/latest/crest.html"
  url "https://github.com/grimme-lab/crest/archive/v2.11.2.tar.gz"
  sha256 "f17da872064eb64502ac24c19e431467940d98dcb1bd391f7267f412a0a79dab"
  license "LGPL-3.0-or-later"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "openblas"
  depends_on "xtb"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  patch :DATA

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dla_backend=openblas"
    meson_args << "-Dfortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/crest", "--version"
  end
end
__END__
diff --git a/src/confparse.f90 b/src/confparse.f90
index 666bcc1..8811d0a 100644
--- a/src/confparse.f90
+++ b/src/confparse.f90
@@ -1839,7 +1839,7 @@ subroutine parseflags(env,arg,nra)  !FOR THE CONFSCRIPT STANDALONE
 !----- additional checks and settings
       if(env%crestver .eq. crest_solv) bondconst = .false.
 
-      if(env%qcg_flag .eq. .true. .and. env%crestver .ne. crest_solv) then
+      if(env%qcg_flag .and. env%crestver .ne. crest_solv) then
          error stop 'At least one flag is only usable for QCG runtype. Exit.'
       end if
 
@@ -1848,7 +1848,7 @@ subroutine parseflags(env,arg,nra)  !FOR THE CONFSCRIPT STANDALONE
 !          env%runver=4
 !      end if
 
-      if(env%autozsort .eq. .true. .and. env%crestver.eq. crest_solv) then
+      if(env%autozsort .and. env%crestver.eq. crest_solv) then
           error stop 'Z sorting of the input is unavailable for -qcg runtyp.'
       end if
 
@@ -2288,12 +2288,12 @@ subroutine inputcoords_qcg(env,arg1,arg2)
       inputfile = trim(arg1)
       write(*,*)'Solute-file: ', arg1
       env%solu_file = arg1
-    else if (solu .and. ex11 .eq. .false.) then
+    else if (solu .and. .not.ex11) then
       call copy('solute','solute.old')
       inputfile = 'solute'
       write(*,'(/,1x,a)')'Solute-file: solute'
       env%solu_file = 'solute'
-    else if(ex12 .and. ex11 .eq. .false.)then !-- save coord as reference
+    else if(ex12 .and. .not.ex11)then !-- save coord as reference
       call copy('coord','coord.old')
       call copy('coord','solute')
       write(*,'(/,1x,a)')'Solute-file: coord'
@@ -2321,12 +2321,12 @@ subroutine inputcoords_qcg(env,arg1,arg2)
       inputfile = trim(arg2)
       write(*,*)'Solvent-file: ', arg2
       env%solv_file = arg2
-    else if (solv .and. ex21 .eq. .false.) then
+    else if (solv .and. .not.ex21) then
       call copy('solvent','solvent.old')
       inputfile = 'solvent'
       write(*,'(/,1x,a)')'Solvent-file: solvent'
       env%solv_file = 'solvent'
-    else if(ex22 .and. ex21 .eq. .false. )then !-- save coord as reference
+    else if(ex22 .and. .not.ex21)then !-- save coord as reference
       call copy('coord','coord.old')
       call copy('coord','solvent')
       inputfile = 'coord'
diff --git a/src/iomod.F90 b/src/iomod.F90
index a687cf5..a8afb67 100644
--- a/src/iomod.F90
+++ b/src/iomod.F90
@@ -528,7 +528,7 @@ subroutine write_wall(env,n1,rabc1,rabc12,fname)
   end if
   call write_cts(31,env%cts)
   call write_cts_biasext(31,env%cts)
-  if(env%cts%used .eq. .true.) then !Only, if user set constrians is an $end written
+  if(env%cts%used) then !Only, if user set constrians is an $end written
      write(31,'(a)') '$end'
   end if
 
diff --git a/src/qcg/solvtool.f90 b/src/qcg/solvtool.f90
index 35fea28..c6fc4ff 100644
--- a/src/qcg/solvtool.f90
+++ b/src/qcg/solvtool.f90
@@ -132,7 +132,7 @@ subroutine crest_solvtool(env, tim)
 !   Cleanup and deallocation
 !------------------------------------------------------------------------------
   if(env%scratchdir .ne. 'qcg_tmp') call qcg_cleanup(env)
-  if(env%keepModef .eq. .false.) call rmrf('qcg_tmp')
+  if(.not.env%keepModef) call rmrf('qcg_tmp')
   call solute%deallocate
   call solvent%deallocate
   call cluster%deallocate
@@ -216,7 +216,7 @@ subroutine qcg_setup(env,solu,solv)
 !---- Geometry preoptimization solute
   if (.not. env%nopreopt) then
     call wrc0('coord',solu%nat,solu%at,solu%xyz) !write coord for xtbopt routine
-    if(env%cts%used .eq. .true.) then
+    if(env%cts%used) then
         call wrc0('coord.ref',solu%nat,solu%at,solu%xyz) !write coord for xtbopt routine
     end if
 !    call wrc0('coord',solu%nat,solu%at,solu%xyz) !write coord for xtbopt routine
@@ -251,7 +251,7 @@ subroutine qcg_setup(env,solu,solv)
   write(*,*) 'Generating LMOs for solute'
   call xtb_lmo(env,'solute')!,solu%chrg)
   call grepval('xtb.out','| TOTAL ENERGY',e_there,solu%energy)
-  if (e_there .eq. .false.) then
+  if (.not.e_there) then
     write(*,*) 'Total Energy of solute not found'
   else
     write(*,outfmt) 'Total Energy of solute: ', solu%energy, ' Eh'
@@ -287,7 +287,7 @@ subroutine qcg_setup(env,solu,solv)
   call xtb_lmo(env,'solvent')!,solv%chrg)
 
   call grepval('xtb.out','| TOTAL ENERGY',e_there,solv%energy)
-  if (e_there .eq. .false.) then
+  if (.not.e_there) then
     write(*,'(1x,a)') 'Total Energy of solvent not found'
   else
     write(*,outfmt) 'Total energy of solvent:', solv%energy,' Eh'
@@ -413,6 +413,24 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
   character(len=20)          :: gfnver_tmp
   integer                    :: ich99,ich15,ich88
 
+  interface
+    subroutine both_ellipsout(fname,n,at,xyz,r1,r2)
+      use iso_fortran_env, only : wp => real64
+      use strucrd, only: i2e
+      implicit none
+
+      integer            :: i,j
+      integer            :: n,at(n)
+      real(wp)           :: dum(3)
+      real(wp)           :: rx,ry,rz 
+      real(wp)           :: xyz(3,n),r1(3)
+      real(wp), optional :: r2(3)
+      real               :: x,y,z,f,rr
+      character(len=*)   :: fname
+      integer            :: ich11  
+    end subroutine both_ellipsout
+  end interface
+
   call tim%start(5,'Grow')
 
   call pr_eval_solute()
@@ -473,7 +491,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
   call get_ellipsoid(env, solu, solv, clus,.false.)
   call xtb_lmo(env,'xtbopt.coord')!,clus%chrg)
   call grepval('xtb.out','| TOTAL ENERGY',e_there,clus%energy)
-  if (e_there .eq. .false.) then
+  if (.not.e_there) then
     write(*,'(1x,a)') 'Total Energy of cluster LMO computation not found'
   end if
   call rename('xtblmoinfo','cluster.lmo')
@@ -481,7 +499,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
 
   call both_ellipsout('twopot_1.coord',clus%nat,clus%at,clus%xyz,clus%ell_abc,solu%ell_abc)
 
-  do while (success .eq. .false.) !For restart with larger wall pot
+  do while (.not.success) !For restart with larger wall pot
     if(iter .eq. 1) then
        call xtb_iff(env, 'solute.lmo', 'solvent.lmo', solu, solv) !solu for nat of core pot. solv for outer ellips
 
@@ -540,7 +558,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
   success=.false.
 
 !--- Cluster restart, if interaction energy not negativ (wall pot. too small)
-  do while (success .eq. .false.)
+  do while (.not.success)
 !--- Cluster optimization
   call opt_cluster(env,solu,clus,'cluster.coord')
   call rdcoord('xtbopt.coord',clus%nat,clus%at,clus%xyz)
@@ -570,7 +588,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
   call wrc0 ('optimized_cluster.coord',clus%nat,clus%at,clus%xyz)
   e_each_cycle(iter) = clus%energy
 
-  if (e_there .eq. .false.) then
+  if (.not.e_there) then
     write(*,'(1x,a)') 'Total Energy of cluster not found.'
   end if
 
@@ -638,7 +656,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
     call grepval('xtb.out','| TOTAL ENERGY',e_there,clus%energy)
     call wrc0 ('optimized_cluster.coord',clus%nat,clus%at,clus%xyz)
 
-    if (e_there .eq. .false.) then
+    if (.not.e_there) then
       write(*,'(1x,a)') 'Total Energy of cluster not found.'
     else
       write(*,'(2x,''Total gfn2-energy of cluster/Eh:'',f20.6)') clus%energy
@@ -676,7 +694,7 @@ subroutine qcg_grow(env,solu,solv,clus,tim)
 
   call chdir(thispath)
   call chdir(env%scratchdir)
-  if(env%keepModef .eq. .false.) call rmrf('tmp_grow')
+  if(.not.env%keepModef) call rmrf('tmp_grow')
 
   call tim%stop(5)
 
@@ -723,6 +741,25 @@ subroutine qcg_ensemble(env,solu,solv,clus,ens,tim,fname_results)
   real(wp), allocatable      :: p(:)
   integer                    :: ich98,ich65,ich48
 
+  interface
+    subroutine aver(pr,env,runs,e_tot,S,H,G,sasa,a_present,a_tot)
+      use iso_fortran_env, only : wp => real64
+      use crest_data
+
+      implicit none
+      type(systemdata),intent(in)     :: env
+      integer, intent(in)             :: runs
+      real(wp), intent(inout)         :: e_tot
+      real(wp), intent(in), optional  :: a_tot
+      real(wp), intent(out)           :: S
+      real(wp), intent(out)           :: H
+      real(wp), intent(out)           :: G
+      real(wp), intent(out)           :: sasa
+      logical, intent(in)             :: pr,a_present
+      dimension e_tot(runs)
+      dimension a_tot(runs)
+    end subroutine aver
+  end interface
 
   if(.not.env%solv_md) then
     call tim%start(6,'Solute-Ensemble')
@@ -810,10 +847,10 @@ subroutine qcg_ensemble(env,solu,solv,clus,ens,tim,fname_results)
     case(0) !Crest runtype
 
       !Defaults
-      if(env%user_dumxyz .eq. .false.) then
+      if(.not.env%user_dumxyz) then
           env%mddumpxyz = 200
       end if
-      if(env%user_mdtime .eq. .false.)then
+      if(.not.env%user_mdtime)then
         env%mdtime = 10.0
       end if
 
@@ -835,23 +872,23 @@ subroutine qcg_ensemble(env,solu,solv,clus,ens,tim,fname_results)
     !--- Setting new defaults for MD/MTD in qcg
       if(env%mdtemp.lt.0.0d0)then
         newtemp=400.00d0 
-      else if(env%user_temp .eq. .false.) then
+      else if(.not.env%user_temp) then
         newtemp=298.0
       else
         newtemp=env%mdtemp
       endif
              
-      if(env%user_mdtime .eq. .false.)then
+      if(.not.env%user_mdtime)then
         newmdtime = 100.0 !100.0
       else
         newmdtime = env%mdtime
       end if
 
-      if(env%user_dumxyz .eq. .false.) then
+      if(.not.env%user_dumxyz) then
           env%mddumpxyz = 1000
       end if
 
-      if(env%user_mdstep .eq. .false.) then
+      if(.not.env%user_mdstep) then
         if(env%ensemble_opt .ne. '--gff') then
           newmdstep = 4.0d0
         else
@@ -1107,7 +1144,7 @@ subroutine qcg_ensemble(env,solu,solv,clus,ens,tim,fname_results)
   call chdir(tmppath2)
   write(comment,'(F20.8)') ens%er(minpos)
   inquire(file='crest_best.xyz',exist=ex)
-  if (ex .eq. .true.) then
+  if (ex) then
      call rmrf('crest_best.xyz') !remove crest_best from 
   end if
   call wrxyz('crest_best.xyz',clus%nat,clus%at,clus%xyz,comment)
@@ -1240,7 +1277,7 @@ subroutine qcg_ensemble(env,solu,solv,clus,ens,tim,fname_results)
 !---Deleting ensemble tmp
   call chdir(thispath)
   call chdir(env%scratchdir)
-  if(env%keepModef .eq. .false.) call rmrf(tmppath2)
+  if(.not.env%keepModef) call rmrf(tmppath2)
 !----Outprint
   write(*,*)
   write(*,'(2x,''Ensemble generation finished.'')') 
@@ -1320,6 +1357,26 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
   real(wp)                   :: optlev_tmp
   integer                    :: ich98,ich31
 
+  interface
+    subroutine aver(pr,env,runs,e_tot,S,H,G,sasa,a_present,a_tot)
+      use iso_fortran_env, only : wp => real64
+      use crest_data
+
+      implicit none
+      type(systemdata),intent(in)     :: env
+      integer, intent(in)             :: runs
+      real(wp), intent(inout)         :: e_tot
+      real(wp), intent(in), optional  :: a_tot
+      real(wp), intent(out)           :: S
+      real(wp), intent(out)           :: H
+      real(wp), intent(out)           :: G
+      real(wp), intent(out)           :: sasa
+      logical, intent(in)             :: pr,a_present
+      dimension e_tot(runs)
+      dimension a_tot(runs)
+    end subroutine aver
+  end interface
+
   call tim%start(8,'CFF')
 
   allocate(e_empty(env%nqcgclust))
@@ -1400,12 +1457,12 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
 
     iter=0    
 !--- Main cycle for addition of solvent molecules
-    convergence: do while (all_converged .eq. .false.)
+    convergence: do while (.not.all_converged)
       k=0
       iter = iter+1
   !--- Setting array, with only numbers of dirs that are not converged
       do i=1,env%nqcgclust
-         if(converged(i) .eq. .false.) then
+         if(.not.converged(i)) then
             k=k+1
             conv(k)=i
             conv(env%nqcgclust+1)=k !How many jobs are open
@@ -1420,7 +1477,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
 !-------------------------------------------------------------------------------------------
 
       do i=1,env%nqcgclust
-         if(converged(i) .eq. .false.) then
+         if(.not.converged(i)) then
             write(to,'("TMPCFF",i0)') i
             call chdir(to)
             call rename('xtblmoinfo','solvent_cluster.lmo')
@@ -1450,7 +1507,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
       clus%nmol = clus%nmol + 1
 
       do i=1,env%nqcgclust
-         if(converged(i) .eq. .false.) then
+         if(.not.converged(i)) then
             write(to,'("TMPCFF",i0)') i
             call chdir(to)
             call remove('xtbrestart')
@@ -1481,7 +1538,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
 !--- Check, if a structure was converged and iff was not necessary
       k=0
       do i=1,env%nqcgclust
-         if(converged(i) .eq. .false.) then
+         if(.not.converged(i)) then
             k=k+1
             conv(k)=i
             conv(env%nqcgclust+1)=k !How many jobs are open
@@ -1496,7 +1553,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
 !----------------------------------------------------------------------------------------------
 
       do i=1,env%nqcgclust
-         if(converged(i) .eq. .false.) then
+         if(.not.converged(i)) then
             write(to,'("TMPCFF",i0)') i
             call chdir(to)
             call copy('xtbopt.coord','solvent_cluster.coord') 
@@ -1523,7 +1580,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
     !--- Check if everything is converged
       dum = 0
       do i=1, env%nqcgclust
-         if (converged(1) .eq. .true.) then
+         if (converged(1)) then
             dum = dum + 1
          end if
       end do
@@ -1660,7 +1717,7 @@ subroutine qcg_cff(env,solu,solv,clus,ens,solv_ens,tim)
   call copysub('crest_best.xyz', resultspath)
   call copysub('population.dat', resultspath)
   call chdir(tmppath)
-  if(env%keepModef .eq. .false.) call rmrf('tmp_CFF')
+  if(.not.env%keepModef) call rmrf('tmp_CFF')
   call chdir(thispath)
 
 !--- Printouts
@@ -1789,7 +1846,7 @@ subroutine qcg_freq(env,tim,solu,solv,solu_ens,solv_ens)
      call chdir(tmppath2)
 
       !--- Solvent cluster (only if cff, than the solvent shell is taken, which was fixed all the time)
-    if(env%cff .eq. .true.) then
+    if(env%cff) then
       call chdir('tmp_solv')
       write(to,'("TMPFREQ",i0)') i
       io = makedir(trim(to))
@@ -1810,7 +1867,7 @@ subroutine qcg_freq(env,tim,solu,solv,solu_ens,solv_ens)
   call chdir(tmppath2)
 
   write(*,*) '  SOLVENT CLUSTER'
-  if(env%cff .eq. .true.) then
+  if(env%cff) then
      call chdir('tmp_solv')
      call ens_freq(env,'solvent_cut.coord',solu_ens%nall,'TMPFREQ')
      call chdir(tmppath2)
@@ -1819,7 +1876,7 @@ subroutine qcg_freq(env,tim,solu,solv,solu_ens,solv_ens)
   call clus%deallocate()
 
   !--- Frequencies solvent cluster (only, if not cff was used)
-  if (env%cff .eq. .false.) then
+  if (.not.env%cff) then
   call chdir('tmp_solv')
   call solv_ens%write('solvent_ensemble.xyz')
 
@@ -1928,7 +1985,7 @@ subroutine qcg_freq(env,tim,solu,solv,solu_ens,solv_ens)
 
 !--- Deleting tmp directory
   call chdir(tmppath)
-  if(env%keepModef .eq. .false.) call rmrf(tmppath2)
+  if(.not.env%keepModef) call rmrf(tmppath2)
   call chdir(thispath)
 
   env%gfnver = gfnver_tmp
@@ -1978,6 +2035,26 @@ subroutine qcg_eval(env,solu,solu_ens,solv_ens)
   integer                    :: ich23
   real(wp),parameter         :: eh     = 627.509541d0
 
+  interface
+    subroutine aver(pr,env,runs,e_tot,S,H,G,sasa,a_present,a_tot)
+      use iso_fortran_env, only : wp => real64
+      use crest_data
+
+      implicit none
+      type(systemdata),intent(in)     :: env
+      integer, intent(in)             :: runs
+      real(wp), intent(inout)         :: e_tot
+      real(wp), intent(in), optional  :: a_tot
+      real(wp), intent(out)           :: S
+      real(wp), intent(out)           :: H
+      real(wp), intent(out)           :: G
+      real(wp), intent(out)           :: sasa
+      logical, intent(in)             :: pr,a_present
+      dimension e_tot(runs)
+      dimension a_tot(runs)
+    end subroutine aver
+  end interface
+
   call pr_eval_eval()
 
   call getcwd(thispath)
@@ -2105,7 +2182,7 @@ subroutine write_qcg_setup(env)
      write(*,'(2x,''Solvation model        : '',a)') env%solvent
   end if
   write(*,'(2x,''xtb opt level          : '',a)') trim(optlevflag(env%optlev))
-  if(env%user_temp .eq. .false.)then
+  if(.not.env%user_temp)then
     write(*,'(2x,''System temperature [K] : ''a)') '298.0'
   else
     write(*,'(2x,''System temperature [K] : '',F5.1)') env%mdtemps(1)
@@ -2776,7 +2853,7 @@ subroutine rdtherm(fname,ht,svib,srot,stra,gt)
   hg_line = 0
 
   open(newunit=ich,file=fname)
-  do while (ende == .false.)
+  do while (.not.ende)
      read(ich,'(a)',iostat=io) a
      if(io.lt.0)then
        ende = .true.
