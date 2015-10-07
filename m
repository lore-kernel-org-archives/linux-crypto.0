From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 1/3] hwrng: st: dt: Fix trivial typo in node address
Date: Wed,  7 Oct 2015 13:23:27 +0100
Message-ID: <1444220609-31251-2-git-send-email-lee.jones@linaro.org>
References: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, pankaj.dev@st.com,
	daniel.thompson@linaro.org, linux@arm.linux.org.uk,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34693 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbJGMZe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2015 08:25:34 -0400
Received: by wicfx3 with SMTP id fx3so209799267wic.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Oct 2015 05:25:33 -0700 (PDT)
In-Reply-To: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DT nodes should not append their addresses with '0x'.

Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/rng/st,rng.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/st,rng.txt b/Documentation/devicetree/bindings/rng/st,rng.txt
index dbc64e6..35734bc 100644
--- a/Documentation/devicetree/bindings/rng/st,rng.txt
+++ b/Documentation/devicetree/bindings/rng/st,rng.txt
@@ -8,7 +8,7 @@ clocks		: Phandle to device's clock (See: ../clocks/clock-bindings.txt)
 
 Example:
 
-rng@0xfee80000 {
+rng@fee80000 {
 	compatible      = "st,rng";
 	reg		= <0xfee80000 0x1000>;
 	clocks          = <&clk_sysin>;
-- 
1.9.1
