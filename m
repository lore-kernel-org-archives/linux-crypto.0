Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1F8C433E7
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26DC32098B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e56ChxsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgIBJR3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBJR1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 05:17:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CAC061244;
        Wed,  2 Sep 2020 02:17:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so3929508wrs.5;
        Wed, 02 Sep 2020 02:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K4YsaDFC3Pt4ZknV5E5TYlw0op731bQlj4z6J8XbD9o=;
        b=e56ChxsFl3Oaxk5No/V0xghZwXJmc+Hu0yfeeV/sfFexFl+dFaZfJxj5nphuqu1i/I
         VV5c2zFcWDhpLikL1qEWkynHM16+wtMH/OC71fKvOewVluFVyzshMchZWXKntFb1nvEB
         LdUDNQ3tbrUtI/dLC4lqj3tOks4XjlNIEnml9CET6Z7Pag4pAMv431PEd43yBaU4Y/TH
         TAVdYqHNOtSguDXUpY/At+QUanwVnBbJrsfIJyYuq8p0USVNq1t3R3VptI/r5cm6Us0T
         LIC+EWXEpyqd2I3TtIqn/fiCjrL/yyF83aVQEJA5V+oDnkjXyxm3aRS22ZplEuTWJ6yg
         PX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K4YsaDFC3Pt4ZknV5E5TYlw0op731bQlj4z6J8XbD9o=;
        b=ZQAgDjh5aXiRtGlBFaeliyY8osM6olD/nJ1omA/0fP1R0Lufh0FgcKFAAmkwc8wxl8
         jfTQsE+Xotszmu2vH51h9XSA86W+i4UjrA2Zm2FvJcQa8dN+sGIceA96DcIKj7+9erS8
         l4aJaP+emXOwfH/phoihjD5Po2mmBJXWcHuLksD20Uu8oQnsMRJ9sKKctQgLjhTIoKS1
         uXHtZi42jNm6luBVjf/eeLTHzdiWBg8v9sMWh71/Bill6usQP8D6CjsCGiq5mpwUF8Mk
         AzSiY/I1csK7fapcFdKs8zj0cg3hS4ge4mcSbZ3ZwbN6haaMp4OX1637+7vF4k5Sg43y
         HfHg==
X-Gm-Message-State: AOAM532wP25PK3efALeqoC7iJx1aEsegDxPZk5at8SXZ9mq1PUABecJI
        nbmbtFadf7RRZEFhrnyqXH8=
X-Google-Smtp-Source: ABdhPJziga6cVnGwqodUAGTuzDSoW5dwcnCBj0weg4cfDUXNmX8rvlXqTeMVVRIW4jd65+tmx+jdFw==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr6214329wrn.83.1599038245240;
        Wed, 02 Sep 2020 02:17:25 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j7sm6335778wrw.35.2020.09.02.02.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 02:17:24 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, robh+dt@kernel.org, robh@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, m.cerveny@computer.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] dt-bindings: crypto: Specify that allwinner,sun8i-a33-crypto needs reset
Date:   Wed,  2 Sep 2020 11:17:16 +0200
Message-Id: <20200902091716.22650-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs reset.
Furthermore, there are no need to use items to list only one compatible
in compatible list.

Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 SS")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml        | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index fc823572bcff..1075f0e75368 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -23,8 +23,7 @@ properties:
       - items:
           - const: allwinner,sun7i-a20-crypto
           - const: allwinner,sun4i-a10-crypto
-      - items:
-          - const: allwinner,sun8i-a33-crypto
+      - const: allwinner,sun8i-a33-crypto
 
   reg:
     maxItems: 1
@@ -59,7 +58,9 @@ if:
   properties:
     compatible:
       contains:
-        const: allwinner,sun6i-a31-crypto
+        oneOf:
+          - const: allwinner,sun6i-a31-crypto
+          - const: allwinner,sun8i-a33-crypto
 
 then:
   required:
-- 
2.26.2

