Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED352746A
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668078; cv=none; b=hHhSEOoqdnnZfuDT/yu5ez6qs+aOUQI60nFjZa1QhHNEXlLCmO3sD9BCqh884uiLtJ113VeyOm12QI1xnx4lkAIg7DG6Vc35NJATZ77Ca8bvn5FwD4DYcjZT6YTFFN9fkbfcHL9TnAur0sejOe1pFWo3EmAblT8cU9zq5U0YCbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668078; c=relaxed/simple;
	bh=eTyaQbLsCQ/Kv9FKVGW8ze675sGI/GHIGW42m91U82Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JK8NN5lytwYCadnk4KqHgWGu8+TxIiI1nG3Pomp2OcOYJK1JrlfKqKMpZggYpxJaQKSjYqVnDn6cXLLqyTdJsmVAuidnBEDzHbX2RTapofv9uxRC9wHlzyQ79WTE8UXZ8+xLAhOX4UbtLb1qaHkouvIjKPh0XCFmGbr4YV0Jraw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2tshOXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2tshOXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B778C4CEE4;
	Mon, 19 May 2025 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747668078;
	bh=eTyaQbLsCQ/Kv9FKVGW8ze675sGI/GHIGW42m91U82Y=;
	h=From:To:Cc:Subject:Date:From;
	b=N2tshOXbHkJN2aGugzCsOLVddYG5Yn6N5CgqPX9O7Hat/AtLNnt7D+JVejigrdGUK
	 Bvy/UvnPiQ4noz+B+4dhnRwv6iTq2brq1jZzBsDNyTzcXt+norcgGMcivm4COfoukK
	 DaIh468LYB37xT9cjfA/iag2J3lEDXqgnz9udAZOXKEZvd4+7vDCM/9PEC4zvi2uhS
	 IvWl5IwGzrPJ5p+h71WZ6zRshUkEb32U0BC590U1OUEIguofN187zETmn0bOgCJ7I+
	 M31o+L55vH7HRzrujxF8UkuGlbnKmDBkxpKIPQ1ZCDIQfj1rFTQB4MBKYlF6Bfv/IS
	 uI1bP+GeEqrmg==
From: Mario Limonciello <superm1@kernel.org>
To: mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccp - Add missing bootloader info reg for pspv6
Date: Mon, 19 May 2025 10:21:01 -0500
Message-ID: <20250519152107.2713743-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The bootloader info reg for pspv6 is the same as pspv4 and pspv5.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index fa5283b05323c..998a5112d2491 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -453,6 +453,7 @@ static const struct psp_vdata pspv6 = {
 	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
 	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
 	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg            = 0x109fc,	/* C2PMSG_63 */
 	.inten_reg              = 0x10510,	/* P2CMSG_INTEN */
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
-- 
2.43.0

