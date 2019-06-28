Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191CCC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C852083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GRVK97sG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfF1RIN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52343 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1RIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so9783569wms.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0GaH6gMf6rFHmhUTNMopOMqkKXePb4CGVETyavgVKBM=;
        b=GRVK97sGasyNGhSZJWSje3MnULipbDZg8XLfT940L8nz8qQUrH26bJCIvd0r9nOBgi
         hQ37lPYiLQA55eW52xbawC4mYxkWqeNCTiFBNcqW/SUWf5T+zbLxHW1uUnQF5wLG733/
         6WrNFmwxZadZUu/R3eH+O1+7xC/htHKHwPaXYVtn6PijzB+E/fLVaIWYqBENA6d5oQuJ
         LEnLZea5+jov6Q4A0g/NxStyjLZePo5M9UA7s6ZIOVpp2/q0GiEotMqkMjArmClUz7P5
         D2DPTP4QM17nQgBxHavQOICPjXN2OzgOXMXaeEGhuva7Rk6AQUg479Xj1aQe2NhyKMZ2
         Qq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0GaH6gMf6rFHmhUTNMopOMqkKXePb4CGVETyavgVKBM=;
        b=MLscl87kbsHFGkxwBHaH04EHy5xUU9OWtCFEOo5Hh7E0lt7OYVwpKoTVkdKZaJLeW1
         56MorOtgTAgKOZc0Fjp1UzwwTmja8h0dRoBK6a9ioyQOin2+ulPHpeRyHIW+uV22Qvaa
         AdEd15B6X9trpTTZiVYDBhlUiXdmJ+bX3ObL4nbaXlXhJc4HJCq+vpp0sbSIIknJlDMp
         34YiCIAoMk/twYKz3UlmP1H4ue2MFhzF0939p2M7jPNyHndijqT3OllwzyArwy075+a3
         TKyUIWS/90NROeUnfmhAn8l5u/kydN4LHBzhiiJV8qIMZfs2ozcAvry9u0e/AXTA2UW4
         VkKw==
X-Gm-Message-State: APjAAAVJK1kxBKhkLa5QygnCsiGkLP9Z2Cia7LV6HwLxPh+WWeZFXjiY
        a/S21gEFPMaA9/HmAtwgGzNpQFCk30H6Mw==
X-Google-Smtp-Source: APXvYqwpsuf3Ka81admMH5C/2gcDjrZt4m0BhZXMykcAds1AW2ZykFpv8QlnTSVZRcnxsrJ4xF+s2Q==
X-Received: by 2002:a1c:a7ca:: with SMTP id q193mr8578748wme.150.1561741690884;
        Fri, 28 Jun 2019 10:08:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 4/7] crypto: aegis - avoid prerotated AES tables
Date:   Fri, 28 Jun 2019 19:07:43 +0200
Message-Id: <20190628170746.28768-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic AES code provides four sets of lookup tables, where each
set consists of four tables containing the same 32-bit values, but
rotated by 0, 8, 16 and 24 bits, respectively. This makes sense for
CISC architectures such as x86 which support memory operands, but
for other architectures, the rotates are quite cheap, and using all
four tables needlessly thrashes the D-cache, and actually hurts rather
than helps performance.

Since x86 already has its own implementation of AEGIS based on AES-NI
instructions, let's tweak the generic implementation towards other
architectures, and avoid the prerotated tables, and perform the
rotations inline. On ARM Cortex-A53, this results in a ~8% speedup.

Acked-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/aegis.h b/crypto/aegis.h
index 41a3090cda8e..3308066ddde0 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -10,6 +10,7 @@
 #define _CRYPTO_AEGIS_H
 
 #include <crypto/aes.h>
+#include <linux/bitops.h>
 #include <linux/types.h>
 
 #define AEGIS_BLOCK_SIZE 16
@@ -53,16 +54,13 @@ static void crypto_aegis_aesenc(union aegis_block *dst,
 				const union aegis_block *key)
 {
 	const u8  *s  = src->bytes;
-	const u32 *t0 = crypto_ft_tab[0];
-	const u32 *t1 = crypto_ft_tab[1];
-	const u32 *t2 = crypto_ft_tab[2];
-	const u32 *t3 = crypto_ft_tab[3];
+	const u32 *t = crypto_ft_tab[0];
 	u32 d0, d1, d2, d3;
 
-	d0 = t0[s[ 0]] ^ t1[s[ 5]] ^ t2[s[10]] ^ t3[s[15]];
-	d1 = t0[s[ 4]] ^ t1[s[ 9]] ^ t2[s[14]] ^ t3[s[ 3]];
-	d2 = t0[s[ 8]] ^ t1[s[13]] ^ t2[s[ 2]] ^ t3[s[ 7]];
-	d3 = t0[s[12]] ^ t1[s[ 1]] ^ t2[s[ 6]] ^ t3[s[11]];
+	d0 = t[s[ 0]] ^ rol32(t[s[ 5]], 8) ^ rol32(t[s[10]], 16) ^ rol32(t[s[15]], 24);
+	d1 = t[s[ 4]] ^ rol32(t[s[ 9]], 8) ^ rol32(t[s[14]], 16) ^ rol32(t[s[ 3]], 24);
+	d2 = t[s[ 8]] ^ rol32(t[s[13]], 8) ^ rol32(t[s[ 2]], 16) ^ rol32(t[s[ 7]], 24);
+	d3 = t[s[12]] ^ rol32(t[s[ 1]], 8) ^ rol32(t[s[ 6]], 16) ^ rol32(t[s[11]], 24);
 
 	dst->words32[0] = cpu_to_le32(d0) ^ key->words32[0];
 	dst->words32[1] = cpu_to_le32(d1) ^ key->words32[1];
-- 
2.20.1

