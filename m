Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5C199FBF;
	Fri,  8 Nov 2024 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731086575; cv=none; b=APbswHPqEvGvFAw59eG0tz8g0qxrSmhMCY1NPJ62l+jOFThhrxAYAztdeIGVNyWYI4ZK6SLiNBWaxBQ+GZqeh6s6x4SyDebzSK69prZ4EIGt9aD7Sb9q1l4x1wmxO7IHv4yM51QorOyWPjrZsQruuEgOpfMGYynTIQslSHR7dMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731086575; c=relaxed/simple;
	bh=b6A1bI7os5S/+V1H6vx1MjuodG50+axjahJKdWQPP2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pS+j655tSCGeYVqkDTMxPIYZtoHUIMc16bDUF/TI/3DR3uE1rJ8T0l17l4kQLM600y0TYi9TkN5Zpn2sFkGVlBOqlSRY7EPUNRRodAd/QsReZ6qt6Qu7Cetg96K3ByufeU/lRxjv3ulVdaE89oD/mTKPIwDFCokZPOvJqwY+OEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=oVNVONmR; arc=none smtp.client-ip=80.12.242.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="oVNVONmR"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 9Sh0tBLraj1r89Sh0tCj0T; Fri, 08 Nov 2024 18:22:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731086565;
	bh=XsYzB9aYFfAC89YLcVs+NFVyywkVwKLs2YtFKokEahE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=oVNVONmRqeOu26PVDDQwOtIrrYaEfS8QrwBr4ST/54LRZNt472erRiqYBfNjL2AM9
	 PPGrWmrC3IJ5TqvjzAPSnzkCYHznikM/gkSIKtGBKMBJeWKqJlO+6zUHK5ADKTmMhC
	 lQxjfnJCv8QnDyck0BrMuagMos1ABo1nOQw14DlIpljze3FpaD9ghRzShNvweuDjgp
	 JyYYrNZzwtjsOgSfIICi/ZUVGnJslgqyWLTrCx1MC/W94JCJRPFXQBOjomEghlDYA4
	 8zUZKaiqUI4dFpBGISI91Nyz2fJQw9g5WWO08kpuq1LEvCD28TWuc4LKoyj5O61pC/
	 NLkMj4xdP8vDA==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 08 Nov 2024 18:22:45 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: George Cherian <gcherian@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	George Cherian <george.cherian@cavium.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()
Date: Fri,  8 Nov 2024 18:22:27 +0100
Message-ID: <774a441420a14d4425c4b6f6d7ae0a06c795f61d.1731086525.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If do_cpt_init() fails, a previous dma_alloc_coherent() call needs to be
undone.

Add the needed dma_free_coherent() before returning.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

I guess that dmam_alloc_coherent() could also be used to fix the leak.
This would simplify cpt_unload_microcode(), IIUC.
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index ec17beee24c0..54de869e5374 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -302,6 +302,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
+		dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+				  mcode->code, mcode->phys_base);
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
 		goto fw_release;
 	}
-- 
2.47.0

