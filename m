Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66FC823DD;
	Mon, 20 Jul 2026 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517839; cv=none; b=UebNAzgCSPRZIrFGCJni1cpNy5uIO2erUjeoY/kxyxGk4JfzEnz2LDR5ZukgSgGKXq90BUAfqvU076b+4x72aiosUnRarnZ2AqJbGclg7tfc8/fbpgIqBkYViZXfzXTaNVAdzGHOiN9n90No4BHuzEpOqmEgqxBlycMoDQAW3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517839; c=relaxed/simple;
	bh=HclbTRxz0ynQQF1hk7P/4WcTT6IygMru1qymKWT+8dk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TWpda7Q9nvIkP6peGmCxR9KT+ZPe5PEx57w/03m2EpwsrwUiUrqC+hqeEdGhq5+nZxjP3aMrUpmKFz67ewiz7zqFplz2wRViP/0cbcMyLRdhc1YUlAuo0UGtKuUUKcNqAVNy2sUXVIVUO0pnBYMBOfXXXAaSiL6MSaZEl27FFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6db7080883ea11f1aa26b74ffac11d73-20260720
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
X-CID-O-INFO: VERSION:1.3.12,REQID:bc4c2c07-fa89-4e57-a3e8-68b73ec13b1b,IP:15,
	URL:0,TC:0,Content:36,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:51
X-CID-INFO: VERSION:1.3.12,REQID:bc4c2c07-fa89-4e57-a3e8-68b73ec13b1b,IP:15,UR
	L:0,TC:0,Content:36,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:51
X-CID-META: VersionHash:e7bac3a,CLOUDID:d06adba27bd548a630ad98b051b67433,BulkI
	D:26072011235163SGHVAC,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:3|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6db7080883ea11f1aa26b74ffac11d73-20260720
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 958085240; Mon, 20 Jul 2026 11:23:51 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	13667453960@163.com,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] crypto: pkcs7 - Use constant-time message digest comparison
Date: Mon, 20 Jul 2026 11:23:16 +0800
Message-Id: <20260720032316.210113-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The message digest comparison in pkcs7_verify() uses memcmp(), whose
execution time depends on the position of the first mismatched byte.
This creates a timing side-channel that could allow an attacker to
forge PKCS#7 signatures byte by byte.

Replace memcmp() with crypto_memneq() to perform a constant-time
comparison, consistent with the rest of the crypto subsystem
(gcm, ccm, chacha20poly1305, rsassa-pkcs1, krb5, verify_pefile, etc.).
Add an explicit <crypto/utils.h> include since this file did not
previously pull in the crypto_memneq() declaration.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 474e2c1ae21b..8c619b252ca5 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -14,6 +14,7 @@
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
 #include <crypto/public_key.h>
+#include <crypto/utils.h>
 #include "pkcs7_parser.h"
 
 /*
@@ -93,8 +94,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			goto error;
 		}
 
-		if (memcmp(sig->m, sinfo->msgdigest,
-			   sinfo->msgdigest_len) != 0) {
+		if (crypto_memneq(sig->m, sinfo->msgdigest,
+				  sinfo->msgdigest_len)) {
 			pr_warn("Sig %u: Message digest doesn't match\n",
 				sinfo->index);
 			ret = -EKEYREJECTED;
-- 
2.25.1

