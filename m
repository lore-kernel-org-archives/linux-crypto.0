Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA7BC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 14:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15EE63213
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 14:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbhKPOgC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 09:36:02 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:43203 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237311AbhKPOgA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 09:36:00 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 119052B012A8;
        Tue, 16 Nov 2021 09:33:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 16 Nov 2021 09:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=6hLb7OiPLBrXnVyULLTa9eHYTZ
        vzjrzL3lOYSa2SxUA=; b=h+v4YcQKu+CrzkqZTy9bmNtSZ2hXULf0aC8sHp1E4e
        Z/ni0EHF0HiM3Dfl0QtAymT2PVq5z15HzVNWqobF6+eZ52f1AwdsXWMin7hBXBSp
        pvU8fbVOaIrUgt2e2yddrhKm+O1Lct/lW/7QSPQVaKe3eiitFNp1mXJ36czbQHjJ
        /ZnfsX+qvTJfgSkUWnKCMTUJRBJvJIcFtPVOZnY4nCYJr2O0/W+QQqcjSO2hEWS0
        TzULGCzNEngZZLnj88B0Wm4X5l9dAx2HkJSfyS0XSGE8ZDErYb08/qgn+9SLAnsv
        ZLe3LFgLzqHGoO8Y+2hTFyI/Gc9mIaq2Zm4sDbkLtiwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6hLb7OiPLBrXnVyUL
        LTa9eHYTZvzjrzL3lOYSa2SxUA=; b=lYvIBrks1J5OC0qoI5w0NwLEF2d0RtLzt
        T3CZQ28oh4ijYSJNm3DU/+p7e7YWPFHJAzR4DcUWDrWmkqLnKrOqWjBWOkFkDFGO
        PyRJpmFX+VC0Xl7UkwJXQmO6C/4CCbnfz5J1rFZHX7uCKEd16v4h+qFIlz+ax+Wk
        bWu205D/op0Z7zBV3/AV68PyJHJz0NLlpi3ZvnOiLAwl8vNdk03B0xiIy4VKQyef
        ClK28MkyIsyhCBOSOsJ0e3BdGzCYB4NyetwFXb6hPMG2pAofPIlLJLzpm44KPB+8
        97UCHeXcPymYwjKG5lhP1KlyZxpUdP+Gf/aRgLPpu4WgDvdD2+HoQ==
X-ME-Sender: <xms:GsGTYaDtOYcM-Y8T8Yrf_Qa12vKN-RydhBqdTbCRuYz5RnX6kQ1t8A>
    <xme:GsGTYUgJnra-_Hvasw9UEjf4k75ehvU4UMaNTe-OentATW79qAUSnuY7hCbpHwZFa
    Gv-Mby9hZ-eTvsvN_E>
X-ME-Received: <xmr:GsGTYdn7YLMx-5UDDrr6pBS9i5zMfeLUP9-cc8KJiESiVCaHI1dQfpRRP8aYK9f0jEtTjQubqCqToQy18WT7ezdBkIzBddaGLWDesIiq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfedvgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepofgrgihimhgvucft
    ihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtthgvrh
    hnpeejffehuddvvddvlefhgeelleffgfeijedvhefgieejtdeiueetjeetfeeukeejgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:GsGTYYydfyEhLnPJlKflOFIZ_j1DFl04W98JVkOIUe-tYdaeX7NZ5A>
    <xmx:GsGTYfSgNcwwotchPUcyJW44h9c5fBLbRjzqIi4w2KWS6ail8IYaoA>
    <xmx:GsGTYTZcR5tiSfewkOu_Sunv2DYjKHLFPt-NBkDRTJCDVe-qEPko5Q>
    <xmx:G8GTYU85J4GqdSITe81KCz4ZBAi-AChIINzXopoqrU_PLlPAddjqHLr9Khk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Nov 2021 09:32:57 -0500 (EST)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     devicetree@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: Add optional dma properties
Date:   Tue, 16 Nov 2021 15:32:55 +0100
Message-Id: <20211116143255.385480-1-maxime@cerno.tech>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some platforms, like the v3s, have DMA channels assigned to the crypto
engine, which were in the DTSI but were never documented.

Let's make sure they are.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index 0429fb774f10..dedc99e34ebc 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -44,6 +44,16 @@ properties:
       - const: ahb
       - const: mod
 
+  dmas:
+    items:
+      - description: RX DMA Channel
+      - description: TX DMA Channel
+
+  dma-names:
+    items:
+      - const: rx
+      - const: tx
+
   resets:
     maxItems: 1
 
-- 
2.33.1

