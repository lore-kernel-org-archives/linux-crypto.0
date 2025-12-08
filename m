Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D942BD036;
	Mon,  8 Dec 2025 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765187493; cv=none; b=hW+PreO/iudSISoM+UsassJsPO/OXCD3UHpx4D5S+qNDGvDTRAGExbSnLDFgTRBG+MWp7jdZQN76REbBtSCg5xYHnQ09DkJfnBsWD3tFE2NxW4BFi+h/ZqctJJ/EJHSqgVE3AUblhondG/CaDU8uUwL6gqKdF2aczdCuPFcGPTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765187493; c=relaxed/simple;
	bh=7rNL00mq7tAbIcF9SHhbcsgQ+5GbFRM5JzP9+81ix3c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=D9m2idEeiMiIJdAMfpfj2lDcBVbUekvJUy4dU1N5/CR8EcdBEGMiKQMZnFMOmyamSfIf0U3DiAme1YCrsw6Oh8FGMXqMmylQU31WPnYW1UFP0KGjyCoP+8m6ctGTW8YEDGyyX2jEmvyGfF+psollDDKh2NmF+9XpXeNS3498lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7448b024d41b11f0a38c85956e01ac42-20251208
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:b276f38f-ce43-4db3-8315-9ee5f48e1e0b,IP:15,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-15
X-CID-INFO: VERSION:1.3.6,REQID:b276f38f-ce43-4db3-8315-9ee5f48e1e0b,IP:15,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-15
X-CID-META: VersionHash:a9d874c,CLOUDID:1cea0632464d43c53aee8c7367c84119,BulkI
	D:251208175123H69U0DTY,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7448b024d41b11f0a38c85956e01ac42-20251208
X-User: pengcan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <pengcan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2078719368; Mon, 08 Dec 2025 17:51:22 +0800
From: Can Peng <pengcan@kylinos.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH 1/1] crypto: fips: annotate fips_enable() with __init to free init memory after boot
Date: Mon,  8 Dec 2025 17:50:10 +0800
Message-Id: <20251208095010.2712698-1-pengcan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The fips_enable() function is only invoked early during kernel boot via the
__setup() macro ("fips=" command line parameter), and is never used again
after initialization completes.

Annotating it with __init places the function in the .init.text section,
allowing the kernel to free its memory after init (when freeing_initmem()
runs), reducing runtime memory footprint.

This is a standard practice for setup/early-parse functions and has no
functional impact — the parsing logic, return values, and fips mode
setting behavior remain unchanged.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
---
 crypto/fips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 65d2bc070a26..c59711248d95 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -22,7 +22,7 @@ ATOMIC_NOTIFIER_HEAD(fips_fail_notif_chain);
 EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
 
 /* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
-static int fips_enable(char *str)
+static int __init fips_enable(char *str)
 {
 	if (kstrtoint(str, 0, &fips_enabled))
 		return 0;
-- 
2.25.1

