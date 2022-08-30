Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4ABECAAD2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 03:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiH3DFQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Aug 2022 23:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH3DFN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2022 23:05:13 -0400
X-Greylist: delayed 305 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 20:05:11 PDT
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0778312AC4
        for <linux-crypto@vger.kernel.org>; Mon, 29 Aug 2022 20:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1661828706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tEUS5NVpeNkT2ib0ytK7390ZoM/5mi9plOGbSeDW1RI=;
        b=XDpDRnab5wgfkvK2nlj2XVkE5mcQvHd2dBprAlLEw36xNLsUnmRvUKfP7nYXOV7XM7YA7q
        Gd2YlEgKC8QcdiCwADxgbGfjZ539l1ARFSp1xRJuaIR4EVKNk/JfnLaOiZ+1H9Hm2kPpmO
        QnlhbwbmyWlFmqd8vJEHA1LNB23toObNKLJwBiLfi1S2Tmw2/b6NQuVzERK6yTX9bx8bwN
        5IXwaIuv1xfQ+XQkC9RG2JMCIBBhyM3OA9AnOkQs4BJpsPjboXoHHDylIG3rURfghsXQ08
        imVwIC3o6KDtJBFoQ28BbgojjbKviYVwAkLcf5BgCvwTluQHcp/R+axoQyTUsg==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-127-dIipq-oxOviO5zmhMB-W3A-1; Mon, 29 Aug 2022 22:58:54 -0400
X-MC-Unique: dIipq-oxOviO5zmhMB-W3A-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 29 Aug 2022 19:58:51 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH] crypto: inside_secure - Change swab to swab32
Date:   Tue, 30 Aug 2022 10:58:45 +0800
Message-ID: <8e639ef525eab18a0628df948459bbef11553ba1.1661827923.git.pliem@maxlinear.com>
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

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
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

