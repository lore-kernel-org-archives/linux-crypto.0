Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84F158DA3;
	Fri,  4 Apr 2025 00:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725154; cv=none; b=IT+yiGps5mlpnxxwC9yksDUOxBN8aqZXDF7QlBWhk99sFHtSg3TYHC/0Xl07ir8yLs/Tx5k6Sr/zRvGQZXcUcoSVY1ehUX2Cm5I5cq9lM0aCdDdwyaxocmX76XyUsmR0kXc5DMDv09yUpGzr3P6OWNfZInlUcUKT39aTv8KVgaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725154; c=relaxed/simple;
	bh=aep08IrwiSVHj/7y75RHNSWliiuJjR4JlNafaQnqHiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TeT2AtiDlYiTZ8mtERxesNeeR+EArK0Plb12784PBzlF7PN7mFRQDqMwHEh5jfsDIf8rEL+qFzz7KLxLLLe0/In7BhcG12Rq6p+kDbuk1aXfdKbmXwJA2Nlofkp86CPl9aEc2VoTsqOQ1CepqMV5fbmdNG9YO6INaSJvt9tm8AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9kjTf/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9kjTf/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AA5C4CEE3;
	Fri,  4 Apr 2025 00:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725154;
	bh=aep08IrwiSVHj/7y75RHNSWliiuJjR4JlNafaQnqHiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9kjTf/SIsuW5F5vEIxjs9ZfCgxEQ3pEiiwzkwCwUcnjLBM2oe3rJhqnH39y1O8IL
	 PikldncWvval5EqRvwEljnn+QZhotk1dQq0pznmb+1ozJNL/VSqtsYgbftCe40/RYL
	 LnNT9KEjHHiCxptCvW6smchrsyy1MSsZVBb4Z3mbPRmatRn0/L+veoc9S7JnDmOrTJ
	 tVc6gx935MJFkJd89YsOYKoAjaA7ZQHa/5/k33AqO+0HfNbGqCf0B+9xRpOJ9Jiaix
	 3DeEh4Cn3ZhYUtcst4xTYXRq/leVPk5DmZBYC81+/qlfHHJCrZzqI+v+z9rXjYekNT
	 Bq/GSrJRf+p8A==
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
Subject: [PATCH AUTOSEL 6.12 05/20] crypto: ccp - Add support for PCI device 0x1134
Date: Thu,  3 Apr 2025 20:05:25 -0400
Message-Id: <20250404000541.2688670-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404000541.2688670-1-sashal@kernel.org>
References: <20250404000541.2688670-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.21
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

