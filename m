Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA3C48BE8
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319452089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JbFH8Ho1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfFXHie (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40032 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFXHie (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so12177480wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5OEzIzFiMPRV9S0K58N+POdMr4xGLcUFsxWOdk6NnnA=;
        b=JbFH8Ho1Xh+3eJVIL3O+9G/GjV6avDk5EN1nC/D6Yddr2ODKBk8LYB8If1dVcCabO6
         4EPFLzpLy/BEaB+YdzCD6Q5ooGapt/8xL2NsmEMV8SVxqqeWKlrnBUTKCNK9yM0SynIS
         +7l4AtjnkeodLGEORYVqv7yemIWAq/J+2wU4GtyD5PKzC103nVnL/13n8kaEQypBG0ql
         CMGcBlyELTKIvt/rYd+sjHlkJutOgO75xTcrCL9ldmFsqVHGzY9xDNSik5X/1Xg64zhO
         OW3k439WmWi9NhfATrDDosUq7sUzmn99MhQLP1/M7WvfA9UkvPbbL0LsVVO4V4KwTVi9
         oA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OEzIzFiMPRV9S0K58N+POdMr4xGLcUFsxWOdk6NnnA=;
        b=SYfbhQrnBFufxdShsuahTnL9Qg2QYUpPoBIzkkQrcINIm/G6izJv09EPjwYQkeLEqI
         wfC+iKnyITfP/iSKsXJxE1nPTyh4oUoTX6/dO1iOJpg3vEu1OSahAASkpq3AOsXJstWd
         52+4rhyyxMEwtxs1GeMPlEVUM8v+8RGyCg7MyDedJuHt9SUAOCpUwCqdF2qHbtMS0bup
         IknCJLIxaKq7DT74CJMkCxZifSEtferb71Svl1Rl/p4bBNk4sKF52HSXtLs3ULXi5MYi
         0FtY85ZQBIsmhMtfldQjzCHTDpHHQjjDgWzlku9QLFE+LgU1WqxqVjL9cvRxcv8Akj1e
         RpyA==
X-Gm-Message-State: APjAAAVycjZk5sM173FHtApXNGKrgcyeHG6mdGzEey9Ab8vT1a8E9d7I
        GJGEC3ma+aeJ9p204sGQj1OBvdnapFfEww==
X-Google-Smtp-Source: APXvYqyWlASfuGG5PFotiQ4hV9ePUb36FLzyGCScJmzQBe02DVBroVPPAdLZZh2kB6zr0Khaw6Ni1g==
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr14098674wmb.103.1561361912283;
        Mon, 24 Jun 2019 00:38:32 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:31 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 3/6] crypto: aegis - avoid prerotated AES tables
Date:   Mon, 24 Jun 2019 09:38:15 +0200
Message-Id: <20190624073818.29296-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
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

