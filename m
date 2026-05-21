Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC4E3D45EF;
	Thu, 21 May 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779366983; cv=none; b=AWx1xKGaqbtZLYZauk6fhmYsyFA1AbNEISJ259Ij2Y9JtrX6l/Vq1D4mSEQuFYjxdUCiW5lwaoUa9gio39YnH6AbbyOT5Usmyp1WfaRHRgJxXg2LioU+x6QGV8Hs/gjjh2kLz3p/bJqG5J1Em3+MsVcpI+IP9OI4d7gQYn6aCTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779366983; c=relaxed/simple;
	bh=hTCV6Tywmfns991pR2bgVGuKHYp0MV9vZhRRF16DNuM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HQLXCDmUANxAo8nFXWd5fKviRTiK0Pel2h8r44kENmzXwRX18JLJPR11Xy6kr3inItnljvV8hgmoMV8kGqmT4z4tpvdrHkuT7w3AnMWE8vc+WQlkkULfTYSRiv1+xr85G9V26QzoIIRUjVkbCEpsIEw5u9K51P8HdwTSEzdrc7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qb84f0Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qb84f0Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B12EC2BCB9;
	Thu, 21 May 2026 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779366982;
	bh=hTCV6Tywmfns991pR2bgVGuKHYp0MV9vZhRRF16DNuM=;
	h=From:Subject:Date:To:Cc:From;
	b=Qb84f0WdKfuvObNwglS4zHpFDa40iT1+NLl0pJ0U3OMdyZgnEtyKGioPYvvAKmb8S
	 QVNMVkxbDgh/+jXV3PsH7V5utLtDAlGtAYRUHQUHw+7oF9qUavrW1lXz+qfE8wiNuM
	 MmeBdrEU5tEKI1o2HX4EoZ3NnoFrE5tT6nXvRB8Ls6xfZEa4Qqo14inASd7SJjBNCk
	 GUsWI4KOWhsFUxjTNTV38+2l7Z4g90ZCUw/t3IZkyJ3LNyfWGYGi1+ji5Emqg9Zi0R
	 2AhPAOZNUQDstlgRUpQ8E0UQgCOKDqSUWKeuGCv6MmZLH1XFolpQBH0vj3SDqzZQV0
	 qdgRVZ0FrcQlA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C239CD5BB0;
	Thu, 21 May 2026 12:36:22 +0000 (UTC)
From: Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 0/2] dt-bindings: crypto: Add Qualcomm Hawi crypto support
Date: Thu, 21 May 2026 12:36:19 +0000
Message-Id: <20260521-hawi-crypto-v1-0-9176a3b51bc0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEP8DmoC/yXMTQqAIBBA4avErBPSKKKrRAvTsaaFhfaLePesl
 t/ivQAeHaGHNgvg8CBPi03geQZqknZERjoZRCHqohKcTfIkpty9bgvjZTMYLWSNqoJUrA4NXd+
 t63/7fZhRbe8CYnwAXxPLB28AAAA=
X-Change-ID: 20260521-hawi-crypto-138bfd2a6ec5
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, mani@kernel.org, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=691; i=mani@kernel.org;
 h=from:subject:message-id;
 bh=hTCV6Tywmfns991pR2bgVGuKHYp0MV9vZhRRF16DNuM=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqDvxEy+aGqC5dsRtzhdhhiv61/ks24RXASkfTR
 ka7eKsSbqKJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCag78RAAKCRBVnxHm/pHO
 9SwUB/9+ar1g3oJI9EXFpGPYwFFsr8iJiIfXZ3FVfMRm9Xt1+J4CIhdVjRoWM+tG6L6h8r9QnZx
 GSS8M7xEEZE+yA3vKf6yOv97z9NiH2hWnMuwoKKca4Dt36uKgfc7Pj3XAAmUhaS7RFpQuAqrIlJ
 f+vJ31JZvsWWlRKKFmkLDzQ1WpYN20p/T9isCCCFs5O2C4oTlrwaqAV5Zf/2VtiQTnKAWdu7Zl6
 D3+DblwAfR541UoVVykKt3Jjj2ZRLv8YsxAAb2YrsU3rB+JzAB5Izdc6hjt66zrNBwKUbuR1f81
 7PII99Ck8cLH+BNRKbF0bKswmk4+vez8G3HCyaJxoC0RqcFc
X-Developer-Key: i=mani@kernel.org; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for mani@kernel.org/default with
 auth_id=787

Hi,

This series adds the crypto (ICE, TRNG) dt-binding support for Qualcomm's
upcoming Hawi SoC.

Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
---
Manivannan Sadhasivam (2):
      dt-bindings: crypto: qcom,prng: Document Hawi TRNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Hawi ICE

 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml                 | 1 +
 2 files changed, 2 insertions(+)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260521-hawi-crypto-138bfd2a6ec5

Best regards,
--  
Manivannan Sadhasivam <mani@kernel.org>


