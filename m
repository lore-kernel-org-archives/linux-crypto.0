Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5D17109B
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732536621; cv=none; b=Nn5Jex4meeTbkhawKQQ5McIOo/Wje8eSpnIvU/UGrzYdYgSWuwkF2SO1GtFzpfeV7tB0CTqR/QuOIWGTBVHbdcIKirfT9/aVvsXu3zFme0pdHtZl92Nb6woNLx3jRFFYlKXicf+qQ58lCRu676BqsDVqbbId2wi2OTDsE33JCfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732536621; c=relaxed/simple;
	bh=M73sL3Sv8a2AmHgvN4rmD4glFFe3PxVvIRhLWFtW5nw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dZ8ZngzTljzXhllf2Va9b9UaNjRGJDKkwhT1Zan/6yGbOK/31wRU0UjdK1ldmWv/SHdbzuZYdtqHvQK6iBdDn0BEHB8MFsz51OTLziLMq0G3gJfXRA0AXdVa2niNg9xXA+U23hNMVxYxsD4whtmpV+bTU3BY20TtmmUEg28u780=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-841ac3f9391so14636139f.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 04:10:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732536619; x=1733141419;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LvNl8pxglySFNL33qrPeiBijVQsos1DSC+9lKcfot8=;
        b=FNs+ngHD8sKSOTMhUC/uja9v0RrXn2CRWV6qfVwgq2CwhUHmH95toACK3UIW0vR1wE
         AktSvcoGb5bW/rJe+KgfnPjS06a2frmaEbRcaes/ZmQwX7iZt4YfndnT+JxMuAsvB/JZ
         iILMHMQF68agnKz0t1DcYmuxW1sCNsFobdSkxO9sa4plf4GP/1+lnA/MInLKSpVVYXL9
         j31FoO4ILoqMSaZXF6QpiJ+yrFcY11f7bvYSb9Sc7C52ctJuTSXuaVmTn3v0uuZIGwDc
         rmtNaZ1r9de8Na+6sq3p9rWiZMAOCe/OFPo9cZ+L8a3WLmMDcnzQ7ff08OkitTI57xZP
         S3YQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN1lZiWwSP7dICjiMfuIL4zV8DrU01NskEG25sAKBbvgqB5KXctykTjy7RcvM88OTELNSciATZy2aS+lg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWmTcZiA3Yl1Y893D+ZUkx2VijGM3a4ZQ8gwB/ZHDLHqcHLfLN
	IT9AdSFfBWUwItaVUn7moFllNaJWnhKVAEqQp+LkBTN86YVerYISh0cFMLMLCopyCGpPHpwzTEZ
	bgV0KRRcvIOp1tyhfNXQztkZnqSvIX0wkXcbMV1OCPdOlU24YUrwKGgA=
X-Google-Smtp-Source: AGHT+IEd+vL2cdCw0lS57SC5BYx4BxRT5NTSsvYSV07gZjNtWDmblGqcKb4oLqv9Oo5N2emQZ8sIpRUlN5aqNmxP7Ka5A5qCc8SG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1647:b0:3a7:6c6a:e2a2 with SMTP id
 e9e14a558f8ab-3a79adbb92cmr135862275ab.9.1732536618988; Mon, 25 Nov 2024
 04:10:18 -0800 (PST)
Date: Mon, 25 Nov 2024 04:10:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6744692a.050a0220.1cc393.007a.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in sw842_decompress
From: syzbot <syzbot+e774233ff687aada969e@syzkaller.appspotmail.com>
To: davem@davemloft.net, haren@us.ibm.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16179930580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f17942989df952c
dashboard link: https://syzkaller.appspot.com/bug?extid=e774233ff687aada969e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/73f465d9c9e2/disk-43fb83c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ada4e5d15a14/vmlinux-43fb83c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9c515c61ce6f/bzImage-43fb83c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e774233ff687aada969e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in sw842_decompress+0x7d4/0x24c0 lib/842/842_decompress.c:303
 sw842_decompress+0x7d4/0x24c0 lib/842/842_decompress.c:303
 crypto842_sdecompress+0x45/0x60 crypto/842.c:92
 scomp_acomp_comp_decomp+0x7c6/0xb90
 scomp_acomp_decompress+0x2f/0x40 crypto/scompress.c:192
 crypto_acomp_decompress include/crypto/acompress.h:265 [inline]
 zswap_decompress+0x5ff/0xa30 mm/zswap.c:981
 zswap_load+0x2b7/0x5c0 mm/zswap.c:1576
 swap_read_folio+0x6c6/0x2ac0 mm/page_io.c:634
 swap_cluster_readahead+0xb48/0xbd0 mm/swap_state.c:706
 swapin_readahead+0x205/0x1690 mm/swap_state.c:882
 do_swap_page+0xade/0x9b20 mm/memory.c:4324
 handle_pte_fault mm/memory.c:5769 [inline]
 __handle_mm_fault mm/memory.c:5909 [inline]
 handle_mm_fault+0x3f29/0xdca0 mm/memory.c:6077
 do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x29f/0x700 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x2b/0x30 arch/x86/include/asm/idtentry.h:623
 compat_put_bitmap+0x133/0x390 kernel/compat.c:236
 compat_set_fd_set fs/select.c:1171 [inline]
 compat_core_sys_select+0x98b/0xe20 fs/select.c:1248
 do_compat_pselect+0x50e/0x5c0 fs/select.c:1338
 __do_compat_sys_pselect6_time32 fs/select.c:1386 [inline]
 __se_compat_sys_pselect6_time32 fs/select.c:1377 [inline]
 __ia32_compat_sys_pselect6_time32+0x2dd/0x410 fs/select.c:1377
 ia32_sys_call+0x1b34/0x4180 arch/x86/include/generated/asm/syscalls_32.h:309
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was stored to memory at:
 next_bits+0xd7a/0xe20 lib/842/842_decompress.c:118
 sw842_decompress+0x1c3/0x24c0 lib/842/842_decompress.c:297
 crypto842_sdecompress+0x45/0x60 crypto/842.c:92
 scomp_acomp_comp_decomp+0x7c6/0xb90
 scomp_acomp_decompress+0x2f/0x40 crypto/scompress.c:192
 crypto_acomp_decompress include/crypto/acompress.h:265 [inline]
 zswap_decompress+0x5ff/0xa30 mm/zswap.c:981
 zswap_load+0x2b7/0x5c0 mm/zswap.c:1576
 swap_read_folio+0x6c6/0x2ac0 mm/page_io.c:634
 swap_cluster_readahead+0xb48/0xbd0 mm/swap_state.c:706
 swapin_readahead+0x205/0x1690 mm/swap_state.c:882
 do_swap_page+0xade/0x9b20 mm/memory.c:4324
 handle_pte_fault mm/memory.c:5769 [inline]
 __handle_mm_fault mm/memory.c:5909 [inline]
 handle_mm_fault+0x3f29/0xdca0 mm/memory.c:6077
 do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x29f/0x700 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x2b/0x30 arch/x86/include/asm/idtentry.h:623

Uninit was created at:
 __alloc_pages_noprof+0x9a7/0xe00 mm/page_alloc.c:4774
 alloc_pages_mpol_noprof+0x299/0x990 mm/mempolicy.c:2265
 alloc_pages_noprof+0x1bf/0x1e0 mm/mempolicy.c:2345
 z3fold_alloc mm/z3fold.c:1036 [inline]
 z3fold_zpool_malloc+0x78f/0x1990 mm/z3fold.c:1388
 zpool_malloc+0x85/0xb0 mm/zpool.c:258
 zswap_compress mm/zswap.c:927 [inline]
 zswap_store+0x1f20/0x3650 mm/zswap.c:1460
 swap_writepage+0xa67/0x17f0 mm/page_io.c:279
 pageout mm/vmscan.c:689 [inline]
 shrink_folio_list+0x5e7f/0x7dd0 mm/vmscan.c:1367
 evict_folios+0x9813/0xbaf0 mm/vmscan.c:4589
 try_to_shrink_lruvec+0x13a3/0x1750 mm/vmscan.c:4784
 shrink_one+0x646/0xd20 mm/vmscan.c:4822
 shrink_many mm/vmscan.c:4885 [inline]
 lru_gen_shrink_node mm/vmscan.c:4963 [inline]
 shrink_node+0x451b/0x5170 mm/vmscan.c:5943
 shrink_zones mm/vmscan.c:6201 [inline]
 do_try_to_free_pages+0x820/0x2550 mm/vmscan.c:6263
 try_to_free_pages+0xbed/0x17c0 mm/vmscan.c:6513
 __perform_reclaim mm/page_alloc.c:3927 [inline]
 __alloc_pages_direct_reclaim+0x107/0x330 mm/page_alloc.c:3949
 __alloc_pages_slowpath+0x995/0x16e0 mm/page_alloc.c:4380
 __alloc_pages_noprof+0xa4c/0xe00 mm/page_alloc.c:4764
 alloc_pages_mpol_noprof+0x299/0x990 mm/mempolicy.c:2265
 alloc_pages_noprof+0x1bf/0x1e0 mm/mempolicy.c:2345
 vm_area_alloc_pages mm/vmalloc.c:3568 [inline]
 __vmalloc_area_node mm/vmalloc.c:3646 [inline]
 __vmalloc_node_range_noprof+0x1030/0x2740 mm/vmalloc.c:3828
 vmalloc_user_noprof+0x90/0xb0 mm/vmalloc.c:3982
 kcov_ioctl+0x5a/0x660 kernel/kcov.c:716
 __do_compat_sys_ioctl fs/ioctl.c:1004 [inline]
 __se_compat_sys_ioctl+0x80f/0x1020 fs/ioctl.c:947
 __ia32_compat_sys_ioctl+0x93/0xe0 fs/ioctl.c:947
 ia32_sys_call+0x2226/0x4180 arch/x86/include/generated/asm/syscalls_32.h:55
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 5784 Comm: syz-executor Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
