Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC42E88BB
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764150433; cv=none; b=d1pYZOhmKzZ6FCSdLUBTSW55TnYhZ9PbSN0vNzo+UsN2GX5y9Dx0Y6T3xaJA85JrrHkrM/dfvyarjzVGaD/xKpFL8bC0G71WGxsQivzbt0M6rYbDNuvlVTfSGPta76B9p7o62yP80aDMt2Vmc0sZN35AQ7b/hwhb2KIsPrnN28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764150433; c=relaxed/simple;
	bh=D8jihN4OFo3/AxsG+ckzMEMKh/2sCg0idCqrn9iSy9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XKk2GxzrRnUk8YmesHs/bk3MskdEtQRVvnTng8Shsq0Wy/X7LUlrz9+JdZZrOvmGZBbiBM7v9xGFGYfWlObso5pVE74P3dBJ095Tz9m0qD2zj7wcs39Z7pPwGJ/4+qFMKpSOfI7nS/Qy6g8uS7nkCWbB2zxDFxoSEsEdDrNm5TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vuoUUpqh; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vuoUUpqh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764150425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5KipOE7hgG8ZU8e64DnissczJCgqW99X/fGlWhtZnJc=;
	b=vuoUUpqhYCTPvLr4Hn2AVuPyKhwRRzgX/Ku8Im0xfJkIloi2/tIvgSzO53iqKfeJO+NC4l
	WkAx2CWgk6dRxqxbABW1ynV65JUsgLIlbKFay4SrjS/Y/HwKV1nNYtDDaCrSDiA2vmhoPl
	vuauDdUF5eOw1f8/3IXM+srNvWYCjHM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Lukasz Bartosik <lbartosik@marvell.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx: Fix length check to avoid truncation in ucode_load_store
Date: Wed, 26 Nov 2025 10:46:13 +0100
Message-ID: <20251126094616.40932-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

OTX_CPT_UCODE_NAME_LENGTH limits the microcode name to 64 bytes. If a
user writes a string of exactly 64 characters, the original code used
'strlen(buf) > 64' to check the length, but then strscpy() copies only
63 characters before adding a NUL terminator, silently truncating the
copied string.

Fix this off-by-one error by using 'count' directly for the length check
to ensure long names are rejected early and copied without truncation.

Cc: stable@vger.kernel.org
Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 9f5601c0280b..417a48f41350 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -1326,7 +1326,7 @@ static ssize_t ucode_load_store(struct device *dev,
 	int del_grp_idx = -1;
 	int ucode_idx = 0;
 
-	if (strlen(buf) > OTX_CPT_UCODE_NAME_LENGTH)
+	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
 		return -EINVAL;
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

