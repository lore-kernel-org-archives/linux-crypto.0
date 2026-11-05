Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863099;
	b=t6fiAe8pjBv8jIcb+aW1hjw5X7uJAasuqXonKdlqFaFe0PqtDmbI1oiGaLUgmCJFEx3w
	 UxFI+xA8T1QISTHJ7UKEaVZisgOTg4kp8hdqTNjb/9clQLxRjoiIy9+P+i4H8vwa6jfd4
	 x56jmhZ5CBMkjVikzSfU7fN8f77lJmlc/UJiFjWW4S3ZRM2N8+ozJZvtboeEUAZZG6nGk
	 id/948PiKqcMT9wg2VDYOnEifuF/PkbXbKLsI3XaxSBkouPZU8CvSe31shRsKatQrhZsP
	 Npl+WOXSAr+efeDX6VcMiqdukjiforSyFyzv3yXyaE/Mdb8A0JfC18tEAk13gZIB8Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863099;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GJfuccBsESyaMktbIQtsSYOwxg6JTp+e/MYBrXLWAPI=;
	b=1GcmRO1ksNrHUlbRpaVjcTU/1kLLNgBGc4113UlkRklRWM75rcDgrPaxClPePTEHiwJj
	 SVUAoeQhK+Rhfw4g3/xqEb5GxYyExHlhO2briYq3CidwSXQ08fSHbS7stosqLJaNrinbD
	 3stcHZSQNZrNUoe5LHMWQ/Sxfwqq5pGaKZzce4twXmza4LDPxc9orcdW+hzp4g0I4+9Ny
	 glILhcxpg9lovt3VENg9zvJr+j9ka9uHhHv/IZTNPw1ZO3GqqEXd/Wfn8E1CBN+u5Z/Ss
	 dqsh0WBmMAeuiXYq4l/S2jT7y4nBEqzGc18T314ACZoOc1k7ZbkvoMIg8vLrS98wzlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F26606A329;
	Thu,  5 Nov 2026 07:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8F26606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 09ea3350d8e911f19a56ed5b684f684d-20261105
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_ADR_NAME, HR_TO_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_EXISTED, SN_UNTRUSTED, SN_UNFAMILIAR
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1a3d4cd5-2fb7-469d-848b-876edd21e248,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:1a3d4cd5-2fb7-469d-848b-876edd21e248,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:b678190c7abd29f5c4e550106320e6c8,BulkI
	D:261105151805TSDO90KJ,BulkQuantity:0,SF:10|40|66|78|102|127|153|865|898,T
	C:nil,Content:0|15|50|99,EDM:5,IP:-2|1,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_IBB,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 09ea3350d8e911f19a56ed5b684f684d-20261105
X-User: leixiang@kylinos.cn
Received: from ninol [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 635666650; Thu, 05 Nov 2026 15:18:03 +0800
From: Xiang Lei <leixiang@kylinos.cn>
To: 
Cc: Xiang Lei <leixiang@kylinos.cn>,
	Wei Liu <liuwei@kylinos.cn>,
	stable@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: virtio - fix copy_data() handling of partial reads
Date: Thu,  5 Nov 2026 15:17:33 +0800
Message-ID: <20261105071736.65932-1-leixiang@kylinos.cn>
X-Mailer: git-send-email 2.53.0
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

vi->data_avail is decremented on each read, so it holds the remaining
bytes rather than the total length. Subtracting vi->data_idx from it
again in commit e3046eeada29 ("hwrng: virtio: clamp device-reported
used.len at copy_data()") undercounts the bytes left after a partial
read. This can leave vi->data_avail nonzero without queuing a new
request, causing virtio_read() to hang on have_data.

Clamp vi->data_avail to sizeof(vi->data) - vi->data_idx instead.

Fixes: e3046eeada29 ("hwrng: virtio: clamp device-reported used.len at copy_data()")
Tested-by: Wei Liu <liuwei@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Xiang Lei <leixiang@kylinos.cn>
---
 drivers/char/hw_random/virtio-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f9982217247d..a3392f7e2d8c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -70,7 +70,7 @@ static void request_entropy(struct virtrng_info *vi)
 static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 			      unsigned int size)
 {
-	unsigned int idx, avail;
+	unsigned int idx;
 
 	/*
 	 * vi->data_avail was set from the device-reported used.len and
@@ -81,13 +81,13 @@ static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 	 * steered into adjacent slab memory, including under
 	 * speculation.
 	 */
-	avail = min(vi->data_avail, sizeof(vi->data));
-	if (vi->data_idx >= avail) {
+	if (vi->data_idx >= sizeof(vi->data)) {
 		vi->data_avail = 0;
 		request_entropy(vi);
 		return 0;
 	}
-	size = min(size, avail - vi->data_idx);
+	vi->data_avail = min(vi->data_avail, sizeof(vi->data) - vi->data_idx);
+	size = min(size, vi->data_avail);
 	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
 	memcpy(buf, vi->data + idx, size);
 	vi->data_idx += size;
-- 
2.53.0

