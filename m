Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690553AFAEA;
	Tue,  6 Oct 2026 09:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278645; cv=none; b=olccq50dRIo+012lcbS1d5fGgvGxPgg5l29uGMdMT7+gmRCHVuVQdP9OGNrx5qSNge3N/Ep/33vgi3YzX5Ahv359ozZO+mOoMX5+oMfzDtCST/4liSjCjMpnDkOsvZ3ans8T5osvt2oSf3Jw1NkKPAEzFhkHDXCG+h76oQy5oiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278645; c=relaxed/simple;
	bh=TgtqlrbHN77VKirZ2ftfAQCStEsvqy+q9O0SKCf4Kg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKpvatqpy+9Q7SCgZxyFfKrCG2ni82IcpqsvUl7eDUBagz2evnqAuYrOLf6vJPAU7F+OMdkrK7l7YR2+EqB1kBZkRrH3iGXv0BvTLkR+BRlDy3z9xUgureVCHjjZh47GxbbCtWFXBoAgMcESgR+WEqmvFIdil9/9zonHmADep/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzXBcW0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzXBcW0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925B21F000FF;
	Tue,  6 Oct 2026 09:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278644;
	bh=3bSkOZrlYsn4bvYELIgk4k4vyT6uwFbI9yY+m9H4fhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AzXBcW0fCYHNOw7ld3MTlFi3RTSTmWWfazNp+z4JjHIs+Ku6vVLJfP9iX8fTgzJOa
	 AGBZQAUoD7Vs0wKPygq1OgsLSBzznfgoY8HORZrQQvlSA8EMpLrbtao4o7n4NOzne4
	 NBXeYu1no+d3oSRVCzUgEaXX/yKk//4QpXaVtKT/qildmf92Fy4VjvTn8XlBVvH8OX
	 OlX56fcmB4imcKK1PzAJ3LvmsWtXB2Vf1tWRh7kjZ8Y9YrPF/9bMgitUqZT8GbmgZq
	 19jRRCC6UMXA6LILmHLTykTJKTt42L/qAugMFrRSh95SMG8v8NkNfX5QgYdx1uUks/
	 C4PoYIbvN6Yrw==
Date: Tue, 6 Oct 2026 11:24:00 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+20d60aafd9a0d1f2a380@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] possible deadlock in __blk_crypto_evict_key
Message-ID: <20261006092400.GB2485@quark>
References: <6a9b25c3.b5d4176b.238c3e.0004.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9b25c3.b5d4176b.238c3e.0004.GAE@google.com>

On Fri, Sep 04, 2026 at 01:10:43PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8ab1afb2eb24 Merge tag 'for-7.3/dm-fixes' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13ea0215580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
> dashboard link: https://syzkaller.appspot.com/bug?extid=20d60aafd9a0d1f2a380
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8ab1afb2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5edb29856782/vmlinux-8ab1afb2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4d05b2b79211/bzImage-8ab1afb2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+20d60aafd9a0d1f2a380@syzkaller.appspotmail.com
> 
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> kswapd0/72 is trying to acquire lock:
> ffff88803f7de4c8 (&profile->lock){++++}-{4:4}, at: blk_crypto_hw_enter block/blk-crypto-profile.c:55 [inline]
> ffff88803f7de4c8 (&profile->lock){++++}-{4:4}, at: __blk_crypto_evict_key+0x111/0x5e0 block/blk-crypto-profile.c:359
> 
> but task is already holding lock:
> ffffffff8ee91d60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7177 [inline]
> ffffffff8ee91d60 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa08/0x32c0 mm/vmscan.c:7555
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
>        fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
>        might_alloc include/linux/sched/mm.h:316 [inline]
>        slab_pre_alloc_hook mm/slub.c:4636 [inline]
>        slab_alloc_node mm/slub.c:4974 [inline]
>        __do_kmalloc_node mm/slub.c:5413 [inline]
>        __kmalloc_noprof+0xbc/0x720 mm/slub.c:5439
>        _kmalloc_noprof include/linux/slab.h:995 [inline]
>        _kzalloc_noprof include/linux/slab.h:1312 [inline]
>        adiantum_setkey+0x139/0x620 crypto/adiantum.c:129
>        crypto_skcipher_setkey+0x2a3/0x460 crypto/skcipher.c:422
>        crypto_sync_skcipher_setkey include/crypto/skcipher.h:621 [inline]
>        blk_crypto_fallback_keyslot_program+0x1ad/0x440 block/blk-crypto-fallback.c:122
>        blk_crypto_get_keyslot+0x941/0x1070 block/blk-crypto-profile.c:295
>        blk_crypto_fallback_encrypt_bio block/blk-crypto-fallback.c:362 [inline]
>        blk_crypto_fallback_bio_prep+0x424/0x1b40 block/blk-crypto-fallback.c:505
>        blk_crypto_submit_bio include/linux/blk-crypto.h:211 [inline]
>        f2fs_submit_write_bio+0x11b/0x2e0 fs/f2fs/data.c:575
>        __submit_merged_bio+0x258/0x6a0 fs/f2fs/data.c:590
>        __f2fs_submit_merged_write fs/f2fs/data.c:682 [inline]
>        __submit_merged_write_cond+0x3c9/0x4e0 fs/f2fs/data.c:706
>        f2fs_submit_merged_write_cond fs/f2fs/data.c:731 [inline]
>        f2fs_write_cache_pages fs/f2fs/data.c:3495 [inline]
>        __f2fs_write_data_pages fs/f2fs/data.c:3603 [inline]
>        f2fs_write_data_pages+0x2a27/0x36f0 fs/f2fs/data.c:3641
>        do_writepages+0x338/0x560 mm/page-writeback.c:2560
>        filemap_writeback mm/filemap.c:387 [inline]
>        filemap_fdatawrite_range mm/filemap.c:412 [inline]
>        file_write_and_wait_range+0x36e/0x440 mm/filemap.c:786
>        f2fs_do_sync_file+0x69d/0x1960 fs/f2fs/file.c:359
>        generic_write_sync include/linux/fs.h:2686 [inline]
>        f2fs_file_write_iter+0x68e/0x2920 fs/f2fs/file.c:5720
>        new_sync_write fs/read_write.c:595 [inline]
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&profile->lock){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3181 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>        validate_chain kernel/locking/lockdep.c:3924 [inline]
>        __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>        down_write+0x96/0x200 kernel/locking/rwsem.c:1631
>        blk_crypto_hw_enter block/blk-crypto-profile.c:55 [inline]
>        __blk_crypto_evict_key+0x111/0x5e0 block/blk-crypto-profile.c:359
>        blk_crypto_evict_key+0x230/0x3c0 block/blk-crypto.c:443
>        fscrypt_destroy_inline_crypt_key+0x1b9/0x260 fs/crypto/block.c:164
>        fscrypt_destroy_prepared_key fs/crypto/keysetup.c:173 [inline]
>        put_crypt_info+0x110/0x2f0 fs/crypto/keysetup.c:560
>        fscrypt_put_encryption_info+0xf6/0x140 fs/crypto/keysetup.c:786
>        f2fs_evict_inode+0x1c9f/0x21f0 fs/f2fs/inode.c:1105
>        evict+0x624/0xb50 fs/inode.c:822
>        dispose_list fs/inode.c:864 [inline]
>        prune_icache_sb+0x223/0x2d0 fs/inode.c:1011
>        super_cache_scan+0x3f5/0x500 fs/super.c:240
>        do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
>        shrink_slab_memcg mm/shrinker.c:560 [inline]
>        shrink_slab+0x838/0x1220 mm/shrinker.c:638
>        shrink_one+0x2a2/0x730 mm/vmscan.c:5119
>        shrink_many mm/vmscan.c:5180 [inline]
>        lru_gen_shrink_node mm/vmscan.c:5258 [inline]
>        shrink_node+0x35d0/0x3e30 mm/vmscan.c:6247
>        kswapd_shrink_node mm/vmscan.c:7101 [inline]
>        balance_pgdat mm/vmscan.c:7279 [inline]
>        kswapd+0x185e/0x32c0 mm/vmscan.c:7555
>        kthread+0x38b/0x480 kernel/kthread.c:436
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&profile->lock);
>                                lock(fs_reclaim);
>   lock(&profile->lock);
> 
>  *** DEADLOCK ***
> 
> locks held by kswapd0/72: 2, last CPU#0:
>  #0: ffffffff8ee91d60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7177 [inline]
>  #0: ffffffff8ee91d60 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa08/0x32c0 mm/vmscan.c:7555
>  #1: ffff88801fc4e0e8 (&type->s_umount_key#52){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:688 [inline]
>  #1: ffff88801fc4e0e8 (&type->s_umount_key#52){.+.+}-{4:4}, at: super_cache_scan+0x94/0x500 fs/super.c:213
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 72 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
>  check_prev_add kernel/locking/lockdep.c:3181 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>  validate_chain kernel/locking/lockdep.c:3924 [inline]
>  __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>  down_write+0x96/0x200 kernel/locking/rwsem.c:1631
>  blk_crypto_hw_enter block/blk-crypto-profile.c:55 [inline]
>  __blk_crypto_evict_key+0x111/0x5e0 block/blk-crypto-profile.c:359
>  blk_crypto_evict_key+0x230/0x3c0 block/blk-crypto.c:443
>  fscrypt_destroy_inline_crypt_key+0x1b9/0x260 fs/crypto/block.c:164
>  fscrypt_destroy_prepared_key fs/crypto/keysetup.c:173 [inline]
>  put_crypt_info+0x110/0x2f0 fs/crypto/keysetup.c:560
>  fscrypt_put_encryption_info+0xf6/0x140 fs/crypto/keysetup.c:786
>  f2fs_evict_inode+0x1c9f/0x21f0 fs/f2fs/inode.c:1105
>  evict+0x624/0xb50 fs/inode.c:822
>  dispose_list fs/inode.c:864 [inline]
>  prune_icache_sb+0x223/0x2d0 fs/inode.c:1011
>  super_cache_scan+0x3f5/0x500 fs/super.c:240
>  do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0x838/0x1220 mm/shrinker.c:638
>  shrink_one+0x2a2/0x730 mm/vmscan.c:5119
>  shrink_many mm/vmscan.c:5180 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5258 [inline]
>  shrink_node+0x35d0/0x3e30 mm/vmscan.c:6247
>  kswapd_shrink_node mm/vmscan.c:7101 [inline]
>  balance_pgdat mm/vmscan.c:7279 [inline]
>  kswapd+0x185e/0x32c0 mm/vmscan.c:7555
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

#syz set subsystems: fscrypt
