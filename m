Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49436C10F00
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF4B205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712775;
	bh=zcUWEd8r4bdfUA9lLYV7HIhvNLrDQzQMyVa3/2CYLk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qwG/dmfsLySkfWIT+L7mIAuFFlJodtKkIp/5/TNmn6rVcAViBs+IEkV69LSEh3y+0
	 WOsbG7eZhqPz/v6isa84NYmBw8lXESNL+5MmLkEQLZgQ5tE8qRL+H2AltlpbAmLIm2
	 W0TQFjYiPXimVNO18LWysT5qK65b1prmRo7DihfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390312AbfC0SRi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389700AbfC0SRg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 14:17:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFE82082F;
        Wed, 27 Mar 2019 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710656;
        bh=zcUWEd8r4bdfUA9lLYV7HIhvNLrDQzQMyVa3/2CYLk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiKdzsx+m3uwxn33SjTDScw2MnDGs0bpq899jJoiUGOsUFqOLrjDepP0Tz8JBuWsq
         GpMn33M/s3PMhQFKZLyc9DYVqoxjQrcbUqCL0TbOeSJoalpIlR0xiqkdfGVP5G/62m
         +jdPXtdL5vL+MnmpS7CdqURQBjVVpeRAGAERei1U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 035/123] crypto: cavium/zip - fix collision with generic cra_driver_name
Date:   Wed, 27 Mar 2019 14:14:59 -0400
Message-Id: <20190327181628.15899-35-sashal@kernel.org>
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
index 1cd8aa488185..a6425a7afa7b 100644
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

