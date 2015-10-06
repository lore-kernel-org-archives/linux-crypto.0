From: Lee Jones <lee.jones@linaro.org>
Subject: [RESEND 1/3] hwrng: st: dt: Fix trivial typo in node address
Date: Tue,  6 Oct 2015 17:12:49 +0100
Message-ID: <1444147971-25778-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, pankaj.dev@st.com, daniel.thompson@linaro.org,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38801 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbJFQPP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Oct 2015 12:15:15 -0400
Received: by wiclk2 with SMTP id lk2so166836852wic.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2015 09:15:14 -0700 (PDT)
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
