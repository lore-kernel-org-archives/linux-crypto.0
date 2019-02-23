Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7667C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 08:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6F420850
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 08:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550910230;
	bh=jbzYxr7CkotKZJMA/lnfSwkGKMLjyxFeef/5h16kQ70=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=a3xaKttYAz2uiU3SRcMZc4lbSGbcbYIpUdi2EGEg1WXmFIoR/S8Hij8KJ7xLuX9E6
	 ooQ092NHO52H97P2lYUeHVw/5AbLbTBzmcueVa95WBbMPva38R46hkeWtjC1G2Pz17
	 s/+oxYS/uLrqppGZbztaslPHB5qEaMd3QWb/pMG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbfBWIXt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 03:23:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfBWIXt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 03:23:49 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B372084F;
        Sat, 23 Feb 2019 08:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550910228;
        bh=jbzYxr7CkotKZJMA/lnfSwkGKMLjyxFeef/5h16kQ70=;
        h=From:To:Cc:Subject:Date:From;
        b=MZU2RDshG+eyxNjdzVGufSyWmO550VA5hsIvve/7CZr2VpHvFDxtCUxQdwvTGGpqs
         SI7FU1Rjn2JQmlUqSzhpowSZRXYMfQga3JZtsLBM0bwhHat4jjdwSvsZDUeSq+nqUp
         KAK5eS63rzSnK3bEAHGx8Axu5ELH8JyVSDULZL6k=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>
Subject: [PATCH] crypto: cavium/zip - fix collision with generic cra_driver_name
Date:   Sat, 23 Feb 2019 00:23:23 -0800
Message-Id: <20190223082323.4126-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
---
 drivers/crypto/cavium/zip/zip_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index e6b09e784e666..a8447a3cf3665 100644
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
2.20.1

