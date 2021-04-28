Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D80EC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 07:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B9E61408
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 07:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhD1HuT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhD1HuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Apr 2021 03:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76F6606A5;
        Wed, 28 Apr 2021 07:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619596174;
        bh=FATxjY4/bNQFF6FiYg2InvSCg2bsri8PT27NwDUiySE=;
        h=Date:From:To:Cc:Subject:From;
        b=AbWvTzES2M4Nf+fjWz5l5BTf1L32W6pza91QNku6Rn7E5Rvo893HuRIyWvjgq5ffx
         /IoeQdB5L3YDWHQ1E7nb7Tn6FiyuMYLvF1mtg4oqcySdaOwI01jJLs172X559rUir9
         LhKUA2nNArCF0zqF0YCCDWuGlUc5nRzexL4QfUew=
Date:   Wed, 28 Apr 2021 09:49:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] Revert "crypto: cavium/nitrox - add an error message to
 explain the failure of pci_request_mem_regions"
Message-ID: <YIkTi9a3nnL50wMq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This reverts commit 9fcddaf2e28d779cb946d23838ba6d50f299aa80 as it was
submitted under a fake name and we can not knowingly accept anonymous
contributions to the repository.

This commit was part of a submission "test" to the Linux kernel
community by some "researchers" at umn.edu.  As outlined at:
	https://www-users.cs.umn.edu/%7Ekjlu/papers/full-disclosure.pdf
it was done so as an attempt to submit a known-buggy patch to see if it
could get by our review.  However, the submission turned out to actually
be correct, and not have a bug in it as the author did not understand
how the PCI driver model works at all, and so the submission was
accepted.

As this change is of useless consequence, there is no loss of
functionality in reverting it.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 1 -
 1 file changed, 1 deletion(-)

Herbert, I will be taking this as part of my larger "revert buggy patch
submissions from umn.edu" tree, so no need for you to take this in your
tree at this point in time, I just wanted to give you a heads up as to
what is happening here.


diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index facc8e6bc580..d385daf2c71c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -442,7 +442,6 @@ static int nitrox_probe(struct pci_dev *pdev,
 	err = pci_request_mem_regions(pdev, nitrox_driver_name);
 	if (err) {
 		pci_disable_device(pdev);
-		dev_err(&pdev->dev, "Failed to request mem regions!\n");
 		return err;
 	}
 	pci_set_master(pdev);
-- 
2.31.1

