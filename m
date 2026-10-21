Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584931;
	b=AzNF50vY09MDJLYN0NHxoFSfUYAUG2/+lzSt1N8LraLb5j+yuDHkKtuRyB3QOa2M4SzB
	 XN8dxUEUNj5aljX45x1oz5USbweoaz9qKOOHdmGESgvObdksdsXEPap9t/O4S29TnMnBd
	 M5Rx5VaHl40T/O+ULgKlWPNC/UJ0x2OmWu0PyAhDW/meK427nlG8rexQGdYQiV77LTObf
	 Tn1HkACIw9w+L/Y+OnauyPn5HM0z9evVqsi0+npX0NF9Wb4VnOTVKK8z5Y8EBYNyQ3lq9
	 syERuSxrnqnnjIJJrXQrxR6/yw5pm6FtE41VxrifzYZXpjsdH5tGjdlUemS3bkFEMRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=X9lWh4O6O7Umzil2pxjsOPjFQX4WkHiI/3kxYZplzAY=;
	b=T9y7VXKw2O1MlfyKHw0b6+v9U7bjyghniUDXysRXPCYMwvmuNO5CjK1mhJDOcrqs6Ui3
	 XGwPqkv/qcw+cDWNkgxHhsqOMMBrGXAqEg81uuwJ8Pe4+I4jmwX9TJlXZysEuUjaane5Y
	 o8DZGomtnJzAa3IUOqwegAr2VlBcB1g/OfmxWAnA5oT8aZPGgKnseQBIAFtq3XKCKFMjV
	 EInf9OHeTDd97Y0gmqKwvzFg8+R6sbHS7GnC+JAg9lTof8NDPUiOR0wvCP75ejjHokCs0
	 5wcGO5Lz3VuSJF9DGhNY6IKz/+Y8WG9I6ISx4q/SLT0iWUFaSh+A/7j9QObue7eLMCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S97KVlOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABE1606A321;
	Wed, 21 Oct 2026 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S97KVlOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390511F000C4;
	Wed, 21 Oct 2026 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584930;
	bh=X9lWh4O6O7Umzil2pxjsOPjFQX4WkHiI/3kxYZplzAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S97KVlOaNk7UeV9V67X4hdY7yar3aMYGquTLgF/sf9CPyYn6wickeS7DDsV12lw7/
	 Yl1IBvB/8Gv4VKc0O+VJWadzuD666BCmNy/yytqe8k7EHsh70NIW/apxE5S2hCdhTu
	 nSHEHm1lxbLfjVq3Rho4NvJepBZ1ghQ2SJd7ijcjswzGKysmpUPlLmRzpOfj6KV4Hu
	 qBwdIjPW7o5Yu75A7RIpocZLgLN8Y9PBHoaqcdOmHrnaNsUrQ5pqHi2Zp0S8uU87aK
	 anpwftz0tEXdNjmybuCRtWbcoWtiqFNaxiDCM6ooy/jNcmzF2qGhBXb9pLiZkAOFk+
	 10zw7k2T1k06g==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 15/28] mfd: loongson-se: Check return value of dma_set_mask_and_coherent()
Date: Wed, 21 Oct 2026 12:09:37 +0000
Message-ID: <20261021121245.3111563-15-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
In-Reply-To: <20261021121245.3111563-1-lee@kernel.org>
References: <20261021121245.3111563-1-lee@kernel.org>
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
2.56.0.218.g1ec904b173-goog

