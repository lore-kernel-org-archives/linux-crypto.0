Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2918C25B669;
	Wed, 26 Feb 2025 21:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606170; cv=none; b=gfddOgN/I5EJAiCKWqsoiY1pLptpaKdwnauAuoLLoJWoIOYg0JlTCSjsAloFV6Cww1U18+mo6vonLDUJTKxNWAQIdUsburWWFzAFGGxQE2C/y8tultwZHVCK/avX5ImSkbaNJUE1DpqNvXZI4zXoAdbOveBonnHKgUDyZgSd3PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606170; c=relaxed/simple;
	bh=8zd/V9WKcVhS8+dNG68SFtFXiYq54FUKZklemleqObM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/wV9hzpAM44wdqsrFaV49tzm44DBu33618r8i1jxtSFDWVLBLPAbjmNHSF3P1NbfbfLaeL8jgKImRJ0Vfy/DiOY6tObU/J6emE68SdOmIp9cEf2WJtJ2i6scHd6bpn/DhFaWjkLlJOCKjE3dCbTmU94Bf9ftqD8+7mk9yeKrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEmdYvXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEmdYvXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708B0C4CED6;
	Wed, 26 Feb 2025 21:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740606169;
	bh=8zd/V9WKcVhS8+dNG68SFtFXiYq54FUKZklemleqObM=;
	h=From:To:Cc:Subject:Date:From;
	b=SEmdYvXp83f6YLJ97yfOWvdnhKaRzESlV1eHmn3zQWzY+1OI/bA94GHwNcNoRESkj
	 CvS46rletr61Y4uLiAMpPMjDUhOxmvx4gb7D6DrK70pg/SOn6doN+tOfuex1B28Exg
	 BlYFWF4ZoA84jHPRmRByV7flD8BowEu0ILkaip+xxFG+JV6Wgqx/WXBJlS5Cw8SzGV
	 cPJdu2p8lbE+AX9Fwhi883SXY8/OdPyET8wMV+V7WwhS22dbyU/05NJHt4/E3L+x9e
	 pgk/GfqY9kUw37ULwMY3hG8gur6y1anLzlDwzbVq0OUyrQ7NXLQSKHddAytqaKudfM
	 yPdv2s92B06Cw==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: inside-secure,safexcel: Allow dma-coherent
Date: Wed, 26 Feb 2025 15:42:43 -0600
Message-ID: <20250226214243.3745682-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some platforms like Marvell are cache coherent, so allow the
"dma-coherent" property.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/inside-secure,safexcel.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index ef07258d16c1..343e2d04c797 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -47,6 +47,8 @@ properties:
       - const: core
       - const: reg
 
+  dma-coherent: true
+
 required:
   - reg
   - interrupts
-- 
2.47.2

