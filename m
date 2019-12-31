Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14947C2D0D3
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C9B2077B
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762484;
	bh=wBNLBiJ2IXT7H2VAszSfeo4KEcW59oHXVPFI3eI/2gU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CbjAMF3RTWjAt07uPN8e5HbJn3ehRIn/6d1jv53idGYCUG7UgDNCONyAFIJCf6mqe
	 cPkrHwQdePQ2Yyz5LKvvmxDDFI8kgaLL58TqjEdnJ1+lO5I1jqTz2XpzRPCJLqYcSG
	 Bij8KzzJnDpOviFBS2ZTPXlWArTPRgg8jQM7mpPg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfLaDUy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfLaDUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:20:54 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BECE20730
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762454;
        bh=wBNLBiJ2IXT7H2VAszSfeo4KEcW59oHXVPFI3eI/2gU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uP3imjigg8Epcik/snokcoKw4HV1v2mkrKhiWux+JIo7Wzg9ddl1YB+WPflZgsD+6
         G6rcSzeIvABKLDR99sxdw1yz6V23E9L2l7lqmGSdX1XZyAPpRbH+rfVac7mLM9So5I
         xZGhFLcujbPs3plvDWuI+/OMd76XNyAZiYE0tLcs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/8] crypto: artpec6 - return correct error code for failed setkey()
Date:   Mon, 30 Dec 2019 21:19:32 -0600
Message-Id: <20191231031938.241705-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
References: <20191231031938.241705-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

->setkey() is supposed to retun -EINVAL for invalid key lengths, not -1.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 4b20606983a4..22ebe40f09f5 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1251,7 +1251,7 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
 
 	if (len != 16 && len != 24 && len != 32) {
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -1;
+		return -EINVAL;
 	}
 
 	ctx->key_length = len;
-- 
2.24.1

