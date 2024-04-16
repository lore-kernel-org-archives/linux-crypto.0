Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [195.130.137.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED51311AF
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713282717; cv=none; b=EuRK0M9So91Vnf4/AXD9KbQQdMFG7IPT43RFTAv0n6RFpIHjU5TWFvxuIJXLTvVmb5BShXK0yINesj4EgeLx/zcYFPoR2WDhJEbLoFlCEBAloQU00E9ZaQO8GmA+2liwv8dvD02bOdFw50XTzgDsB5XCH2qDKIsRnjwGUQnOaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713282717; c=relaxed/simple;
	bh=ignFx7s0NiBnYpeVTSMh0+Ot5BPapj/CSfLebV6bNKY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QPSD5Xq183/5RhAi7itkaItFoAVqfAV22X8op6NDerhwcesYQxicCRqruQZGHFP7Gzp9VUH5+/89VtoLt3pI4yApUm/+1kxCRMJgXRKkGIUZqfOr1equRsnLz1YZ0e8631UySYOcM4fGv/j5c4eDse3It+IuGXTU8Z4NsYd+zy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:76d0:2bff:fec8:549])
	by laurent.telenet-ops.be with bizsmtp
	id Brrr2C00B0SSLxL01rrrJB; Tue, 16 Apr 2024 17:51:54 +0200
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rwl5Y-008JeT-3T;
	Tue, 16 Apr 2024 17:51:51 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rwl67-00Ebq8-HR;
	Tue, 16 Apr 2024 17:51:51 +0200
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: crypto: starfive: Restore sort order
Date: Tue, 16 Apr 2024 17:51:49 +0200
Message-Id: <1b1bb24987409fcd7ea80940e92be2e9aa67ea49.1713282603.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore alphabetical sort order of the list of supported compatible
values.

Fixes: 2ccf7a5d9c50f3ea ("dt-bindings: crypto: starfive: Add jh8100 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../devicetree/bindings/crypto/starfive,jh7110-crypto.yaml      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/starfive,jh7110-crypto.yaml b/Documentation/devicetree/bindings/crypto/starfive,jh7110-crypto.yaml
index 446764bc2ccce570..7ccb6e1641d07fb9 100644
--- a/Documentation/devicetree/bindings/crypto/starfive,jh7110-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/starfive,jh7110-crypto.yaml
@@ -13,8 +13,8 @@ maintainers:
 properties:
   compatible:
     enum:
-      - starfive,jh8100-crypto
       - starfive,jh7110-crypto
+      - starfive,jh8100-crypto
 
   reg:
     maxItems: 1
-- 
2.34.1

