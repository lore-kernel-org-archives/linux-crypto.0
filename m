Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9D3184539;
	Wed, 11 Sep 2024 10:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726050606; cv=none; b=NlNwdcVv47i+CUq1QpJ1FrVY02PHex2kG8j/l9+qNQMhk1xc06N2EVLJa7DpWjCXq7fe0gfZtxIBbkEzXjrtlPmk2UFKqlAGGUqGYOnAhw7wh1W/Q/Jr5Dd4FmTIUsCN8FI+LWiW5FbRHLq+Km3wh2QfRMjvyHFkSua84VN8RZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726050606; c=relaxed/simple;
	bh=Rxpg3VD7xlnDbdcEKOV2zBxYKYWAxzjUkDsqH5+pXt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akuD5LCxeoGqfblgGLN82yCW6GYP0wNCEZ33C9oWYE9a7C4pAlNEz1P17LBteKZZwhgF0ajAISEtlirvawF5OkYFb9uhLsQTIKO9lQM57p38vyt+Xgme/8cFIXXlmsuES3aXSleebUzAjfV2KtlJtstp2qwVRHhbKefiHobhAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=q/jy5OXP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="q/jy5OXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=52ooZ9Z9AzT02tFCSg+KXYKanXc1xPioGMsPH/144xc=; b=q/jy5OXPRnDeA831jYg2LRSp2S
	yO7aJbktBnaRmFJsUp6EPv8ioLcECpcr2AEOumkpU0kd1EzLVYPCGIMPiqlzMCNWuRxaQ5+91WXmv
	KCp+mOQ325TqguwX8TftzSjZ8TmBh0q5RaiQGH1FSMt0AtOBxV53tKB4hBnakPwKT5RFgzCd+IAMV
	XCGGnqSARvQeATwPbc+o5raKMMG/blU6gRBaLF7nZAArcWqOO1+OXc75O8rF0Lgh0pRSe1t/tJbUC
	DnEQQ9kneSCeXuBeENtEoAhw1u/FgWRm1syR1Scyv0zME7tH6F8fZLgqaQqzIyOfL/N5qEe8d0xKy
	BIANngcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1soKRV-001h2d-2Z;
	Wed, 11 Sep 2024 18:29:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Sep 2024 18:29:35 +0800
Date: Wed, 11 Sep 2024 18:29:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nicolai Stange <nstange@suse.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Martin Doucha <mdoucha@suse.cz>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Hu Chunyu <chuhu@redhat.com>
Subject: Re: [PATCH 3/5] padata: grab parallel_data refcnt for reorder
Message-ID: <ZuFxD90UO8HadnCj@gondor.apana.org.au>
References: <20221019083708.27138-1-nstange@suse.de>
 <20221019083708.27138-4-nstange@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083708.27138-4-nstange@suse.de>

On Wed, Oct 19, 2022 at 10:37:06AM +0200, Nicolai Stange wrote:
> On entry of padata_do_serial(), the in-flight padata_priv owns a reference
> to the associated parallel_data instance.
> 
> However, as soon as the padata_priv got enqueued on the reorder list, it
> can be completed from a different context, causing the reference to get
> released in the course.
> 
> This would potentially cause UAFs from the subsequent padata_reorder()
> operations invoked from the enqueueing padata_do_serial() or from the
> reorder work.

I've just received yet another report of a UAF in padata on s390
while running the pcrypt_aead01 LTP test.  The kernel in question
contains an identical version of padata to upstream.  Perhaps it's
time to revisit the life-time issues in padata?

[ 9463.217163] ==================================================================
 [ 9463.217339] BUG: KASAN: slab-use-after-free in work_is_static_object+0x2a/0x68
 [ 9463.217678] Read of size 8 at addr 0000000098917c38 by task kworker/u4:2/59
 [ 9463.217798]
 [ 9463.217804] CPU: 0 PID: 59 Comm: kworker/u4:2 Kdump: loaded Not tainted 5.14.0-454.el9.s390x+debug #1
 [ 9463.218051] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
 [ 9463.218058] Workqueue: pdecrypt_parallel padata_parallel_worker
 [ 9463.218119] Call Trace:
 [ 9463.218123]  [<0000000001cbe122>] dump_stack_lvl+0xfa/0x150
 [ 9463.218226]  [<0000000001cada10>] print_address_description.constprop.0+0x180/0x430
 [ 9463.218236]  [<0000000001caddc2>] print_report+0x102/0x1f0
 [ 9463.218243]  [<00000000009c075a>] kasan_report+0xb2/0x1f8
 [ 9463.218251]  [<00000000009c1af2>] kasan_check_range+0x17a/0x1c0
 [ 9463.218302]  [<0000000000235b62>] work_is_static_object+0x2a/0x68
 [ 9463.218308]  [<0000000001002036>] lookup_object_or_alloc.part.0+0x12e/0x1a8
 [ 9463.218373]  [<0000000001002da2>] debug_object_activate+0x20a/0x450
 [ 9463.218381]  [<0000000000240456>] __queue_work+0x646/0x1128
 [ 9463.218443]  [<0000000000241080>] queue_work_on+0x148/0x150
 [ 9463.218506]  [<00000000007d707e>] padata_parallel_worker+0x76/0xc8
 [ 9463.218988]  [<0000000000242040>] process_one_work+0x978/0x1748
 [ 9463.218994]  [<00000000002433b4>] worker_thread+0x5a4/0xf58
 [ 9463.219000]  [<000000000025d60c>] kthread+0x2a4/0x358
 [ 9463.219008]  [<000000000010601a>] __ret_from_fork+0x8a/0xe8
 [ 9463.219016]  [<0000000001cf343a>] ret_from_fork+0xa/0x30
 [ 9463.219086] 5 locks held by kworker/u4:2/59:
 [ 9463.219143]  #0: 00000000ef82a948 ((wq_completion)pdecrypt_parallel){+.+.}-{0:0}, at: process_one_work+0x830/0x1748
 [ 9463.219204]  #1: 001bff8000b0fcf8 ((work_completion)(&pw->pw_work)){+.+.}-{0:0}, at: process_one_work+0x830/0x1748
 [ 9463.219215]  #2: 0000000002a93160 (rcu_read_lock){....}-{1:2}, at: __queue_work+0xa0/0x1128
 [ 9463.219337]  #3: 000000017fa0f618 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x314/0x1128
 [ 9463.219399]  #4: 0000000005d7a0c0 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0x166/0x450
 [ 9463.219446]
 [ 9463.219448] Allocated by task 397970:
 [ 9463.219452]  kasan_save_stack+0x34/0x58
 [ 9463.219457]  kasan_set_track+0x36/0x48
 [ 9463.219460]  __kasan_kmalloc+0xaa/0xc0
 [ 9463.219463]  padata_alloc_pd+0x70/0xbc8
 [ 9463.219466]  padata_alloc_shell+0x8a/0x208
 [ 9463.219469]  pcrypt_create_aead.isra.0+0xba/0x698 [pcrypt]
 [ 9463.219535]  cryptomgr_probe+0x9e/0x1d8
 [ 9463.219578]  kthread+0x2a4/0x358
 [ 9463.219582]  __ret_from_fork+0x8a/0xe8
 [ 9463.219586]  ret_from_fork+0xa/0x30
 [ 9463.219589]
 [ 9463.219591] Freed by task 392422:
 [ 9463.219594]  kasan_save_stack+0x34/0x58
 [ 9463.219598]  kasan_set_track+0x36/0x48
 [ 9463.219645]  kasan_save_free_info+0x46/0x68
 [ 9463.219651]  __kasan_slab_free+0x102/0x178
 [ 9463.219656]  slab_free_freelist_hook+0x148/0x228
 [ 9463.219685]  __kmem_cache_free+0x92/0x2b8
 [ 9463.219690]  padata_free_shell+0x242/0x2f8
 [ 9463.219697]  pcrypt_free+0x50/0xa0 [pcrypt]
 [ 9463.219703]  crypto_destroy_instance+0x86/0xe0
 [ 9463.219709]  crypto_mod_put+0xa4/0xf0
 [ 9463.219714]  crypto_del_alg+0xc8/0x138
 [ 9463.219720]  crypto_user_rcv_msg+0x39a/0x490
 [ 9463.219725]  netlink_rcv_skb+0x21a/0x4a0
 [ 9463.219773]  crypto_netlink_rcv+0x40/0x58
 [ 9463.219781]  netlink_unicast+0x46a/0x6e0
 [ 9463.219787]  netlink_sendmsg+0x75c/0xbe8
 [ 9463.219835]  __sock_sendmsg+0xca/0x170
 [ 9463.219843]  ____sys_sendmsg+0x5d8/0x730
 [ 9463.219848]  ___sys_sendmsg+0x11e/0x178
 [ 9463.219855]  __sys_sendmsg+0xda/0x150
 [ 9463.219915]  __do_sys_socketcall+0x3e2/0x480
 [ 9463.220092]  do_syscall+0x22c/0x328
 [ 9463.220097]  __do_syscall+0xce/0xf0
 [ 9463.220103]  system_call+0x70/0x98
 [ 9463.220109]
 [ 9463.220148] Last potentially related work creation:
 [ 9463.220152]  kasan_save_stack+0x34/0x58
 [ 9463.220157]  __kasan_record_aux_stack+0xba/0xd0
 [ 9463.221000]  __call_rcu_common.constprop.0+0x104/0x998
 [ 9463.221070]  __key_link+0x124/0x320
 [ 9463.221380]  construct_alloc_key+0x53a/0x618
 [ 9463.221386]  construct_key_and_link+0x196/0x3a8
 [ 9463.221506]  request_key_and_link+0x38a/0x3e0
 [ 9463.221512]  __do_sys_request_key+0x164/0x268
 [ 9463.221518]  do_syscall+0x22c/0x328
 [ 9463.221617]  __do_syscall+0xce/0xf0
 [ 9463.221622]  system_call+0x70/0x98
 [ 9463.221627]
 [ 9463.221630] Second to last potentially related work creation:
 [ 9463.221634]  kasan_save_stack+0x34/0x58
 [ 9463.221638]  __kasan_record_aux_stack+0xba/0xd0
 [ 9463.221642]  __call_rcu_common.constprop.0+0x104/0x998
 [ 9463.221743]  assoc_array_gc+0xde6/0x10f8
 [ 9463.221747]  keyring_gc+0x170/0x210
 [ 9463.221751]  key_garbage_collector+0x598/0x760
 [ 9463.221756]  process_one_work+0x978/0x1748
 [ 9463.221759]  worker_thread+0x71a/0xf58
 [ 9463.221763]  kthread+0x2a4/0x358
 [ 9463.221767]  __ret_from_fork+0x8a/0xe8
 [ 9463.221770]  ret_from_fork+0xa/0x30
 [ 9463.221774]
 [ 9463.221836] The buggy address belongs to the object at 0000000098917c00
 [ 9463.221836]  which belongs to the cache kmalloc-512 of size 512
 [ 9463.221887] The buggy address is located 56 bytes inside of
 [ 9463.221887]  freed 512-byte region [0000000098917c00, 0000000098917e00)
 [ 9463.221891]
 [ 9463.221894] The buggy address belongs to the physical page:
 [ 9463.221898] page:00000000e2f31a4b refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x98914
 [ 9463.222571] head:00000000e2f31a4b order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 [ 9463.222577] flags: 0x2000000000010200(slab|head|node=0|zone=1)
 [ 9463.222585] page_type: 0xffffffff()
 [ 9463.222592] raw: 2000000000010200 0000000080083400 0000000000000000 0000000100000122
 [ 9463.222599] raw: 0000000000000000 0010002000000000 ffffffff00000001 0000000000000000
 [ 9463.222604] page dumped because: kasan: bad access detected
 [ 9463.222648]
 [ 9463.222651] Memory state around the buggy address:
 [ 9463.222660]  0000000098917b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 [ 9463.222665]  0000000098917b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 [ 9463.222670] >0000000098917c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 [ 9463.222795]                                         ^
 [ 9463.222838]  0000000098917c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 [ 9463.222843]  0000000098917d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 [ 9463.222849] ==================================================================
 [ 9463.222853] Disabling lock debugging due to kernel taint
 [ 9463.222858] ------------[ cut here ]------------
 [ 9463.222862] ODEBUG: activate not available (active state 0) object: 00000000990ad955 object type: work_struct hint: invoke_padata_reorder+0x0/0x58
 [ 9463.223373] WARNING: CPU: 0 PID: 59 at lib/debugobjects.c:514 debug_print_object+0x1be/0x248
 [ 9463.223549] Modules linked in: pcrypt zstd zstd_compress zsmalloc exfat vfat fat overlay ext4 mbcache jbd2 loop tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio iommufd drm i2c_core drm_panel_orientation_quirks fuse xfs libcrc32c ghash_s390 prng aes_s390 des_s390 libdes sha3_512_s390 virtio_net net_failover failover virtio_blk sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt [last unloaded: zram]
 [ 9463.223743] CPU: 0 PID: 59 Comm: kworker/u4:2 Kdump: loaded Tainted: G    B             -------  ---  5.14.0-454.el9.s390x+debug #1
 [ 9463.223747] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
 [ 9463.223748] Workqueue: pdecrypt_parallel padata_parallel_worker
 [ 9463.223751] Krnl PSW : 0404e00180000000 00000000010004aa (debug_print_object+0x1c2/0x248)
 [ 9463.223756]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 [ 9463.223789] Krnl GPRS: 0000000000000001 001c000000000000 0000000000000086 0000000000000004
 [ 9463.223791]            0000000000000001 00000000006289f8 0000000098917c38 0000000001fccca0
 [ 9463.223793]            00000000007d7dc8 00000000029243e0 0000000001fcc780 001bff8000b0f9c8
 [ 9463.223795]            00000000028e3eb0 0000000000000000 00000000010004a6 001bff8000b0f868
 [ 9463.223804] Krnl Code: 000000000100049a: c020007e5e13       larl    %r2,0000000001fcc0c0
 [ 9463.223804]            00000000010004a0: c0e5ff8ee004       brasl   %r14,00000000001dc4a8
 [ 9463.223804]           #00000000010004a6: af000000           mc      0,0
 [ 9463.223804]           >00000000010004aa: c41d00c06113       lrl     %r1,000000000280c6d0
 [ 9463.223804]            00000000010004b0: a71a0001           ahi     %r1,1
 [ 9463.223804]            00000000010004b4: c41f00c0610e       strl    %r1,000000000280c6d0
 [ 9463.223804]            00000000010004ba: eb6ff0b00004       lmg     %r6,%r15,176(%r15)
 [ 9463.223804]            00000000010004c0: 07fe               bcr     15,%r14
 [ 9463.223818] Call Trace:
 [ 9463.223819]  [<00000000010004aa>] debug_print_object+0x1c2/0x248
 [ 9463.223823] ([<00000000010004a6>] debug_print_object+0x1be/0x248)
 [ 9463.223852]  [<0000000001002f5e>] debug_object_activate+0x3c6/0x450
 [ 9463.223854]  [<0000000000240456>] __queue_work+0x646/0x1128
 [ 9463.223856]  [<0000000000241080>] queue_work_on+0x148/0x150
 [ 9463.223858]  [<00000000007d707e>] padata_parallel_worker+0x76/0xc8
 [ 9463.223861]  [<0000000000242040>] process_one_work+0x978/0x1748
 [ 9463.223864]  [<00000000002433b4>] worker_thread+0x5a4/0xf58
 [ 9463.223866]  [<000000000025d60c>] kthread+0x2a4/0x358
 [ 9463.223868]  [<000000000010601a>] __ret_from_fork+0x8a/0xe8
 [ 9463.223871]  [<0000000001cf343a>] ret_from_fork+0xa/0x30
 [ 9463.223873] INFO: lockdep is turned off.
 [ 9463.223874] Last Breaking-Event-Address:
 [ 9463.223875]  [<00000000001dc64a>] __warn_printk+0x1a2/0x1a8
 [ 9463.223878] irq event stamp: 24602747
 [ 9463.223879] hardirqs last  enabled at (24602746): [<00000000001f4ac0>] __local_bh_enable_ip+0x188/0x348
 [ 9463.223884] hardirqs last disabled at (24602747): [<0000000000241042>] queue_work_on+0x10a/0x150
 [ 9463.223886] softirqs last  enabled at (24602712): [<00000000007d7072>] padata_parallel_worker+0x6a/0xc8
 [ 9463.223917] softirqs last disabled at (24602720): [<00000000007d7042>] padata_parallel_worker+0x3a/0xc8
 [ 9463.223920] ---[ end trace 0000000000000000 ]---
 [ 9463.224330] ------------[ cut here ]------------
 [ 9463.224394] ODEBUG: deactivate not available (active state 0) object: 00000000990ad955 object type: work_struct hint: invoke_padata_reorder+0x0/0x58
 [ 9463.224520] WARNING: CPU: 0 PID: 306462 at lib/debugobjects.c:514 debug_print_object+0x1be/0x248
 [ 9463.224526] Modules linked in: pcrypt zstd zstd_compress zsmalloc exfat vfat fat overlay ext4 mbcache jbd2 loop tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio iommufd drm i2c_core drm_panel_orientation_quirks fuse xfs libcrc32c ghash_s390 prng aes_s390 des_s390 libdes sha3_512_s390 virtio_net net_failover failover virtio_blk sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt [last unloaded: zram]
 [ 9463.224781] CPU: 0 PID: 306462 Comm: kworker/0:0 Kdump: loaded Tainted: G    B   W         -------  ---  5.14.0-454.el9.s390x+debug #1
 [ 9463.224897] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
 [ 9463.224898] Workqueue:  0x0 (events)
 [ 9463.224907] Krnl PSW : 0404e00180000000 00000000010004aa (debug_print_object+0x1c2/0x248)
 [ 9463.224949]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 [ 9463.224953] Krnl GPRS: 0000000000000001 001c000000000000 0000000000000088 0000000000000004
 [ 9463.224956]            0000000000000001 00000000006289f8 0000000098917c38 0000000001fccca0
 [ 9463.224959]            00000000007d7dc8 00000000029243e0 0000000001fcc6c0 001bff8005b6fb58
 [ 9463.224961]            00000000028e3eb0 0000000000000000 00000000010004a6 001bff8005b6fa10
 [ 9463.224968] Krnl Code: 000000000100049a: c020007e5e13       larl    %r2,0000000001fcc0c0
 [ 9463.224968]            00000000010004a0: c0e5ff8ee004       brasl   %r14,00000000001dc4a8
 [ 9463.224968]           #00000000010004a6: af000000           mc      0,0
 [ 9463.224968]           >00000000010004aa: c41d00c06113       lrl     %r1,000000000280c6d0
 [ 9463.224968]            00000000010004b0: a71a0001           ahi     %r1,1
 [ 9463.224968]            00000000010004b4: c41f00c0610e       strl    %r1,000000000280c6d0
 [ 9463.224968]            00000000010004ba: eb6ff0b00004       lmg     %r6,%r15,176(%r15)
 [ 9463.224968]            00000000010004c0: 07fe               bcr     15,%r14
 [ 9463.225011] Call Trace:
 [ 9463.225012]  [<00000000010004aa>] debug_print_object+0x1c2/0x248
 [ 9463.225022] ([<00000000010004a6>] debug_print_object+0x1be/0x248)
 [ 9463.225025]  [<0000000001002546>] debug_object_deactivate+0x1c6/0x2f8
 [ 9463.225029]  [<0000000000241a86>] process_one_work+0x3be/0x1748
 [ 9463.225032]  [<00000000002433b4>] worker_thread+0x5a4/0xf58
 [ 9463.225035]  [<000000000025d60c>] kthread+0x2a4/0x358
 [ 9463.225038]  [<000000000010601a>] __ret_from_fork+0x8a/0xe8
 [ 9463.225101]  [<0000000001cf343a>] ret_from_fork+0xa/0x30
 [ 9463.225294] INFO: lockdep is turned off.
 [ 9463.225357] Last Breaking-Event-Address:
 [ 9463.225357]  [<00000000001dc64a>] __warn_printk+0x1a2/0x1a8
 [ 9463.225543] irq event stamp: 2298862
 [ 9463.225544] hardirqs last  enabled at (2298861): [<0000000001cf2cc2>] _raw_spin_unlock_irq+0x92/0xb0
 [ 9463.225549] hardirqs last disabled at (2298862): [<0000000001cd7e60>] __schedule+0xb20/0x1478
 [ 9463.225585] softirqs last  enabled at (2292304): [<0000000001cf5c12>] __do_softirq+0xaaa/0x1040
 [ 9463.225589] softirqs last disabled at (2291215): [<00000000001f3bf2>] __irq_exit_rcu+0x2fa/0x3b8
 [ 9463.225593] ---[ end trace 0000000000000000 ]---
 [ 9463.225606] Unable to handle kernel pointer dereference in virtual kernel address space
 [ 9463.225847] Failing address: 0005fce7876cc000 TEID: 0005fce7876cc403
 [ 9463.225853] Fault in home space mode while using kernel ASCE.
 [ 9463.225863] AS:0000000003b2800b R2:0000000000000028
 [ 9463.226167] Oops: 003a ilc:2 [#1] SMP
 [ 9463.226174] Modules linked in: pcrypt zstd zstd_compress zsmalloc exfat vfat fat overlay ext4 mbcache jbd2 loop tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio iommufd drm i2c_core drm_panel_orientation_quirks fuse xfs libcrc32c ghash_s390 prng aes_s390 des_s390 libdes sha3_512_s390 virtio_net net_failover failover virtio_blk sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt [last unloaded: zram]
 [ 9463.226373] CPU: 0 PID: 306462 Comm: kworker/0:0 Kdump: loaded Tainted: G    B   W         -------  ---  5.14.0-454.el9.s390x+debug #1
 [ 9463.226376] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
 [ 9463.226378] Workqueue: pdecrypt_serial invoke_padata_reorder
 [ 9463.226381] Krnl PSW : 0704c00180000000 0000000000361e96 (do_raw_spin_trylock+0x46/0x148)
 [ 9463.226427]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
 [ 9463.226430] Krnl GPRS: 0000000000000001 001c000000000000 0005fce700000001 001c000000000000
 [ 9463.226433]            0000000000000000 00000000003583a8 0000000000000001 0005fce7876cc850
 [ 9463.226435]            0000000098917c24 0005fce7876cc868 0005fce7876cc850 0005fce7876cc850
 [ 9463.226438]            00000000028e3eb0 0000000013122f84 001bff8005b6f9b0 001bff8005b6f970
 [ 9463.226445] Krnl Code: 0000000000361e8a: a7740065           brc     7,0000000000361f54
 [ 9463.226445]            0000000000361e8e: 582003ac           l       %r2,940
 [ 9463.226445]           #0000000000361e92: a7180000           lhi     %r1,0
 [ 9463.226445]           >0000000000361e96: ba12b000           cs      %r1,%r2,0(%r11)
 [ 9463.226445]            0000000000361e9a: a7a80001           lhi     %r10,1
 [ 9463.226445]            0000000000361e9e: ec160050007e       cij     %r1,0,6,0000000000361f3e
 [ 9463.226445]            0000000000361ea4: a51c001c           llihh   %r1,28
 [ 9463.226445]            KernelAddressSanitizer initialized

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
