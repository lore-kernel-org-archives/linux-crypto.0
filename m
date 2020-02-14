Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB75FC3B1A1
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 16:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A4C72067D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581699131;
	bh=a0c+ELYiUcKi9HUn9ZbzbeLIHnsSuxPMACvkT/vwv64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ANzVW6f18ieLE/5d3i4gmmOJYukDu0Xj+gMFVj57qoX1dcD4WYCzha1jtixzaBzqM
	 ttp2U/mH4Tz5VN3o81XU7OoRo242yMu1/JJD1BQl9Sx92ODCl4qUkXMWcVZ0lYU7vO
	 hA6iNye33XDtA7I++MCOycTYnwjxGkDeuGr7eo4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405289AbgBNQwK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404998AbgBNQTc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A93CC24706;
        Fri, 14 Feb 2020 16:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697171;
        bh=a0c+ELYiUcKi9HUn9ZbzbeLIHnsSuxPMACvkT/vwv64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzExVrh/wEM8OLhXfjFejGYu+X96GvN68CbXiwg6NXLaYxsMnHxQvAm6F1nLwq9QB
         6/4E7Sf03WMZXym01a7s8Ht0sjKl6kWekPhsif83IMdY2ehDHitYbADW/ODIyMUkLI
         HjDN1EK15c+VG1WiEMlPENhSadc/HytDlOpNNyoI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 105/186] crypto: artpec6 - return correct error code for failed setkey()
Date:   Fri, 14 Feb 2020 11:15:54 -0500
Message-Id: <20200214161715.18113-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit b828f905904cd76424230c69741a4cabb0174168 ]

->setkey() is supposed to retun -EINVAL for invalid key lengths, not -1.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Lars Persson <lars.persson@axis.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 9f82e14983f65..a886245b931e6 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1256,7 +1256,7 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
 
 	if (len != 16 && len != 24 && len != 32) {
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -1;
+		return -EINVAL;
 	}
 
 	ctx->key_length = len;
-- 
2.20.1

