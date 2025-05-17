Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D878C2C6
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747513626; cv=none; b=oagXXaq5P0VJJo/hvVKZzYQprdy7C3TFvlfCBHp4SjGVoS6Erc4ODsBMxyRr6fbSKFBMdRtWj+Y4dAINzGNwm8TS/LgtUEQah3kPIkzObquInl9BVPkTX3kO0Fr6tb6wxsR1roWsFKBX7nOqAZsrmwoDu53giHrQmTXSJQDzilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747513626; c=relaxed/simple;
	bh=AdeDuYXv5pDtlxAEwKYCuL4QlLTIf3x8DgGeUvoa+8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+W8X0aHBK2IJlt36USO2JdPhLf5Vx+Op6PsMMZ/izHHeUvEvVxPPpQA0ovEwrEXOClF29s5jw2b68cwhT6hdeeIt1jcFjE3/WIJRpZxhZFqgrBcnzWTNEBFOMujI3o4BJ4HZKI0khNp5fKyxGzKOh+n0sUf1LtTRW40J1JV5pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aebo9KhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aebo9KhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11788C4CEE9;
	Sat, 17 May 2025 20:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747513625;
	bh=AdeDuYXv5pDtlxAEwKYCuL4QlLTIf3x8DgGeUvoa+8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aebo9KhOps3YVEefSLduqJPQX9Jkw2SGNzf+VNgHc3vv7Z34FNSMuC1OBzcqUilOM
	 3/Vfm/NAbvnQabxAEvJRxVBP73cZ7Geq9oyBmty5JU0P6PpnXzcsa1+fVKSOVa4i7/
	 VmFQszmK7dwYJUD22CmqR19Q6DpfWP0zwOwBeacy1GjS+6VL62lktpYYrfS2smKy3s
	 tHYXCAJtyg7uDgm2HvKGuMgirdzT30UzzlDjSaJvORrDxXikeXldWyvb6EB2QnJUS1
	 748jXHamekWe27govF3D1dI6YrmOTlmMXK4pReaz8rutpoi6cBWS/ZtvCM0zXl5d9h
	 izcjDdd0GmGyg==
From: Mario Limonciello <superm1@kernel.org>
To: mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: ccp - Add missing bootloader info reg for pspv5
Date: Sat, 17 May 2025 15:26:29 -0500
Message-ID: <20250517202657.2044530-2-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250517202657.2044530-1-superm1@kernel.org>
References: <20250517202657.2044530-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The bootloader info reg for pspv5 is the same as pspv4.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 2ebc878da1609..e8d2bb646f3f4 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -440,6 +440,7 @@ static const struct psp_vdata pspv5 = {
 	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
 	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
 	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
 	.inten_reg		= 0x10510,	/* P2CMSG_INTEN */
 	.intsts_reg		= 0x10514,	/* P2CMSG_INTSTS */
-- 
2.43.0

