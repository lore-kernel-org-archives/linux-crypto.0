Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01E33793C5
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774892411; cv=none; b=TNZKbHRLALQHZ+PMWIEp/S5LGMSODWo6wrCJOMjmLtD56UrpPTnkO4jyjnIs7ll7m/3KOAK/WQ9u9YpUIIvYU5VsCqBjZWmRzg5aM0RlVTWIGwWtYysk8+ig6gX0G2v2/9D+/Pgt9WmL4PVBFv5U3fbWNT8MQe+wqpHT+C1A65s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774892411; c=relaxed/simple;
	bh=MmonoAx1361qvYCSdrtWQwdUQUNtBdSPQ/Yy/qcDpbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AwhNlmjy6QF+rodyo7SR5UnK+slkcor58PL+/eFnhGxJbj+Vs6Jhu8cgT9EiJAisLVbA+ISUvtxJp7AP5zGdWJ8nITHNN9KZbUBSmYMRuqs5r5X6BFsha/3UWQujO0Ztswd4ybktAn4mjxxJedW86DcX1IivZ6KFzpZqFhYe59s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dj8Qo/vO; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dj8Qo/vO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774892397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=joPdK440VeWntNfhQggHWZlGE83OY4yxxCUVtLRFu2w=;
	b=dj8Qo/vOtZG9Ebv7bkvPOvJvaSLQpSoxbaAWQQsNmfnjaTHtJYmzuMOrAI0W8Ojl9X1WPE
	/beumUXfuI11JTx/DiBygGjUMRvVoUerT+GDzUWEEjMsWYNWUm+lRfyTacH07xd+7p2VtU
	Ag+ml8ALsg0n9AO4dMju/SP5eqitGV4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - simplify qce_xts_swapiv()
Date: Mon, 30 Mar 2026 19:39:25 +0200
Message-ID: <20260330173923.479407-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1254; i=thorsten.blum@linux.dev; h=from:subject; bh=MmonoAx1361qvYCSdrtWQwdUQUNtBdSPQ/Yy/qcDpbE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmntnr7Vc2wndQmG602+0BV9+c3z8IN6j+UP18W6OmTr X2gXmxXRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEykmIfhv7NqU35Zc+CxeQlL Zgj2zQ0/VSD2q/qk3vfPfQeaX/hVzmNk6OSfsvW5j1yVTH+Db1lA/Y9L7BuEfXfNX6FTnrtahmc +DwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Declare 'swap' as zero-initialized and use a single index variable to
simplify the byte-swapping loop in qce_xts_swapiv(). Add a comment for
clarity.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 04253a8d3340..54a78a57f630 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -280,17 +280,17 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
 {
-	u8 swap[QCE_AES_IV_LENGTH];
-	u32 i, j;
+	u8 swap[QCE_AES_IV_LENGTH] = {0};
+	unsigned int i, offset;
 
 	if (ivsize > QCE_AES_IV_LENGTH)
 		return;
 
-	memset(swap, 0, QCE_AES_IV_LENGTH);
+	offset = QCE_AES_IV_LENGTH - ivsize;
 
-	for (i = (QCE_AES_IV_LENGTH - ivsize), j = ivsize - 1;
-	     i < QCE_AES_IV_LENGTH; i++, j--)
-		swap[i] = src[j];
+	/* Reverse and right-align IV bytes. */
+	for (i = 0; i < ivsize; i++)
+		swap[offset + i] = src[ivsize - 1 - i];
 
 	qce_cpu_to_be32p_array(dst, swap, QCE_AES_IV_LENGTH);
 }
