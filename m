Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163577;
	b=X6+FjrZeoKaR5j6wA6zWcDHDp7NgkuK7j/fXe+wI8oMzCGmZZxC0Y2awa8XWrsIbQr/Q
	 fujVrEQEVSKaiQaifJ3Jjgyj18koTNgDwxdI24ppicC8XWHoAjFqoQH0wwW2lP3eMzLd6
	 6MD5tKDmGaAVuLwGHB3LaAKCGz5elIf4hlivdRSqB6wiou3jkepsdY10tt7QFHzGhSeSk
	 Zn4xa0NCf//vuJvP3Vu7kWqQX+WOaTfRwuiErwZWwqDn4K021N7bdyApRQ5UF0YULYhrf
	 uj2REh/6/VH56ndmoRu7Q5+ZVn4IzA48S60tdehx8ZVvGDbVuG9EGVGlmbvuOtiequg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163577;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LTOeBOcH0QpOoEy39qSrrTEZAau+gsErAVOrAz8XShY=;
	b=QTjUNr+eB3Ll9o3XOc1I0k4n7WPmCd1zWjkUVpwokhoj9mE/NLcM1qHa67e901yryLih
	 8Xc4sIgaykp3tiedp5aQnChyJQf465ss2ifmgETXMBBKNyfxnoF+o1BLLHa2zUzJpP8b6
	 ctIqq0rFYf2DoxAPK4+sDZQS6U0z7cSy0UkjzN89h55XHXVc8Fu6b5SKkh5WrXghkwimc
	 2L7mrnb1Qpv1WZdC+vidbrxVVcnqqGh7ITu0wVsBq96T7YZ5BLrw6/1aBnga/ItwfQtkd
	 +iFp4Druy4m1uRQxj+y6QyhoB6DEC1Zn3cSCjM6HqyYqMbAC7cZ6QPP9YqwQhR12Kug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2987606A325;
	Fri, 20 Nov 2026 08:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2987606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f6f41ca4e4bc11f19a56ed5b684f684d-20261120
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_UNTRUSTED
	SA_LOWREP, SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:0da4cfba-52cb-4ef1-b897-5ccf1184d1bc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:0da4cfba-52cb-4ef1-b897-5ccf1184d1bc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:e946d9e6907a3d2024b7686ccf8f6212,BulkI
	D:2611201632519E4ABE11,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f6f41ca4e4bc11f19a56ed5b684f684d-20261120
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(36.106.123.207)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 386470586; Fri, 20 Nov 2026 16:32:47 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: [PATCH] crypto: af_alg - wake up waiters on zero-length final message
Date: Fri, 20 Nov 2026 03:32:44 -0500
Message-ID: <20261120083244.1156396-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
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

af_alg_data_wakeup() returns early whenever ctx->used is zero, whereas
af_alg_wait_for_data() waits for:

	ctx->init && (!ctx->more || (min && ctx->used >= min))

When a reader is blocked in recvmsg() and a sender submits a zero-length
final message (no MSG_MORE), such as an empty gcm(aes) AEAD encryption
or an empty send to finish a MSG_MORE stream, af_alg_sendmsg() sets
ctx->init = true and ctx->more = false while ctx->used remains 0.
af_alg_data_wakeup() then bails out on !ctx->used, leaving the reader
blocked indefinitely.

Only skip the wakeup if the context is not initialized yet or more data
is still expected with nothing queued.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
Cc: stable@vger.kernel.org
Signed-off-by: Guicai Ma <maguicai@kylinos.cn>
---
Verified with a two-threaded AF_ALG test (zero-length final sendmsg
on gcm(aes) and ecb(aes) while recvmsg() is blocked): recvmsg() hangs
before this patch and completes immediately after.

 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7524070f26d8..9b4f8c1d2e3a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -938,7 +938,7 @@ static void af_alg_data_wakeup(struct sock *sk)
 	struct af_alg_ctx *ctx = ask->private;
 	struct socket_wq *wq;
 
-	if (!ctx->used)
+	if (!ctx->init || (ctx->more && !ctx->used))
 		return;
 
 	rcu_read_lock();
