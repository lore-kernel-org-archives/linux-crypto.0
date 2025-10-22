Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E3218AD4;
	Wed, 22 Oct 2025 23:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761174256; cv=none; b=ufqLxAGzg+SqczvpVvVEfPELZJFMeadc8ECKCpAgHF8qbnRbu7IMcUIWVm22coBoKXZ8lKWllHmI8hneVCKXSHtDrWv8aFlIawyTDbneARfNqdlrei3q8dfV222wioaxNfPfz0PgQopMg3NKKK98kUh1mrMABhuakJqKO9/ffeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761174256; c=relaxed/simple;
	bh=t2nsO6Xk3gAhYG65R/VNOLNcV2bAzdvuCWkB/LR4aOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7sG3/lM9ZQje0UGgUWj3Ba1hyoiF2IN3WZgBCWjQ+LqrcwRKCW0GBcw42l9CS81zTw9K/CfRZsa0s6tyq/IRuQ9tLoYFoQ4gWtQqVqNfbelDqpLmxc9Ecw13VMGvsjWn6G8BWWY6qeRCkjE3CnZMFZtWRCJts2R0jaJ32lolKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBDCl7Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBDCl7Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE1C4CEE7;
	Wed, 22 Oct 2025 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761174255;
	bh=t2nsO6Xk3gAhYG65R/VNOLNcV2bAzdvuCWkB/LR4aOg=;
	h=From:To:Cc:Subject:Date:From;
	b=cBDCl7Wq7JdnSNsBYTS3DNYH1Adaxk8+Mfkat0P/08zBLpC6CuoApZupNttC5iT0o
	 uDR2Tl5Ak/W97Bzf87PQ12/UcXgNlmYbDwlYIDqk1PWG6fUDE4sHSbXIe/jNnK4JgN
	 EZaX7wvWPFf/cWkDEBhYjMNn+cS1wj0Vb+Sc3Gn9xcCHLj4R+lWy3yRN7G9rnklsvv
	 nUnV0xnpr+N476nBYSwS2c9/bK5rN+nxEfrFWPNR5DLUfrH51C745z6t+tTLwSEh30
	 w3Yi+x72qmyBjkeE0e/R+MLnqDmp8OyGdIT1uQHvsjfHCKbRDFwqqgFE3z+USm6KdT
	 8manYHsdjiEwA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: amd,ccp-seattle-v1a: Allow 'iommus' property
Date: Wed, 22 Oct 2025 18:04:03 -0500
Message-ID: <20251022230403.421699-1-robh@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AMD Seattle CCP is behind an IOMMU and has 4 entries, so add
the 'iommus' property.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml        | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml b/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
index 32bf3a1c3b42..5fb708471059 100644
--- a/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
+++ b/Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
@@ -21,6 +21,9 @@ properties:
 
   dma-coherent: true
 
+  iommus:
+    maxItems: 4
+
 required:
   - compatible
   - reg
-- 
2.51.0

