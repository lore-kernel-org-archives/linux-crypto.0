Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994DFC8FE;
	Fri,  4 Apr 2025 00:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725057; cv=none; b=IC8CxMhIvyNhWoEByzSv0OA5UwMYCAV7DU/lau/PMfHX1X2Y6vbMzfS4zE3gl5zYjSMe148VBdDRvQ1lub2DtrHx2C+C/VJZ4a/C4uJOPOB49l1DaiTptZ0lyS1RxEvWZGUc/VbJaRBe2lzP+Px2imZ/ORpj3fGhNfj5RDOX3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725057; c=relaxed/simple;
	bh=aep08IrwiSVHj/7y75RHNSWliiuJjR4JlNafaQnqHiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N1Go+jrTH26QBDMTeA4QBfDxSOgJuCU9hkbzCSXXiCwFimWJxtnlJRUfdeF99elUN7/UNah7LOXFFDbclP3Jjd98iVMWcLAO41AuOkbgeq2SSFZkPJQTiPPPHMc5DGTMZxDpmWxjNtLXeIwstlwDN6wx/ig4wlfBI2y5yLFqLPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j89/GzCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j89/GzCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BC8C4CEF1;
	Fri,  4 Apr 2025 00:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725057;
	bh=aep08IrwiSVHj/7y75RHNSWliiuJjR4JlNafaQnqHiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j89/GzChechSybCvQ/wYD2QDfH61mrxkR8f4M6VGrR34kmimY4HBSZ5PJRkjrFcZh
	 05zDNu2T8o82VDYOkcRGa5LXpLGoVBm3rPQJa+FyTtwKWVIuId5PaCchFQhIHEi8H1
	 nUD4Ezqb+qEQtZdst2FQLGHp6+SEyNgEsQajAuwibjCkRzTbMjjxSjn/5TYBSIBhVN
	 N/bUqw3JM2bUBmvLlEeVkv9O5dYzpVPmUG5EZwNxEsXTA7SJtVaB0KUkhZf6pn0oUw
	 H47ekZ9fJZxSuQAL4QNCBuBSUfHs5Ia/vTCZ0HLds/yVOmN7c8wzWoa3s6DtIalL+U
	 WCvyFROjtka0A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	john.allen@amd.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 06/23] crypto: ccp - Add support for PCI device 0x1134
Date: Thu,  3 Apr 2025 20:03:43 -0400
Message-Id: <20250404000402.2688049-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404000402.2688049-1-sashal@kernel.org>
References: <20250404000402.2688049-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14
Content-Transfer-Encoding: 8bit

From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

[ Upstream commit 6cb345939b8cc4be79909875276aa9dc87d16757 ]

PCI device 0x1134 shares same register features as PCI device 0x17E0.
Hence reuse same data for the new PCI device ID 0x1134.

Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 248d98fd8c48d..5357c4308da06 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -529,6 +529,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
-- 
2.39.5

