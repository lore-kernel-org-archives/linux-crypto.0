Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66B43F083;
	Mon, 20 Jul 2026 03:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517545; cv=none; b=BeiGwnf5/nWzYz/Fl6Rg8O5CgiKClhuIs97oXy7OaywfOtMq9JgDNbemqli9BCyIhJbMND1JOam0CGlHUyRIVBzNy77n0VoNUg4ROV5YNcN9RgbqLezBMHWkA9NblLoxtmwPDYp1jgQxf0Yc3TzVEoGqD1clKlsY1msLhVNQYJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517545; c=relaxed/simple;
	bh=SUqUudlv8IrRHKbiWcCbHXRQmbqjhmJQqPQomXDaOV4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aVZRDLrApcygcILCmrASSX0Zle9YJ712RmX4lvNiY43nMGFCYj3sw8z4Ezc2Llruj2Z9jrQPo+kiF6GuT+5x19itjkxFdx/mYChZ4ZmW/7WUShrwaueMr5ikUvjYqm7JKXPJDjs1/kjZwq87ySefgCtL6ZBI5g564lq6J2FRJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: be6e0d8883e911f1aa26b74ffac11d73-20260720
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3f45f9f6-8c67-4d74-adc7-2a21b87f8ec1,IP:15,
	URL:0,TC:0,Content:49,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:64
X-CID-INFO: VERSION:1.3.12,REQID:3f45f9f6-8c67-4d74-adc7-2a21b87f8ec1,IP:15,UR
	L:0,TC:0,Content:49,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
	N:quarantine,TS:64
X-CID-META: VersionHash:e7bac3a,CLOUDID:58089b165723c209770b2120800fc73a,BulkI
	D:260720111857GPVNYG9P,BulkQuantity:0,Recheck:0,SF:10|38|66|78|127|850|865
	|898,TC:nil,Content:3|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ASC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: be6e0d8883e911f1aa26b74ffac11d73-20260720
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1504268535; Mon, 20 Jul 2026 11:18:57 +0800
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
Subject: [PATCH] crypto: verify_pefile - Use constant-time digest comparison
Date: Mon, 20 Jul 2026 11:18:15 +0800
Message-Id: <20260720031815.204237-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PE file digest comparison in verify_pefile_signature() uses
memcmp(), whose execution time depends on the position of the first
mismatched byte. This creates a timing side-channel that could allow
an attacker to forge PE file signatures byte by byte.

Replace memcmp() with crypto_memneq() to perform a constant-time
comparison, consistent with the rest of the crypto subsystem
(gcm, ccm, chacha20poly1305, rsassa-pkcs1, krb5, etc.). Add an
explicit <crypto/utils.h> include since this file did not previously
pull in the crypto_memneq() declaration.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 crypto/asymmetric_keys/verify_pefile.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index cec99db14129..dce40a2a3fac 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -14,6 +14,7 @@
 #include <linux/asn1.h>
 #include <linux/verification.h>
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include "verify_pefile.h"
 
 /*
@@ -374,7 +375,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	/* Check that the PE file digest matches that in the MSCODE part of the
 	 * PKCS#7 certificate.
 	 */
-	if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
+	if (crypto_memneq(digest, ctx->digest, ctx->digest_len)) {
 		pr_warn("Digest mismatch\n");
 		ret = -EKEYREJECTED;
 	} else {
-- 
2.25.1

