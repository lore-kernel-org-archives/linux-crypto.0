Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F6582485
	for <linux-crypto@vger.kernel.org>; Mon,  9 Sep 2024 03:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725851345; cv=none; b=nW4Lqmg+lG8zXdx8VFnwpH8paDHQrDsyMW84iMhXZYCczccqkr6iZTocCQGbJcdyFJNKeahoVI0+h81tolyoaOyktWS8NnbnoHHVutZxcK+BUf3HIcw9bWS4VbVTHC2+Bi3EJ9bQh/1HvXs6bnpsySesSU8ZfZRrLOsA63VFqjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725851345; c=relaxed/simple;
	bh=gRPGL8iQF1p6XDSkNxB/jIh6hUVw/Yr+tohP8MVTy+c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=LsvB5/yBzZR4MDd5ONJOGKE8i7ygxlfu4E+GV/fNv1Ewdn97O5xDjVYiuP3aYbbHs5bwRGfMzvjzFHOvkvWTTDmD5cw1alDwcpPen8TozXQTfokpnFgy+s2IShHhVWFEVXw3zXZ6RVWepZcyBZL9slKHeMeB65gMVLTGE8iuhR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82cdc7b7debso144717939f.3
        for <linux-crypto@vger.kernel.org>; Sun, 08 Sep 2024 20:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725851343; x=1726456143;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ogX9ioynseCZNLkk8HgEb3jMvON/X7SNvzmEgruOw2Q=;
        b=Pb8VsSsgUSfnUsQy/MRyh6L5LAjJzbWqzB8X5EM37GiKjQu5cHwnOMjccEMEp53oIG
         yFT5pygTXmgX4Xdi4D4hj56ETM0UTIdBUf7bXCDCFZ7qZAUiBzuzPyUdYYjrqujQC6GF
         RZ+qPyPOturPSdnSD/tQ9kprOvvL9k6pd6V/uRHn9h/gXQCdGE+wejXpktCRTUwXR3Jr
         QRyzmT53629MJ7fWG8f02x/eGkN/ZNKXAh8/ym4cB7KYx9ZFwqn2E3HHrLgasUfzMXbv
         KkJR9BogXsr07eKQmDE2Xfmp7oaja0vrB4Z+kPsparGZAY2bhHz5FfrDu4WlqtHibn/3
         wpJg==
X-Forwarded-Encrypted: i=1; AJvYcCXYrdiUoV1hVTSnFelByzlc/TpcjktDy92nNFjKnn5s1OFMaruYNkQSswBI9rJogo7oQJ141cmVS42B824=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRr3sk8QfczNoorXHrzo2KvBZP/dTpW7ZOu/L++uVX69ajmSs+
	PDQShJ16fwowfwGeJN+xo6iSUk+i4QtV17SevAECBRnqEAgYp0/CIiFFKF+jpvUbOy6xOksXNVs
	a/D4lt8Xfe6RMOsZUyYSUWAX1inBY2EsBelj9gcS4DvRN5FnQEoSbN6g=
X-Google-Smtp-Source: AGHT+IHSkpstj/vxyYcVH23wJMxnv+Vk4pA0yrLT5fnVnCks9y0rlpxZaQf62X68EKiPYhjgwaOJG2ErIqWfUhNLhu/Hjqz4Uttd
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:26c6:b0:82a:23b4:4c90 with SMTP id
 ca18e2360f4ac-82aa456c0a8mr618142139f.1.1725851342978; Sun, 08 Sep 2024
 20:09:02 -0700 (PDT)
Date: Sun, 08 Sep 2024 20:09:02 -0700
In-Reply-To: <48435cf7-8c2d-4d3e-8b26-f8814f9a6338@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003bd3d10621a714f0@google.com>
Subject: Re: [syzbot] [crypto?] [ntfs3?] KMSAN: uninit-value in sw842_compress
From: syzbot <syzbot+17cae3c0a5b0acdc327d@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, davem@davemloft.net, 
	haren@us.ibm.com, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, zhaomengmeng@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KMSAN: uninit-value in sw842_compress

=====================================================
BUG: KMSAN: uninit-value in check_template lib/842/842_compress.c:391 [inline]
BUG: KMSAN: uninit-value in process_next lib/842/842_compress.c:456 [inline]
BUG: KMSAN: uninit-value in sw842_compress+0x15eb/0x5990 lib/842/842_compress.c:543
 check_template lib/842/842_compress.c:391 [inline]
 process_next lib/842/842_compress.c:456 [inline]
 sw842_compress+0x15eb/0x5990 lib/842/842_compress.c:543
 crypto842_scompress+0x4f/0x70 crypto/842.c:78
 scomp_acomp_comp_decomp+0x7c6/0xb90
 scomp_acomp_compress+0x32/0x40 crypto/scompress.c:187
 crypto_acomp_compress include/crypto/acompress.h:251 [inline]
 zswap_compress+0x368/0xad0 mm/zswap.c:927
 zswap_store+0x1af3/0x2dd0 mm/zswap.c:1459
 swap_writepage+0x11f/0x470 mm/page_io.c:198
 shmem_writepage+0x1a75/0x1f70 mm/shmem.c:1536
 pageout mm/vmscan.c:680 [inline]
 shrink_folio_list+0x577f/0x7cb0 mm/vmscan.c:1360
 evict_folios+0x9a49/0xbb30 mm/vmscan.c:4560
 try_to_shrink_lruvec+0x13a3/0x1750 mm/vmscan.c:4755
 lru_gen_shrink_lruvec mm/vmscan.c:4897 [inline]
 shrink_lruvec+0x4a3/0x46c0 mm/vmscan.c:5652
 shrink_node_memcgs mm/vmscan.c:5888 [inline]
 shrink_node+0x104e/0x50f0 mm/vmscan.c:5928
 shrink_zones mm/vmscan.c:6172 [inline]
 do_try_to_free_pages+0x820/0x2550 mm/vmscan.c:6234
 try_to_free_mem_cgroup_pages+0x3f7/0xae0 mm/vmscan.c:6566
 try_charge_memcg+0x72c/0x1830 mm/memcontrol.c:2210
 try_charge mm/memcontrol-v1.h:20 [inline]
 charge_memcg mm/memcontrol.c:4438 [inline]
 __mem_cgroup_charge+0x11d/0x3f0 mm/memcontrol.c:4453
 mem_cgroup_charge include/linux/memcontrol.h:672 [inline]
 shmem_alloc_and_add_folio+0xe83/0x1ca0 mm/shmem.c:1792
 shmem_get_folio_gfp+0x10bd/0x24c0 mm/shmem.c:2188
 shmem_read_folio_gfp+0x80/0x140 mm/shmem.c:5201
 drm_gem_get_pages+0x3cf/0x1440 drivers/gpu/drm/drm_gem.c:568
 drm_gem_shmem_get_pages drivers/gpu/drm/drm_gem_shmem_helper.c:177 [inline]
 drm_gem_shmem_vmap+0x2dc/0xca0 drivers/gpu/drm/drm_gem_shmem_helper.c:337
 drm_gem_shmem_object_vmap+0x35/0x40 include/drm/drm_gem_shmem_helper.h:229
 drm_gem_vmap drivers/gpu/drm/drm_gem.c:1205 [inline]
 drm_gem_vmap_unlocked+0xc6/0x200 drivers/gpu/drm/drm_gem.c:1247
 drm_gem_fb_vmap+0x11b/0x590 drivers/gpu/drm/drm_gem_framebuffer_helper.c:365
 vkms_prepare_fb+0x12f/0x170 drivers/gpu/drm/vkms/vkms_plane.c:176
 drm_atomic_helper_prepare_planes+0x436/0x10b0 drivers/gpu/drm/drm_atomic_helper.c:2601
 drm_atomic_helper_commit+0x1f3/0xe80 drivers/gpu/drm/drm_atomic_helper.c:2029
 drm_atomic_commit+0x30a/0x380 drivers/gpu/drm/drm_atomic.c:1522
 drm_atomic_helper_update_plane+0x42b/0x600 drivers/gpu/drm/drm_atomic_helper.c:3190
 __setplane_atomic+0x33d/0x3f0 drivers/gpu/drm/drm_plane.c:1074
 drm_mode_cursor_universal drivers/gpu/drm/drm_plane.c:1229 [inline]
 drm_mode_cursor_common+0x171a/0x1e80 drivers/gpu/drm/drm_plane.c:1288
 drm_mode_cursor_ioctl+0x97/0xd0 drivers/gpu/drm/drm_plane.c:1338
 drm_ioctl_kernel+0x4ea/0x560 drivers/gpu/drm/drm_ioctl.c:745
 drm_ioctl+0xd13/0x15a0 drivers/gpu/drm/drm_ioctl.c:842
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0x261/0x450 fs/ioctl.c:893
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:893
 x64_sys_call+0x18bf/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

<Zero or more stacks not recorded to save memory>

Uninit was stored to memory at:
 memcpy_from_iter lib/iov_iter.c:73 [inline]
 iterate_bvec include/linux/iov_iter.h:122 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:249 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 __copy_from_iter lib/iov_iter.c:249 [inline]
 copy_page_from_iter_atomic+0x12bb/0x2ae0 lib/iov_iter.c:481
 copy_folio_from_iter_atomic include/linux/uio.h:186 [inline]
 generic_perform_write+0x896/0x12e0 mm/filemap.c:4032
 shmem_file_write_iter+0x2bd/0x2f0 mm/shmem.c:3074
 do_iter_readv_writev+0x8a1/0xa40
 vfs_iter_write+0x459/0xd50 fs/read_write.c:895
 lo_write_bvec drivers/block/loop.c:243 [inline]
 lo_write_simple drivers/block/loop.c:264 [inline]
 do_req_filebacked drivers/block/loop.c:511 [inline]
 loop_handle_cmd drivers/block/loop.c:1910 [inline]
 loop_process_work+0x15ec/0x3750 drivers/block/loop.c:1945
 loop_rootcg_workfn+0x2b/0x40 drivers/block/loop.c:1976
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_update_dup+0xd81/0xf80 fs/ntfs3/index.c:2694
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_read_run_nb+0x786/0x1070 fs/ntfs3/fsntfs.c:1252
 ntfs_read_bh+0x64/0xde0 fs/ntfs3/fsntfs.c:1313
 indx_read+0x44e/0x17b0 fs/ntfs3/index.c:1067
 indx_find+0xd12/0x1440 fs/ntfs3/index.c:1181
 indx_update_dup+0x607/0xf80 fs/ntfs3/index.c:2666
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_update_dup+0xd81/0xf80 fs/ntfs3/index.c:2694
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_read_run_nb+0x786/0x1070 fs/ntfs3/fsntfs.c:1252
 ntfs_read_bh+0x64/0xde0 fs/ntfs3/fsntfs.c:1313
 indx_read+0x44e/0x17b0 fs/ntfs3/index.c:1067
 indx_find+0xd12/0x1440 fs/ntfs3/index.c:1181
 indx_update_dup+0x607/0xf80 fs/ntfs3/index.c:2666
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_insert_into_buffer+0xd8f/0x2010 fs/ntfs3/index.c:1811
 indx_insert_entry+0xa3c/0xee0 fs/ntfs3/index.c:1988
 ni_add_name+0xe5d/0x10d0 fs/ntfs3/frecord.c:3123
 ntfs_link_inode+0x265/0x310 fs/ntfs3/inode.c:1768
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:150
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 hdr_insert_de fs/ntfs3/index.c:838 [inline]
 indx_insert_into_buffer+0xcdf/0x2010 fs/ntfs3/index.c:1807
 indx_insert_entry+0xa3c/0xee0 fs/ntfs3/index.c:1988
 ni_add_name+0xe5d/0x10d0 fs/ntfs3/frecord.c:3123
 ntfs_link_inode+0x265/0x310 fs/ntfs3/inode.c:1768
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:150
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3998 [inline]
 slab_alloc_node mm/slub.c:4041 [inline]
 kmem_cache_alloc_noprof+0x637/0xb20 mm/slub.c:4048
 ntfs_link_inode+0x8f/0x310 fs/ntfs3/inode.c:1756
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:150
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 6036 Comm: syz.0.15 Not tainted 6.11.0-rc7-syzkaller-gda3ea35007d0-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
=====================================================


Tested on:

commit:         da3ea350 Linux 6.11-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a0e567980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea008021530b2de3
dashboard link: https://syzkaller.appspot.com/bug?extid=17cae3c0a5b0acdc327d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11514e00580000

