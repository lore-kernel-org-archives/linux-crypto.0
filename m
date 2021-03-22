Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AE7C433E8
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 13:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E499A6192D
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 13:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhCVNJO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 09:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbhCVNFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 09:05:47 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0B2C061756;
        Mon, 22 Mar 2021 06:05:47 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id y5so8820286qkl.9;
        Mon, 22 Mar 2021 06:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=801QFsuMh5/bXT7iDGLM8P3LIQI2jpvEZ62QIecOMdw=;
        b=g7aI/jvx2znrl1EyXPcFMm56+a5ShivFYZZ9ennJJNFYkMLttLz8Vj7hCqf7nA8MIf
         NcOoj3cd0rR8rYJYFNH2wrHub0iLAhwMp16IPriKiNqC1ohnCWyQJzC6btBsnbM0JPej
         p4o4sMERKZVv0dJbh6m2Qk1p0OP+OmbDq/VDd6UKcsdCwhn76ypRmjNmrtFgnUlJ9vxK
         //DULu3p9tfRRIswQxfQG9bTpGs2N4qi+yGzLYtNGrfpt/m8b2FaEqev5Q8/XwlhW4R6
         ikoygTYVztwcUI3QDjbiT7BDZBVI5V6p2Tyz89jvbBBPSpnw4KxN7/1uU6/sm/an/F0k
         cYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=801QFsuMh5/bXT7iDGLM8P3LIQI2jpvEZ62QIecOMdw=;
        b=HB2OPEx2NkJ/w61fZdCDmyTIe5IaV0iJeKk0lvZf4N8/TWQQzi0wubyup0fgXB/TdH
         IxgQ3PAUg7mzwzaMZX2kQ98t8A+LSYcGrIHbRzmZVB7wh0NfPvECqo0h0+jNkgfX1dKg
         MOSROBcCQTX5mz7QvThgq4NDeC5eBYQnMVg8cVJ/K1Fwns8ByDVw5mujzIdo5G8w2085
         +f89pyqgd/PNjtFivxjWXoPPeZZS5CaO7ycWE0ILHamOXyQcCwcA4wHAXmKEu9ZqPVnE
         3TpEVVtwNG8Z9zmqNtluqx1vuRs/3qKVl8kXvr8/MV1zAV8B1PZ2HxOwDHeO1TftavfO
         RT0Q==
X-Gm-Message-State: AOAM531FKLPaPH93nNtFWjcJvVrSVzuhMKlD+bNUNfEc143pGnz4APUA
        gJeKK7jGOx7WRyppuj2jqj4=
X-Google-Smtp-Source: ABdhPJyEEhJj8SFIQBJSsr3d4eJcQbj9s3I/grK8x+/NEg7D0hoRx+x1KVAgNoIEtF5eSZAqa3Yv3g==
X-Received: by 2002:a05:620a:553:: with SMTP id o19mr2511279qko.491.1616418346402;
        Mon, 22 Mar 2021 06:05:46 -0700 (PDT)
Received: from localhost.localdomain ([143.244.44.200])
        by smtp.gmail.com with ESMTPSA id r125sm10703324qkf.132.2021.03.22.06.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 06:05:45 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] s390/crc32-vx: Couple of typo fixes
Date:   Mon, 22 Mar 2021 18:35:33 +0530
Message-Id: <20210322130533.3805976-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/defintions/definitions/
s/intermedate/intermediate/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 arch/s390/crypto/crc32be-vx.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/crc32be-vx.S b/arch/s390/crypto/crc32be-vx.S
index 0099044e2c86..6b3d1009c392 100644
--- a/arch/s390/crypto/crc32be-vx.S
+++ b/arch/s390/crypto/crc32be-vx.S
@@ -32,7 +32,7 @@
  * process particular chunks of the input data stream in parallel.
  *
  * For the CRC-32 variants, the constants are precomputed according to
- * these defintions:
+ * these definitions:
  *
  *	R1 = x4*128+64 mod P(x)
  *	R2 = x4*128    mod P(x)
@@ -189,7 +189,7 @@ ENTRY(crc32_be_vgfm_16)
 	 * Note: To compensate the division by x^32, use the vector unpack
 	 * instruction to move the leftmost word into the leftmost doubleword
 	 * of the vector register.  The rightmost doubleword is multiplied
-	 * with zero to not contribute to the intermedate results.
+	 * with zero to not contribute to the intermediate results.
 	 */

 	/* T1(x) = floor( R(x) / x^32 ) GF2MUL u */
--
2.31.0

