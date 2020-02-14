Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ADDC2BA83
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 15:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C69222C4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581695730;
	bh=G49HKmQTKtA+wr4UsRFhIrWrbndFXkiqlz9M8hDvXhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u1l2ldeaBQ+qUGZXTtAHGYeEiorGs3Ade1bNP4FGctw8l6pKd4OETE/ny75NdWiX1
	 W1JxYuGT5UyNq5JpOAqb9XLx+CB+ris72t2eSmdvlHsLQhONrhoWFZfc+5C+s1anZa
	 uA0ttugAnQG9d5LAqxygGRUSgexahZKkh+5nkQkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgBNPz3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731777AbgBNPz2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34BD24673;
        Fri, 14 Feb 2020 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695728;
        bh=G49HKmQTKtA+wr4UsRFhIrWrbndFXkiqlz9M8hDvXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7QrqjS90FXN9HEGgvhUp6vc9h8U8vw5k6aKjkktNPVvavfweQnAmHRE4qpwfvY4r
         f/aCnyEkUgNRcJMtdxeML7J5WDEFKz3678VkPcfHLyKj2iBfEaEZ0a94Y3NhM1SnDm
         AR4X6laIxIWPuZro2ckAzV5quZ2kEuebb7nnBeMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 303/542] crypto: artpec6 - return correct error code for failed setkey()
Date:   Fri, 14 Feb 2020 10:44:55 -0500
Message-Id: <20200214154854.6746-303-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 4b20606983a43..22ebe40f09f53 100644
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
2.20.1

