Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22C4C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 18:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7322075B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594148382;
	bh=EFAUE/O3NAFgFk16uIpubIyUQAmR64ga9v6sCy4aUV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IhsDRqPGmSWktxgLF9ly/a5MCKLgd+j1upX5S2HanWhluaCLe2S7mEoWq+cLrvYzj
	 3TqsMawYMY65SQeBlojDHnwIWzAPW7jc5VhLr5txj1ET7XuucXmJej+G1HqPE5IHh2
	 HPxDSgnW8pluYSG8mxC2cdpQA8FzXKpin/wJXNdI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGGS7l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 14:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgGGS7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 14:59:39 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EE7206CD;
        Tue,  7 Jul 2020 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594148379;
        bh=EFAUE/O3NAFgFk16uIpubIyUQAmR64ga9v6sCy4aUV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9732zf5gH9kNy/qOxs8iTYY7nqaMEDN+LqFtnIDsK66oKlYDc0huOBgQasFTmiX9
         6RR5REwpmJGjyz9yhxRabbDu0oEpD2PYmoa1biV75kcYGkeew5KY5746nv3IJ4jw54
         vIInYsdRydl1osvc5z62Y0mYRv2uh1UeQWXsQpOo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     alsa-devel@alsa-project.org, Ard Biesheuvel <ardb@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        Tzung-Bi Shih <tzungbi@google.com>
Subject: [PATCH 4/4] ASoC: cros_ec_codec: use sha256() instead of open coding
Date:   Tue,  7 Jul 2020 11:58:18 -0700
Message-Id: <20200707185818.80177-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707185818.80177-1-ebiggers@kernel.org>
References: <20200707185818.80177-1-ebiggers@kernel.org>
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

