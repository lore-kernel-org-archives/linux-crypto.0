Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8872C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD51218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dwq4x3/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfGCIzx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:53 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32793 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGCIzx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:53 -0400
Received: by mail-lf1-f67.google.com with SMTP id y17so1214086lfe.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dp9qP6sTONWkO4Yd/NU5NtSvJh7LYPkiXZbr4kC7GvU=;
        b=dwq4x3/aV8/sFAShqdmmhGKwDR9NyeLVyz3rorwe9tC0cqmVbXv2cJytipQYf1CsaO
         B1bua8sN2Y7ZArkSHqYv1g2x+ds+JuXbJNuswlsjU5Y4aBN6MzCXid9ufYTRJg6AYTgg
         y0HIbQkgcsv/GoOkT9DQmqGb+U96wB2SLTWbWpCYlOihi8AQkxRDQKXFwPHPhO55zjV4
         q6IWxsr7Mxc6rwsmzXwvP00jfz5aaRW+7xopDs5x75REJz9ukxRxvXh6WXbcshX+O1ux
         59nTK1WJ7D6zm+jVMQPmY5wmMbU2uTTqK806IWg7wZ1FSY07dKL2nBN4x5bnUbobE4Gb
         Bd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dp9qP6sTONWkO4Yd/NU5NtSvJh7LYPkiXZbr4kC7GvU=;
        b=k9vpgBT87O1OkCGBFpkRScK63gq50tkLDgeGCd6kgItUT58gj6wEcPdnsfJdkaIq9Y
         DXBYeDjZllfs1FXEBrx5dJkpizjuyFpAllE5Lu3bpZ4IyzM/HXgANGE2S4GswvUsKY/a
         vIDBcpYcrkN/L5Ave8lUyfcPO45sWZFpJnySuMAHVKNn+n/mnMqk/k/PbDns5ne7Xj6w
         KO4KnlOdt6j9cbq6cFWnK9Yv7wv7kAKX+hewM4x2AIp3aRLptrRj2TUNm+UtlJMvpVnW
         vyObnRSNBT49Ml0t/vJb79+ON0a9IuQmCDyQKdz7h9a4DXDYClOY/eJRq/fzMnczTOYA
         q1Pg==
X-Gm-Message-State: APjAAAXI65tCeStKPFQQQux2FO1aPQabSKYeQATapPjaVK8UF4DnAGt1
        uFKsAxQWJCCAK2eGRhw+tlnpbkcZV2DjxhVL
X-Google-Smtp-Source: APXvYqzUKBA7oCoHvqaIh9cHjsFdm/1B+6Fxb+WCh67wYjM0TZnxc9za81jyAVn3+0PH1IKR+eKaaw==
X-Received: by 2002:a19:ca4b:: with SMTP id h11mr3586816lfj.162.1562144150753;
        Wed, 03 Jul 2019 01:55:50 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 4/7] crypto: aegis - avoid prerotated AES tables
Date:   Wed,  3 Jul 2019 10:55:09 +0200
Message-Id: <20190703085512.13915-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
References: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
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

