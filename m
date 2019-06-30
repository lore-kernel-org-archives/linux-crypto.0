Return-Path: <SRS0=31iC=U5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71170C5B57E
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 413D220665
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nt2XIRVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfF3Qur (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jun 2019 12:50:47 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45123 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfF3Qur (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jun 2019 12:50:47 -0400
Received: by mail-lf1-f65.google.com with SMTP id u10so7077657lfm.12
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jun 2019 09:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dp9qP6sTONWkO4Yd/NU5NtSvJh7LYPkiXZbr4kC7GvU=;
        b=Nt2XIRVnYop+E4BTfWDQC4eYZIiREzopfzYPgecrmhWoHFoI/pUeSS3Dvgp/Jfq7Ge
         ohmDVOw8PwZXxF36VGYjbdfdEi00ascuIhWtGLu579yw5eFDjFYl8cLfZvoOtsXV5HUa
         KKrsO/FhWFV5JgLzoCE/C1AnrtyVR2i1ySXDylD9BPy+z880B30CvradBzGwXkwJkha/
         an+QtTtYUuBcu0HFJ7E7fhGWpc/bHARqpjaqZ/FEYDQ79VJ6VE+dBdFliQSJRpYlwkVV
         eK4ixnsg7CGUfBEz1vCf5ISiMswc22gASN3n1QGl1f4hT34v/I8Q5e3trjQTAd+A2AC7
         yYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dp9qP6sTONWkO4Yd/NU5NtSvJh7LYPkiXZbr4kC7GvU=;
        b=bu5mzc8efh7qlx93UsfGd1221ZsvytXuycXZka+muQkLqWgoVtp4GWSBA92WOapw+l
         Al/9Zzadse8kRZJVGdRU1hj2m+WKp9ru/1nW/ylTFKQofG3tgccwE2ioMS6eYzhdSG+S
         4F5XDk8yd09cVyXzQ22txv/JlAPfZTqcdOSnaGXkk5kv3Bc5BeUaaInir/bFl1fQ0cgT
         usMTFwK2ralkvVmZa/dys0XsZjY0lIoRa2CjPmCI5OsQ6PlLTCP+t7AQKDHoH630hNJL
         JafS0S+964Ddn/TumBUSTdLm9P6eOHW5tLuonBEL/fbMk7SZ+ugfbqchyCiuHqXTeEu+
         +TXQ==
X-Gm-Message-State: APjAAAVLdmBbe1cWRYVLDqoh6a/wi0qctpjFv7HdtBkbc6jqxS9gTmw4
        8jESfSUoK9HKkEVJ/wNfmUAsWOVEuWcsqw==
X-Google-Smtp-Source: APXvYqwiuaZ6hk92TjQlKP3H74ZENK7dwtOQdiAMOq6O92sCts0t1S6cGPlqNTZ1fPnosXwBkiK+lA==
X-Received: by 2002:a19:5046:: with SMTP id z6mr9748930lfj.185.1561913444972;
        Sun, 30 Jun 2019 09:50:44 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id t15sm2097367lff.94.2019.06.30.09.50.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 09:50:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 4/7] crypto: aegis - avoid prerotated AES tables
Date:   Sun, 30 Jun 2019 18:50:28 +0200
Message-Id: <20190630165031.26365-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
References: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
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
2.17.1

