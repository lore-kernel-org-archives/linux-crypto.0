Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDFEC433E2
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 14:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C1420639
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 14:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gi+okfXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgICOzl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgICOzH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 10:55:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09737C061244;
        Thu,  3 Sep 2020 07:55:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so3214666wmk.1;
        Thu, 03 Sep 2020 07:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qe0IUMor49oE5XMAhnvv6mSoLAEeSax8zKoliUVr2L0=;
        b=gi+okfXZCeX/IlzkMiCpZlg//ifHFRP21IdCT++z0wG14P5iGcFqn7N8v7NoUbSfOj
         0tdSg6dbh5QAllC9EGec1pc7B/9FgTuraemtgTRnFf+4tTch2YhAKIi4AaoCdrkMGHUI
         vtZiL8FY/zNy00AWcclqs/KmK4dauPB3Xo+R2RSXE6STv35I00R7K2tTlJ7hxXccITUs
         7DlcgbQ1xpJDGNM8xywp06F0rPGou/oUqllkktUpn481sIWoZgMGmwGbuNZXXCKmo6/Y
         c9rZ8SABVtYrhgbttUHtmrgS6QFCitd0Gkg//8buqscEJJdLWCSSjn29g5mXQtE5xe2n
         iOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qe0IUMor49oE5XMAhnvv6mSoLAEeSax8zKoliUVr2L0=;
        b=qmdXksnIQsqLy64i+weItKbYF5QJjr3W3zIqvZYV80uw47K7leVTUqIiD06OoicH8Z
         9tY/ZsjtBqTyc61K9NLij+jAesbDDY5S0exHdBWViVVb5Ix0isHTgI/coDyFh8gj+Ay/
         n7AZvC39NrTJQIrU0aZUR4VxOAm1YdnMqsz7akR+NhC8n9f3tTSdCJRDDNv9DIy4Ydeq
         Iiz1iEZ50ePwo7IauJp4zukDE4zy9XLQLmnqrJe5qcHTrGeY2vq8DoYRFx/pNegvW/o5
         UMYbzYuEjJKw+bZeFuoUGcbpGVniit/FBe0xd/cJFVd1w5/lYISSIGhGxjR9kybIivhd
         B0og==
X-Gm-Message-State: AOAM533+kMh4IYIP+qv4KXHPkLG7jgh5lci7q3vkmFtliYlCyCkbVcUv
        uBEt30V3cU0QK2UcQbH3TOQ=
X-Google-Smtp-Source: ABdhPJzp7FadRwfFn2uumKx32iCq68f9e/8XCNGw/dcsrbaamHNjyN/I4Ew0UOBPtpUZdHtUwQk7ig==
X-Received: by 2002:a1c:2983:: with SMTP id p125mr2887798wmp.21.1599144900930;
        Thu, 03 Sep 2020 07:55:00 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l8sm5124266wrx.22.2020.09.03.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 07:55:00 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, robh+dt@kernel.org, robh@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, m.cerveny@computer.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2] dt-bindings: crypto: Specify that allwinner,sun8i-a33-crypto needs reset
Date:   Thu,  3 Sep 2020 16:54:45 +0200
Message-Id: <20200903145445.31779-1-clabbe.montjoie@gmail.com>
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
Change since v1:
- use an enum for adding allwinner,sun8i-a33-crypto to "reset list"

 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml        | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index fc823572bcff..279f4a2e1dd7 100644
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
+        enum:
+          - const: allwinner,sun6i-a31-crypto
+          - const: allwinner,sun8i-a33-crypto
 
 then:
   required:
-- 
2.26.2

