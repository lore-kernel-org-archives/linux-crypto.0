Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED392C4CECE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 15:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83F5206B7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 15:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="rSd5X0zy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCMPni (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:43:38 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32834 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgCMPni (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 11:43:38 -0400
Received: by mail-ot1-f66.google.com with SMTP id g15so10552801otr.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2020 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Yk8SyjkedWcG2BXnpHX1Q0mNMp4pp9j5pSXt/1RWy8E=;
        b=rSd5X0zykUQxUes4RdG1nOZYSBi8gIBWnHh4Rtrc6q3SwGGTpwx/30kXIwFMzwQb0q
         sX6e9oLwAeLtdCaX52iaelpvB1Wqk+jVp41HamZAyTp7DCCDbf8qPkqBIGPwlLzPVfTE
         wYOG4tYiKhznOpMBFCIxbpNgETD/LySaknqUEgf9CWhNaAYiJl4nHNdrB4YPuAOiOhs6
         Z1n8Cvn4F5LSOI/6qNE5wec8BuxFL6PoCNqM9AmZT+SA+U6PhjPB+lPjbyHcV2LKxun0
         puL3mbAd5sOI00cD3YVssuZ/KhT/GmlrnFzVjvxcdH0BYW28poLOrxxQZUVt6K2YBADM
         jXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Yk8SyjkedWcG2BXnpHX1Q0mNMp4pp9j5pSXt/1RWy8E=;
        b=o8vH4GlKvxMRQ0ayA9F9ts49i20WNg7Z9dWMyfb4fzpY27y7/ZSNyFUy1tBX3yytOr
         c6v+HXZN9T9uK9TwJJ7etflBcufIifmrZXmn+CR0Ptcq+l9iO/cQhx4WFszlPgVHJJLQ
         9wXn7ND+DYPtibE9DYYQ/tboQNLZ9+9ZypsQzD00jJADVfOzGX35zuq56B3XV3lXizNN
         eKZC2pd+v/0PY5NAheYb+q9ykpatpdueVSoYpHqB/8LgkH4/iuWXV/tE5rqbrhQ5ZwUy
         ao6fHXDXvm34IDzMRMlx8Y2pacvMjEgce3F3NcCQc+V7/5yrwlgqvHfn7dqO4kFGiiZJ
         HagA==
X-Gm-Message-State: ANhLgQ1zQHh7GO3/6LrHaRaumVqAGL0uqiLmClMHscW6Ozmh834IRQ0Y
        a5flWJNAT/fJttIiCrldqnRhwfqpkZuD8PdrGwUeOw==
X-Google-Smtp-Source: ADFU+vtxN+jLaPsv7/0+8gRJG1W4zsa/YD2Q2I81Q7aiP2XACm0zgdI1WntiCKIM4LbhJEFgteWa4aAZUYJBPsHgecg=
X-Received: by 2002:a9d:6946:: with SMTP id p6mr11598855oto.224.1584114215024;
 Fri, 13 Mar 2020 08:43:35 -0700 (PDT)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 13 Mar 2020 08:43:23 -0700
Message-ID: <CAJ+vNU2nO6CQD0gq4qqnc8FU6jhfygdzk0Vp9VQ9Jjwzfa1Kog@mail.gmail.com>
Subject: thunder-cptvf 0000:04:00.4: rejecting DMA map of vmalloc memory
To:     George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Greetings,

I'm testing 5.6-rc5 on an OcteonTX (TX1) and seeing some issues with
the CPT driver.

[   18.937693] cavium_rng_pf 0000:02:00.0: Adding to iommu group 20
[   19.032430] thunder-cpt 0000:04:00.0: Adding to iommu group 21
[   19.045137] pci 0000:02:00.1: [177d:a033] type 00 class 0x120000
[   19.744218] cavium_rng_vf 0000:02:00.1: Adding to iommu group 22
[   19.745730] random: crng init done
[   19.745739] random: 7 urandom warning(s) missed due to ratelimiting
[   19.765222] thunder-cpt 0000:04:00.0: Microcode Loaded CNT8x-MC-AE-MAIN-0001
[   19.812692] thunder-cpt 0000:04:00.0: Microcode Loaded CNT8x-MC-SE-IPSEC-0002
[   19.917153] pci 0000:04:00.1: [177d:a041] type 00 class 0x108000
[   19.917585] pci 0000:04:00.2: [177d:a041] type 00 class 0x108000
[   19.917930] pci 0000:04:00.3: [177d:a041] type 00 class 0x108000
[   19.918263] pci 0000:04:00.4: [177d:a041] type 00 class 0x108000
[   19.918625] thunder-cpt 0000:04:00.0: SRIOV enabled, number of VF available 4
[   20.139618] thunder-cptvf 0000:04:00.1: Adding to iommu group 23
[   20.139756] thunder-cptvf 0000:04:00.1: enabling device (0004 -> 0006)
[   20.157195] thunder-cptvf 0000:04:00.1: Creating VQ worker threads (1)
[   20.241429] thunder-cptvf 0000:04:00.2: Adding to iommu group 24
[   20.241568] thunder-cptvf 0000:04:00.2: enabling device (0004 -> 0006)
[   20.265181] thunder-cptvf 0000:04:00.2: Creating VQ worker threads (1)
[   20.345397] thunder-cptvf 0000:04:00.3: Adding to iommu group 25
[   20.345525] thunder-cptvf 0000:04:00.3: enabling device (0004 -> 0006)
[   20.365193] thunder-cptvf 0000:04:00.3: Creating VQ worker threads (1)
[   20.457380] thunder-cptvf 0000:04:00.4: Adding to iommu group 26
[   20.457500] thunder-cptvf 0000:04:00.4: enabling device (0004 -> 0006)
[   20.477220] thunder-cptvf 0000:04:00.4: Creating VQ worker threads (1)
[   20.557904] ------------[ cut here ]------------
[   20.557913] thunder-cptvf 0000:04:00.3: rejecting DMA map of vmalloc memory
[   20.557977] WARNING: CPU: 2 PID: 473 at ./include/linux/dma-mapping.h:585 set
up_sgio_components.isra.12+0x394/0x3a8 [cptvf]
[   20.557980] Modules linked in: cptvf(+) cavium_rng_vf rng_core cptpf cavium_r
ng crct10dif_ce algif_rng af_alg ip_tables x_tables ipv6 nf_defrag_ipv6
[   20.558008] CPU: 2 PID: 473 Comm: cryptomgr_test Not tainted 5.6.0-rc5-00349-
gc64926f #26
[   20.558012] Hardware name: Gateworks Newport CN80XX GW6404 (DT)
[   20.558016] pstate: 20000005 (nzCv daif -PAN -UAO)
[   20.558023] pc : setup_sgio_components.isra.12+0x394/0x3a8 [cptvf]
[   20.558030] lr : setup_sgio_components.isra.12+0x394/0x3a8 [cptvf]
[   20.558033] sp : ffff800012ecb6b0
[   20.558035] x29: ffff800012ecb6b0 x28: ffff000072c64600
[   20.558041] x27: ffff800012ecb980 x26: 0000000000000010
[   20.558045] x25: 0001000000000000 x24: ffff000077ddc000
[   20.558050] x23: 0000000000000004 x22: ffff000077ddc0b0
[   20.558054] x21: ffff000071c69890 x20: 0000000000000002
[   20.558059] x19: ffff000071c698c0 x18: ffff800011201000
[   20.558063] x17: 0000000000000000 x16: 0000000000000000
[   20.558068] x15: 00000000fffffff0 x14: ffff8000112a5008
[   20.558073] x13: ffff8000112a4000 x12: ffff800011201000
[   20.558077] x11: 0000000000000000 x10: ffff8000112a4658
[   20.558082] x9 : 0000000000000000 x8 : 0000000000000004
[   20.558086] x7 : 0000000000000213 x6 : ffff8000112a4000
[   20.558091] x5 : 0000000000000001 x4 : 0000000000000000
[   20.558095] x3 : 0000000000000007 x2 : 0000000000000000
[   20.558099] x1 : 7e2134a19dc68000 x0 : 0000000000000000
[   20.558104] Call trace:
[   20.558112]  setup_sgio_components.isra.12+0x394/0x3a8 [cptvf]
[   20.558119]  process_request+0xd4/0xd30 [cptvf]
[   20.558125]  cptvf_do_request+0x34/0x140 [cptvf]
[   20.558132]  cvm_encrypt+0x284/0x2e0 [cptvf]
[   20.558141]  crypto_skcipher_encrypt+0x20/0x30
[   20.558146]  test_skcipher_vec_cfg+0x270/0x780
[   20.558150]  test_skcipher_vec+0x88/0x140
[   20.558154]  alg_test_skcipher+0xc4/0x1f0
[   20.558159]  alg_test+0x100/0x408
[   20.558163]  cryptomgr_test+0x44/0x50
[   20.558169]  kthread+0x118/0x120
[   20.558173]  ret_from_fork+0x10/0x1c
[   20.558177] ---[ end trace 2761a15f2801a65a ]---
[   20.558186] thunder-cptvf 0000:04:00.3: DMA map kernel buffer failed for comp
onent: 2
[   20.571606] ------------[ cut here ]------------
[   20.571623] WARNING: CPU: 2 PID: 473 at drivers/iommu/io-pgtable-arm.c:655 ar
m_lpae_unmap+0x78/0x88
[   20.571626] Modules linked in: cptvf(+) cavium_rng_vf rng_core cptpf cavium_r
ng crct10dif_ce algif_rng af_alg ip_tables x_tables ipv6 nf_defrag_ipv6
[   20.571652] CPU: 2 PID: 473 Comm: cryptomgr_test Tainted: G        W
5.6.0-rc5-00349-gc64926f #26
[   20.571654] Hardware name: Gateworks Newport CN80XX GW6404 (DT)
[   20.571659] pstate: 40000005 (nZcv daif -PAN -UAO)
[   20.571662] pc : arm_lpae_unmap+0x78/0x88
[   20.571666] lr : arm_smmu_unmap+0x40/0xb8
[   20.571669] sp : ffff800012ecb570
[   20.571672] x29: ffff800012ecb570 x28: ffff000072c64600
[   20.571677] x27: ffff800012ecb980 x26: 0000000000000010
[   20.571681] x25: ffff000076915558 x24: ffff800012ecb660
[   20.571686] x23: ffff80001123c508 x22: 0000000000002000
[   20.571690] x21: ffff00007b7d5c80 x20: fffffffffffff000
[   20.571695] x19: ffff000076915658 x18: 0000000000000000
[   20.571699] x17: 0000000000000000 x16: 0000000000000000
[   20.571704] x15: 0000a24c6994ac8e x14: 00000000000000da
[   20.571708] x13: 0000000000000001 x12: 0000000000000000
[   20.571713] x11: 000000000000b5a0 x10: 00000000000009c0
[   20.571718] x9 : ffff800012ecb310 x8 : ffff0000768ede20
[   20.571722] x7 : 0000000000001000 x6 : ffff000076915600
[   20.571727] x5 : 0000000040201000 x4 : ffffffffffffffff
[   20.571731] x3 : ffff800012ecb660 x2 : 0000000000001000
[   20.571736] x1 : fffffffffffff000 x0 : 0000000000000000
[   20.571741] Call trace:
[   20.571745]  arm_lpae_unmap+0x78/0x88
[   20.571749]  arm_smmu_unmap+0x40/0xb8
[   20.571754]  __iommu_unmap+0xb0/0x120
[   20.571758]  iommu_unmap_fast+0xc/0x18
[   20.571762]  __iommu_dma_unmap+0x80/0x100
[   20.571767]  iommu_dma_unmap_page+0x34/0x48
[   20.571777]  setup_sgio_components.isra.12+0x244/0x3a8 [cptvf]
[   20.571784]  process_request+0xd4/0xd30 [cptvf]
[   20.571791]  cptvf_do_request+0x34/0x140 [cptvf]
[   20.571797]  cvm_encrypt+0x284/0x2e0 [cptvf]
[   20.571803]  crypto_skcipher_encrypt+0x20/0x30
[   20.571809]  test_skcipher_vec_cfg+0x270/0x780
[   20.571813]  test_skcipher_vec+0x88/0x140
[   20.571817]  alg_test_skcipher+0xc4/0x1f0
[   20.571821]  alg_test+0x100/0x408
[   20.571825]  cryptomgr_test+0x44/0x50
[   20.571831]  kthread+0x118/0x120
[   20.571835]  ret_from_fork+0x10/0x1c
[   20.571839] ---[ end trace 2761a15f2801a65b ]---
[   20.627876] thunder-cptvf 0000:04:00.3: Failed to setup gather list
[   20.634217] thunder-cptvf 0000:04:00.3: Setting up SG list failed
[   20.640391] alg: skcipher: cavium-cbc-aes encryption failed on test
vector 0; expected_error=0, actual_error=-14, cfg="in-place"
[   20.654815] thunder-cptvf 0000:04:00.3: Software error interrupt
0x10 on CPT VF 2
[   20.662392] thunder-cptvf 0000:04:00.3: Request failed with Software error
[   21.985119] nicvf 0000:05:00.1 eth0: Link is Up 1000 Mbps Full duplex

Any ideas what's happening here?

Best Regards,

Tim
