Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4433F6;
	Sun,  9 Nov 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762699558; cv=none; b=gu37KW7uEukbo/57tgHrvo29/4mA2yTQqfwclyAMbxc0MikMnnPPweZjW8EfB7n6X2eS5xbQfwZslRoZVvcUNzh3FwglQkgoXctbZAxnYwVkfsmDHhjZOdMZ23ZJkuva+agZ61HEiRgswQIicP6MVt1UKRqBELM3JzrcCF2awKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762699558; c=relaxed/simple;
	bh=1IcjavsIzywwpfImhhe3Ii+OnYJEwOlXREv3CiZfPdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iX3OTx6UQR3yUyS8kTf5zNSBeGhD8mxdJ94KOBdPh88bGsnLXtaV/SX/oGlI+Npf/1hoX0rfRaNTfh2SAujSGZCQ0ntUmPrjlWBEYkIRwPmJjG598zhD1630cN9PoZ9yHg1B/9auYTKJJUjascq7yBu/pK/tWz+hADNAX7ut3Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c1d4f0b2bd7a11f0a38c85956e01ac42-20251109
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IT, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-CACHE: Type:Local,Time:202511092244+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e9c7f34b-8220-4242-a264-1003ae9b8153,IP:10,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-45
X-CID-INFO: VERSION:1.3.6,REQID:e9c7f34b-8220-4242-a264-1003ae9b8153,IP:10,URL
	:0,TC:0,Content:0,EDM:-25,RT:0,SF:-30,FILE:0,BULK:0,RULE:EDM_GN8D19FE,ACTI
	ON:release,TS:-45
X-CID-META: VersionHash:a9d874c,CLOUDID:0a3df30eafa8c650610621555f9363b5,BulkI
	D:2511092244216HOW2UMU,BulkQuantity:0,Recheck:0,SF:10|66|78|102|850,TC:nil
	,Content:0|15|50,EDM:2,IP:-2,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c1d4f0b2bd7a11f0a38c85956e01ac42-20251109
X-User: hehuiwen@kylinos.cn
Received: from localhost.localdomain [(220.202.195.89)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1672393917; Sun, 09 Nov 2025 22:45:38 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: schalla@marvell.com
Cc: bbhushan2@marvell.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	krzk@kernel.org,
	sbhatta@marvell.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] crypto: octeontx2 - Replace deprecated strcpy() in cpt_ucode_load_fw()
Date: Mon, 10 Nov 2025 06:45:15 +0800
Message-Id: <20251109224515.182108-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strlen() requires eng_type[8] to be NUL-terminated, but strcpy() does
not check the buffer size or guarantee NUL termination. This may lead
to out-of-bounds memory access when accessing eng_type[i].

Replace strcpy() with strscpy() to ensure NUL termination and prevent
potential overflow. This improves code safety and robustness.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index ebdf4efa09d4..2371696df426 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -458,13 +458,13 @@ static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info,
 			     u16 rid)
 {
 	char filename[OTX2_CPT_NAME_LENGTH];
-	char eng_type[8] = {0};
+	char eng_type[8];
 	int ret, e, i;
 
 	INIT_LIST_HEAD(&fw_info->ucodes);
 
 	for (e = 1; e < OTX2_CPT_MAX_ENG_TYPES; e++) {
-		strcpy(eng_type, get_eng_type_str(e));
+		strscpy(eng_type, get_eng_type_str(e));
 		for (i = 0; i < strlen(eng_type); i++)
 			eng_type[i] = tolower(eng_type[i]);
 
-- 
2.25.1

