Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258D3CEBBD
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701108; cv=none; b=Kee8til/Rh3vU+xRB4L5FcMAJAW+duwdIlTfBS9g/yLTRNkG4+l3YEltjAesUsv1VF/EhTOdrkr3UV29a+0Olfo8S6c3aC1v8cqlIXpcopzvTsiK3a8AUbyJyKUsdlpy4DvXvpbQ4Iou4CKA36uvmxLMslZ02hmg+tcYsrRLTQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701108; c=relaxed/simple;
	bh=fqyF5E6FdTvB3Vh0ZDFzU66K6V4HoeFx4G1xs4QqaGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpO9fAjKcg6Mmmxl/HtRg7jSJ5itT+nyKsizpNelbcF6vXj3H+wP18KsTk73poRtx/9UQw7CEnTDOjvXLZQinob+D0YrCgBeJVKPWCDIS1XRus/tGZcFX2JHyO98i8M+f9Mn4uOPogpWZ//i1RgdrW3Q1Gm/2WAeMY8Y8/xFhDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VKsGKIsL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VKsGKIsL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k5rX1CGgzDmvfRITgR4OThhebipCo2/PsPWpZujmPLc=;
	b=VKsGKIsLoXnxrPoK2d58hmcqk3L+I+TM5bWlbqgEV9vU+j3Ahlv/uv0HfiZrhkrKXys0xa
	MhEOFmSXfbjujgsUduNqhTjj996OLWRpTtdRrqrumDtpOITTSmiCOn3w3oPHKXR9sZbhOC
	LZxofhsTdARpHyQdaJ9G3t0uOn0Rl/g=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 6/6] crypto: octeontx - use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:11:03 +0200
Message-ID: <20260605231056.1622060-14-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2322; i=thorsten.blum@linux.dev; h=from:subject; bh=fqyF5E6FdTvB3Vh0ZDFzU66K6V4HoeFx4G1xs4QqaGk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Y1/38v37dzWul6tUGFWa3Nwr7Bg98uw+YX+BULNk d4aLi0dpSwMYlwMsmKKLA9m/ZjhW1pTuckkYifMHFYmkCEMXJwCMBF9XYa/8hF1p0/lWNTVRT+K 9u6ZY11dfOH0ustu8zwmCJl/u3FzKcP/qsM+M6aXm3trPD9huSeH4/Q+FY+NWe18qxN5BTg2fJn JBgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c   | 4 ++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 205579a6ba2b..58dd996c7f3a 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -99,7 +99,7 @@ static int dev_supports_eng_type(struct otx_cpt_eng_grps *eng_grps,
 static void set_ucode_filename(struct otx_cpt_ucode *ucode,
 			       const char *filename)
 {
-	strscpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
+	strscpy(ucode->filename, filename);
 }
 
 static char *get_eng_type_str(int eng_type)
@@ -140,7 +140,7 @@ static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
 	u32 i, val = 0;
 	u8 nn;
 
-	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
+	strscpy(tmp_ver_str, ucode_hdr->ver_str);
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 9b0887d7e62c..465f00e74623 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -74,7 +74,7 @@ static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
 static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
 			       const char *filename)
 {
-	strscpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
+	strscpy(ucode->filename, filename);
 }
 
 static char *get_eng_type_str(int eng_type)
@@ -130,7 +130,7 @@ static int get_ucode_type(struct device *dev,
 	int i, val = 0;
 	u8 nn;
 
-	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
+	strscpy(tmp_ver_str, ucode_hdr->ver_str);
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
