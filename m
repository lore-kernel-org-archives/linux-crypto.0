Return-Path: <SRS0=LUcm=VV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43725C76186
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 21:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFF72084D
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 21:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfGXVWM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jul 2019 17:22:12 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:51458 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbfGXVWL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jul 2019 17:22:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 13DD06089339;
        Wed, 24 Jul 2019 23:22:09 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id rU2TxR2z4FAv; Wed, 24 Jul 2019 23:22:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C11CA6089354;
        Wed, 24 Jul 2019 23:22:08 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4gLqFIRnLWU7; Wed, 24 Jul 2019 23:22:08 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 9A8E06089339;
        Wed, 24 Jul 2019 23:22:08 +0200 (CEST)
Date:   Wed, 24 Jul 2019 23:22:08 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc:     horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        david <david@sigma-star.at>
Message-ID: <839258138.49105.1564003328543.JavaMail.zimbra@nod.at>
Subject: Backlog support for CAAM?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF60 (Linux)/8.8.12_GA_3809)
Thread-Index: BRBzCkuiRpn89WxIsrxtpCssT2oQQg==
Thread-Topic: Backlog support for CAAM?
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!

Recently I had the pleasure to debug a lockup on a imx6 based platform.
It turned out that the lockup was caused by the CAAM driver because it
just returns -EBUSY upon a full job ring.

Then I found commits:
0618764cb25f ("dm crypt: fix deadlock when async crypto algorithm returns -EBUSY")
c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypto algorithm returns -EBUSY"")

Is there a reason why the driver has still no proper backlog support?

If it is just a matter of -ENOPATCH, I have some cycles left an can help.
But before working on this topic I'd like to figure what the current state
or plans are. :-)

So far I work around the issue with disgusting hacks like this one:

--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -339,6 +339,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
                return -EIO;
        }
 
+again:
        spin_lock_bh(&jrp->inplock);
 
        head = jrp->head;
@@ -347,8 +348,8 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
        if (!rd_reg32(&jrp->rregs->inpring_avail) ||
            CIRC_SPACE(head, tail, JOBR_DEPTH) <= 0) {
                spin_unlock_bh(&jrp->inplock);
-               dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
-               return -EBUSY;
+               msleep(100);
+               goto again;
        }
 
        head_entry = &jrp->entinfo[head];

Thanks,
//richard
