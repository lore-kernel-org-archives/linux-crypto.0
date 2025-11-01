Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A5189B84
	for <linux-crypto@vger.kernel.org>; Sat,  1 Nov 2025 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762005914; cv=none; b=NOPTjz/B7T/efUNKwlrBnFxCWBHtsgx2KC1tegc6vT8E3GJEnCkvfZr6KKwpqnPIK5Oszbg7x6LWoZ5Iek2Ndeqo7NFa6TpzSWbWKhxbut0RE1M2zPLb4NoTmifAiRj79nbl8361xD6V2llb7prefS5r9/UTY4Ka26oEca2gKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762005914; c=relaxed/simple;
	bh=SQ38qYTNJxk5DYz0GtHJiiInMCX0D2KO2qM0xpn1akg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lZ1svPh+k191FdAK8Io3p7X+bwLGbHbUXmuS1CGBQ1uc1YlkhhrTmnIv83RjO3O6TUFgkY+QO69s/FI2CAc3+z3nhQMztfjT9appvcyrwJKzNXJqIDR7WfblGl785zT9wABO8283SHCBTAxoHNsCJEUi1v3mf58fnCh1qdQDLoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TBgUo5xI; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TBgUo5xI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762005896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GeA2oPtPm0WGain9EgMxJLDlTytvn/JelbYftagDkAI=;
	b=TBgUo5xIH0RcEGr3LoS4cfOyE5O7PsYWwEd+Yc9phTdUd6TRM+Kh97F2csTOOF/W5htME3
	VDcWvB1DIrbEDGhqEv3jT2HXNLdYKhXBAZs1WatoW6CMxahzL6oipj6cIy2accYemYRwSP
	R5Lx27drlAX7uD32T8R4GNWuT/xvrho=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: Sai Krishna <saikrishnag@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Replace deprecated strcpy in cpt_ucode_load_fw
Date: Sat,  1 Nov 2025 15:04:42 +0100
Message-ID: <20251101140445.2226-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() is deprecated; use the safer strscpy() instead.

The destination buffer is only zero-initialized for the first iteration
and since strscpy() guarantees its NUL termination anyway, remove
zero-initializing 'eng_type'.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index ebdf4efa09d4..b5cc5401f704 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -3,6 +3,7 @@
 
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/string.h>
 #include <linux/string_choices.h>
 #include "otx2_cptpf_ucode.h"
 #include "otx2_cpt_common.h"
@@ -458,13 +459,13 @@ static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info,
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
2.51.1

