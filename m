Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40D0C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 18:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbjJYShi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 14:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjJYShV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 14:37:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637A31BE
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:16 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-27e0c1222d1so17454a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1698259036; x=1698863836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWDZyqBJhOVpYqYhwbudR4lRinTiZ1fIB/oQ8fHi3tg=;
        b=mRDDTlxDfVZ4q4JsFyDbCTEDG/QLsx/GfO41ZwHBPW87ceShqpqIoBk8el3SDT0c7b
         Z70hpl8okKOoMgyTscvmy8Q2WsMEW9ovIwGyJjUFn6ag3nIqnu/o6tFYmP6v8vJCWdj1
         nyXYOBcGgGXk5i4qXzrjEdYxAee8jRMTwG0Lvx1BYPeEIEgk9gD4iTHYCdvGQhHqQR9A
         KrLLnbQbbMQ0XV8fY0jUFh7qHRF+kW4DkwfoIB7zHlxUxlWuK51Y1eRpyo6M04CjLvLA
         Fr5VjXUd3tfBiwZOzMW1RS58SCfnCi75cmlZi21VvipOEDTppJLGTklc34sFsGZhg5ME
         wAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698259036; x=1698863836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWDZyqBJhOVpYqYhwbudR4lRinTiZ1fIB/oQ8fHi3tg=;
        b=hU0rLvDRVaqeeSylsxS8Laz0b77D0AqdLhU/52ndgSUmRPKNGhE/Yo8yzhgFT7AzIR
         T5hpNNM72a8Fg437Ve0sNcGrBt8uOj2nRcoCgTj7ndT3ktK1A+0RLJdc1nOQuZVpA27P
         rOF6+M2n46WUXO8fXpAWX/VNP2fZc3f2AeByb9vU7mJbVhfrcDKDc8zxwkFi1YVKOid8
         QEjd59PxaQ83alAn/D9THsgJ4ZajVK59V7Li64he9XNPYvjCMgwRE/57auJYSSepeT99
         PIBRMSm2Jd4+M8uChxwbzk4D7q0n9vREuo/1UaaIcGFtl9ZY/p8VrAbiGUKMJpUNt2uR
         JBxA==
X-Gm-Message-State: AOJu0YyFeSEnypdRV5y2vi7z/4XNPhiJLtwAZjnKCVO0PjZD1M+KS4DI
        VdH/xhGgyPMObUqoOXBgL4/FQA==
X-Google-Smtp-Source: AGHT+IFOJxOczYNy9csjaf/jWys3suT6WH12pXc8zs4hoIeoK9YHwvDMemywNi2gacyq+/6UAnDc7Q==
X-Received: by 2002:a17:90b:4a8f:b0:27d:b885:17f2 with SMTP id lp15-20020a17090b4a8f00b0027db88517f2mr12749747pjb.30.1698259035682;
        Wed, 25 Oct 2023 11:37:15 -0700 (PDT)
Received: from localhost.localdomain ([49.216.222.119])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090adb0300b00278f1512dd9sm212367pjv.32.2023.10.25.11.37.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Oct 2023 11:37:15 -0700 (PDT)
From:   Jerry Shih <jerry.shih@sifive.com>
To:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     andy.chiu@sifive.com, greentime.hu@sifive.com,
        conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
        heiko@sntech.de, ebiggers@kernel.org, ardb@kernel.org,
        phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 05/12] crypto: scatterwalk - Add scatterwalk_next() to get the next scatterlist in scatter_walk
Date:   Thu, 26 Oct 2023 02:36:37 +0800
Message-Id: <20231025183644.8735-6-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231025183644.8735-1-jerry.shih@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In some situations, we might split the `skcipher_request` into several
segments. When we try to move to next segment, we might use
`scatterwalk_ffwd()` to get the corresponding `scatterlist` iterating from
the head of `scatterlist`.

This helper function could just gather the information in `skcipher_walk`
and move to next `scatterlist` directly.

Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 include/crypto/scatterwalk.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 32fc4473175b..b1a90afe695d 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -98,7 +98,12 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
-				     struct scatterlist *src,
-				     unsigned int len);
+				     struct scatterlist *src, unsigned int len);
+
+static inline struct scatterlist *scatterwalk_next(struct scatterlist dst[2],
+						   struct scatter_walk *src)
+{
+	return scatterwalk_ffwd(dst, src->sg, src->offset - src->sg->offset);
+}
 
 #endif  /* _CRYPTO_SCATTERWALK_H */
-- 
2.28.0

