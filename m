Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D2E3603EE;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604075; cv=none; b=fIcZSEbuNPHGmyh12N75C/kLBsjfUkAgUSl+XXF7QzTz/VX73uV7jEGrILHHVa8X+YVWQ1/f+jnZiXjYqw3I6s9xbUwkEPuP7GVvu1Hzo1R1iGf+fs+keF/EnVE03DssJIuCfVvV1ct2b8balQPELCsFtwNAt9S4EcSpR09ftmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604075; c=relaxed/simple;
	bh=46+Rp5O2lg0V+JRNwYc5a2//EZbW9Cy4/tzxUOaVB5M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jplLxJ623KDbpczHlAHaHbxXx8wBmLU/BQkek0/lf1eLYJiR452/6OEFl/Jgl21FW8mmTsEcDnfAbK5yYymt1cIo6sXxo6i360hxgZ19p5mJtIwvdBMr0p4ZP+epU3kG7qpyCE0ioNtwNkPl+UY1daTUP4VyV1CtV58sudfIwWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrFZ8E0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrFZ8E0h"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95123C4AF13;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790604075;
	bh=46+Rp5O2lg0V+JRNwYc5a2//EZbW9Cy4/tzxUOaVB5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RrFZ8E0huVdnYvr7CtYwMxqKkehDUIaH2GjEykpSGbWEkU+2+f/yT61KkystL2TZY
	 INwNksK+mpfXXKonRWVdHj9XUB83ae/4ybw3pVcxrdsao7ovrLW6Y/XnJ1JXKVTSJp
	 HFoqJeCEcq+li80QpIVOVo/oFCKWeHI+TRwv3fXwnwLUJVBxvkWH5xfc1NuRmBI4MZ
	 r3GcZ1Avjp6ONKylDhk5G/RNkKFiuzvcXKup7NtmZaW5yqYtpRLlSq3FDHBTuhVBMU
	 t7dqYdTxCktJDpOqkDNXP24CdWMqDAatdzFtuPcQ9La2lRNrndWECQUawA1EousakI
	 3awdhbJMBRUMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EC3C9833F;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Mon, 28 Sep 2026 16:01:05 +0200
Subject: [PATCH 3/3] crypto: caam/qi2 - priority from the DTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-for-upstream-caam-qi2-priority-v1-3-e4a8e5f01dbc@free.fr>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790604073; l=1782;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=iq3+PxFNmYgXB61bU9JaS64+yNKmnFhKP0HR8tcxDG8=;
 b=J9qxMrWMVHlBWp4AOfdZ7RQ4U0ivmsSMx8YCLJF2ihntA1MShcyS4XdkdjDVUGWF6AEUk/7ML
 NRgRksUz4gcBgjMmJho67RJ8cmqDL6KAF4ZUgz+Z6/1/XKpkag+vVxd
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

From: Vincent Jardin <vjardin@free.fr>

Read fsl,qi2-crypto-priority from the SEC node when dpaa2_caam probes,
so the board's DTS sets the priority its algorithms register with.

The dpaa2_caam.priority parameter has precedence when it is set.
When they are not set, we keep the default behaviour.

Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
 drivers/crypto/caam/caamalg_qi2.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index dbb84a6996a2..7d6a5e4ee86e 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/fsl/mc.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
 #include <soc/fsl/dpaa2-io.h>
@@ -35,6 +36,25 @@ MODULE_PARM_DESC(priority,
 
 static int cra_priority = CAAM_CRA_PRIORITY;
 
+static int dpaa2_caam_cra_priority(void)
+{
+	struct device_node *np;
+	u32 prio;
+	int err;
+
+	if (priority)
+		return priority;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!np)
+		return CAAM_CRA_PRIORITY;
+
+	err = of_property_read_u32(np, "fsl,qi2-crypto-priority", &prio);
+	of_node_put(np);
+
+	return err ? CAAM_CRA_PRIORITY : prio;
+}
+
 /* max key is sum of AES_MAX_KEY_SIZE, max split key size */
 #define CAAM_MAX_KEY_SIZE	(AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE + \
 				 SHA512_DIGEST_SIZE * 2)
@@ -5215,8 +5235,7 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
 
 	caam_imx = false;
 
-	if (priority)
-		cra_priority = priority;
+	cra_priority = dpaa2_caam_cra_priority();
 
 	dev = &dpseci_dev->dev;
 

-- 
2.43.0


