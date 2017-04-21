From: kernel test robot <fengguang.wu@intel.com>
Subject: [cpu/hotplug] d215aab82d:  [ INFO: possible circular locking
 dependency detected ]
Date: Fri, 21 Apr 2017 17:32:06 +0800
Message-ID: <58f9d196.MAI1Ehs5QU/exRig%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ"
Cc: LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wfg@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:26523 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1037219AbdDUJcP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 05:32:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp/hotplug

commit d215aab82d81974f438bfbc80aa437132f3c37c3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue Apr 18 19:05:06 2017 +0200
Commit:     Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu Apr 20 13:08:58 2017 +0200

    cpu/hotplug: Convert hotplug locking to percpu rwsem
    
    There are no more (known) nested calls to get_online_cpus() so it's
    possible to remove the nested call magic and convert the mutex to a
    percpu-rwsem, which speeds up get/put_online_cpus() significantly for the
    uncontended case.
    
    The contended case (write locked for hotplug operations) is slow anyway, so
    the slightly more expensive down_write of the percpu rwsem does not matter.
    
    [ peterz: Add lockdep assertions ]
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Sebastian Siewior <bigeasy@linutronix.de>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Link: http://lkml.kernel.org/r/20170418170554.382344438@linutronix.de

641693094e  perf: Avoid cpu_hotplug_lock r-r recursion
d215aab82d  cpu/hotplug: Convert hotplug locking to percpu rwsem
d215aab82d  cpu/hotplug: Convert hotplug locking to percpu rwsem
65ec919279  Merge branch 'x86/irq'
+----------------------------------------------------+------------+------------+------------+------------+
|                                                    | 641693094e | d215aab82d | d215aab82d | 65ec919279 |
+----------------------------------------------------+------------+------------+------------+------------+
| boot_successes                                     | 33         | 1          | 1          | 0          |
| boot_failures                                      | 0          | 12         | 12         | 11         |
| INFO:possible_circular_locking_dependency_detected | 0          | 12         | 12         | 11         |
+----------------------------------------------------+------------+------------+------------+------------+

[child1:349] uid changed! Was: 0, now 35957
[child0:342] child exiting.
Bailing main loop. Exit reason: UID changed.
[   69.250950] 
[   69.251227] ======================================================
[   69.252022] [ INFO: possible circular locking dependency detected ]
[   69.252715] 4.11.0-rc6-00240-gd215aab #1 Not tainted
[   69.253273] -------------------------------------------------------
[   69.254061] kworker/1:1/24 is trying to acquire lock:
[   69.254699]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffff811ee48e>] static_key_slow_dec+0x1e/0x80
[   69.255872] 
[   69.255872] but task is already holding lock:
[   69.256651]  (perf_sched_mutex){+.+...}, at: [<ffffffff811d6c0a>] perf_sched_delayed+0x1a/0x70
[   69.258146] 
[   69.258146] which lock already depends on the new lock.
[   69.258146] 
[   69.259516] 
[   69.259516] the existing dependency chain (in reverse order) is:
[   69.260566] 
[   69.260566] -> #2 (perf_sched_mutex){+.+...}:

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 450dd7177bd6ac5e70d22c5375ef482e9436a748 4f7d029b9bf009fbee76bb10c0c4351a1870d2f3 --
git bisect  bad 084d34b9fe3fa15fd649e66a7a8bcfc146c2863f  # 12:01  B      0     1   12   0  Merge 'tip/smp/hotplug' into devel-catchup-201704210032
git bisect good b3c310c5863b9563bdd08f8778989d99a9c449c8  # 12:26  G     11     0    0   0  Merge 'linux-review/Sjoerd-Simons/RFC-serial-core-Dynamic-minor-support/20170420-210045' into devel-catchup-201704210032
git bisect good e4708292510f96868aeb8daefb259298e33bdbcb  # 12:42  G     11     0    1   1  Merge 'linux-review/Leon-Romanovsky/IB-mlx5-Set-correct-SL-in-completion-for-RoCE/20170420-191557' into devel-catchup-201704210032
git bisect good 650306edb95f2ab1fa07685aaec9c0f74ee534b8  # 13:00  G     11     0    0   0  Merge 'pinchartl-media/omapdrm/fences' into devel-catchup-201704210032
git bisect good ab0d337bb7b090f67b1547a70b383f785c0bb9b1  # 13:35  G     10     0    0   0  Merge 'pinchartl-media/omapdrm/cache-flush' into devel-catchup-201704210032
git bisect good 379c171f26e4acafb52a805afc8d2e2bcc30784e  # 13:57  G     11     0    0   0  Merge 'tip/x86/boot' into devel-catchup-201704210032
git bisect good 8153f9ac43897f9f4786b30badc134fcc1a4fb11  # 14:28  G     10     0    0   0  ACPI/processor: Replace racy task affinity logic
git bisect good 91e555edde960481085a8a69ac32726a9f6df0c9  # 14:45  G     11     0    0   0  hwtracing/coresight-etm4x: Use cpuhp_setup_state_nocalls_cpuslocked()
git bisect good b4d1673371196dd9aebdd2f61d946165c777b931  # 15:03  G     11     0    0   0  PCI: Use cpu_hotplug_disable() instead of get_online_cpus()
git bisect good 82947f31231157d8ab70fa8961f23fd3887a3327  # 15:37  G     10     0    0   0  jump_label: Pull get_online_cpus() into generic code
git bisect good 641693094ee1568502280f95900f374b2226b51d  # 15:51  G     10     0    0   0  perf: Avoid cpu_hotplug_lock r-r recursion
git bisect  bad d215aab82d81974f438bfbc80aa437132f3c37c3  # 16:01  B      0     6   17   0  cpu/hotplug: Convert hotplug locking to percpu rwsem
# first bad commit: [d215aab82d81974f438bfbc80aa437132f3c37c3] cpu/hotplug: Convert hotplug locking to percpu rwsem
git bisect good 641693094ee1568502280f95900f374b2226b51d  # 16:16  G     30     0    0   0  perf: Avoid cpu_hotplug_lock r-r recursion
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad d215aab82d81974f438bfbc80aa437132f3c37c3  # 16:48  B      0     8   19   0  cpu/hotplug: Convert hotplug locking to percpu rwsem
# extra tests on HEAD of linux-devel/devel-catchup-201704210032
git bisect  bad 450dd7177bd6ac5e70d22c5375ef482e9436a748  # 16:48  B      0    11   26   1  0day head guard for 'devel-catchup-201704210032'
# extra tests on tree/branch tip/smp/hotplug
git bisect  bad d215aab82d81974f438bfbc80aa437132f3c37c3  # 16:50  B      0    12   24   0  cpu/hotplug: Convert hotplug locking to percpu rwsem
# extra tests with first bad commit reverted
git bisect good 202f4dd0635c28aea54fabc282b989b8f3b074f5  # 17:04  G     10     0    0   0  Revert "cpu/hotplug: Convert hotplug locking to percpu rwsem"
# extra tests on tree/branch tip/master
git bisect  bad 65ec9192791aafa1daad627da891417e9e948a18  # 17:26  B      0     2   13   0  Merge branch 'x86/irq'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-quantal-lkp-hsw01-3:20170421160022:x86_64-randconfig-b0-04210030:4.11.0-rc6-00240-gd215aab:1.gz"

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
9z/ujiLmdSwCzJcu3wIc/gJFRC3Lt4gBAA==

--=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-quantal-lkp-hsw01-3:20170421160022:x86_64-randconfig-b0-04210030:4.11.0-rc6-00240-gd215aab:1"

#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu kvm64
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.11.0-rc6-00240-gd215aab"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.11.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
CONFIG_NO_HZ_FULL_SYSIDLE=y
CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_DEBUG=y
# CONFIG_SOCK_CGROUP_DATA is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INITRAMFS_COMPRESSION=".gz"
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_USERFAULTFD is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_MEMBARRIER is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
CONFIG_PROFILING=y
CONFIG_KEXEC_CORE=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
CONFIG_GCC_PLUGIN_SANCOV=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
CONFIG_X86_X2APIC=y
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_NUMACHIP=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_QUEUED_LOCK_STAT is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
# CONFIG_XEN_512GB is not set
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_XEN_PVH=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_APB_TIMER=y
# CONFIG_DMI is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
# CONFIG_VM86 is not set
CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_I8K is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_FRAME_VECTOR=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
# CONFIG_KEXEC_VERIFY_SIG is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_DPTF_POWER=y
CONFIG_ACPI_EXTLOG=m
# CONFIG_PMIC_OPREGION is not set
CONFIG_ACPI_CONFIGFS=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_SFI_CPUFREQ=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT is not set

#
# PCI host controller drivers
#
CONFIG_VMD=y
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
# CONFIG_YENTA_ENE_TUNE is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_STREAM_PARSER is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
# CONFIG_DST_CACHE is not set
# CONFIG_GRO_CELLS is not set
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
CONFIG_TEST_ASYNC_DRIVER_PROBE=m
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPMI=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_NAND_HISI504=m
# CONFIG_MTD_NAND_MTK is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_MT81xx_NOR=m
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
CONFIG_SPI_INTEL_SPI=m
CONFIG_SPI_INTEL_SPI_PLATFORM=m
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
# CONFIG_PANEL is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_IDT_89HPESX=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=m

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
CONFIG_VOP_BUS=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
CONFIG_VOP=m
CONFIG_VHOST_RING=m
CONFIG_GENWQE=m
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_BEEPER=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_GPIO_DECODER=m
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=m
# CONFIG_INPUT_TPS65218_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9063_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_XEN_KBDDEV_FRONTEND is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_HYPERV_KEYBOARD is not set
# CONFIG_USERIO is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
CONFIG_DEVMEM=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_SERIAL_DEV_BUS=m
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=m
# CONFIG_SCR24X is not set
# CONFIG_MWAVE is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=y
CONFIG_TCG_XEN=m
CONFIG_TCG_CRB=m
CONFIG_TCG_VTPM_PROXY=m
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
CONFIG_I2C_EMEV2=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=y
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_MENZ127=y
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VX855 is not set

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=m

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_LP3943=m
# CONFIG_GPIO_MSIC is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_TPS65086=m
# CONFIG_GPIO_TPS65218 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_MERRIFIELD=y
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_RDC321X=y

#
# SPI or I2C GPIO expanders
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=m
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_AVS=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=y
# CONFIG_BATTERY_BQ27XXX is not set
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_LP8788=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_BQ25890=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GAUGE_LTC2941=m
CONFIG_BATTERY_GOLDFISH=m
CONFIG_BATTERY_RT5033=m
CONFIG_CHARGER_RT9455=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DELL_SMM is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC2990=y
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MAX31790=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_TC654 is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=m
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT7802=y
# CONFIG_SENSORS_NCT7904 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC3815=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_TPS40422=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHT3x=m
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=m
CONFIG_SENSORS_TMP108=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_XGENE=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=m
CONFIG_GENERIC_ADC_THERMAL=m
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X_I2C is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9062=m
CONFIG_MFD_DA9063=y
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_INTEL_LPSS=m
CONFIG_MFD_INTEL_LPSS_ACPI=m
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RT5033=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=m
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TI_LP873X is not set
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_CS47L24=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_PCI_SKELETON=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_DMA_SG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_VIDEO_TW5864=y
# CONFIG_VIDEO_TW68 is not set
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
# CONFIG_VIDEO_ZORAN_ZR36060 is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_DT3155=m

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVID is not set
# CONFIG_VIDEO_VIM2M is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
# CONFIG_RADIO_SI4713 is not set
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_TEA5764=m
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=m
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#

#
# Video encoders
#
CONFIG_VIDEO_ADV7175=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_LIB_RANDOM is not set

#
# Frame buffer Devices
#
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SM501=m
CONFIG_FB_IBM_GXT4500=m
CONFIG_FB_GOLDFISH=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_HYPERV is not set
CONFIG_FB_SM712=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_PM8941_WLED is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=m
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_HIDPP is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MAYFLASH=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_HYPERV_MOUSE=m
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_UDRAW_PS3=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m

#
# I2C HID support
#
CONFIG_I2C_HID=y

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=m
CONFIG_UWB_WHCI=m
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=m
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP3952=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_LP8860=m
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_LM355x=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_MTD=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_LEDS_TRIGGER_PANIC=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_ABB5ZES3=m
CONFIG_RTC_DRV_ABX80X=m
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=m
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS80031=m
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8010=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV8803=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_VRTC is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1685_FAMILY=m
# CONFIG_RTC_DRV_DS1685 is not set
# CONFIG_RTC_DRV_DS1689 is not set
CONFIG_RTC_DRV_DS17285=y
# CONFIG_RTC_DRV_DS17485 is not set
# CONFIG_RTC_DRV_DS17885 is not set
# CONFIG_RTC_DS1685_PROC_REGS is not set
# CONFIG_RTC_DS1685_SYSFS_REGS is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_BALLOON is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SCRUB_PAGES is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_XEN_MCE_LOG=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
CONFIG_STAGING=y
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
# CONFIG_COMEDI_ADDI_APCI_1516 is not set
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3120=m
# CONFIG_COMEDI_ADDI_APCI_3501 is not set
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
CONFIG_COMEDI_ADL_PCI7X3X=m
CONFIG_COMEDI_ADL_PCI8164=m
# CONFIG_COMEDI_ADL_PCI9111 is not set
# CONFIG_COMEDI_ADL_PCI9118 is not set
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1720=m
# CONFIG_COMEDI_ADV_PCI1723 is not set
CONFIG_COMEDI_ADV_PCI1724=m
CONFIG_COMEDI_ADV_PCI1760=m
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
CONFIG_COMEDI_AMPLC_PC236_PCI=m
# CONFIG_COMEDI_AMPLC_PC263_PCI is not set
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DAS08_PCI=m
CONFIG_COMEDI_DT3000=m
CONFIG_COMEDI_DYNA_PCI10XX=m
CONFIG_COMEDI_GSC_HPDI=m
# CONFIG_COMEDI_MF6X4 is not set
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_DAQBOARD2000=m
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
# CONFIG_COMEDI_CB_PCIDAS is not set
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
# CONFIG_COMEDI_ME4000 is not set
CONFIG_COMEDI_ME_DAQ=m
# CONFIG_COMEDI_NI_6527 is not set
CONFIG_COMEDI_NI_65XX=m
# CONFIG_COMEDI_NI_660X is not set
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_LABPC_PCI=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_8254=m
CONFIG_COMEDI_8255=m
# CONFIG_COMEDI_8255_SA is not set
# CONFIG_COMEDI_KCOMEDILIB is not set
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7606=m
# CONFIG_AD7606_IFACE_PARALLEL is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2x7x is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_FB_SM750=m
CONFIG_FB_XGI=m

#
# Speakup console speech
#
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ION=y
# CONFIG_ION_TEST is not set
# CONFIG_ION_DUMMY is not set
CONFIG_GOLDFISH_AUDIO=y
CONFIG_MTD_GOLDFISH_NAND=m
# CONFIG_DGNC is not set
CONFIG_GS_FPGABOOT=y
CONFIG_CRYPTO_SKEIN=m
# CONFIG_UNISYSSPAR is not set
# CONFIG_MOST is not set
CONFIG_GREYBUS=m
CONFIG_GREYBUS_BOOTROM=m
CONFIG_GREYBUS_HID=m
CONFIG_GREYBUS_LIGHT=m
CONFIG_GREYBUS_LOG=m
CONFIG_GREYBUS_LOOPBACK=m
CONFIG_GREYBUS_POWER=m
CONFIG_GREYBUS_RAW=m
CONFIG_GREYBUS_VIBRATOR=m
CONFIG_GREYBUS_BRIDGED_PHY=m
# CONFIG_GREYBUS_GPIO is not set
CONFIG_GREYBUS_I2C=m
# CONFIG_GREYBUS_PWM is not set
# CONFIG_GREYBUS_UART is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_SMO8800=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=m
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WIRELESS=m
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_TOSHIBA_HAPS=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
CONFIG_INTEL_SCU_IPC=y
# CONFIG_INTEL_SCU_IPC_UTIL is not set
CONFIG_INTEL_MID_POWER_BUTTON=m
# CONFIG_INTEL_MFLD_THERMAL is not set
CONFIG_INTEL_IPS=y
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=m
CONFIG_PVPANIC=y
CONFIG_INTEL_PMC_IPC=m
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_MLX_PLATFORM=y
CONFIG_MLX_CPLD_PLATFORM=m
CONFIG_PMC_ATOM=y
CONFIG_GOLDFISH_BUS=y
CONFIG_GOLDFISH_PIPE=m
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=m
CONFIG_CROS_EC_CHARDEV=m
CONFIG_CROS_EC_LPC=m
CONFIG_CROS_EC_PROTO=y
CONFIG_CROS_KBD_LED_BACKLIGHT=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=m
CONFIG_COMMON_CLK_SI5351=m
CONFIG_COMMON_CLK_CDCE706=m
# CONFIG_COMMON_CLK_CS2000_CP is not set
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PWM=m
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
# CONFIG_SOC_ZTE is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
CONFIG_DEVFREQ_GOV_PASSIVE=m

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX3355 is not set
CONFIG_EXTCON_QCOM_SPMI_MISC=y
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
CONFIG_EXTCON_USB_GPIO=m
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
CONFIG_IIO_SW_TRIGGER=y

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
CONFIG_DMARD09=m
CONFIG_DMARD10=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set
CONFIG_KXCJK1013=m
CONFIG_MC3230=y
CONFIG_MMA7455=m
CONFIG_MMA7455_I2C=m
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=y
CONFIG_MMA9551=y
CONFIG_MMA9553=m
# CONFIG_MXC4005 is not set
CONFIG_MXC6255=m
CONFIG_STK8312=m
# CONFIG_STK8BA50 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD799X=y
# CONFIG_HX711 is not set
CONFIG_LP8788_ADC=y
CONFIG_LTC2485=m
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=y
CONFIG_QCOM_SPMI_IADC=m
# CONFIG_QCOM_SPMI_VADC is not set
CONFIG_TI_ADC081C=y

#
# Amplifiers
#

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_IAQCORE is not set
# CONFIG_VZ89X is not set
CONFIG_IIO_CROS_EC_SENSORS_CORE=m
CONFIG_IIO_CROS_EC_SENSORS=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_MS_SENSORS_I2C=m

#
# SSP Sensor Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Counters
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=m
# CONFIG_AD5593R is not set
CONFIG_M62332=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

#
# IIO dummy driver
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_BMG160 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_MPU3050=m
CONFIG_MPU3050_I2C=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=m
CONFIG_MAX30100=m

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
CONFIG_HTS221=y
CONFIG_HTS221_I2C=y
# CONFIG_HTU21 is not set
CONFIG_SI7005=m
CONFIG_SI7020=y

#
# Inertial measurement units
#
CONFIG_BMI160=m
CONFIG_BMI160_I2C=m
# CONFIG_KMX61 is not set
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
# CONFIG_IIO_ST_LSM6DSX is not set

#
# Light sensors
#
CONFIG_ACPI_ALS=y
# CONFIG_ADJD_S311 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
CONFIG_APDS9960=m
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
CONFIG_CM32181=m
# CONFIG_CM3232 is not set
CONFIG_CM3323=y
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_ISL29018=y
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_JSA1212=m
CONFIG_RPR0521=y
# CONFIG_LTR501 is not set
# CONFIG_MAX44000 is not set
CONFIG_OPT3001=m
# CONFIG_PA12203001 is not set
CONFIG_SI1145=y
CONFIG_STK3310=y
CONFIG_TCS3414=m
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
CONFIG_VEML6070=y

#
# Magnetometer sensors
#
CONFIG_AK8975=m
# CONFIG_AK09911 is not set
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_MMC35240=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m

#
# Triggers - standalone
#
# CONFIG_IIO_HRTIMER_TRIGGER is not set
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_TIGHTLOOP_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Digital potentiometers
#
CONFIG_DS1803=m
CONFIG_MCP4531=y
CONFIG_TPL0102=y

#
# Digital potentiostats
#
CONFIG_LMP91000=y

#
# Pressure sensors
#
CONFIG_ABP060MG=y
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
# CONFIG_IIO_CROS_EC_BARO is not set
CONFIG_HID_SENSOR_PRESS=m
CONFIG_HP03=m
CONFIG_MPL115=m
CONFIG_MPL115_I2C=m
CONFIG_MPL3115=y
CONFIG_MS5611=m
# CONFIG_MS5611_I2C is not set
CONFIG_MS5637=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m
CONFIG_HP206C=m
# CONFIG_ZPA2326 is not set

#
# Lightning sensors
#

#
# Proximity and distance sensors
#
CONFIG_LIDAR_LITE_V2=m
# CONFIG_SX9500 is not set
CONFIG_SRF08=y

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_TMP006=m
CONFIG_TMP007=y
CONFIG_TSYS01=m
CONFIG_TSYS02D=m
CONFIG_NTB=y
CONFIG_NTB_AMD=y
CONFIG_NTB_INTEL=m
CONFIG_NTB_PINGPONG=y
CONFIG_NTB_TOOL=m
CONFIG_NTB_PERF=y
CONFIG_NTB_TRANSPORT=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
# CONFIG_VME_TSI148 is not set
# CONFIG_VME_FAKE is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=m
CONFIG_VME_PIO2=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_CROS_EC is not set
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
# CONFIG_PWM_LPSS_PLATFORM is not set
CONFIG_PWM_PCA9685=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_PXA_28NM_HSIC is not set
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_BCM_KONA_USB2_PHY=m
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=m
# CONFIG_MCB_LPC is not set

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=m

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_DEVICES="binder"
CONFIG_NVMEM=m
CONFIG_STM=y
# CONFIG_STM_DUMMY is not set
# CONFIG_STM_SOURCE_CONSOLE is not set
# CONFIG_STM_SOURCE_HEARTBEAT is not set
# CONFIG_INTEL_TH is not set

#
# FPGA Configuration Support
#
CONFIG_FPGA=m

#
# FSI support
#
CONFIG_FSI=m

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_UEFI_CPER=y
# CONFIG_EFI_DEV_PATH_PARSER is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=m
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_STACK_VALIDATION is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_ARCH_HAS_KCOV=y
CONFIG_KCOV=y
# CONFIG_KCOV_INSTRUMENT_ALL is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHED_INFO is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_WW_MUTEX_SELFTEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT_DELAY=3
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
CONFIG_CPU_HOTPLUG_STATE_CONTROL=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_TEST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_HEXDUMP=m
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_TEST_PRINTF is not set
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_HASH=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
CONFIG_TEST_UDELAY=y
# CONFIG_MEMTEST is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP_CORE is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEY_DH_OPERATIONS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_INTEL_TXT=y
CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
CONFIG_CRYPTO_ECDH=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
# CONFIG_CRYPTO_SHA1_MB is not set
# CONFIG_CRYPTO_SHA256_MB is not set
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=m
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_SG_SPLIT is not set
# CONFIG_SG_POOL is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y

--=_58f9d196.knXssdpsYRH0ahNd0g8kwDGxiL0EkAOdbKDnUlTWjiYfJQrQ--
