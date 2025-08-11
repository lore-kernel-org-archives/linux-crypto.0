Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611DD2DCF6B
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754904332; cv=none; b=EddAiKBMOKdbh9RgRYhKhMjFtqvIild9GDQ8cdVHWsReUfVDWYaSK1te9pxAsoV4+E6S3TUYtzwkG9VdLNr7c3FwmO9Q9v82V1j2H+/boxnzePeRgAtWxaiNTk1joF7G+43jEZFRu6ZyBEL6xGu1ffJ8JEmoC9hZTPQAY3T/Das=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754904332; c=relaxed/simple;
	bh=/Y+j5nnBZmfosDIt5AA2wiHFd+B/n8jBcY8XVbUbILc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jg8NIuraL3TjU9GNNsA8EC4WXJBfv+25dVcVGKdkctnj9pS4OCdkSOYwfQWaWp4br+ErMhcXKMfrtLUs3YEGDoR8lyOPVXCF9N5fey7mfreG+52Szp7p2ECtpF1YAq1H/CHWK6Q7BALgWCu6NarI8V/sEYRXXDEy00ZRcDXjo+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W2x4wT1p; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W2x4wT1p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754904327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nvZPeHoZUGv8yiunX9lwcunwG1NgaTC2loxZhPTUEvY=;
	b=W2x4wT1pGl+/zjamyP4eVKDX08Acuv/skkrSNde8nC2qSwGaKpnfQLeQSNUo3UnyUR9ONe
	unQKSK+kNlKpywrG3vts4cHDOSo9NBMaTB0m1HW+pEytyWZCwO45CmoIu81QJe6E+1Ci88
	fD05Jh4G5EvE6ARCpMhHSjyQcMnPpc0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Shijith Thotton <sthotton@marvell.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Call strscpy() with correct size argument
Date: Mon, 11 Aug 2025 11:24:57 +0200
Message-ID: <20250811092459.4833-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In otx2_cpt_dl_custom_egrp_create(), strscpy() is called with the length
of the source string rather than the size of the destination buffer.

This is fine as long as the destination buffer is larger than the source
string, but we should still use the destination buffer size instead to
call strscpy() as intended. And since 'tmp_buf' is a fixed-size buffer,
we can safely omit the size argument and let strscpy() infer it using
sizeof().

Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index cc47e361089a..ebdf4efa09d4 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1615,7 +1615,7 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		return -EINVAL;
 	}
 	err_msg = "Invalid engine group format";
-	strscpy(tmp_buf, ctx->val.vstr, strlen(ctx->val.vstr) + 1);
+	strscpy(tmp_buf, ctx->val.vstr);
 	start = tmp_buf;
 
 	has_se = has_ie = has_ae = false;
-- 
2.50.1

