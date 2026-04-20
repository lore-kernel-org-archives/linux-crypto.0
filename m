Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60641376468;
	Mon, 20 Apr 2026 01:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776649743; cv=none; b=iVqa7k6s31i+vbiIva4X5EFNgI/kUepdIvXrXzYo+OWMayX9Oc6ltsw/mEXasnoQGykkLmbGNp5+VdHL4dYGKJEdGNoELxK7G0uk89mabg6oQTm6ueix1MGqtW0Vzf6NSXjFTmeoliXvsk6WC+NcmcPdHxuyI4DiInobWHEaVLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776649743; c=relaxed/simple;
	bh=ebH5f8GGYpk+JNWN/CnYahq/Cl7JSsLZ83fTC8cR2oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=coUstgA+lzKeu2dOBCq66ZcLYWTtD9dp2C/P0XzoFf3xSbgaFefIICtkQWWrS9ywLhBVlNcnyhVkDEklFNvU9uM5gcaJvvazvtRvBLSeOIVplqJe/FnrtLwjuF7/NISg349t8GReo9D6TAmI395iJjJD3wA99Fy3S/zeYlbWgPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nk8mB8U3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nk8mB8U3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776649741; x=1808185741;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ebH5f8GGYpk+JNWN/CnYahq/Cl7JSsLZ83fTC8cR2oE=;
  b=nk8mB8U3VH0UqTvf4oZ7x3Ud+rBAnSH0zCLx9zZDFAs6HeciB7CuFbIB
   4iVGdFgcRZHp2n4Jrqv/KIRbfdzYs1MTXS1TZL4abtJtIXX+C2K/ruef4
   fkxmUlx4G8ZcFvC7tW24+pvUQE+x6AwpqCzXuvPSZqQlMej/gJOoEVv7f
   HAmaNv9zQAm4DSEh0HJTkmtHjX+Gu+5lbry84YvpsbwIHBi3KPP2n1UgM
   9NIrfJ+036HOM9hX7kEbUL+xHskYOx+42G//vJSOLPnX03r02cswpyBoM
   CuphKrGccjliPm5/VXllMbzoO/Lq7ALZLnPBRLBkrG8R69GusnmS9ubBC
   w==;
X-CSE-ConnectionGUID: gnXDRcwdTLKY+1YJ4Vf8Iw==
X-CSE-MsgGUID: 3z5rL5ZYQVuPW066bnpBzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77684884"
X-IronPort-AV: E=Sophos;i="6.23,189,1770624000"; 
   d="scan'208";a="77684884"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2026 18:48:35 -0700
X-CSE-ConnectionGUID: ynOjDndbSG2fwD9bjbpdwQ==
X-CSE-MsgGUID: 0aNlJi2NSzyABngJDnR5+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,189,1770624000"; 
   d="scan'208";a="236569066"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 19 Apr 2026 18:47:20 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wEdjI-000000001zU-0Qzv;
	Mon, 20 Apr 2026 01:47:16 +0000
Date: Mon, 20 Apr 2026 09:46:31 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Thomas Graf <tgraf@suug.ch>,
	David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: Re: [PATCH] rhashtable: Restore insecure_elasticity toggle
Message-ID: <202604200210.OEDP0u1Y-lkp@intel.com>
References: <aeLgjAeJuidWNy3N@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2zPSTveijpLLSn4Z"
Content-Disposition: inline
In-Reply-To: <aeLgjAeJuidWNy3N@gondor.apana.org.au>


--2zPSTveijpLLSn4Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on net/main net-next/main linus/master horms-ipvs/master v7.0 next-20260417]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/rhashtable-Restore-insecure_elasticity-toggle/20260418-233732
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/aeLgjAeJuidWNy3N%40gondor.apana.org.au
patch subject: [PATCH] rhashtable: Restore insecure_elasticity toggle
config: alpha-allnoconfig
compiler: alpha-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build):

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604200210.OEDP0u1Y-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from lib/rhashtable.c:25:
   include/linux/rhashtable.h: In function '__rhashtable_insert_fast':
>> include/linux/rhashtable.h:831:39: error: invalid type argument of '->' (have 'struct rhashtable_params')
     831 |         if (elasticity <= 0 && !params->insecure_elasticity)
         |                                       ^~
   include/linux/rhashtable.h:839:20: error: invalid type argument of '->' (have 'struct rhashtable_params')
     839 |             !params->insecure_elasticity)
         |                    ^~
   lib/rhashtable.c: In function 'rhashtable_lookup_one':
>> lib/rhashtable.c:541:38: error: invalid type argument of '->' (have 'struct rhashtable_params')
     541 |         if (elasticity <= 0 && !ht->p->insecure_elasticity)
         |                                      ^~
   lib/rhashtable.c: In function 'rhashtable_insert_one':
   lib/rhashtable.c:572:19: error: invalid type argument of '->' (have 'struct rhashtable_params')
     572 |             !ht->p->insecure_elasticity)
         |                   ^~


vim +831 include/linux/rhashtable.h

   756	
   757	/* Internal function, please use rhashtable_insert_fast() instead. This
   758	 * function returns the existing element already in hashes if there is a clash,
   759	 * otherwise it returns an error via ERR_PTR().
   760	 */
   761	static __always_inline void *__rhashtable_insert_fast(
   762		struct rhashtable *ht, const void *key, struct rhash_head *obj,
   763		const struct rhashtable_params params, bool rhlist)
   764	{
   765		struct rhashtable_compare_arg arg = {
   766			.ht = ht,
   767			.key = key,
   768		};
   769		struct rhash_lock_head __rcu **bkt;
   770		struct rhash_head __rcu **pprev;
   771		struct bucket_table *tbl;
   772		struct rhash_head *head;
   773		unsigned long flags;
   774		unsigned int hash;
   775		int elasticity;
   776		void *data;
   777	
   778		rcu_read_lock();
   779	
   780		tbl = rht_dereference_rcu(ht->tbl, ht);
   781		hash = rht_head_hashfn(ht, tbl, obj, params);
   782		elasticity = RHT_ELASTICITY;
   783		bkt = rht_bucket_insert(ht, tbl, hash);
   784		data = ERR_PTR(-ENOMEM);
   785		if (!bkt)
   786			goto out;
   787		pprev = NULL;
   788		flags = rht_lock(tbl, bkt);
   789	
   790		if (unlikely(rcu_access_pointer(tbl->future_tbl))) {
   791	slow_path:
   792			rht_unlock(tbl, bkt, flags);
   793			rcu_read_unlock();
   794			return rhashtable_insert_slow(ht, key, obj);
   795		}
   796	
   797		rht_for_each_from(head, rht_ptr(bkt, tbl, hash), tbl, hash) {
   798			struct rhlist_head *plist;
   799			struct rhlist_head *list;
   800	
   801			elasticity--;
   802			if (!key ||
   803			    (params.obj_cmpfn ?
   804			     params.obj_cmpfn(&arg, rht_obj(ht, head)) :
   805			     rhashtable_compare(&arg, rht_obj(ht, head)))) {
   806				pprev = &head->next;
   807				continue;
   808			}
   809	
   810			data = rht_obj(ht, head);
   811	
   812			if (!rhlist)
   813				goto out_unlock;
   814	
   815	
   816			list = container_of(obj, struct rhlist_head, rhead);
   817			plist = container_of(head, struct rhlist_head, rhead);
   818	
   819			RCU_INIT_POINTER(list->next, plist);
   820			head = rht_dereference_bucket(head->next, tbl, hash);
   821			RCU_INIT_POINTER(list->rhead.next, head);
   822			if (pprev) {
   823				rcu_assign_pointer(*pprev, obj);
   824				rht_unlock(tbl, bkt, flags);
   825			} else
   826				rht_assign_unlock(tbl, bkt, obj, flags);
   827			data = NULL;
   828			goto out;
   829		}
   830	
 > 831		if (elasticity <= 0 && !params->insecure_elasticity)
   832			goto slow_path;
   833	
   834		data = ERR_PTR(-E2BIG);
   835		if (unlikely(rht_grow_above_max(ht, tbl)))
   836			goto out_unlock;
   837	
   838		if (unlikely(rht_grow_above_100(ht, tbl)) &&
   839		    !params->insecure_elasticity)
   840			goto slow_path;
   841	
   842		/* Inserting at head of list makes unlocking free. */
   843		head = rht_ptr(bkt, tbl, hash);
   844	
   845		RCU_INIT_POINTER(obj->next, head);
   846		if (rhlist) {
   847			struct rhlist_head *list;
   848	
   849			list = container_of(obj, struct rhlist_head, rhead);
   850			RCU_INIT_POINTER(list->next, NULL);
   851		}
   852	
   853		atomic_inc(&ht->nelems);
   854		rht_assign_unlock(tbl, bkt, obj, flags);
   855	
   856		if (rht_grow_above_75(ht, tbl))
   857			schedule_work(&ht->run_work);
   858	
   859		data = NULL;
   860	out:
   861		rcu_read_unlock();
   862	
   863		return data;
   864	
   865	out_unlock:
   866		rht_unlock(tbl, bkt, flags);
   867		goto out;
   868	}
   869	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--2zPSTveijpLLSn4Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

reproduce (this is a W=1 build):
        git remote add akpm-mm https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git
        git fetch akpm-mm mm-nonmm-unstable
        git checkout akpm-mm/mm-nonmm-unstable
        b4 shazam https://lore.kernel.org/r/aeLgjAeJuidWNy3N@gondor.apana.org.au

        git clone https://github.com/intel/lkp-tests.git ~/lkp-tests

        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-15.2.0 ~/lkp-tests/kbuild/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-15.2.0 ~/lkp-tests/kbuild/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash lib/ 

--2zPSTveijpLLSn4Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated file; DO NOT EDIT.
# Linux/alpha 7.0.0-rc5 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="alpha-linux-gcc (GCC) 15.2.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=150200
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24500
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24500
CONFIG_LLD_VERSION=0
CONFIG_RUSTC_VERSION=0
CONFIG_RUSTC_LLVM_VERSION=0
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_ASSUME=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_CC_HAS_COUNTED_BY=y
CONFIG_CC_HAS_MULTIDIMENSIONAL_NONSTRING=y
CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY=y
CONFIG_PAHOLE_VERSION=131
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_BUILD_SALT=""
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_WATCH_QUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
# end of IRQ subsystem

CONFIG_GENERIC_CLOCKEVENTS=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
# CONFIG_POSIX_AUX_CLOCKS is not set
# end of Timers subsystem

#
# BPF subsystem
#
# CONFIG_BPF_SYSCALL is not set
# end of BPF subsystem

CONFIG_PREEMPT_NONE_BUILD=y
CONFIG_PREEMPT_NONE=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_TINY_SRCU=y
# end of RCU Subsystem

# CONFIG_IKCONFIG is not set
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=17

#
# Scheduler features
#
# end of Scheduler features

CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC10_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_GCC_NO_STRINGOP_OVERFLOW=y
CONFIG_CC_NO_STRINGOP_OVERFLOW=y
# CONFIG_CGROUPS is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_BOOT_CONFIG is not set
CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN=1021
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_MULTIUSER=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_FUTEX_PRIVATE_HASH=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_CACHESTAT_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
# end of Kernel Performance Events And Counters

# CONFIG_PROFILING is not set

#
# Kexec and crash features
#
# end of Kexec and crash features

#
# Live Update and Kexec HandOver
#
# end of Live Update and Kexec HandOver
# end of General setup

CONFIG_ALPHA=y
CONFIG_64BIT=y
CONFIG_MMU=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_PGTABLE_LEVELS=3
CONFIG_AUDIT_ARCH=y

#
# System setup
#
CONFIG_ALPHA_GENERIC=y
# CONFIG_ALPHA_ALCOR is not set
# CONFIG_ALPHA_DP264 is not set
# CONFIG_ALPHA_EIGER is not set
# CONFIG_ALPHA_LX164 is not set
# CONFIG_ALPHA_MARVEL is not set
# CONFIG_ALPHA_MIATA is not set
# CONFIG_ALPHA_MIKASA is not set
# CONFIG_ALPHA_NAUTILUS is not set
# CONFIG_ALPHA_NORITAKE is not set
# CONFIG_ALPHA_PC164 is not set
# CONFIG_ALPHA_RAWHIDE is not set
# CONFIG_ALPHA_RUFFIAN is not set
# CONFIG_ALPHA_RX164 is not set
# CONFIG_ALPHA_SX164 is not set
# CONFIG_ALPHA_SABLE is not set
# CONFIG_ALPHA_SHARK is not set
# CONFIG_ALPHA_TAKARA is not set
# CONFIG_ALPHA_TITAN is not set
# CONFIG_ALPHA_WILDFIRE is not set
CONFIG_ISA=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ALPHA_BROKEN_IRQ_MASK=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_SMP is not set
# CONFIG_ARCH_SPARSEMEM_ENABLE is not set
# CONFIG_ALPHA_WTINT is not set
# CONFIG_VERBOSE_MCHECK is not set
# CONFIG_HZ_32 is not set
# CONFIG_HZ_64 is not set
# CONFIG_HZ_128 is not set
# CONFIG_HZ_256 is not set
CONFIG_HZ_1024=y
# CONFIG_HZ_1200 is not set
CONFIG_HZ=1024
# CONFIG_SRM_ENV is not set
# end of System setup

CONFIG_DUMMY_CONSOLE=y
CONFIG_CPU_MITIGATIONS=y
CONFIG_ARCH_HAS_DMA_OPS=y

#
# General architecture-dependent options
#
CONFIG_HAVE_64BIT_ALIGNED_ACCESS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_32BIT_USTAT_F_TINODE=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_NO_RANGE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_PAGE_SIZE_8KB=y
CONFIG_PAGE_SIZE_8KB=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_PAGE_SHIFT=13
CONFIG_ISA_BUS_API=y
CONFIG_ODD_RT_SIGACTION=y
CONFIG_OLD_SIGSUSPEND=y
# CONFIG_COMPAT_32BIT_TIME is not set
CONFIG_ARCH_NO_PREEMPT=y
CONFIG_CPU_NO_EFFICIENT_FFS=y

#
# GCOV-based kernel profiling
#
# end of GCOV-based kernel profiling

CONFIG_FUNCTION_ALIGNMENT=0
CONFIG_CC_HAS_MIN_FUNCTION_ALIGNMENT=y
CONFIG_CC_HAS_SANE_FUNCTION_ALIGNMENT=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLOCK_LEGACY_AUTOLOAD is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_WRITE_MOUNTED is not set
# CONFIG_BLK_DEV_ZONED is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_OSF_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

#
# IO Schedulers
#
# CONFIG_MQ_IOSCHED_DEADLINE is not set
# CONFIG_MQ_IOSCHED_KYBER is not set
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y

#
# Executable file formats
#
# CONFIG_BINFMT_ELF is not set
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
# CONFIG_SWAP is not set

#
# Slab allocator options
#
CONFIG_SLUB=y
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLAB_BUCKETS is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_RANDOM_KMALLOC_CACHES is not set
# end of Slab allocator options

# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_FLATMEM=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
# CONFIG_COMPACTION is not set
# CONFIG_PAGE_REPORTING is not set
CONFIG_PCP_BATCH_SCALE_MAX=5
CONFIG_PHYS_ADDR_T_64BIT=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_PAGE_MAPCOUNT=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CMA is not set
CONFIG_PAGE_BLOCK_MAX_ORDER=10
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ZONE_DMA=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set

#
# GUP_TEST needs to have DEBUG_FS enabled
#
# CONFIG_DMAPOOL_TEST is not set
# CONFIG_ANON_VMA_NAME is not set
# CONFIG_USERFAULTFD is not set
# CONFIG_LRU_GEN is not set
CONFIG_LOCK_MM_AND_FIND_VMA=y
CONFIG_PT_RECLAIM=y

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

# CONFIG_NET is not set

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_FORCE_PCI=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_TSM is not set
# CONFIG_PCI_DOE is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCIE_TPH is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#

#
# Cadence-based PCIe controllers
#
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers

#
# PLDA-based PCIe controllers
#
# end of PLDA-based PCIe controllers
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCI_PWRCTRL_SLOT is not set
# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_FW_LOADER_COMPRESS is not set
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

# CONFIG_GOOGLE_FIRMWARE is not set

#
# Qualcomm firmware drivers
#
# end of Qualcomm firmware drivers

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_FWCTL is not set
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
# CONFIG_PNP is not set
# CONFIG_BLK_DEV is not set

#
# NVME Support
#
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TARGET is not set
# end of NVME Support

#
# Misc devices
#
# CONFIG_DUMMY_IRQ is not set
# CONFIG_PHANTOM is not set
# CONFIG_RPMB is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
# CONFIG_NTSYNC is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Altera FPGA firmware download module (requires I2C)
#
# CONFIG_INTEL_MEI is not set
# CONFIG_GENWQE is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_PVPANIC is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# end of SCSI device support

# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_LEGACY_TIOCSTI is not set
# CONFIG_LDISC_AUTOLOAD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# end of Serial drivers

# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_NULL_TTY is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_DTLK is not set
# CONFIG_APPLICOM is not set
# CONFIG_DEVMEM is not set
# CONFIG_DEVPORT is not set
# CONFIG_TCG_TPM is not set
# CONFIG_XILLYBUS is not set
# end of Character devices

#
# I2C support
#
# CONFIG_I2C is not set
# end of I2C support

# CONFIG_I3C is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
# CONFIG_PPS is not set

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK_OPTIONAL=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# end of PTP clock support

#
# DPLL device support
#
# end of DPLL device support

# CONFIG_PINCTRL is not set
CONFIG_GPIOLIB_LEGACY=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_SEQUENCING is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_MADERA is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TQMX86 is not set
# CONFIG_MFD_VX855 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AUXDISPLAY is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
# CONFIG_LCD_CLASS_DEVICE is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# end of Backlight & LCD device support

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
# end of Console display driver support

# CONFIG_TRACE_GPU_MEM is not set
# end of Graphics support

# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
# CONFIG_SYNC_FILE is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_VIRTIO_MENU is not set
# CONFIG_VHOST_MENU is not set

#
# Microsoft Hyper-V guest support
#
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_GPIB is not set
# CONFIG_STAGING is not set
# CONFIG_GOLDFISH is not set
# CONFIG_COMMON_CLK is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

# CONFIG_WPCM450_SOC is not set

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

#
# PM Domains
#

#
# Amlogic PM Domains
#
# end of Amlogic PM Domains

#
# Broadcom PM Domains
#
# end of Broadcom PM Domains

#
# i.MX PM Domains
#
# end of i.MX PM Domains

#
# Qualcomm PM Domains
#
# end of Qualcomm PM Domains
# end of PM Domains

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set
# CONFIG_RAS is not set
# CONFIG_USB4 is not set

#
# Android
#
# end of Android

# CONFIG_DAX is not set
# CONFIG_NVMEM is not set

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
# CONFIG_FS_VERITY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS3_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

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
# CONFIG_TMPFS is not set
# CONFIG_CONFIGFS_FS is not set
# end of Pseudo filesystems

# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NLS is not set
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_PROC_MEM_ALWAYS_FORCE=y
# CONFIG_PROC_MEM_FORCE_PTRACE is not set
# CONFIG_PROC_MEM_NO_FORCE is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
# CONFIG_INIT_STACK_ALL_PATTERN is not set
CONFIG_INIT_STACK_ALL_ZERO=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

#
# Bounds checking
#
# CONFIG_HARDENED_USERCOPY is not set
# end of Bounds checking

#
# Hardening of kernel data structures
#
# CONFIG_LIST_HARDENED is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Hardening of kernel data structures

CONFIG_RANDSTRUCT_NONE=y
# end of Kernel hardening options
# end of Security options

# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
# CONFIG_CORDIC is not set
# CONFIG_PRIME_NUMBERS is not set
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC32=y
CONFIG_CRC_OPTIMIZATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
# end of Crypto library routines

# CONFIG_RANDOM32_SELFTEST is not set
# CONFIG_XZ_DEC is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS_HELPERS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_NEED_SYNC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_FORCE_NR_CPUS=y
# CONFIG_IRQ_POLL is not set
CONFIG_ARCH_NO_SG_CHAIN=y
CONFIG_SBITMAP=y
# CONFIG_LWQ_TEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_PRINTK_CALLER is not set
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DYNAMIC_DEBUG_CORE is not set
# CONFIG_SYMBOLIC_ERRNAME is not set
# end of printk and dmesg options

# CONFIG_DEBUG_KERNEL is not set

#
# Compile-time checks and compiler options
#
CONFIG_AS_HAS_NON_CONST_ULEB128=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_DEBUG_FS is not set
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# end of Networking Debugging

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_MEM_ALLOC_PROFILING is not set
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# end of Memory Debugging

#
# Debug Oops, Lockups and Hangs
#
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_TIMEOUT=0
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
# CONFIG_SCHEDSTATS is not set
# end of Scheduler Debugging

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_WW_MUTEX_SELFTEST is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set

#
# Debug kernel data structures
#
# end of Debug kernel data structures

#
# RCU Debugging
#
# end of RCU Debugging

# CONFIG_SAMPLES is not set

#
# alpha Debugging
#
CONFIG_EARLY_PRINTK=y
# CONFIG_ALPHA_LEGACY_START_ADDRESS is not set
CONFIG_MATHEMU=y
# end of alpha Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--2zPSTveijpLLSn4Z--
