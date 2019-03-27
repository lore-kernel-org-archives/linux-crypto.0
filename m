Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CA7C10F00
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C8A21734
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714949;
	bh=nY+eHoxEhyDZlB54lIOyeUi9JPcqzwmLIWIwepUcsRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xvHmInKwZ56mC/qOsMxfc89jfov62OZ09irc+w2VPBNltHVU0trMPSEeDougQpQTs
	 ljBP5pYrQ6cOCOLIMnMEzCE1nG+jFxWa0XOwvdnUsYdA8w/BLUddB0FOhHzWUlWy1/
	 YZRpyDIviRXT3OcYEKpBNCW4aMsSQlO4z5wAEg/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfC0SEB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733068AbfC0SEB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 14:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9E92063F;
        Wed, 27 Mar 2019 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709840;
        bh=nY+eHoxEhyDZlB54lIOyeUi9JPcqzwmLIWIwepUcsRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAFLSKrCUh1HWMuBlcO5/OrJ+qOEqYBQ6BeWJ9bcfnTJpEYZm5bgxQE6mCaE01OGT
         GEHacJtXnF5YykZ6lOrab3zsoOpjAYECtvZFOiesLS7F9WtLwzXlCwcQAfylM++3z3
         ztRoqx26qkTDtukFNzU655nArdU2AVGdmUmzrVto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 068/262] crypto: cavium/zip - fix collision with generic cra_driver_name
Date:   Wed, 27 Mar 2019 13:58:43 -0400
Message-Id: <20190327180158.10245-68-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 41798036430015ad45137db2d4c213cd77fd0251 ]

The cavium/zip implementation of the deflate compression algorithm is
incorrectly being registered under the generic driver name, which
prevents the generic implementation from being registered with the
crypto API when CONFIG_CRYPTO_DEV_CAVIUM_ZIP=y.  Similarly the lzs
algorithm (which does not currently have a generic implementation...)
is incorrectly being registered as lzs-generic.

Fix the naming collision by adding a suffix "-cavium" to the
cra_driver_name of the cavium/zip algorithms.

Fixes: 640035a2dc55 ("crypto: zip - Add ThunderX ZIP driver core")
Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
Cc: Jan Glauber <jglauber@cavium.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/zip/zip_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index be055b9547f6..6183f9128a8a 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -351,6 +351,7 @@ static struct pci_driver zip_driver = {
 
 static struct crypto_alg zip_comp_deflate = {
 	.cra_name		= "deflate",
+	.cra_driver_name	= "deflate-cavium",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
 	.cra_priority           = 300,
@@ -365,6 +366,7 @@ static struct crypto_alg zip_comp_deflate = {
 
 static struct crypto_alg zip_comp_lzs = {
 	.cra_name		= "lzs",
+	.cra_driver_name	= "lzs-cavium",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
 	.cra_priority           = 300,
@@ -384,7 +386,7 @@ static struct scomp_alg zip_scomp_deflate = {
 	.decompress		= zip_scomp_decompress,
 	.base			= {
 		.cra_name		= "deflate",
-		.cra_driver_name	= "deflate-scomp",
+		.cra_driver_name	= "deflate-scomp-cavium",
 		.cra_module		= THIS_MODULE,
 		.cra_priority           = 300,
 	}
@@ -397,7 +399,7 @@ static struct scomp_alg zip_scomp_lzs = {
 	.decompress		= zip_scomp_decompress,
 	.base			= {
 		.cra_name		= "lzs",
-		.cra_driver_name	= "lzs-scomp",
+		.cra_driver_name	= "lzs-scomp-cavium",
 		.cra_module		= THIS_MODULE,
 		.cra_priority           = 300,
 	}
-- 
2.19.1

