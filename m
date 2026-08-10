Received: from mail.zlab.su (mail.zlab.su [109.73.193.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C53DC4B6;
	Mon, 10 Aug 2026 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.73.193.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364189; cv=none; b=bJL5NES5bAg6htszfy33xeaKmt8NvyGbP5PPAChUIO1D6Xa+OeGVdn+6dNm85T1Wyw9CQaH9jzaICnMFb/j8Q/iDUTD9iwRimwQBpnUt9Tu0eY36p41NlvG8n7DolhaiqU+wECQoJUeLaJZ3SowFealHll7JA9szKedx8aNWMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364189; c=relaxed/simple;
	bh=t91XblPqoV6PdJaJMiKtKZWFOUj+j7FoahLhW23CxDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM4Wk8PTE+8tdfvXZFvD3hJOY8WsNlvbW/A5XJnIl3+KXBunsOe+ml5iGGOjNLYP4pvTgCgG5wp+C1cYmWUd1qnvI1QdgmrvIspOsWCQulD9s2jpv5bF+KT1iZNNI1laFcYmZRHp4ny02amjIkrW0X9RhgqJBExESX0y6ik/duE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zlab.su; spf=pass smtp.mailfrom=zlab.su; dkim=pass (2048-bit key) header.d=zlab.su header.i=@zlab.su header.b=nFuLd717; arc=none smtp.client-ip=109.73.193.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zlab.su
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zlab.su
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zlab.su header.i=@zlab.su header.b="nFuLd717"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4EC63C0518;
	Mon, 10 Aug 2026 15:16:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zlab.su; s=dkim;
	t=1786364186; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=lOe5l9utNgT7rnp1te/CrBZS1W64mKYVhM5GuNKN2to=;
	b=nFuLd717My9K/2HTU5k1GvZJr8IbjhdkNZTwa0rR081ukM0y7pRzaCclLFR25Os905OgqI
	c6o6mwtDaf+6mi02TDhDEXbeFYnXSGx+UQQlLB7lR9Rx2FZy6tmqZcqrGVeHaYc9ma4KRJ
	Zk6zNpKdAQN7kjMzuTMwzdkyX10QQM/QVbCwaR6zSL3ceY2zhqx1Z1H/DE9me6wiFORduy
	4WNmbKQquo5xf1V4hPd+9pp+nJJ1yxNdcMfGgZVyWum5DzF2PFGgM/TpQCeXau2JvJcVLZ
	RJQkSfTF2ChmyDoT1FxMsXUAnjZT3FcmeGNeXqXAslDVOp67nJbo8Z+OOVOkMg==
From: Vladislav Leonov <vlad@zlab.su>
To: linux-rockchip@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org,
	Simon Glass <sjg@chromium.org>,
	linux-clk@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vladislav Leonov <vlad@zlab.su>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 20/25] dt-bindings: rng: rockchip: Add RV1106 compatible
Date: Mon, 10 Aug 2026 15:11:11 +0300
Message-ID: <20260810121121.210040-21-vlad@zlab.su>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810121121.210040-1-vlad@zlab.su>
References: <20260810121121.210040-1-vlad@zlab.su>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Add rockchip,rv1106-rng as a variant of rockchip,rk3588-rng, following
the pattern used for fallback compatibles in the schema (an items list
with an enum and a matching const fallback), so RV1106 can reuse the
existing rk3588-rng driver bindings.

Signed-off-by: Vladislav Leonov <vlad@zlab.su>
---

 .../devicetree/bindings/rng/rockchip,rk3588-rng.yaml  | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
index fcc5be80142d..60ceac2697c0 100644
--- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -13,10 +13,13 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - rockchip,rk3576-rng
-      - rockchip,rk3588-rng
-
+    oneOf:
+      - const: rockchip,rk3576-rng
+      - const: rockchip,rk3588-rng
+      - items:
+          - enum:
+              - rockchip,rv1106-rng
+          - const: rockchip,rk3588-rng
   reg:
     maxItems: 1
 
-- 
2.47.3

