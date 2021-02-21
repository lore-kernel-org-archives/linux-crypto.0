Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70D8C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Feb 2021 15:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7099164EF2
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Feb 2021 15:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhBUP2J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Feb 2021 10:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhBUP2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Feb 2021 10:28:07 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA0CC061786
        for <linux-crypto@vger.kernel.org>; Sun, 21 Feb 2021 07:27:26 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id a1so4929871qvd.13
        for <linux-crypto@vger.kernel.org>; Sun, 21 Feb 2021 07:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iPVmmhxs1nPmOqsBoFXIubxOd3ZvYPcUYvEPYFP3YTY=;
        b=O07HFtq9Bvh+M5Q4RyO+6cI16GA5pgLxy+ZkcYp4yQKPED5HmT7Y3aZU37U0bhl2+5
         2UjEcV48TTx3ZYn1bGshgefHqG97FvRgzgaCBqMVWD0XBchPkodtClh9RwIOScT0Y3sB
         yN9zLKX1WoHqzB+K/7DO/vTFFc+g8pxy/7rk9YIbVYDEaSCi+elNRbAfXMXUk9S3otVc
         38gPKynirVre5UTdbED8DjZWMWrIkJ0HcRS+AAdf88alE9wo5/Ey3liuR5lxok5x3+Nq
         QXZsT3eeIq9nbK0Ec7SmZ887MVdtKPbeW61v7FKXkQbvm+JooE9bc/ULwF8OWsjsbEeV
         L8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iPVmmhxs1nPmOqsBoFXIubxOd3ZvYPcUYvEPYFP3YTY=;
        b=T3gixQTrc78Ep3X4PdHCy4smiI546wplLzA8zCmLBCH9RHKYY8eB4FwrK/pa0iOzeQ
         /IUV0O9YzFMBBlsbdRRUcq3xSBg57n1iyRndx3WKk6y2a4Ot5Vr+eRMZbQ2Q1sdXfJVC
         znLtgduRjXXnxhZx/UJE6ZmHnm257Dmy5Vb34cQj2KEPsfk5YqNEYXjw6ZToPcL4vXg2
         hdNxcEYQ2Hm14S8jRWXAdMW2B3ZiJALNFi7LPz/pqCNzNxUfBW4TXapYtMCrk0ZLpJpk
         u/mC12yKvYWDmKzGy7quLucaqS7x1HOk5VYQpooy/fbDa0Ql272xowDGaxHS65PEXlcN
         u18g==
X-Gm-Message-State: AOAM532h+gYBqUiGogHoLvJONvk7V2wfvGKcb+XEF4E0fO+qY+q7USLP
        dVuyibhNbL23OXRC+fZTmxN2LxNGM5BphWMaMYkkDg==
X-Google-Smtp-Source: ABdhPJwmklWvYj1u4yRlex6zK9dbRlxQ2he5wmDLA2jwF/mUL32+gwItKmIUTBZR798S9X7UNbxE0ilP3l+ODX6gRtw=
X-Received: by 2002:a0c:a5e2:: with SMTP id z89mr9587076qvz.37.1613921245044;
 Sun, 21 Feb 2021 07:27:25 -0800 (PST)
MIME-Version: 1.0
References: <00000000000079365f05b877530b@google.com> <X/nkga4iirR8QKP2@sol.localdomain>
 <CACT4Y+bGasXBz1UNo+Se5Hc7r3N5ri8i8RO4MXdiLXaGFhGB6w@mail.gmail.com>
In-Reply-To: <CACT4Y+bGasXBz1UNo+Se5Hc7r3N5ri8i8RO4MXdiLXaGFhGB6w@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 21 Feb 2021 16:27:13 +0100
Message-ID: <CACT4Y+Y4J_6xCxshpb3s8fpj=y3nTNf3KXhWZ+aW=+mFEkr+-Q@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in __crypto_memneq (2)
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        syzbot <syzbot+e0f501056b282add58a6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kamal Prasad <kamalpr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 9, 2021 at 6:33 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Jan 9, 2021 at 6:14 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +Jason, since this looks WireGuard-related.
>
> I suspect that the uninit was created by geneve or batadv and then
> just handed off to wireguard, which couldn't deal with it at that
> point.

+Kamal who wants to ask something re batadv

> > On Sat, Jan 09, 2021 at 05:05:24AM -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
> > > git tree:       https://github.com/google/kmsan.git master
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=142ab9c0d00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=e0f501056b282add58a6
> > > compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+e0f501056b282add58a6@syzkaller.appspotmail.com
> > >
> > > =====================================================
> > > BUG: KMSAN: uninit-value in __crypto_memneq_16 crypto/memneq.c:99 [inline]
> > > BUG: KMSAN: uninit-value in __crypto_memneq+0x42c/0x470 crypto/memneq.c:161
> > > CPU: 0 PID: 20526 Comm: kworker/0:3 Not tainted 5.10.0-rc4-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Workqueue: wg-crypt-wg1 wg_packet_decrypt_worker
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x21c/0x280 lib/dump_stack.c:118
> > >  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
> > >  __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
> > >  __crypto_memneq_16 crypto/memneq.c:99 [inline]
> > >  __crypto_memneq+0x42c/0x470 crypto/memneq.c:161
> > >  crypto_memneq include/crypto/algapi.h:277 [inline]
> > >  chacha20poly1305_crypt_sg_inplace+0x1662/0x1cd0 lib/crypto/chacha20poly1305.c:311
> > >  chacha20poly1305_decrypt_sg_inplace+0x179/0x1d0 lib/crypto/chacha20poly1305.c:351
> > >  decrypt_packet drivers/net/wireguard/receive.c:284 [inline]
> > >  wg_packet_decrypt_worker+0x9cf/0x17d0 drivers/net/wireguard/receive.c:509
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
> > >  put_unaligned_le64 include/linux/unaligned/access_ok.h:50 [inline]
> > >  poly1305_core_emit+0x625/0x6a0 lib/crypto/poly1305-donna64.c:182
> > >  poly1305_final_generic+0xe2/0x280 lib/crypto/poly1305.c:71
> > >  poly1305_final include/crypto/poly1305.h:94 [inline]
> > >  chacha20poly1305_crypt_sg_inplace+0x15cf/0x1cd0 lib/crypto/chacha20poly1305.c:310
> > >  chacha20poly1305_decrypt_sg_inplace+0x179/0x1d0 lib/crypto/chacha20poly1305.c:351
> > >  decrypt_packet drivers/net/wireguard/receive.c:284 [inline]
> > >  wg_packet_decrypt_worker+0x9cf/0x17d0 drivers/net/wireguard/receive.c:509
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
> > >  poly1305_core_blocks+0x8f4/0x940 lib/crypto/poly1305-donna64.c:107
> > >  poly1305_update_generic+0x1a7/0x5a0 lib/crypto/poly1305.c:49
> > >  poly1305_update include/crypto/poly1305.h:83 [inline]
> > >  chacha20poly1305_crypt_sg_inplace+0x1496/0x1cd0 lib/crypto/chacha20poly1305.c:302
> > >  chacha20poly1305_decrypt_sg_inplace+0x179/0x1d0 lib/crypto/chacha20poly1305.c:351
> > >  decrypt_packet drivers/net/wireguard/receive.c:284 [inline]
> > >  wg_packet_decrypt_worker+0x9cf/0x17d0 drivers/net/wireguard/receive.c:509
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
> > >  poly1305_core_blocks+0x8f4/0x940 lib/crypto/poly1305-donna64.c:107
> > >  poly1305_update_generic+0x1a7/0x5a0 lib/crypto/poly1305.c:49
> > >  poly1305_update include/crypto/poly1305.h:83 [inline]
> > >  chacha20poly1305_crypt_sg_inplace+0xb4d/0x1cd0 lib/crypto/chacha20poly1305.c:263
> > >  chacha20poly1305_decrypt_sg_inplace+0x179/0x1d0 lib/crypto/chacha20poly1305.c:351
> > >  decrypt_packet drivers/net/wireguard/receive.c:284 [inline]
> > >  wg_packet_decrypt_worker+0x9cf/0x17d0 drivers/net/wireguard/receive.c:509
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
> > >  crypto_xor_cpy include/crypto/algapi.h:167 [inline]
> > >  chacha_crypt_generic+0x696/0x880 lib/crypto/libchacha.c:23
> > >  chacha_crypt include/crypto/chacha.h:90 [inline]
> > >  chacha20_crypt include/crypto/chacha.h:96 [inline]
> > >  chacha20poly1305_crypt_sg_inplace+0xda2/0x1cd0 lib/crypto/chacha20poly1305.c:280
> > >  chacha20poly1305_encrypt_sg_inplace+0x125/0x140 lib/crypto/chacha20poly1305.c:338
> > >  encrypt_packet drivers/net/wireguard/send.c:216 [inline]
> > >  wg_packet_encrypt_worker+0x1288/0x2680 drivers/net/wireguard/send.c:301
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
> > >  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
> > >  __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
> > >  pskb_expand_head+0x3eb/0x1df0 net/core/skbuff.c:1631
> > >  __skb_cow include/linux/skbuff.h:3165 [inline]
> > >  skb_cow_head include/linux/skbuff.h:3199 [inline]
> > >  geneve_build_skb+0x56e/0xf80 drivers/net/geneve.c:753
> > >  geneve6_xmit_skb drivers/net/geneve.c:1023 [inline]
> > >  geneve_xmit+0x2d86/0x3cc0 drivers/net/geneve.c:1056
> > >  __netdev_start_xmit include/linux/netdevice.h:4718 [inline]
> > >  netdev_start_xmit include/linux/netdevice.h:4732 [inline]
> > >  xmit_one+0x2b9/0x770 net/core/dev.c:3564
> > >  dev_hard_start_xmit net/core/dev.c:3580 [inline]
> > >  __dev_queue_xmit+0x33f2/0x4520 net/core/dev.c:4140
> > >  dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
> > >  batadv_send_skb_packet+0x622/0x970 net/batman-adv/send.c:108
> > >  batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
> > >  batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:394 [inline]
> > >  batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
> > >  batadv_iv_send_outstanding_bat_ogm_packet+0xb3a/0xf00 net/batman-adv/bat_iv_ogm.c:1712
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was stored to memory at:
> > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
> > >  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
> > >  kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
> > >  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
> > >  __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
> > >  pskb_expand_head+0x3eb/0x1df0 net/core/skbuff.c:1631
> > >  __skb_cow include/linux/skbuff.h:3165 [inline]
> > >  skb_cow_head include/linux/skbuff.h:3199 [inline]
> > >  batadv_skb_head_push+0x2ce/0x410 net/batman-adv/soft-interface.c:75
> > >  batadv_send_skb_packet+0x1ed/0x970 net/batman-adv/send.c:86
> > >  batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
> > >  batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:394 [inline]
> > >  batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
> > >  batadv_iv_send_outstanding_bat_ogm_packet+0xb3a/0xf00 net/batman-adv/bat_iv_ogm.c:1712
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > >
> > > Uninit was created at:
> > >  kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:121
> > >  kmsan_alloc_page+0xd3/0x1f0 mm/kmsan/kmsan_shadow.c:274
> > >  __alloc_pages_nodemask+0x84e/0xfb0 mm/page_alloc.c:4989
> > >  __alloc_pages include/linux/gfp.h:511 [inline]
> > >  __alloc_pages_node include/linux/gfp.h:524 [inline]
> > >  alloc_pages_node include/linux/gfp.h:538 [inline]
> > >  __page_frag_cache_refill mm/page_alloc.c:5065 [inline]
> > >  page_frag_alloc+0x35b/0x890 mm/page_alloc.c:5095
> > >  __netdev_alloc_skb+0xbee/0xc50 net/core/skbuff.c:456
> > >  __netdev_alloc_skb_ip_align include/linux/skbuff.h:2846 [inline]
> > >  netdev_alloc_skb_ip_align include/linux/skbuff.h:2856 [inline]
> > >  batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:559 [inline]
> > >  batadv_iv_ogm_queue_add+0x143f/0x1cf0 net/batman-adv/bat_iv_ogm.c:671
> > >  batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:834 [inline]
> > >  batadv_iv_ogm_schedule+0xe4e/0x1670 net/batman-adv/bat_iv_ogm.c:870
> > >  batadv_iv_send_outstanding_bat_ogm_packet+0xd7b/0xf00 net/batman-adv/bat_iv_ogm.c:1724
> > >  process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
> > >  worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
> > >  kthread+0x51c/0x560 kernel/kthread.c:292
> > >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> > > =====================================================
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/X/nkga4iirR8QKP2%40sol.localdomain.
