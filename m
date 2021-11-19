Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31D7C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 05:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C6661B3D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 05:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhKSFNb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 00:13:31 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:54725 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhKSFNb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 00:13:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 024BA2B01141;
        Fri, 19 Nov 2021 00:10:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 19 Nov 2021 00:10:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=3jZEuuT042YuKjrqUBVG00zSgy
        KEIh3n+2j4Pj4Mvqs=; b=Q5LIBqame/H7azrv8rFKxhpsYzlzXJoX3zZdpErrSi
        ZNj8kwnIZfBkJLks1HAwDDuP3JN07E1bJdEN0Iu0oYXp5zLmefWkJiZ21vr23OOr
        wifVy5IoBEiBzplqL6pXV9fyF/hnaFOCtXrmCSZYhKPOeDJy2ekoQ1Qa87vzo1BR
        eKAuCP19Uo5YXV7VnvBeRhmHV5kDZeEfGRtoJuB44cVAxHVQf6tij5aXuXLTjLcL
        Q4Pl2+IO55ozyt5IHS8Cvx9ASgScjhHar4Pk9LOT3HRHatQJ0IJvfe6AWc2Nq8rk
        74vrebmCimJ+L+AXSYJx1cA5eMIxXEZdwV0rIaCQ6jgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3jZEuuT042YuKjrqU
        BVG00zSgyKEIh3n+2j4Pj4Mvqs=; b=gq2ZzgcVFtRt4zoQBZDGDrkYoSjSECmD2
        weD/kGMODazfEAEC74rj/iAiyFMlgT65Z6lTG+Ctm0XDsxIbzQt2DEy7ZN2sX2NC
        UYbu+5Qy0aQqA5qv02dTHZb0IU13d3Ybf6ia6GgXEBn3d1SUHj6m+srJ7N7ypZPz
        eQMfdzeaa29QWdRE6gjDzY5ByIxPOrkKtDyouO4JyzTDRJAUIhfUfn1+rUKGIEiK
        b3qNuXmZq1x327nY9XwhPS8aCgsIarmdGW6rCNnwrEjI1dEmtRLTnxBNY3W7nIUO
        FtJeaNMO1CsJ39Yi5Zf3n4W4wtZwcQeS4tEH5fGgRVfYfg9mv70Jw==
X-ME-Sender: <xms:wzGXYUYws2WNBCkBYIt-bVgahVNVWUs06SD9k7kenYR0UqiUvTGQVw>
    <xme:wzGXYfaNKMdEgTUrzZ1NVyvLcRe20iW4M2D_lUpXObnMohXjeNniYHt072gfQeeva
    spDYVAHVau-Spn5SA>
X-ME-Received: <xmr:wzGXYe_N92UjXueSfAD0Eawqes5DOQ8JEg2T2_5enABVypKK07XfTjMTJpz2xsqFfwnm6vyQIg9trzTw-fJ8umTYpb1jfMYJzE1uptJY5Ku6vK9X-mk-vhSjaA3Npj153QIcOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeejgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhepieetkefhheduudfgledtudefjeejfeegveehkeeufffhhfejkeehiefftdev
    tdevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    grmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:wzGXYerUvmyBZ6Xn7K0CjR2fpNJQOjhMltrnL9YVnwrcGvpljugy_g>
    <xmx:wzGXYfqnhjCdpyb7j9ws9QDjoI9p9nB24zftpI-XdllfKmqDYlhKbQ>
    <xmx:wzGXYcS9nstHb1CR42pMcZp96SBDIk0nITys4K5cJQoAcNOMoZd0Rw>
    <xmx:xDGXYS0EO3HcL256jeACCimtGgnFj7CjBosuBhkv3iXjgZZmB9zJg74hkUU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 00:10:26 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev, Samuel Holland <samuel@sholland.org>
Subject: [PATCH 1/2] dt-bindings: crypto: sun8i-ce: Add compatible for D1
Date:   Thu, 18 Nov 2021 23:10:24 -0600
Message-Id: <20211119051026.13049-1-samuel@sholland.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

D1 has a crypto engine similar to the one in other Allwinner SoCs.
Like H6, it has a separate MBUS clock gate.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 .../devicetree/bindings/crypto/allwinner,sun8i-ce.yaml      | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
index 00648f9d9278..d43a8aad8680 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -14,6 +14,7 @@ properties:
     enum:
       - allwinner,sun8i-h3-crypto
       - allwinner,sun8i-r40-crypto
+      - allwinner,sun20i-d1-crypto
       - allwinner,sun50i-a64-crypto
       - allwinner,sun50i-h5-crypto
       - allwinner,sun50i-h6-crypto
@@ -44,7 +45,10 @@ properties:
 if:
   properties:
     compatible:
-      const: allwinner,sun50i-h6-crypto
+      contains:
+        enum:
+          - allwinner,sun20i-d1-crypto
+          - allwinner,sun50i-h6-crypto
 then:
   properties:
     clocks:
-- 
2.32.0

