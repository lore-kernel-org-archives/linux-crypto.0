Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6EB36A358
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824422; cv=none; b=SKIAVIOJ7d4fsvX7CyqAj5GzvDh/+MY53243TKdTP8NbSdXdAbUdA41ThyHE99P+uO63+zYiA8uAXyRGFzpEYzKupr5ZKIKBO0o4q5lG6rZAIvozoX9/6NXxEcsRf9MeEDeaaamdiFq7GALsBOqmrzB9EYlkP6TXCeOzsgB2fWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824422; c=relaxed/simple;
	bh=VKjttiqZTJ9JAtJeP2OISKVZqEAK2TTFftlDyNp+TUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fVM7O3COGavFcvNuPsdvbw/CfWTTWewQfSKIimoSt0RoJ5JdEaL+Pet35TjVcAR7SlYNF51l6/dY4enDIxs1j8mbHdiklefmPLhdicLiRcZnAMJOC9sjfkYtjEsRczpOL23kAb2sDyZWPYGNFv3sjk0v6ep40hSwnK5svDszGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tg8OheUr; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tg8OheUr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784824412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=liIUhIszn70ej2Xb1ALaUVFJ32HZsXvPGGT6YWV6bME=;
	b=Tg8OheUrLxI+PdzlRi3oKwiBtQ2veTK1k+ux4QTqj1LopAc4iEgyQS0bat3uYbQf+ml3U5
	HqMy0LsQEaKpjd8RrCNfy9I1mYa4ePwliTUPpOSDyELHy9VM5CGexpD+KERaoyhtT1Y6dX
	YFeXOhdE1PCb7Mq5mQRkhirrlZOcQ+0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kees Cook <kees@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx - simplify get_{eng,ucode}_type_str helpers
Date: Thu, 23 Jul 2026 18:33:25 +0200
Message-ID: <20260723163326.163043-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; i=thorsten.blum@linux.dev; h=from:subject; bh=VKjttiqZTJ9JAtJeP2OISKVZqEAK2TTFftlDyNp+TUw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlJTmF1r95d36YectBA4pTuqX5GjjPHc/2ieb2Ezn/oY D4uv4qjo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACaiPY/hr0jtE2eFD1vrbbSC /TYqvMrbKNNnFJ+/1Mvxcbzm/NkeVxn+p8zatv1H/m3RU3a1B8+7Lj5vum79u3aGUzPW5Ahn+66 exwgA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove the local variables, add default cases, and return the strings
directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 .../crypto/marvell/octeontx/otx_cptpf_ucode.c | 24 +++++++------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 417a48f41350..6b74b4737421 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -103,34 +103,26 @@ static void set_ucode_filename(struct otx_cpt_ucode *ucode,
 
 static char *get_eng_type_str(int eng_type)
 {
-	char *str = "unknown";
-
 	switch (eng_type) {
 	case OTX_CPT_SE_TYPES:
-		str = "SE";
-		break;
-
+		return "SE";
 	case OTX_CPT_AE_TYPES:
-		str = "AE";
-		break;
+		return "AE";
+	default:
+		return "unknown";
 	}
-	return str;
 }
 
 static char *get_ucode_type_str(int ucode_type)
 {
-	char *str = "unknown";
-
 	switch (ucode_type) {
 	case (1 << OTX_CPT_SE_TYPES):
-		str = "SE";
-		break;
-
+		return "SE";
 	case (1 << OTX_CPT_AE_TYPES):
-		str = "AE";
-		break;
+		return "AE";
+	default:
+		return "unknown";
 	}
-	return str;
 }
 
 static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
