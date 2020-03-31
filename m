Return-Path: <SRS0=uha7=5Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C34DC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Mar 2020 12:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC37A208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Mar 2020 12:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="datYa4by"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgCaMyV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Mar 2020 08:54:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:18283 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730604AbgCaMyU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Mar 2020 08:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1585659259;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=O+n33gjulUEA+3+JRW5G+8jein/qCQrpZR1NMDiokkg=;
        b=datYa4byzIcKpOXGrPPzbJp7xupIybV55QO8qJXo1sFKQ67OYIVMDmqzjd27YbPh/i
        DcOet3FJSo6K+z/Ly4Arp3GjvSUzm6hD0fo4PykoUuLiDglR+nnUOE23lrOntfg0/4NK
        dhBYDuGTIgsSfI2FaeYIqImZmQHXcfh7tsMAZ2UjksIlkPqm7Wr//6XIDmIuxXCTchE6
        1qS7gCrklJcUYdXqNLTtYwNzcXZVoqtDtA2H5nSXzEFY9aszQdlcmvxZtUWQDUGsvsLl
        T7EbpdKnTIBQEp1riARqC+g3JMcU4BEL7YvScPTwWZ4aUSD/TUP59dCkNX+9qL8i9pnw
        4Sag==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJ/SfQ46x"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.2.1 DYNA|AUTH)
        with ESMTPSA id q0554fw2VCmGNAI
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate)
        for <linux-crypto@vger.kernel.org>;
        Tue, 31 Mar 2020 14:48:16 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Linux Crypto List <linux-crypto@vger.kernel.org>
Subject: POWER8 BE: NX crypto driver caused oops
Date:   Tue, 31 Mar 2020 14:48:15 +0200
Message-ID: <6610324.mVlmhZnPjZ@tauon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

with a 5.5 vanilla kernel, I got the following crash in the NX crypto driver 
on a POWER8 BE system.

When compiling out the NX driver, the boot is successful.

[    5.233403] pseries_rng: Registering IBM pSeries RNG driver
[    5.291347] BUG: Unable to handle kernel data access on read at 0x0488a000
[    5.291360] Faulting instruction address: 0xc0000000000b3530
[    5.291365] Oops: Kernel access of bad area, sig: 11 [#1]
[    5.291370] BE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[    5.291375] Modules linked in: nx_crypto(+) pseries_rng
vmx_crypto(+) ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth
scsi_transport_srp dm_mirror dm_region_hash dm_log dm_mod
[    5.291392] CPU: 2 PID: 933 Comm: cryptomgr_test Not tainted 5.5.0 #1
[    5.291396] NIP:  c0000000000b3530 LR: c00000000036e84c CTR: 
0000000000000200
[    5.291401] REGS: c0000005f9bbb620 TRAP: 0380   Not tainted  (5.5.0)
[    5.291405] MSR:  800000010280b032
<SF,VEC,VSX,EE,FP,ME,IR,DR,RI,TM[E]>  CR: 44008420  XER: 20000010
[    5.291415] CFAR: c0000000000b34ec IRQMASK: 0
[    5.291415] GPR00: 0000000000000200 c0000005f9bbb8b0
c0000000018e6c00 000000000488a000
[    5.291415] GPR04: 0000000000000000 0000000000000000
000000000488a000 0000000000000000
[    5.291415] GPR08: 0000000000000000 c0000005f901d700
0000000000000000 c008000001565f80
[    5.291415] GPR12: c00000000036e810 c00000001ecad600
c000000000170e10 c0000005f7331f00
[    5.291415] GPR16: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
[    5.291415] GPR20: 0000000000000000 0000000000000000
c000000001896ec8 c00000000d0b9c00
[    5.291415] GPR24: 0000000000000400 c000000000c2fec8
0000000000000000 c00000000ce3da28
[    5.291415] GPR28: c00000000d178800 c00000000ce3da00
c00000000ce3da28 000000000488a000
[    5.291461] NIP [c0000000000b3530] .memset+0x68/0x104
[    5.291466] LR [c00000000036e84c] .kzfree+0x3c/0x60
[    5.291469] Call Trace:
[    5.291473] [c0000005f9bbb8b0] [c00000000036e83c] .kzfree+0x2c/0x60
(unreliable)
[    5.291482] [c0000005f9bbb930] [c008000001561a44]
.nx_crypto_ctx_skcipher_exit+0x24/0x50 [nx_crypto]
[    5.291490] [c0000005f9bbb9b0] [c0000000005b8e5c]
.crypto_skcipher_exit_tfm+0x3c/0x60
[    5.291496] [c0000005f9bbba30] [c0000000005b3424]
.crypto_destroy_tfm+0x74/0x150
[    5.291502] [c0000005f9bbbac0] [c0000000005c6724]
.alg_test_skcipher+0xe4/0x1c0
[    5.291508] [c0000005f9bbbb70] [c0000000005c36bc] .alg_test+0x49c/0x590
[    5.291513] [c0000005f9bbbce0] [c0000000005c1df4] .cryptomgr_test+0x64/0x70
[    5.291519] [c0000005f9bbbd60] [c000000000170f60] .kthread+0x150/0x190
[    5.291526] [c0000005f9bbbe20] [c00000000000b644]
.ret_from_kernel_thread+0x58/0x74
[    5.291530] Instruction dump:
[    5.291534] 409e000c b0860000 38c60002 409d000c 90860000 38c60004
78a0d183 78a506a0
[    5.291541] 7c0903a6 41820034 60000000 60000000 <f8860000> f8860008
f8860010 f8860018
[    5.291551] ---[ end trace 06547fcdb2cf5b98 ]---
[    5.295565]
[    5.306315] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    6.295575] Kernel panic - not syncing: Fatal exception

Ciao
Stephan


