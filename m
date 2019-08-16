Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D702BC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 09:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1FAB20644
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 09:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="m/+VxdOS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHPJui (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 05:50:38 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:15709 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfHPJui (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 05:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1565949036;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=WRrh4q2xcbU2Qb4nejmxfAOg95FcdwV4XpuO6ig21iQ=;
        b=m/+VxdOSI/8xrIbglRoONVTW73r7UaLaJm/tLOqEJ3xhI6tdRS/b2O/jo3vQsQKz90
        N5+2/FKCWH6u1p88hJp61AQFHHUvaD1ljevw8cdf+kL4INjkglcw0SeDw/yJHFqUmVoE
        KUzSQOFlQTv3eT6ok6FlaRdzkbxyujwSYvR7qyiHtqtlfMYIEDq/ZDtkpabZxOn2y6f6
        3KiC7SeBZkYAB1lXc6F9JP3UkamkvcsThtCRP2Z8HlXtu2eouus7kbYGfncOndYozjxC
        K4tVsVVjyj8+SjRWEFPdcguOFMWyjeGE9r6fUShQs+SsVSziX3Bf8x5GhXplue2NPmy1
        8EqQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIvSfYak+"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.26.1 DYNA|AUTH)
        with ESMTPSA id u073a8v7G9oaI3F
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-crypto@vger.kernel.org>;
        Fri, 16 Aug 2019 11:50:36 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org
Subject: XTS self test fail
Date:   Fri, 16 Aug 2019 11:50:36 +0200
Message-ID: <1989109.29ScpdGMdu@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

with the current cryptodev-2.6 code, I get the following with fips=1:

[   22.301826] alg: skcipher: xts-aes-aesni encryption failed on test vector 
"random: len=28 klen=64"; expected_error=0, actual_error=-22, cfg="random: 
inplace may_sleep use_final src_divs=[<reimport>100.0%@+20] iv_offset=57"
[   22.304800] Kernel panic - not syncing: alg: self-tests for xts-aes-aesni 
(xts(aes)) failed in fips mode!
[   22.305709] CPU: 0 PID: 259 Comm: cryptomgr_test Not tainted 5.3.0-rc1+ #9
[   22.305709] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.12.0-2.fc30 04/01/2014
[   22.305709] Call Trace:
[   22.305709]  dump_stack+0x7c/0xc0
[   22.305709]  panic+0x240/0x453
[   22.305709]  ? add_taint.cold+0x11/0x11
[   22.305709]  ? __atomic_notifier_call_chain+0x5/0x130
[   22.305709]  ? notifier_call_chain+0x27/0xb0
[   22.305709]  alg_test+0x789/0x8d0
[   22.305709]  ? valid_testvec_config+0x1d0/0x1d0
[   22.305709]  ? lock_downgrade+0x380/0x380
[   22.305709]  ? lock_acquire+0xff/0x220
[   22.305709]  ? __kthread_parkme+0x45/0xd0
[   22.305709]  ? mark_held_locks+0x24/0x90
[   22.305709]  ? _raw_spin_unlock_irqrestore+0x43/0x50
[   22.305709]  ? lockdep_hardirqs_on+0x1a8/0x290
[   22.305709]  cryptomgr_test+0x36/0x60
[   22.305709]  kthread+0x1a8/0x200
[   22.305709]  ? crypto_acomp_scomp_free_ctx+0x70/0x70
[   22.305709]  ? kthread_create_on_node+0xd0/0xd0
[   22.305709]  ret_from_fork+0x3a/0x50
[   22.305709] Kernel Offset: 0x35000000 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffffbfffffff)
[   22.305709] ---[ end Kernel panic - not syncing: alg: self-tests for xts-
aes-aesni (xts(aes)) failed in fips mode! ]---

Ciao
Stephan


