Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D60C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 10:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A40F20747
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 10:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cantona-net.20150623.gappssmtp.com header.i=@cantona-net.20150623.gappssmtp.com header.b="qzwmWD/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgFKKIB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgFKKH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 06:07:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F13AC08C5C2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2020 03:07:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p21so2332083pgm.13
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2020 03:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cantona-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKMw40QAEHjK+S+ezMDIXXaG/yrYUUF90WtikY/P0Os=;
        b=qzwmWD/9k2NXJdGvmAjTf4fCY5oDmIOLmDKwSCGKedMX+n/T4yoAVsQJ8wVZdwQeNM
         +cQnGl2w/6RhIqeqonlsqeaWAc11cVswPMC5vbgr+YyPpJnKPJ3BrZ7QW+YFJ0ublWEr
         +QvCWWuw6v6cPzzGsBxIC9bRnpMqI294xJ84PkyFqwX6eGl5EKqsrT/ypX5NiPXNz+AG
         JwpDfAPWllsDiGbD0BnrzFVWq0x84KkLCkt1xSzRBd/R/+TJIkhweuxWFPidLGnMzcRx
         hZXJI2o9DJ+Oz9tXYA3dGnWKXBrQIdQqzbJeJrQtc9ittmCeoNaenb/ouNT1rTuOW+Tc
         cl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKMw40QAEHjK+S+ezMDIXXaG/yrYUUF90WtikY/P0Os=;
        b=eP4hhcyc9wXJ06SSIb24CUc2a/FqYxaemumSRGvHZzJ5eOpeXi2403tOdqFhV++tE5
         9TCAo+XMp+SgFWTfWRCT/+TiiXlup9jWcLBLIqiWs1/k/ecWQi4JuCdHX82rIbj9SdZO
         YIsaTblqVPiZazl8YDA81UuOCpSkRQ09Snt2cN/1gAZY+N2h2ABM+ZXnoi6wPfFYHJ7d
         d0s2lnARgfKh8pqq3pxlhP6aCk2Lwk2yYAKbn2Vz+eb3xurrgoVi0AnYajUnz9PGgRj6
         2oXyluuTLz1C4lD+4DeXMzd/AK5Gri8i3pyx87A6mz5IoqpkeTBmcr7SWFIB4Bzx1qRj
         06Tw==
X-Gm-Message-State: AOAM531yXgAht69jvSWBnM5Zr7vMKAolyxzrjlRZaM9bAP7mUlDljN9N
        BLdlJi4YQRKqGtNA4N1IfoyUBw==
X-Google-Smtp-Source: ABdhPJyyilHCc9Y5Udw5M5OgruJWeqSofGNrzejr7O4RvuQ3h9eRppWd1VR/bUn4BkFPNfk/GHmgBw==
X-Received: by 2002:a05:6a00:1342:: with SMTP id k2mr6493599pfu.32.1591870077544;
        Thu, 11 Jun 2020 03:07:57 -0700 (PDT)
Received: from localhost.localdomain ([116.92.204.89])
        by smtp.googlemail.com with ESMTPSA id j1sm2251822pjv.21.2020.06.11.03.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 03:07:57 -0700 (PDT)
From:   Su Kang Yin <cantona@cantona.net>
To:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        christophe.leroy@c-s.fr
Cc:     Su Kang Yin <cantona@cantona.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: talitos - fix ECB and CBC algs ivsize
Date:   Thu, 11 Jun 2020 18:07:45 +0800
Message-Id: <20200611100745.6513-1-cantona@cantona.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cantona@cantona.net>
References: <cantona@cantona.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch for 4.9 upstream:

commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
wrongly modified CBC algs ivsize instead of ECB aggs ivsize.

This restore the CBC algs original ivsize of removes ECB's ones.

Signed-off-by: Su Kang Yin <cantona@cantona.net>
---
 drivers/crypto/talitos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8b383d3d21c2..05a35ab5595b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2636,7 +2636,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_ablkcipher = {
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
-				.ivsize = AES_BLOCK_SIZE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2670,6 +2669,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_ablkcipher = {
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
 				.setkey = ablkcipher_aes_setkey,
 			}
 		},
@@ -2687,7 +2687,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_ablkcipher = {
 				.min_keysize = DES_KEY_SIZE,
 				.max_keysize = DES_KEY_SIZE,
-				.ivsize = DES_BLOCK_SIZE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2720,7 +2719,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_ablkcipher = {
 				.min_keysize = DES3_EDE_KEY_SIZE,
 				.max_keysize = DES3_EDE_KEY_SIZE,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-- 
2.21.0

