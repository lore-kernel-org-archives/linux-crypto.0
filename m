Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAA5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jun 2022 02:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiFCCLj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jun 2022 22:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiFCCLj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jun 2022 22:11:39 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACA62BE0
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jun 2022 19:11:37 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id ew15so4711858qtb.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jun 2022 19:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=wg4v5cJRl93lWxCvOMBbcTwGJExaNjPwdU1/CzXBUaQ=;
        b=cF3k1BXhhrBEyUZNh9MLrZfYdPDIgxQMqh/uOy9jYPW4y81PNrJH62y/6Yv66mKztV
         lNSMsp6eq4Mxz6K6TMi8jQzlesJ61vrr2ScR1cdfbD4B3u/sp6eaETxVlXyQKHGLDk6Y
         cawdJvQai1PtVdm396qK7hSSDTHKqAVNtmMAdrh+WHGuW/OoAfC2ZisTZBwj2M+6okFj
         95kSxJc3pxWAM+5ne0vZCbO11GVBKPs+x5E4jF2McyN3EHEXmnLuNQQOWN2bGD67vJqj
         gupepA+u/7uxXpAqmuLLZMmdn0M5+Zof1x7CCl/6/QMfhtKdLOzio4gLeBt5Aan/ztlN
         C4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=wg4v5cJRl93lWxCvOMBbcTwGJExaNjPwdU1/CzXBUaQ=;
        b=B1W7+WNzl9kzIGLAnX/L9W3gCs5OIBpE9XpcxFvkmM6YEiGF2ELrh8UZdXWHplQsaw
         BGK63Ld6Fp88EVF7EEMJbvRH18RuJfS4XD8JPpP/FDofPXOgiMhYJw4TolKZfRsKaSs2
         PJuGb4CL5d1L6ALdJys3MCQloYnMHw2lbsnvUxwdr8H4RAhDBVzpX15EyBB4NKMkcj53
         7NSCbzkhTesGbR09CfMSTu/+TAWESCLiLWMhDge9/mTyo4M/ZHvczkdp0E2dl9HwQRrC
         iobat9CEs8lkDNVLqrQd+bOZ6uwN8jry9mXHr8UraUBYkE0uQeon8+7kb1W2H3mT7p07
         Ao7Q==
X-Gm-Message-State: AOAM530e5Q7ATgKKdgYRFePVtKn3rKBE2bMUjegUsLL8kRuMKmU/oyrU
        QostXpScoJvNg4slrGYqMyUJvo/sdt9n
X-Google-Smtp-Source: ABdhPJyl8w/RROop65kGrudPHWLIo0q3ip0xfWKnRXtLHcmuVpDZuXARxhIF+M9vyvw3h8QTl4ha1Q==
X-Received: by 2002:a05:622a:246:b0:2f3:d514:7ac with SMTP id c6-20020a05622a024600b002f3d51407acmr5889923qtx.688.1654222296935;
        Thu, 02 Jun 2022 19:11:36 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id bz11-20020a05622a1e8b00b002f77a8bc37fsm4039144qtb.51.2022.06.02.19.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 19:11:35 -0700 (PDT)
Date:   Thu, 2 Jun 2022 22:11:34 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     ebiggers@google.com, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: Memory corruption related to skcipher code
Message-ID: <20220603021134.ehlnluenrz3adpxc@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In bcachefs, we've been getting reports of memory corruption, and I finally came
up with a way to reproduce it - fstests generic/269, with encryption enabled
(bcachefs uses chacha20 & poly1305).

It looks like a stray pointer write - I see corruption in a lot of areas, and
it's really easy to spot if I've got kasan, or slub debugging, or pagealloc
debug on - but I haven't been having any luck yet with finding the stray
_write_. kasan does spot stray reads, example below:

It also looks like a regression, but not a recent one - I tested as far back as
about 5.10 before I ran into problems with the kernel building with my current
toolchain, feh.

Example kasan splat below - as you can see we're in skcipher_next_slow(). I
think what's going on, and the reason bcachefs is hitting this and not other
chacha20 users, is that the lengths we're encrypting aren't aligned to the
chacha20 blocksize. We're hitting this in the bcachefs btree io path, not the
normal user data path where the crypto calls are chacha20 blocksize aligned.

Any chance one of you could help with debugging this? I'd be happy to get you
whatever info you need, or help you reproduce it with ktest [1]

1: https://evilpiepirate.org/git/ktest.git/

00024 BUG: KASAN: slab-out-of-bounds in scatterwalk_copychunks (include/linux/uaccess.h:184 include/linux/uaccess.h:211 include/linux/highmem-internal.h:227 include/crypto/scatterwalk.h:62 crypto/scatterwalk.c:39) 
00024 Read of size 32 at addr ffff88806f01afe0 by task fsstress/1436
00024 
00024 CPU: 1 PID: 1436 Comm: fsstress Not tainted 5.18.0-01355-gfad6d13aa55f #1
00024 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
00024 Call Trace:
00024  <TASK>
00024 dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
00024 print_report.cold (mm/kasan/report.c:314 mm/kasan/report.c:429) 
00024 ? scatterwalk_copychunks (include/linux/uaccess.h:184 include/linux/uaccess.h:211 include/linux/highmem-internal.h:227 include/crypto/scatterwalk.h:62 crypto/scatterwalk.c:39) 
00024 kasan_report (mm/kasan/report.c:493) 
00024 ? scatterwalk_copychunks (include/linux/uaccess.h:184 include/linux/uaccess.h:211 include/linux/highmem-internal.h:227 include/crypto/scatterwalk.h:62 crypto/scatterwalk.c:39) 
00024 kasan_check_range (mm/kasan/generic.c:190) 
00024 memcpy (mm/kasan/shadow.c:65) 
00024 scatterwalk_copychunks (include/linux/uaccess.h:184 include/linux/uaccess.h:211 include/linux/highmem-internal.h:227 include/crypto/scatterwalk.h:62 crypto/scatterwalk.c:39) 
00024 skcipher_walk_next (crypto/skcipher.c:280 crypto/skcipher.c:363) 
00024 skcipher_walk_done (crypto/skcipher.c:159) 
00024 chacha_simd_stream_xor (arch/x86/crypto/chacha_glue.c:174) 
00024 ? chacha_crypt_arch (arch/x86/crypto/chacha_glue.c:165) 
00024 ? bch2_inode_to_text (fs/bcachefs/inode.c:414) 
00024 ? key_type_inline_data_to_text (fs/bcachefs/bkey_methods.c:127) 
00024 ? vfs_truncate (fs/open.c:111) 
00024 chacha_simd (arch/x86/crypto/chacha_glue.c:204) 
00024 crypto_skcipher_encrypt (crypto/skcipher.c:633) 
00024 do_encrypt_sg (fs/bcachefs/checksum.c:107) 
00024 ? bch2_chardev_exit (fs/bcachefs/checksum.c:99) 
00024 ? validate_bset_keys.constprop.0 (fs/bcachefs/btree_io.c:780) 
00024 ? validate_bset (fs/bcachefs/btree_io.c:645) 
00024 ? btree_node_sort (fs/bcachefs/btree_io.c:645) 
00024 ? bch2_bkey_invalid (fs/bcachefs/bkey_methods.c:260) 
00024 ? __bch2_bkey_invalid (fs/bcachefs/bkey_methods.c:259) 
00024 ? vmalloc_to_page (mm/vmalloc.c:696) 
00024 bch2_encrypt (fs/bcachefs/checksum.c:217) 
00024 ? bch2_checksum (fs/bcachefs/checksum.c:213) 
00024 __bch2_btree_node_write (fs/bcachefs/btree_io.c:1938) 
00024 ? bset_aux_tree_verify (fs/bcachefs/bset.c:385) 
00024 ? bch2_btree_complete_write (fs/bcachefs/btree_io.c:1777) 
00024 ? bset_aux_tree_buf_end (fs/bcachefs/bset.c:328 (discriminator 2)) 
00024 ? __kasan_check_write (mm/kasan/shadow.c:38) 
00024 ? mutex_unlock (arch/x86/include/asm/atomic64_64.h:190 include/linux/atomic/atomic-long.h:449 include/linux/atomic/atomic-instrumented.h:1790 kernel/locking/mutex.c:178 kernel/locking/mutex.c:537) 
00024 ? __mutex_unlock_slowpath.constprop.0 (kernel/locking/mutex.c:535) 
00024 ? btree_update_add_key.constprop.0 (fs/bcachefs/keylist.h:25 fs/bcachefs/btree_update_interior.c:519) 
00024 bch2_btree_node_write (include/linux/instrumented.h:71 include/asm-generic/bitops/instrumented-non-atomic.h:134 fs/bcachefs/btree_types.h:466 fs/bcachefs/btree_io.c:2096) 
00024 btree_split.isra.0 (fs/bcachefs/btree_update_interior.c:1460) 
00024 ? bch2_btree_update_start (fs/bcachefs/btree_update_interior.c:1079) 
00024 ? __btree_split_node (fs/bcachefs/btree_update_interior.c:973) 
00024 ? bch2_btree_node_alloc_replacement (fs/bcachefs/btree_update_interior.c:1397) 
00024 bch2_btree_split_leaf (fs/bcachefs/btree_update_interior.c:1606) 
00024 ? bch2_inode_v2_invalid (fs/bcachefs/inode.c:363) 
00024 bch2_trans_commit_error (fs/bcachefs/btree_update_leaf.c:970) 
00024 ? bch2_setattr_nonsize (fs/bcachefs/btree_update.h:106 fs/bcachefs/fs.c:752) 
00024 ? bch2_trans_update_by_path (fs/bcachefs/btree_update_leaf.c:964) 
00024 ? six_unlock_write (arch/x86/include/asm/atomic64_64.h:160 include/linux/atomic/atomic-instrumented.h:699 kernel/locking/six.c:572 kernel/locking/six.c:607) 
00024 ? bch2_bkey_invalid (fs/bcachefs/bkey_methods.c:260) 
00024 ? bch2_btree_path_verify_locks (fs/bcachefs/btree_iter.c:401 fs/bcachefs/btree_iter.c:391) 
00024 __bch2_trans_commit (fs/bcachefs/btree_update_leaf.c:1182) 
00024 ? bch2_btree_add_journal_pin (fs/bcachefs/btree_update_leaf.c:1084) 
00024 bch2_setattr_nonsize (fs/bcachefs/btree_update.h:106 fs/bcachefs/fs.c:752) 
00024 ? xas_start (lib/xarray.c:193) 
00024 ? bch2_unlink (fs/bcachefs/fs.c:707) 
00024 ? bch2_inode_peek (fs/bcachefs/inode.c:262) 
00024 ? truncate_inode_partial_folio (mm/truncate.c:332) 
00024 ? __kernel_text_address (kernel/extable.c:79) 
00024 ? truncate_pagecache (mm/truncate.c:755) 
00024 bch2_truncate (fs/bcachefs/fs-io.c:2721) 
00024 ? bch2_fsync (fs/bcachefs/fs-io.c:2622) 
00024 ? __kasan_check_write (mm/kasan/shadow.c:38) 
00024 ? lockref_get_not_dead (lib/lockref.c:203 (discriminator 7)) 
00024 ? setattr_prepare (fs/attr.c:108) 
00024 ? find_inode_rcu (fs/inode.c:2455) 
00024 bch2_setattr (fs/bcachefs/fs.c:830) 
00024 notify_change (fs/attr.c:414) 
00024 do_truncate (fs/open.c:66) 
00024 ? file_open_root (fs/open.c:41) 
00024 ? get_acl (fs/posix_acl.c:121) 
00024 ? inode_permission (fs/namei.c:533) 
00024 vfs_truncate (fs/open.c:111) 
00024 do_sys_truncate.part.0 (fs/open.c:135) 
00024 ? vfs_truncate (fs/open.c:122) 
00024 ? __kasan_check_read (mm/kasan/shadow.c:32) 
00024 ? fpregs_assert_state_consistent (arch/x86/kernel/fpu/context.h:39 arch/x86/kernel/fpu/core.c:757) 
00024 __x64_sys_truncate (fs/open.c:144) 
00024 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
00024 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115) 
