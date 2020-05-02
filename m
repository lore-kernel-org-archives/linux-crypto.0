Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D59C47254
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911BA2184D
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397631;
	bh=BbS+GJU8E1cfxJI7vp3WOcStloDByRcBqGG0dMSFyjI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RWiYRAQyJGRzBLuWps4feosPUdtHkJU489G7pnyllsBMPr7PBtkB+/eJSzZquVVX4
	 VYMhM+Y7ciSCxFkmHfDcB0a3kWcQOdBhriMhtWMBiVkxpG7hBUmZf+Mm2cyTbFn41i
	 XBLlM/Dnx5/bbIGAtUC/BlM0RPV/BMy6U3Kd9WN0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgEBFdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbgEBFdp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:45 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEFE32184D
        for <linux-crypto@vger.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397624;
        bh=BbS+GJU8E1cfxJI7vp3WOcStloDByRcBqGG0dMSFyjI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t/HrfgcttYLU/IPDBheLMNqHTTMfU5+5GDQ7/qv2XVPDxHiEOkd/oHhkwyNElD6ym
         JEYEYbYTyLu98/SPcRJwrSzLzoPP+i7Th9YBS7J6ZVVcoog9QIF5tQth+K17vs8roL
         brnI2suD2smYtxfYQiDmRBd7x6zFKiHYZGGXKAMM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 13/20] fscrypt: use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:15 -0700
Message-Id: <20200502053122.995648-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 7 +------
 fs/crypto/hkdf.c  | 6 +-----
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 4c212442a8f7f1..5c9fb013e3f757 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -83,13 +83,8 @@ static int fscrypt_do_sha256(const u8 *data, unsigned int data_len, u8 *result)
 			tfm = prev_tfm;
 		}
 	}
-	{
-		SHASH_DESC_ON_STACK(desc, tfm);
 
-		desc->tfm = tfm;
-
-		return crypto_shash_digest(desc, data, data_len, result);
-	}
+	return crypto_shash_tfm_digest(tfm, data, data_len, result);
 }
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index efb95bd19a8948..0cba7928446d34 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -44,17 +44,13 @@ static int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
 			unsigned int ikmlen, u8 prk[HKDF_HASHLEN])
 {
 	static const u8 default_salt[HKDF_HASHLEN];
-	SHASH_DESC_ON_STACK(desc, hmac_tfm);
 	int err;
 
 	err = crypto_shash_setkey(hmac_tfm, default_salt, HKDF_HASHLEN);
 	if (err)
 		return err;
 
-	desc->tfm = hmac_tfm;
-	err = crypto_shash_digest(desc, ikm, ikmlen, prk);
-	shash_desc_zero(desc);
-	return err;
+	return crypto_shash_tfm_digest(hmac_tfm, ikm, ikmlen, prk);
 }
 
 /*
-- 
2.26.2

