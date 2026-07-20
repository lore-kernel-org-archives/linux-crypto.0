Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551FA233941;
	Mon, 20 Jul 2026 03:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517225; cv=none; b=SfKQE8uyx/MUkEDVg/cQ7Acp9sz0Cy5M6jI+zeIqVR3MUsRwtiESrGUA4TaFYnXGMAJYB3pLtcAvLa4P8uLZ2iMpFS9VYYwqC2bYfaNNJvTxwYncY9rwyKeqSbgfx2bNUrtzYtMPESqUcpsp8ZPTSOkZ1ZIl43pxnwketmhF2AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517225; c=relaxed/simple;
	bh=idsiyDJxIn3yU9iRXTHvLUAlSKBvq7Ih9esnssiKbrc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ku0X0hAD51sKPuZeu2mgWxSVjTD/++iJ2ODeS/hdLBPzZqnb/jXz3xuYRz6Fu+z0PR22enFu5+kxNihBY+X95WPgcHecMX6BHAb0KmdwScnaYeRZ5VrqBhHHdOA3XBaEt2At6E2Iw/PFZkhCSFkP8tazWXdicVSpaha4t46ZYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0034245683e911f1aa26b74ffac11d73-20260720
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
X-CID-O-INFO: VERSION:1.3.12,REQID:564490ea-2e45-4a01-a285-5376e240e437,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:564490ea-2e45-4a01-a285-5376e240e437,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:813146823c55015110ad06dcca4f69c0,BulkI
	D:260720111339QK2GOPPI,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0034245683e911f1aa26b74ffac11d73-20260720
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 684670238; Mon, 20 Jul 2026 11:13:37 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	13667453960@163.com,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] crypto: krb5 - Use constant-time checksum comparison
Date: Mon, 20 Jul 2026 11:13:04 +0800
Message-Id: <20260720031304.198172-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MIC checksum comparison in rfc3961_verify_mic() uses memcmp(),
whose execution time depends on the position of the first mismatched
byte. This creates a timing side-channel that could allow an attacker
to forge Kerberos checksums byte by byte.

The same crypto/krb5 subsystem already uses crypto_memneq() for the
equivalent checksum comparison in crypto/krb5enc.c (line 255), making
the memcmp() in rfc3961_simplified.c an inconsistent oversight.

Replace memcmp() with crypto_memneq() to perform a constant-time
comparison, consistent with the rest of the crypto subsystem
(gcm, ccm, chacha20poly1305, rsassa-pkcs1, etc.). Add an explicit
<crypto/utils.h> include since this file did not previously pull in
the crypto_memneq() declaration.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 crypto/krb5/rfc3961_simplified.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index e49cbdec7c40..8722609bb723 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -75,6 +75,7 @@
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include "internal.h"
 
 /* Maximum blocksize for the supported crypto algorithms */
@@ -763,7 +764,7 @@ int rfc3961_verify_mic(const struct krb5_enctype *krb5,
 	if (done != krb5->cksum_len)
 		goto error;
 
-	if (memcmp(cksum, cksum2, krb5->cksum_len) != 0) {
+	if (crypto_memneq(cksum, cksum2, krb5->cksum_len)) {
 		ret = -EBADMSG;
 		goto error;
 	}
-- 
2.25.1

