Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBDCEB64DA
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jul 2023 15:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjGVPBo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jul 2023 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGVPBn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jul 2023 11:01:43 -0400
X-Greylist: delayed 451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Jul 2023 08:01:42 PDT
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9114F1FCB
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jul 2023 08:01:42 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id NDziq9IyeeA2LNDziqDHuc; Sat, 22 Jul 2023 16:54:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1690037649;
        bh=lfDR0mINkrCKxcAnadMKPEe9Mciru7liyonpOcMXacU=;
        h=From:To:Cc:Subject:Date;
        b=DQxDYxtDbHTvG6MFjroIFnhP/3V6nQpawqQ2gCrQEhZGf80GXIq9vw1KxfQ8FK67f
         tGELfSAPJgUCUCNmkgqoiRpHwJD+0N2OdqhjK5zu3rPd9sU4hz1u9nYERSfYVmfOTe
         ftuMWx0FeVGyzWBCBxI72EAjl7S8nWH2RNBHO6DEJKv2VRg7mnaRPEULO9XumTKLCr
         g7nIGEt6o9YlmPtObdlvQ8ApLGMeUpOsnu0NYg21FVASxN5/T6JXiAFQGvQgO9onWW
         sPYZf0O9zDSVOtFJe+lo3BJGiUKwXgPkq+x1KRsuXZQ7RP5fHl57RZN5MsMpmrARLK
         iVMIU1IinDs6A==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 22 Jul 2023 16:54:09 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: caam - Use struct_size()
Date:   Sat, 22 Jul 2023 16:53:58 +0200
Message-Id: <0fc02b533bd3c3422bec5856bc65bbb66ebf7b58.1690037578.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use struct_size() instead of hand-writing it, when allocating a structure
with a flex array.

This is less verbose, more robust and more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/caam/caamhash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 80deb003f0a5..9e5924e24f2e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -708,9 +708,8 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
-	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
 
-	edesc = kzalloc(sizeof(*edesc) + sg_size, flags);
+	edesc = kzalloc(struct_size(edesc, sec4_sg, sg_num), flags);
 	if (!edesc) {
 		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
 		return NULL;
-- 
2.34.1

