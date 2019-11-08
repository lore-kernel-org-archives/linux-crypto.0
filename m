Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D60FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87DF3218AE
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="lbk0ljkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbfKHJpg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 04:45:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53609 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHJpg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 04:45:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id x4so5450457wmi.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 01:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=w0FiN6gyAyacF2gs8LToS4qHDjvvIl4Fdx7KgNHxcPA=;
        b=lbk0ljknocwIdkmF9k7GAivkHRDTe/IAjZGyeQYpGPDyWtGzQmSXi4OPx48dAgQO0J
         TMvYwp/agAMuRMGZj6lkbkJ+rTmtdHV52hEpEf1LJfXOcKs1uYdC7rSy+vs/M8ZR6SKx
         NU+mmP3iv3Pl2/Y/LVuUzmpS/b3BpIIYVYuCK6Y9GnUbTs/slK8qwiPZzPfCj4GUDkhT
         OGhdrWrwzuQfnXXtLYvvdNhAV+aANu6mo0CcXevdI5/q3duUfaB1RAoX2SEHj5YztOmt
         rVtHFeQqKCG1RiVCj1gxnZmQy5THOMv3RalfhBY9RGDSGtgOm5d6M67bKxxnJLiIqyZ2
         948g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w0FiN6gyAyacF2gs8LToS4qHDjvvIl4Fdx7KgNHxcPA=;
        b=cuJMD3CO1JoBP1r2IVunxiTc2nqjMj1bn28GC3mK5R5KiGHyp0Ya/JnWcMH/GuFMwo
         jTdw28zt0xGgOUhTMnLdN9Xlov8LU2M6lJDgejagl3wT1mzaPlWRDE3XyiuLx7uDAR9X
         PHtNuHC7ygAVJmhZW/Jifih4LHhfGavG3uIVeQQeFZZ9NFfeFb77TCphonJZAD9qDnh8
         a91SR1o+PFyKCb2bbHEHT4+3kf1Rh8HUsrh6kIAzeeB9ohDdVSyz5lAD8jONpmPve8L+
         mc39us3wPlCfcHzYWtV7lYuVu0jx2+OKAkWEkbDpfDoeM53CE5jezjwrsqK3vj/7DkTe
         N3/w==
X-Gm-Message-State: APjAAAX+cKxXjzBXUUhDPdWG+0l+0oplvhgeq7V3y/8GcLr04R3/bdJO
        Mf33TaB6OFRbeLGgHSlZ6Y1sMw==
X-Google-Smtp-Source: APXvYqxyMB4JCp9NWE1ioQbruVXzPQumvhGWe31zInW2/Ji/Iz9hHST1fhd3vJd3yu3ksEJkV7WIVg==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr7125636wmh.45.1573206334295;
        Fri, 08 Nov 2019 01:45:34 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c24sm10601737wrb.27.2019.11.08.01.45.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 01:45:33 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        keescook+coverity-bot@chromium.org, narmstrong@baylibre.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: amlogic - fix two resources leak
Date:   Fri,  8 Nov 2019 09:45:17 +0000
Message-Id: <1573206317-9926-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes two resources leak that occur on error path.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1487403 ("RESOURCE_LEAK")
Addresses-Coverity-ID: 1487401 ("Resource leaks")
Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index e9283ffdbd23..58b717aab6e8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -131,7 +131,8 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->iv && ivsize > 0) {
 		if (ivsize > areq->cryptlen) {
 			dev_err(mc->dev, "invalid ivsize=%d vs len=%d\n", ivsize, areq->cryptlen);
-			return -EINVAL;
+			err = -EINVAL;
+			goto theend;
 		}
 		memcpy(bkeyiv + 32, areq->iv, ivsize);
 		keyivlen = 48;
@@ -151,9 +152,10 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	phykeyiv = dma_map_single(mc->dev, bkeyiv, keyivlen,
 				  DMA_TO_DEVICE);
-	if (dma_mapping_error(mc->dev, phykeyiv)) {
+	err = dma_mapping_error(mc->dev, phykeyiv);
+	if (err) {
 		dev_err(mc->dev, "Cannot DMA MAP KEY IV\n");
-		return -EFAULT;
+		goto theend;
 	}
 
 	tloffset = 0;
@@ -245,7 +247,6 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->iv && ivsize > 0) {
 		if (rctx->op_dir == MESON_DECRYPT) {
 			memcpy(areq->iv, backup_iv, ivsize);
-			kzfree(backup_iv);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst,
 						 areq->cryptlen - ivsize,
@@ -254,6 +255,7 @@ static int meson_cipher(struct skcipher_request *areq)
 	}
 theend:
 	kzfree(bkeyiv);
+	kzfree(backup_iv);
 
 	return err;
 }
-- 
2.23.0

