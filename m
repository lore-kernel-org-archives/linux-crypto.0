Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446731;
	b=1Aa+rTpEvb9VMT+GXm89Tz/0CAkku3J+pu80EKNMMUz7MHhYj9ePh4+35+4n7rF0URub
	 FevQ9CjcaGjeM7Z7GApArb6habJ1UsOxKkaa0lOhgY7KW/ksG4FJt/tIXklIdaKYs//D9
	 bIKEYuEqmzIEcdZ3rspYzNHPCS/VjcboxLKOuyvp6DPCijkChu5HPlSV7poLqBzgAW7Do
	 ga8CURUZbiw8YPTO6DCMmAjKGsB5pSyytaosyb9od2y5RlobyT//xawsfkhZ36OQIyiOa
	 oaPdJoWK5GzkwSc5aYrkNXdM+FNR8Ix9XPm+92ckDB7p+NOFIgwv3NoCfScsAqs+yYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=P2XW2sccuUVgo6BwdJvmsjjX7/WXqZl8dRMrcDqHgXg=;
	b=Ab4+wzrrP459zY1xauNe0dyJUIF3vQ0UeVX3Y6q0mtvl44Ad50gh+KaNlvJ9XV0J0VyI
	 v7dJ8a/ARzlGabNChRhfSg3tYnz+QiApC1AXVMcixGhTMnzN/BhHCh2MIdpul6FtyNhLE
	 rmtc0ofOJucpAYMqjl/KOHa198zsq+F+Kx5hPzElzgqCRKX88zPgacGwcWBHVugNY3Fzv
	 G8S7OdcrVgJxT0FY8Tk4zNUwG37hDxuGwqSaCXL38z5dRTnZC15/hjenSWD9zm9V2B4ET
	 9lJpflTSdIojbz8CyJJ9eJ0Pntci39H0WBGuXF/G/YmVXknfqZime9SqhyJVgk6iv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kFtrLImG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E724606A31F;
	Mon, 23 Nov 2026 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kFtrLImG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D04A1F000D0;
	Mon, 23 Nov 2026 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446730;
	bh=P2XW2sccuUVgo6BwdJvmsjjX7/WXqZl8dRMrcDqHgXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFtrLImGjN5ASXnjgtBGtbUg9JgKlyMhqhiJ3RO6BUkIIxxW002vYHMZ9SHV5QdQY
	 tlsRMr+XcoKRsJIoxKGPye3GSFTs3a3CpbeLL5yjDhOIhw40lz3O0e0WcpD/D9L0BS
	 +0E/N0cgp41WLkXfI/CDKZ9GLTO7m4bTnjzkZZ3IAKwlcDyQNz2QlRQCxQ9VVMOdC7
	 0SPXu9tMRuI5aUimROWZzVc2DXcMJ0JTuJI0SCeZhz9wDce+jJQeV8aPCNkB5B0HMQ
	 /0TyCIQRQMSMpyhEfYmY1Sy7smXabCIL9DSPyR+tgKRzm3AJSgARpdLG19kMSjoGJQ
	 2Et9HjUMJwHyg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 09/10] crypto: qce - Terminate RX DMA channel if TX preparation fails
Date: Mon, 23 Nov 2026 15:10:00 +0000
Message-ID: <20261123151055.2533735-10-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

qce_dma_prep_sgs() prepares and submits the rxchan DMA descriptor via
qce_dma_prep_sg() before preparing the txchan descriptor.  If the
subsequent txchan preparation fails, qce_dma_prep_sgs() returns an
error while leaving the submitted rxchan descriptor queued in the DMA
engine, and callers jump straight to unmapping their scatterlists
without calling qce_dma_terminate_all().

On the next cryptographic request, qce_dma_issue_pending() flushes the
stale rxchan descriptor against already-unmapped memory.

Terminate rxchan via dmaengine_terminate_async() when preparing txchan
fails in qce_dma_prep_sgs().

Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Closes: https://sashiko.dev/#/bug/linux-0b5dbd9f-7869-4856-a8e5-47c2c6e342f1
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/qce/dma.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad..726e7fd3421e 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -116,8 +116,12 @@ int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *rx_sg,
 	if (ret)
 		return ret;
 
-	return qce_dma_prep_sg(txchan, tx_sg, tx_nents, flags, DMA_DEV_TO_MEM,
-			       cb, cb_param);
+	ret = qce_dma_prep_sg(txchan, tx_sg, tx_nents, flags, DMA_DEV_TO_MEM,
+			      cb, cb_param);
+	if (ret)
+		dmaengine_terminate_async(rxchan);
+
+	return ret;
 }
 
 void qce_dma_issue_pending(struct qce_dma_data *dma)
-- 
2.56.1.750.gf70dc682cf-goog

