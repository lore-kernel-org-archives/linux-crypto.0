Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BA6C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E149D20709
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uqr9FAH6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfKNK6T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:58:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53447 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNK6T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 05:58:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so5185517wmc.3;
        Thu, 14 Nov 2019 02:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUDQmuDK49ImgwHVLgjE9X4paiR383d/ziyJit2HbDw=;
        b=uqr9FAH6BQ7HESVl57/IfLRJbzZXTLbF2wXTTboVQw0KZFt3nmPkyWuA3rbJ3nFooJ
         GBBn1lAcHoEkVrUl1Px9R87ovisLn98BFe4cHyQ34IWaOOLj5kKONpgT9azV6sqf5AFQ
         4FFwf1CDhdPxctlYTrdjZ/lpnmCyWz1nttXvgJv0E6Eunhni2s9RictuIk9p11tqoQeO
         oEYr7RwlqfStQXgig2bZblBaYoBp1nI+M3fNBihSPD7M41fLR2YhjQgiUsat7wFCW/Bd
         +FMoSMKrO40wztajwS1w9LAz1MXLTL15zc2Wh39+0AXmSNNtIHoWJjFSFaBz4EqHr/5L
         OFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUDQmuDK49ImgwHVLgjE9X4paiR383d/ziyJit2HbDw=;
        b=gHtO3nLYUroTqeUO+LfXy3Zr/V4hFQcQvtnRlLXscaPbOhYgG74TerwPEy11uNojKb
         AGErRAYvl4DcNITYOGsoNrlttM/5vZiLlHUX3IDMaL/K/8WEl1q3TC4r3ErkxT8e77ak
         NFGOoscpomo/l9brapFu2WapzlJFLAuTL+LTgud5F0GQY/U20hVa1SVhjiE2CONPrvLA
         6Tc9MjBqudqkGIxzgf+TVrqrGVbIbNj0ckoXKWnMpGwpnsmKwunfdXUYXw8avHNBW3yx
         ZZFEhYh8ysymcczW8M+FLb9CfANQoiwd1PZ9bWPUVs0Teu56nkKdIMjiQdwe6lCzXVwC
         RUNQ==
X-Gm-Message-State: APjAAAWFFfXOJfm/H8jnJJB7Jc94ioGFLiJWmGo2YWM8jJsIeVNAaKNJ
        0vKW//nvIgo/8dTT9d/PvSk=
X-Google-Smtp-Source: APXvYqx2jCcvlo2boZJ1P3rOWROelM+uphB4pp6k229Qk5W3qr+3NetY+PuKuVIistmjIBMc/9ubzg==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr7571066wmj.125.1573729096886;
        Thu, 14 Nov 2019 02:58:16 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id b66sm6042770wmh.39.2019.11.14.02.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:58:16 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss: use crypto_ahash_digestsize
Date:   Thu, 14 Nov 2019 11:58:13 +0100
Message-Id: <20191114105813.13171-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The size of the digest is different between MD5 and SHA1 so instead of
using the higher value (5 words), let's use crypto_ahash_digestsize().

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index ee518dcdba42..ec5d9ce24bb8 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -227,7 +227,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 */
 	if (op->byte_count) {
 		ivmode = SS_IV_ARBITRARY;
-		for (i = 0; i < 5; i++)
+		for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++)
 			writel(op->hash[i], ss->base + SS_IV0 + i * 4);
 	}
 	/* Enable the device */
-- 
2.23.0

