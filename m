Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90DF5BACF
	for <linux-crypto@vger.kernel.org>; Sat,  4 May 2024 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714843260; cv=none; b=oqL/V+sglCvAO0euI6OLhMAmSC7ki13TGeUf1YLJ1hs9xGTzYQLAIKVYIMObqgmGExNzMxg1pdZVHESUr2Y2zi8ePlykZ8PGGTROqqM6InZRAtmR1VwbsM6FnPeutC4VHUI417WnRYKRC9YpIU61CllYXQ/deCNDmtY1Ts6oL00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714843260; c=relaxed/simple;
	bh=3saRA6SBdzl9SBOCA/zci7qviK/yYTa76i0JUnx/cNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhsM623zVut2giMfjMehy15ZmTs0111Ari8kJd49NzS1qAe9hVbXZvZCk7MbR658cwf8rubneumrptiN+yLd8dpp0aj9k7mfyOhupyUxBEJQ7yKd2Equ4kjRNzCOQmnCWze0BpjO4oPFR3BN+1obz50tNuagsUmkTeyiliQ5xKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lj1yOIZ7; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lj1yOIZ7"
Date: Sat, 4 May 2024 13:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714843255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0w5rO3Pwqv2w3mazjvQomUpMSBaL5ssVKBpQd/18nTA=;
	b=lj1yOIZ7F5N9Zb0e5FUs0T+ggMWApj81B9RBZcnTrXTA4sSMekgJwlIn/2Q5d7pTWTY7T0
	vkV/s+lcBas64zBALEJdtt2wpo4GOXkX3uB8tp/xh0cha0iCR9jOeGynx+KijKHjWwKaWJ
	r82nfL56XrWrqhblxfLsX0PHuXONUFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com>, 
	davem@davemloft.net, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in skcipher_walk_virt
Message-ID: <yyxz7mm542wyswp7o6t7oagqq543scntvvtrvros3iqvfjewb2@3ksyadymtnrn>
References: <000000000000dcd2ae06178bccb0@google.com>
 <CANp29Y5k1S5ETBibTzWv7y6jiKevOhMYg0LYqM+PGvuFYiM14A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y5k1S5ETBibTzWv7y6jiKevOhMYg0LYqM+PGvuFYiM14A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

This is odd - it seems to be req->base.flags that's uninitialized, and I
can't find the code that's supposed to be initializing it - but bcachefs
usage seems to be the same as all the other uses I'm looking at; if it
is req->base.flags then other code must be buggy as well?

On Fri, May 03, 2024 at 02:34:30PM +0200, Aleksandr Nogikh wrote:
> #syz set subsystems: bcachefs
> 
> On Fri, May 3, 2024 at 2:24 PM syzbot
> <syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    f03359bca01b Merge tag 'for-6.9-rc6-tag' of git://git.kern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17c169df180000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf567496022057b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=97b4444a5bd7bf30b3a8
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/b345b1c01095/disk-f03359bc.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/d59970ea319e/vmlinux-f03359bc.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/47407f406f40/bzImage-f03359bc.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com
> >
> > loop3: detected capacity change from 0 to 32768
> > bcachefs (loop3): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
> > bcachefs (loop3): recovering from clean shutdown, journal seq 10
> > =====================================================
> > BUG: KMSAN: uninit-value in skcipher_walk_virt+0x91/0x1a0 crypto/skcipher.c:504
> >  skcipher_walk_virt+0x91/0x1a0 crypto/skcipher.c:504
> >  chacha_stream_xor+0x7c/0x710 crypto/chacha_generic.c:22
> >  crypto_chacha_crypt+0x79/0xb0 crypto/chacha_generic.c:45
> >  crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
> >  do_encrypt_sg fs/bcachefs/checksum.c:107 [inline]
> >  do_encrypt+0x99c/0xc30 fs/bcachefs/checksum.c:127
> >  gen_poly_key fs/bcachefs/checksum.c:190 [inline]
> >  bch2_checksum+0x21f/0x7c0 fs/bcachefs/checksum.c:226
> >  bch2_btree_node_read_done+0x1898/0x75e0 fs/bcachefs/btree_io.c:1055
> >  btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
> >  bch2_btree_node_read+0x3d42/0x4b50
> >  __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
> >  bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
> >  read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
> >  bch2_fs_recovery+0x7adb/0x9310 fs/bcachefs/recovery.c:785
> >  bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
> >  bch2_fs_open+0x135f/0x1670 fs/bcachefs/super.c:2102
> >  bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
> >  legacy_get_tree+0x114/0x290 fs/fs_context.c:662
> >  vfs_get_tree+0xa7/0x570 fs/super.c:1779
> >  do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
> >  path_mount+0x742/0x1f20 fs/namespace.c:3679
> >  do_mount fs/namespace.c:3692 [inline]
> >  __do_sys_mount fs/namespace.c:3898 [inline]
> >  __se_sys_mount+0x725/0x810 fs/namespace.c:3875
> >  __ia32_sys_mount+0xe3/0x150 fs/namespace.c:3875
> >  ia32_sys_call+0x3a9a/0x40a0 arch/x86/include/generated/asm/syscalls_32.h:22
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
> >  __do_fast_syscall_32+0xb4/0x120 arch/x86/entry/common.c:386
> >  do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
> >  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
> >  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > Local variable __req_desc.i created at:
> >  do_encrypt_sg fs/bcachefs/checksum.c:101 [inline]
> >  do_encrypt+0x8f9/0xc30 fs/bcachefs/checksum.c:127
> >  gen_poly_key fs/bcachefs/checksum.c:190 [inline]
> >  bch2_checksum+0x21f/0x7c0 fs/bcachefs/checksum.c:226
> >
> > CPU: 1 PID: 15218 Comm: syz-executor.3 Not tainted 6.9.0-rc6-syzkaller-00131-gf03359bca01b #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> > =====================================================
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000dcd2ae06178bccb0%40google.com.
