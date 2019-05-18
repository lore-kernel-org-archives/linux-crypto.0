Return-Path: <SRS0=YBhh=TS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3B5C04AAF
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3B520675
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLKKZ6rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfERVaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 May 2019 17:30:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34716 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbfERVaj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 May 2019 17:30:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id f8so4126344wrt.1
        for <linux-crypto@vger.kernel.org>; Sat, 18 May 2019 14:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4Lqw/zQ80YlBBdOSp8JeAaKFNVuGR6IKzdNJI+IX3k=;
        b=GLKKZ6rrDwzUC1CPKXR0pEgJLmhG2CgE5OABBZuODl6rJFNhcQHKL0bhUXKsxB0MtN
         zK1snAnezZaBbiI9ptNdSAHzGIndZfkKquVFtIkqLBmlWYqp7N07KLOGEOvcYtXuNJqy
         DqRdTWr+3nbBM02wCzGX4FdeNMvRzRQHIjXnW9AI0zipZSXmM5chM7ybaZ1BJxLsUKEP
         M5UG7bX8DVJi7W10VPtfbWNAxKnHpCCc3nCr7J4u+xSWaGMPkZNrEBTe2H/0iTpjRIz1
         v1cXznO6RaA5T4d18dZPxFjSaMZ2wQENPlXonHph5b98T6hjyXBiGhFDCUQ1gvGiL4W9
         dAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4Lqw/zQ80YlBBdOSp8JeAaKFNVuGR6IKzdNJI+IX3k=;
        b=NZ4dzAfOrFWmvEaSRx/6rzIn5j6t+a90jpgjyN15Jikg4qC2XwO+iyDX1L7mRtwTaA
         h89/56jkSDE2CX0HGkClHJwc2Xg5gabV4Uzfqojc/HsPblh2PU4ekZt9cWaH4TdW2vv+
         OXi48Q+t6lmS5Cnrza0PD0njgCOWqYpRv8PWA36k9yyE95Dgku0GIjyHNFcs69cDoChJ
         C3CXjgygdIQJTue4flLjGdvF6JIaWJ/WyWBHuaVRDsi1f+5JQpt+/M9qAI3AmZWHZQCM
         c17JlZwxa7YwZObxootOgGqv7+aBYmtEV3JSyyAQ/mTCxOHk6M8RHl4kCGYovVi39buJ
         ZlNQ==
X-Gm-Message-State: APjAAAXYNcIKVrNuK/MNDT/wH3ynhcqfxLf0wbrQ4OxlvYXPFhOEdFwe
        VRXFVNHNiyE5AciI5KtoB33brdnG
X-Google-Smtp-Source: APXvYqxYj2MkP7SyH8QtQjHStBWHLZYMZpmtgINYMy5ItCgu/uA74AXoYbaYfzVdZbf4DxYjENr6qg==
X-Received: by 2002:adf:eb91:: with SMTP id t17mr22130166wrn.203.1558215036928;
        Sat, 18 May 2019 14:30:36 -0700 (PDT)
Received: from debian64.daheim (p4FD0962E.dip0.t-ipconnect.de. [79.208.150.46])
        by smtp.gmail.com with ESMTPSA id i15sm14510867wre.30.2019.05.18.14.30.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 May 2019 14:30:36 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hS6uZ-0005ej-TJ; Sat, 18 May 2019 23:30:35 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH] crypto: skcipher - perform len fits into blocksize check at the top
Date:   Sat, 18 May 2019 23:30:35 +0200
Message-Id: <20190518213035.21699-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds early check to test the given data length
is aligned with the supported ciphers blocksize, or abort
with -EINVAL in case the supplied chunk size does not fit
without padding into the blocksize for block ciphers.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

---

This will also work instead of the
"crypto: crypto4xx - blockciphers should only accept complete blocks"
It will fix all potential driver issues in other drivers as well as
break the drivers that don't have the correct blocksize set. it will
also make the extra checks scattered around in the drivers make
redundand as well as the extra tests that do send incomplete blocks
to the hardware drivers.
---
 include/crypto/skcipher.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index e555294ed77f..971294602a41 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -494,6 +494,8 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 	crypto_stats_get(alg);
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
+	else if (!IS_ALIGNED(cryptlen, crypto_skcipher_blocksize(tfm)))
+		ret = -EINVAL;
 	else
 		ret = tfm->encrypt(req);
 	crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
@@ -521,6 +523,8 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 	crypto_stats_get(alg);
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
+	else if (!IS_ALIGNED(cryptlen, crypto_skcipher_blocksize(tfm)))
+		ret = -EINVAL;
 	else
 		ret = tfm->decrypt(req);
 	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
-- 
2.20.1

