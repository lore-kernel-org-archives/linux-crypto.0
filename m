Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F531E2606;
	Thu, 11 Dec 2025 08:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.241.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765442803; cv=none; b=EABYQhJC4dcbIxMsJwqHTEjwc3IMF+pOx+d8dTyb9vz9ogbkIn19ZOUqfyWrqr0U2ATjl0swxIstErmegZrrHtsK7I3Q9F4Vxhy2vTxykSf3wdCLIh9l+l35ZTFQVKc/DX1JsPjYJCrzz1ZFhgTBD1Gvllmm2UTL8xZQbtZeNeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765442803; c=relaxed/simple;
	bh=JnkTmw4C1Jgs0//VWSnP0/eoZvp3SMN6HA2NVa3qSwE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hHVUEYXSuz6wpR6p4aVXAw4oDX1eu9nBguEdfIGUHE+5DL84p6TxWoBtck1wYyGzbjAKKQwdZUdjn0fYhXXLC/90lTFt2tsH1bpOYAdFtS/eWlDtcL3NU3JrKK6pTy7W1YDt1TOaRchc/Lwi7yNolMev4zqo4RzlQEpSDZH+cBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au; spf=pass smtp.mailfrom=codeconstruct.com.au; dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b=Mm0oV692; arc=none smtp.client-ip=203.29.241.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b="Mm0oV692"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1765442796;
	bh=OktlR9bq9mtEJ084n35uOYN2zYX8CCRfSb1l9l6A6kk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mm0oV6927NtwXJE3mZ5NmG0zvn3PLYLkzuH2SuFBs0ZLXJGI6nAlarUCDa4g3xQnK
	 kt3dxwj0rntoJLRQiItErW2OtnnEgXTXgbd8I9EwVeckhHKjStFY2OKQ72oa0603xf
	 ysq6gJFwro2BzOitoUv/fcH77fmag4NGvMSMI4/2a3RdTPyWAmSp/MOgleNxfrstqN
	 mNxmn93DegF3TrrLKt6hYW8isRz367469Xx5DYNwqZacGzZsgGwCDzcJSfy38wgFXH
	 AF8EwEXPZJ4/XWy/VSfTbcp/Y6TdJg2ExjtCJCuMd5Eo17JeoMIwk6XG9zn79e0urP
	 sltPCG4O5FxbQ==
Received: from [127.0.1.1] (fs98a57d9c.tkyc007.ap.nuro.jp [152.165.125.156])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id C64A97D6B0;
	Thu, 11 Dec 2025 16:46:31 +0800 (AWST)
From: Andrew Jeffery <andrew@codeconstruct.com.au>
Date: Thu, 11 Dec 2025 17:45:44 +0900
Subject: [PATCH RFC 02/16] pinctrl: aspeed: g5: Constrain LPC binding
 revision workaround to AST2500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-dev-dt-warnings-all-v1-2-21b18b9ada77@codeconstruct.com.au>
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Linus Walleij <linusw@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>, linux-hwmon@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-iio@vger.kernel.org, Andrew Jeffery <andrew@codeconstruct.com.au>
X-Mailer: b4 0.14.3

Discovering a phandle to an AST2400 or AST2600 LPC node indicates an
error for the purpose of the AST2500 pinctrl driver.

Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
index 792089628362..d4c364d19d64 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
@@ -2654,9 +2654,7 @@ static struct regmap *aspeed_g5_acquire_regmap(struct aspeed_pinmux_data *ctx,
 		np = of_parse_phandle(ctx->dev->of_node,
 					"aspeed,external-nodes", 1);
 		if (np) {
-			if (!of_device_is_compatible(np->parent, "aspeed,ast2400-lpc-v2") &&
-			    !of_device_is_compatible(np->parent, "aspeed,ast2500-lpc-v2") &&
-			    !of_device_is_compatible(np->parent, "aspeed,ast2600-lpc-v2"))
+			if (!of_device_is_compatible(np->parent, "aspeed,ast2500-lpc-v2"))
 				return ERR_PTR(-ENODEV);
 
 			map = syscon_node_to_regmap(np->parent);

-- 
2.47.3

