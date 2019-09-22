Return-Path: <SRS0=lF8a=XR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8016FC4740C
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Sep 2019 19:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F10D214AF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Sep 2019 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569179696;
	bh=s7x370y95jXHCMWBXfaRjHHLe9MY1QprAjrHw4KTmss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qbziB84WQYjEn9jFOytEEVMXg6wOlSbOBJ0LOGACR3blKj+LNpMUj4fNdei6m1UHK
	 bvcajB/4QaGzyuV7fw2mP/clN87z7DvECHMuLG7NgUVQbLLAqm/R+z24djz9QS3oqW
	 jIK3QacO2bz36N6E/nQ5VblEF3u2odQu0dxm1O8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394622AbfIVS4q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Sep 2019 14:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438477AbfIVS4p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2162184D;
        Sun, 22 Sep 2019 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178604;
        bh=s7x370y95jXHCMWBXfaRjHHLe9MY1QprAjrHw4KTmss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKPkDpCLijuk+ubOgLmRV/Fvyi/HNaAi+Icm50vOAirq2drOjGxkjcI6tcL4YIR7R
         6+SeSzTim0LxyQmbbyf2Kfp9nE6SvNxylBWWMfZlbFN27q0tQWIMbPN1Qolkl0Hva2
         7AEt7M5UZ8UqmwB4Rqf5SYiorNKE4SMoAIpEvZQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 107/128] s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding
Date:   Sun, 22 Sep 2019 14:53:57 -0400
Message-Id: <20190922185418.2158-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 9e323d45ba94262620a073a3f9945ca927c07c71 ]

With 'extra run-time crypto self tests' enabled, the selftest
for s390-xts fails with

  alg: skcipher: xts-aes-s390 encryption unexpectedly succeeded on
  test vector "random: len=0 klen=64"; expected_error=-22,
  cfg="random: inplace use_digest nosimd src_divs=[2.61%@+4006,
  84.44%@+21, 1.55%@+13, 4.50%@+344, 4.26%@+21, 2.64%@+27]"

This special case with nbytes=0 is not handled correctly and this
fix now makes sure that -EINVAL is returned when there is en/decrypt
called with 0 bytes to en/decrypt.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 8ff7cb3da1cba..2bc189187ed40 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -585,6 +585,9 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	if (unlikely(!xts_ctx->fc))
 		return xts_fallback_encrypt(desc, dst, src, nbytes);
 
@@ -599,6 +602,9 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	if (unlikely(!xts_ctx->fc))
 		return xts_fallback_decrypt(desc, dst, src, nbytes);
 
-- 
2.20.1

