Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38A9C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 07:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIPHII convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 03:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIPHIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 03:08:07 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FA58C447;
        Fri, 16 Sep 2022 00:08:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guanjun@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VPw-tZN_1663312082;
Received: from smtpclient.apple(mailfrom:guanjun@linux.alibaba.com fp:SMTPD_---0VPw-tZN_1663312082)
          by smtp.aliyun-inc.com;
          Fri, 16 Sep 2022 15:08:03 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH RESEND v1 0/9] Drivers for Alibaba YCC (Yitian
 Cryptography Complex) cryptographic accelerator
From:   guanjun <guanjun@linux.alibaba.com>
In-Reply-To: <1662435353-114812-1-git-send-email-guanjun@linux.alibaba.com>
Date:   Fri, 16 Sep 2022 15:08:01 +0800
Cc:     "zelin.deng@linux.alibaba.com" <zelin.deng@linux.alibaba.com>,
        xuchun.shang@linux.alibaba.com,
        "artie.ding@linux.alibaba.com" <artie.ding@linux.alibaba.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <60CD0494-8A0F-4234-9599-21C94221FF32@linux.alibaba.com>
References: <1662435353-114812-1-git-send-email-guanjun@linux.alibaba.com>
To:     herbert@gondor.apana.org.au,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> 2022年9月6日 上午11:35，Guanjun <guanjun@linux.alibaba.com> 写道：
> 
> From: Guanjun <guanjun@linux.alibaba.com>
> 
> Hi,
> 
> This patch series aims to add drivers for Alibaba YCC (Yitian Cryptography Complex)
> cryptographic accelerator. Enables the on-chip cryptographic accelerator of
> Alibaba Yitian SoCs which based on ARMv9 architecture.
> 
> It includes PCIe enabling, skcipher, aead, rsa, sm2 support.
> 
> I resend this patchset (see [1]) due to Herbert missed this email.
> 
> I list the differences between the former version under [1]. Mainly according to Elliott's comments.
> 
> Please help to review.
> 
> Thanks,
> Guanjun.
> 
> [1] https://lore.kernel.org/all/1661334621-44413-1-git-send-email-guanjun@linux.alibaba.com/
> 
> v1 -> v1 RESEND:
>  - [01/09] Adjust the Kconfig entry in alphabetical order
>  - [05/09][07/09][08/09] Adjust the format of algorithm names


This is a kindly ping :)

BR,
Guanjun

> 
> Guanjun (3):
>  crypto/ycc: Add skcipher algorithm support
>  crypto/ycc: Add aead algorithm support
>  crypto/ycc: Add rsa algorithm support
> 
> Xuchun Shang (1):
>  crypto/ycc: Add sm2 algorithm support
> 
> Zelin Deng (5):
>  crypto/ycc: Add YCC (Yitian Cryptography Complex) accelerator driver
>  crypto/ycc: Add ycc ring configuration
>  crypto/ycc: Add irq support for ycc kernel rings
>  crypto/ycc: Add device error handling support for ycc hw errors
>  MAINTAINERS: Add Yitian Cryptography Complex (YCC) driver maintainer
>    entry
> 
> MAINTAINERS                            |   8 +
> drivers/crypto/Kconfig                 |   2 +
> drivers/crypto/Makefile                |   1 +
> drivers/crypto/ycc/Kconfig             |  18 +
> drivers/crypto/ycc/Makefile            |   4 +
> drivers/crypto/ycc/sm2signature_asn1.c |  38 ++
> drivers/crypto/ycc/sm2signature_asn1.h |  13 +
> drivers/crypto/ycc/ycc_aead.c          | 646 ++++++++++++++++++++++
> drivers/crypto/ycc/ycc_algs.h          | 176 ++++++
> drivers/crypto/ycc/ycc_cdev.c          |  86 +++
> drivers/crypto/ycc/ycc_cdev.h          |  18 +
> drivers/crypto/ycc/ycc_dev.h           | 157 ++++++
> drivers/crypto/ycc/ycc_drv.c           | 574 ++++++++++++++++++++
> drivers/crypto/ycc/ycc_isr.c           | 279 ++++++++++
> drivers/crypto/ycc/ycc_isr.h           |  12 +
> drivers/crypto/ycc/ycc_pke.c           | 944 +++++++++++++++++++++++++++++++++
> drivers/crypto/ycc/ycc_ring.c          | 652 +++++++++++++++++++++++
> drivers/crypto/ycc/ycc_ring.h          | 168 ++++++
> drivers/crypto/ycc/ycc_ske.c           | 925 ++++++++++++++++++++++++++++++++
> 19 files changed, 4721 insertions(+)
> create mode 100644 drivers/crypto/ycc/Kconfig
> create mode 100644 drivers/crypto/ycc/Makefile
> create mode 100644 drivers/crypto/ycc/sm2signature_asn1.c
> create mode 100644 drivers/crypto/ycc/sm2signature_asn1.h
> create mode 100644 drivers/crypto/ycc/ycc_aead.c
> create mode 100644 drivers/crypto/ycc/ycc_algs.h
> create mode 100644 drivers/crypto/ycc/ycc_cdev.c
> create mode 100644 drivers/crypto/ycc/ycc_cdev.h
> create mode 100644 drivers/crypto/ycc/ycc_dev.h
> create mode 100644 drivers/crypto/ycc/ycc_drv.c
> create mode 100644 drivers/crypto/ycc/ycc_isr.c
> create mode 100644 drivers/crypto/ycc/ycc_isr.h
> create mode 100644 drivers/crypto/ycc/ycc_pke.c
> create mode 100644 drivers/crypto/ycc/ycc_ring.c
> create mode 100644 drivers/crypto/ycc/ycc_ring.h
> create mode 100644 drivers/crypto/ycc/ycc_ske.c
> 
> -- 
> 1.8.3.1

