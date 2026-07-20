Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03EA72623;
	Mon, 20 Jul 2026 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784513655; cv=none; b=L1JMVOwrzC/SN0l6Sj6Ri/vxcEshxyaXfLRTCpcX7B2aNr6vnBH9Y/ypNFNL0UY6SN/lk4lsLPpWWy5i+CwVmM31UlewsV/QCQ0xtpUT7z7k4bgFKX7XoQ0GoV7FPrusn9+Ul5Yp2qR2JMOzrCVJ7jF0qNlIBxvaSxD4I9vhShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784513655; c=relaxed/simple;
	bh=SrWleWXqhe9ZAaOZLDCbF/+5e+by+hmpkLG9x9qAqTs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eyW4xkGcdNgtRCWbj+Sz4VZoj3VQYYPczF04Xagc/AP7eH4Dir+AkPq4vG1gwejypIBhGCXVygEfur7klbmfNnAVw5arTv5EaNrAwFX4u0V8AoYgfqEu1lS9Fmxwz3Oqf5rULBnL6ccukAiMlJGI/GlIgdGRk7PsvelBCA4V+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b02e5cb883e011f1aa26b74ffac11d73-20260720
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7fcd9d23-5882-46a9-ac6c-a8f12cda6b17,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:7fcd9d23-5882-46a9-ac6c-a8f12cda6b17,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:e9db82c961f5bb119f0c487871581647,BulkI
	D:260720101408BWPN2JAN,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b02e5cb883e011f1aa26b74ffac11d73-20260720
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 322931628; Mon, 20 Jul 2026 10:14:07 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	13667453960@163.com,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] crypto: rsassa-pkcs1 - Use constant-time digest comparison
Date: Mon, 20 Jul 2026 10:13:22 +0800
Message-Id: <20260720021322.122784-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The digest comparison in rsassa_pkcs1_verify() uses memcmp(), whose
execution time depends on the position of the first mismatched byte.
This creates a timing side-channel that could allow an attacker to
forge RSA PKCS#1 v1.5 signatures byte by byte.

Notably, the same function already uses crypto_memneq() for the hash
prefix comparison (line 287), making the memcmp() at line 294 an
inconsistent oversight.

Replace memcmp() with crypto_memneq() to perform a constant-time
comparison, consistent with the rest of the function and the crypto
subsystem (gcm, ccm, chacha20poly1305, krb5enc, etc.).

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 crypto/rsassa-pkcs1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..a612a9eef2dd 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -291,7 +291,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	/* RFC 8017 sec 8.2.2 step 4 - comparison of digest with out_buf */
 	if (dlen != dst_len - pos)
 		return -EKEYREJECTED;
-	if (memcmp(digest, out_buf + pos, dlen) != 0)
+	if (crypto_memneq(digest, out_buf + pos, dlen))
 		return -EKEYREJECTED;
 
 	return 0;
-- 
2.25.1

