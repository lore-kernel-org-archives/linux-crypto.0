Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC4813FEE
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 02:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194937; cv=none; b=NMxERebutDp6TWNhdRO4tHXq6wxljk9hNhIzKIGP0xK7r/cD84wHxedmZ+KMwsDumsrGl3tQc1w+A99Cd/RDZoskx++t/UtksCEg6h4pt8H95FIHwb3Y94I6yZPj8U7KEUy4dWpJWaLFw5D87WZDusBzqY3hmEfVDuhMYVTjWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194937; c=relaxed/simple;
	bh=Q5cFX2k6bHPxzmFwA1jZZP2sbUYKylqyAiNpZjCoMM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fChp2h0rgwvZj7+Vn5r8r4FV5jqxDMX30VrLTGx4RJlAhRw7f1p3qO59k63cXHxIowTIRo29iM2z/KvpEOc59m7DKP9+9yjQ7WjVGKNUwmprpxM1jVCd0G/bOINUSUcB9s63/KTut32oqVygxVlK8XVXwoKaQjYZmROSWbnm5Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gUKioZh+; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gUKioZh+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773194922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T9f/NPNUnA8wcieHoMwt6iGWiyD3QsUUnDTus3MDL7Y=;
	b=gUKioZh+4Jvw0/Iw+sLJF9tyZm+zYGd9qYPoanXP8n7soOYeOBpIhWtADOc2ujewBJurMc
	2O0tOlqunO3vw6b7VDZpIiRs2v3N5px5LqkaMVpn/XuWJtMEz8olT3J7ykzYCpUv4pMFNE
	PN9y76lAAm8GUfn0QHKNKBN5JQ54eYs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Wed, 11 Mar 2026 03:07:35 +0100
Message-ID: <20260311020733.250288-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1027; i=thorsten.blum@linux.dev; h=from:subject; bh=Q5cFX2k6bHPxzmFwA1jZZP2sbUYKylqyAiNpZjCoMM4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkbzqUKhj15ssTH/p5yVPAMFmUvWem/ayZN9d3q6B3YZ uMoec20o5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACZiYcPwh08kfmn/Dd0kES32 PX/LDjYL7ihJ4qxcJyY2e8URS+m/3owM56+nOv77sNJ0/77WGUKnt/Yt+/Di5IGA5S7cHYs2P/7 dww8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

atmel_aes_buff_init() allocates 4 pages using __get_free_pages() with
ATMEL_AES_BUFFER_ORDER, but atmel_aes_buff_cleanup() frees only the
first page using free_page(), leaking the remaining 3 pages. Use
free_pages() with ATMEL_AES_BUFFER_ORDER to fix the memory leak.

Fixes: bbe628ed897d ("crypto: atmel-aes - improve performances of data transfer")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index bc0c40f10944..9b0cb97055dc 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2131,7 +2131,7 @@ static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)
