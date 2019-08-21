Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBBFC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15719216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OYSQlSzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfHUOdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40611 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbfHUOdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id c5so2176791wmb.5
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RP1SFo8o3z1+1lccKhX0WLT22cd3vbFmL6iK1Nrc258=;
        b=OYSQlSzfG5P/PXfk3dZ5BKvjslEuFcuOODfcf6mrtIUupYQEsoCe1sRvpl3Piy4ReG
         h4LoZQWBmOgHmANRAuM3DwHLO5K9CYQVvHEwahV3V0do2pZssPXr8sRvM3QTNTfVGjbm
         h9AKjwDRsj/Ow3GobQ08/HRL0RzmrMTS762tNHMLwg2BiKtD8habB9WtI/hv0qN7q7de
         7RDwGA3F8r7Ygzz3nL/8od9fBIgkgBKkXS9f2//ffCkFFkpbnfmkrwA7qSGKtBoH2g6i
         S1nDfQ9vsYkQaGZpdxAkkRHqggLFfsAZMcSUwZK338ZReAq7q89e2hOIEfqSifi91/69
         8nJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RP1SFo8o3z1+1lccKhX0WLT22cd3vbFmL6iK1Nrc258=;
        b=RSScXLRGil4yVLy/eqHgZB5c3I4d8JUw0a82Qz7ydkR0ixl93wGCtQbt8yTBK5lBmX
         PjkYstea+3Yk/1L75KjDCZmVQ+Y50LSSYGLwSL+OjVFgFkZYc4CiPYw4Gsw2f5/59dIu
         GlzHfn56kyegdCu51x4tZR2SCliFXDlq+giN4FnsFHQCL0OhbIQXnDBaECVBHUL/y1i2
         hySp5vkHF/+lFlODonKCiI0LqCKUtYfeOfjBvREG0rvrRFCCvw4kvhOB51EteUA/TCfL
         G8KQspY+PevgGyGcKbUHi9KUXO1E0Y2t6M8PfMKKuyBbMi2LLyTL0CxVmCddCUSVYjue
         DujQ==
X-Gm-Message-State: APjAAAUWbTLYHEXUTLp/jc93Q3pWA98d0S+CswJMDksn6qbGXFbktVsm
        Xdf/ME/AbmEPHGlqlKoBQsrAkgQQ/4f0Rw==
X-Google-Smtp-Source: APXvYqypOCzsoVQtS6gYTjbqgxtw56Sy4KXbcY0k4AoKKPZzRuZM6b/MPAvRdXYoPQSvnyUW43CB+g==
X-Received: by 2002:a1c:1f4e:: with SMTP id f75mr326557wmf.137.1566397992768;
        Wed, 21 Aug 2019 07:33:12 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/17] crypto: skcipher - add the ability to abort a skcipher walk
Date:   Wed, 21 Aug 2019 17:32:44 +0300
Message-Id: <20190821143253.30209-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After starting a skcipher walk, the only way to ensure that all
resources it has tied up are released is to complete it. In some
cases, it will be useful to be able to abort a walk cleanly after
it has started, so add this ability to the skcipher walk API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/skcipher.c                  | 3 +++
 include/crypto/internal/skcipher.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 5d836fc3df3e..973ab1c7dcca 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -140,6 +140,9 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 		goto already_advanced;
 	}
 
+	if (unlikely(!n))
+		goto finish;
+
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
 already_advanced:
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d68faa5759ad..bc488173531f 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -148,6 +148,11 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
 void skcipher_walk_complete(struct skcipher_walk *walk, int err);
 
+static inline void skcipher_walk_abort(struct skcipher_walk *walk)
+{
+	skcipher_walk_done(walk, walk->nbytes);
+}
+
 static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
 					       int err)
 {
-- 
2.17.1

