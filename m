Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DE54D7948;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604075; cv=none; b=LemhkWWJ6l7XVHnscXcXvD5cMPQ4BR1Qv8zfkuhDLnOhSKkEokJnocG8opwCv2T6GAttlXALjMU6Rf0jSA4akrsY/K0bA6ZHQ5yfAy4rvki4MhIxgmzwY06IeYCJj7LgOeF0u+/KFh6BD+dNSzQBdA0LJpPsIRes4Fv3Z6nR+E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604075; c=relaxed/simple;
	bh=VQCqIbvpKHoGuXknDG939w5Zs3oTF6LC3BYTebnxqaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N2ECjk5fYXw5TM0p7kAZRUweZuTT4me6R/s+m3DZ17TrAGBvwTdMpStSCEr0qPud2AImFhviUXoW+ZQEnsk1sCzt2hKH7QQmDmrpxZGIDDFrr1hg8JJpLCd7JroT21iHvCZjQlczH7tKW5okKRxSllvMrHPJSZaeQ/+mcslq2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6fDghgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6fDghgi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 753F5C4AF0B;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790604075;
	bh=VQCqIbvpKHoGuXknDG939w5Zs3oTF6LC3BYTebnxqaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=A6fDghgiEcT33Ew8Xt1yV8kCH+VmoHnBXX/Bc4kutVQVKAMoveCAuJlzzDwLZRTXP
	 zs5sMwow2iMR28DUy3Y8Jx06YHny7BhBj2AS3QtDkmsGIgiaTciOBNsHZakm2hxBJ1
	 AyLWAXBQu0zK2xq/b3lurNDydiuR0ZnRKSy2dt2sYD5cmBV4Vr08Gj65sn546ZdqcC
	 C8Yj0cX24UHLBOnj+/Jxe3xeyztvBhddmr/wb4QXFFrvvnZmoFhLeYlu8HozwpHKdG
	 /1Rx0eyhs8g4FXtzZRBzk308Bc34LU//kuDG8/RqOszboEWfvEDvta5QkLb3UDykGh
	 +3crr/0wAYqWQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57296CA5FA6;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Mon, 28 Sep 2026 16:01:04 +0200
Subject: [PATCH 2/3] dt-bindings: crypto: fsl,sec-v4.0: add
 fsl,qi2-crypto-priority
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-for-upstream-caam-qi2-priority-v1-2-e4a8e5f01dbc@free.fr>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
In-Reply-To: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Gaurav Jain <gaurav.jain@nxp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 devicetree@vger.kernel.org, Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790604073; l=1266;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=14RLdogArJ3g8dT8zr0+nx/DICrh8YFGpKTsKBxlPRo=;
 b=bqXI0S0xMmAYCpfL9E7bpJIfPD3dsRqR1is6HT9SASQArZPs2FLs90E4sdi0mQY/3J9mKbaI6
 Ca54EWx4dGfCChneC+MS83wXOkm8L7QxXggVvftV3/5c/EbFQRV5lMQ
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

From: Vincent Jardin <vjardin@free.fr>

Let a board set the crypto API priority of the algorithms the DPAA2
front end (dpaa2_caam) registers.

Benefits: Its DTS decides whether the SEC or the CPU is the default for
in-kernel crypto.

Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
 Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
index dcc755d2709a..0231fe3853b0 100644
--- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
@@ -86,6 +86,15 @@ properties:
     description: Defines the 'ERA' of the SEC device.
     $ref: /schemas/types.yaml#/definitions/uint32
 
+  fsl,qi2-crypto-priority:
+    description:
+      Crypto API priority of the algorithms the DPAA2 (QI2) front end
+      registers. Below the CPU's own implementations, the SEC is used only
+      when asked for by driver name. The dpaa2_caam.priority module
+      parameter overrides it.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 2000
+
 patternProperties:
   '^jr@[0-9a-f]+$':
     type: object

-- 
2.43.0


