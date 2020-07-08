Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6EFC433E5
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A9D8207C4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594226438;
	bh=PtXTYUvhYp1TuGbsTeUDAcDwsA77DUzWQdDtmeDTULs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g+yxCOE9XIklWjKH3UTlcszs0G1qZTSXQne/sAlS/VD4/SxhTFlynnu2uZ3CM4cd6
	 4po9kAe106mL7Ao6K1niAke3SLmVPy+Pc8SeolssmGwqfb2Ic6cBYcb7z68zMPTHvO
	 C8QdMUZt1mbnh9YuuJK3FJYpI59do+OIJ5wIr1fs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgGHQke (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgGHQke (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 12:40:34 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BD820857;
        Wed,  8 Jul 2020 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594226433;
        bh=PtXTYUvhYp1TuGbsTeUDAcDwsA77DUzWQdDtmeDTULs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJN66Ndye2qFIHyiJrkgTdH/ifIhiwbe6VTAXwwXDZSots17O7ZP+1npYona5La6I
         E1LdabHsFPyNR8BUdckP4hJKQyONX/UDQSyqJXwe9Xnv6Y+u8NmH/n20ylLt/+KQD/
         5Sdkno5gfMnXsS5w+S5mBxoiReJ9IRpAZBydLEEk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     alsa-devel@alsa-project.org, Ard Biesheuvel <ardb@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        Tzung-Bi Shih <tzungbi@google.com>
Subject: [PATCH v2 5/5] ASoC: cros_ec_codec: use sha256() instead of open coding
Date:   Wed,  8 Jul 2020 09:39:43 -0700
Message-Id: <20200708163943.52071-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200708163943.52071-1-ebiggers@kernel.org>
References: <20200708163943.52071-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that there's a function that calculates the SHA-256 digest of a
buffer in one step, use it instead of sha256_init() + sha256_update() +
sha256_final().

Also simplify the code by inlining calculate_sha256() into its caller
and switching a debug log statement to use %*phN instead of bin2hex().

Acked-by: Tzung-Bi Shih <tzungbi@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc: alsa-devel@alsa-project.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Cheng-Yi Chiang <cychiang@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 sound/soc/codecs/cros_ec_codec.c | 27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/sound/soc/codecs/cros_ec_codec.c b/sound/soc/codecs/cros_ec_codec.c
index 8d45c628e988..ab009c7dfdf4 100644
--- a/sound/soc/codecs/cros_ec_codec.c
+++ b/sound/soc/codecs/cros_ec_codec.c
@@ -103,28 +103,6 @@ static int send_ec_host_command(struct cros_ec_device *ec_dev, uint32_t cmd,
 	return ret;
 }
 
-static int calculate_sha256(struct cros_ec_codec_priv *priv,
-			    uint8_t *buf, uint32_t size, uint8_t *digest)
-{
-	struct sha256_state sctx;
-
-	sha256_init(&sctx);
-	sha256_update(&sctx, buf, size);
-	sha256_final(&sctx, digest);
-
-#ifdef DEBUG
-	{
-		char digest_str[65];
-
-		bin2hex(digest_str, digest, 32);
-		digest_str[64] = 0;
-		dev_dbg(priv->dev, "hash=%s\n", digest_str);
-	}
-#endif
-
-	return 0;
-}
-
 static int dmic_get_gain(struct snd_kcontrol *kcontrol,
 			 struct snd_ctl_elem_value *ucontrol)
 {
@@ -782,9 +760,8 @@ static int wov_hotword_model_put(struct snd_kcontrol *kcontrol,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ret = calculate_sha256(priv, buf, size, digest);
-	if (ret)
-		goto leave;
+	sha256(buf, size, digest);
+	dev_dbg(priv->dev, "hash=%*phN\n", SHA256_DIGEST_SIZE, digest);
 
 	p.cmd = EC_CODEC_WOV_GET_LANG;
 	ret = send_ec_host_command(priv->ec_device, EC_CMD_EC_CODEC_WOV,
-- 
2.27.0

