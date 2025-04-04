Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F101FF1C9;
	Fri,  4 Apr 2025 00:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725196; cv=none; b=ZvwHwgA/1CwZVBZInFerqi0hT+uCrIpqabrCTVPapCOgB9RLqX5FS6VSi5vFgmNRycIV2AlKwmFGAk3rB74BSF9zXfKwGVRbh/0i180sbkt3MH63H/qQjOr2QENcoCoa3dQ4VlB0LiUk+zbJ538rDXKv1QRy6LGA7JXg4whT+lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725196; c=relaxed/simple;
	bh=9Q+3d3LGkgEMYCftg/STadhPUfGGd9Slnlol3D4n09A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VTrkKhj6we8ISSp2QG2Xajmz8XD8cT3xA1+VEebu3+tNXjttxvZb58P12yZehj+lh3R6j+9aUMlRvEoWcdLXAox5T3PRjcxspZwUPL9ttb0l5PmXAFmUYha8J0pQPEXBR5j8gLzLWh/hp1MX672XMF4Ib3iYz57Uii1CQLk/qPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QG/duPCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QG/duPCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908D9C4CEE5;
	Fri,  4 Apr 2025 00:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725194;
	bh=9Q+3d3LGkgEMYCftg/STadhPUfGGd9Slnlol3D4n09A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG/duPCD9X6DdSQMXJ59PtElwhyDi1rAXfg1zYb7LrINseaGBGh8ypL7eJoutLWLZ
	 nhlvyD0hJ+UyCRCl3WgLep4ifGVQGHWiVqQDQb9dSkjExwvPgqp5yfQgJj536nVqmH
	 fm9VHAUAxNaksb+uffzuV1cIPi88D+laFvvhz0Ckajl32pQNTRE8sCtv+a/EDOH6zG
	 0tMfhD0XGRqd94vX/Ncqynr7FzZJW5HkCNHA9LZCXhbGayNbXAQNyqPFxwLY6kBLVk
	 hJzwVqxbgvF6o6NGsKhRsHonyNK37z0DcbjiWz3xKi8t9wy9/96TrTyRlTHf6Fft2t
	 LPHmXgyezn4zQ==
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
Subject: [PATCH AUTOSEL 6.6 03/16] crypto: ccp - Add support for PCI device 0x1134
Date: Thu,  3 Apr 2025 20:06:11 -0400
Message-Id: <20250404000624.2688940-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404000624.2688940-1-sashal@kernel.org>
References: <20250404000624.2688940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.85
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
index b6ab56abeb682..4ee84719ae0bb 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -574,6 +574,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
-- 
2.39.5

