Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A20ECAAD3
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 02:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiIFCvn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 22:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiIFCvm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 22:51:42 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F236052A
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 19:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662432699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VVQrv5SKgU4xBHWjsf2VPR7aB698QG5khCMxHnZbzYI=;
        b=WcBBoyDPCYTHNFDiVCFiWg+ZTCAJsjTpV0gsSm9B39PiTDyOfXTZejy9U7XUhLu88TPvIs
        +Sd7j0c3iPufO8YLuZABC6bU7mUKXJv9wfy/7MaLON6crMJdnLsR5HjxL7wdJGblYthiH8
        dZULD7u37XpCX4sm2KpnpVb7mLMhYh3dAIE4yg3B0uLcx2E+GpggbtltJfn+Jm6eO/2oBk
        hIFT8vn1bPOUpaM5/P7aO/tAokc0TrDTNsmpF/Urxib0MV4G7syEpcFDUpdmZllFI5UCYj
        6yFE6wwfEIQfCQtovN4XiVZebDPX5dDUOKXaCB0f74CaS5FQEv5hfzDqL/zuKQ==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-182-cy0Fm7PvOyG3r6sotqhY0Q-1; Mon, 05 Sep 2022 22:51:38 -0400
X-MC-Unique: cy0Fm7PvOyG3r6sotqhY0Q-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 5 Sep 2022 19:51:36 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH v2] crypto: inside_secure - Change swab to swab32
Date:   Tue, 6 Sep 2022 10:51:28 +0800
Message-ID: <e25e423595ead12913c9d6444438d89d85270a37.1662430815.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The use of swab() is causing failures in 64-bit arch, as it
translates to __swab64() instead of the intended __swab32().
It eventually causes wrong results in xcbcmac & cmac algo.

Fixes: 78cf1c8bfcb8 ("crypto: inside-secure - Move ipad/opad into safexcel_=
context")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
v2:
 Add fixes tag

 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/=
inside-secure/safexcel_hash.c
index bc60b5802256..2124416742f8 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -383,7 +383,7 @@ static int safexcel_ahash_send_req(struct crypto_async_=
request *async, int ring,
 =09=09=09=09=09u32 x;
=20
 =09=09=09=09=09x =3D ipad[i] ^ ipad[i + 4];
-=09=09=09=09=09cache[i] ^=3D swab(x);
+=09=09=09=09=09cache[i] ^=3D swab32(x);
 =09=09=09=09}
 =09=09=09}
 =09=09=09cache_len =3D AES_BLOCK_SIZE;
@@ -821,7 +821,7 @@ static int safexcel_ahash_final(struct ahash_request *a=
req)
 =09=09=09u32 *result =3D (void *)areq->result;
=20
 =09=09=09/* K3 */
-=09=09=09result[i] =3D swab(ctx->base.ipad.word[i + 4]);
+=09=09=09result[i] =3D swab32(ctx->base.ipad.word[i + 4]);
 =09=09}
 =09=09areq->result[0] ^=3D 0x80;=09=09=09// 10- padding
 =09=09crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
@@ -2106,7 +2106,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahas=
h *tfm, const u8 *key,
 =09crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 =09=09"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 =09for (i =3D 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
-=09=09ctx->base.ipad.word[i] =3D swab(key_tmp[i]);
+=09=09ctx->base.ipad.word[i] =3D swab32(key_tmp[i]);
=20
 =09crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
 =09crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
@@ -2189,7 +2189,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *=
tfm, const u8 *key,
 =09=09return ret;
=20
 =09for (i =3D 0; i < len / sizeof(u32); i++)
-=09=09ctx->base.ipad.word[i + 8] =3D swab(aes.key_enc[i]);
+=09=09ctx->base.ipad.word[i + 8] =3D swab32(aes.key_enc[i]);
=20
 =09/* precompute the CMAC key material */
 =09crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
--=20
2.17.1

