Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1EB312822
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754545; cv=none; b=a/655BIc9mG7G+zg2WYWGgIO7RU0X3JKsOAe6f2F7lXHQrHnuhU/Is0p9050X1eCG2lbxoutMVd8DTrRmAkQDf7h84U4j02IN7On19/GzsNXmboY+zu590hjODCAdZx+IKVvyBQB10mh74rAqsyt+mWJr5UztbK0sIzrE40Xdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754545; c=relaxed/simple;
	bh=QFlqv9P6nVUrzUGFJcOPouxoAPajBFlEDkMQyD7Fcjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j2pW87VKexI1fHXQKyHXuGPuyDHZfwOjGhO/XWx94/IH77VYKpmhZ22Y6Wb5Y8DYiGfnh0Xsnk/Dsoquf22O1ljAQCgOC3vtxFBeWy4nXkQ2aLBKv9ToU/gw6hBZ6GOuOcM03BNDbvQyxDyEvt4rueQrQrI3l0xV53rt2YKoghw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d69C52XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d69C52XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E70C4CEF7;
	Wed, 29 Oct 2025 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761754545;
	bh=QFlqv9P6nVUrzUGFJcOPouxoAPajBFlEDkMQyD7Fcjc=;
	h=From:To:Cc:Subject:Date:From;
	b=d69C52XVpuCjE5HT4FKmAzyb7RNW5BbLVzmKjeLH/IT5SjPECBxWJhkbRiPx2Gn/y
	 ci46XluBXxrlw/EGzQGII2r831jJxY5y39Nc72V06UUx9SIjXXt6HVzWaCXa/W5r4m
	 I0wbKQN0PT6VOxbGJKPRHVfDPU63hlLoClaoYq/lEqMo3aa6wArwKHqy+h1qq6t+Aa
	 mO3aG62mZRQpTnlzn5jIlqCmOYMawPTEMzDZYVv/4pBppYoZDaD9loeUpqLhAcz+4l
	 5jHYBP+5Yn9HVZnup+xExt9gJ181WkLUu1kTCB/7cerWxm/Ad8VogBsBfDQ8Y0KFfh
	 aD1yL/jlENRhA==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccp - Add support for PCI device 0x115A
Date: Wed, 29 Oct 2025 11:15:01 -0500
Message-ID: <20251029161502.2286541-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PCI device 0x115A is similar to pspv5, except it doesn't have platform
access mailbox support.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e7bb803912a6d..8891ceee1d7d0 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -459,6 +459,17 @@ static const struct psp_vdata pspv6 = {
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
 };
 
+static const struct psp_vdata pspv7 = {
+	.tee			= &teev2,
+	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
+	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
+	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
+	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
+	.inten_reg		= 0x10510,	/* P2CMSG_INTEN */
+	.intsts_reg		= 0x10514,	/* P2CMSG_INTSTS */
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -525,6 +536,13 @@ static const struct sp_dev_vdata dev_vdata[] = {
 		.psp_vdata = &pspv6,
 #endif
 	},
+	{	/* 9 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata = &pspv7,
+#endif
+	},
+
 };
 static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
@@ -539,6 +557,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.43.0

