Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EC5C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D882075C
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712775;
	bh=kvkCwcHxhjJCvdDnaatwvmnKYzQOI7wCcLz8mpqrU+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MH3uoPVSxnZwLGzK64NgBQgmzFbXPEHUgEemxCPXGb2TT2YAnYDASxBtRPKHeW5DG
	 gmNII4UmXIuYsofyD0E/VOggP0Dx4HvdCKwGvxlAghj1cDPCcd8Y4ayxuSLWXOQlbj
	 4QA3e5xVDd2VCPr2CZgYEilsA3YirUXmtzAFgog0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbfC0SRi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388074AbfC0SRe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 14:17:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50A420449;
        Wed, 27 Mar 2019 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710653;
        bh=kvkCwcHxhjJCvdDnaatwvmnKYzQOI7wCcLz8mpqrU+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsOU4GczQaVCbBSDcHBAAQY9npV0AMUQ8Uom1NPXX79h1+NfePEjK8/DochSKBect
         hqhXvf+oGA97vwEHvBbrdIokRFlG7JORKOe4yjkjc9pgHZ7FgAfu6kApkmvKpw9dyq
         be+9CGHQuZbpsXMsi529Xuzre4FQAkufbHdPeAsQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 034/123] crypto: crypto4xx - add missing of_node_put after of_device_is_available
Date:   Wed, 27 Mar 2019 14:14:58 -0400
Message-Id: <20190327181628.15899-34-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit 8c2b43d2d85b48a97d2f8279278a4aac5b45f925 ]

Add an of_node_put when a tested device node is not available.

The semantic patch that fixes this problem is as follows
(http://coccinelle.lip6.fr):

// <smpl>
@@
identifier f;
local idexpression e;
expression x;
@@

e = f(...);
... when != of_node_put(e)
    when != x = e
    when != e = x
    when any
if (<+...of_device_is_available(e)...+>) {
  ... when != of_node_put(e)
(
  return e;
|
+ of_node_put(e);
  return ...;
)
}
// </smpl>

Fixes: 5343e674f32fb ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_trng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 677ca17fd223..368c5599515e 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -80,8 +80,10 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 
 	/* Find the TRNG device node and map it */
 	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
-	if (!trng || !of_device_is_available(trng))
+	if (!trng || !of_device_is_available(trng)) {
+		of_node_put(trng);
 		return;
+	}
 
 	dev->trng_base = of_iomap(trng, 0);
 	of_node_put(trng);
-- 
2.19.1

