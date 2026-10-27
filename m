Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097457;
	b=CyhcuO3H7XzyU/j2EiXXAkjvBUQXp+436tIkyAtThFNE3dCs1eYCtcKVmYVL30n8cOHO
	 hmFMpa/1ZnHA+9SjVWQWJyc8JfeFLVgzTEos+HcF+eB4HyR65fZ6478QZUvkP60EEAn//
	 PnAunsUjx0sKcGFMy+6F5fFPIw2Pa8/oIJB1mMYHnMVxFcljRx3xH4JZWvCJbkho0O5r0
	 dt+ko/qbJEBT3fBF9Mv6T8tVsfRQM3ik5gZ4BYJRYubQXM7iZzsAw/TL4VVzL682ijW83
	 I6UWH/6YL/42kSG1nJJrfrEljB4btMqTzIktsrjc18FlO3DxPky1Dk7wlF2gEtDMxNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iOfhgmxWCwnZtJ0TmGVMocK5COR1vR2TuyujyACrook=;
	b=Iw4LdZJgCbBwlsxrNIfAnzl1O2lcDM1lwlBCCHuPA+chJ3mFqa8gTugPsOZQMkNIvkwP
	 uCUHz5ks0XE1R4Fje5e+QOLsASk40iUQPxfGZFCmu/i9HA7K7GsqYj0VrT25RvJ4DzJtu
	 6yMpU2nwySQGmgOqgpyF0OZDM36KaOCZfjgCfHP49BtC49ZaHh9kB0I1ztQ2Ffq3dPkiS
	 o/7/UV7UAZ0kBj6jNgab4fIw/no92pqPf2tzqVyqJniYipL4SmmVMArKRTd/OUPWT0TKh
	 8Zh793avitOLeAt+ePYD6NLxT15aqSvqTPRv3j5DbgP/jUCK+ZlB/QmVyYD0BfXEFhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdRjghx1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1959606A31A;
	Tue, 27 Oct 2026 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdRjghx1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F290A1F01825;
	Tue, 27 Oct 2026 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097456;
	bh=iOfhgmxWCwnZtJ0TmGVMocK5COR1vR2TuyujyACrook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdRjghx1YREDEQJESr9volri3i4LNsUZO9W+r4iEu3bBauTcoI6pWhb1E8mNhvVx3
	 LAqtnwN0lDzAhHt6it7oCze7S/9jgGHQzI4uMv8/bEdeCDDmRtJ9deSkAVGXVmSIZR
	 nVHvL7y75sCxmcSi6xETQ5gCiFN4ne5nQ/8aQLEv6HmnyKkusC2mKpUys83p+W0lPm
	 fccvQ3HKFq1EBvAOmUw+MDXjNpbqpEZPk7VKRURUSBwcB/noPkNCDRBjn8R5Uh7Vs5
	 x1zuy3H0w9xlRLTx4AVQUNtCWCOAIRrh9oyEhLBXaSFD8swj0k0F4uXj3PIq2sIpeQ
	 4FdIowKRRgPqg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 14/27] mfd: loongson-se: Check return value of dma_set_mask_and_coherent()
Date: Tue, 27 Oct 2026 09:30:43 +0000
Message-ID: <20261027093306.2812695-15-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261027093306.2812695-1-lee@kernel.org>
References: <20261027093306.2812695-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

loongson_se_probe() ignores the return value of
dma_set_mask_and_coherent() when requesting a 64-bit DMA mask before
allocating coherent DMA memory.  Check the return value and abort probe
if the platform cannot satisfy the 64-bit DMA mask requirement.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-6685ee0c-b7ed-4f21-8800-cc705cec449b
Cc: stable@vger.kernel.org
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d69..8dcb90a067b3 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -199,7 +199,10 @@ static int loongson_se_probe(struct platform_device *pdev)
 	spin_lock_init(&se->dev_lock);
 	mutex_init(&se->engine_init_lock);
 
-	dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (err)
+		return err;
+
 	if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
 		return -ENODEV;
 
-- 
2.56.0.307.g5fe7bd680c-goog

