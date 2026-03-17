Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEA4385517
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 20:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778727; cv=none; b=Abfn+9cM0ynfLCrmANRjLG3ijHSfZan0hQaonG9893usMo/lciF5ZcUDu8AlTDL3enD9MfuMF0R69fDV7WEWPUppKq7LnW4r3/n3UM8z5xLfwisQlBHWwca0ZjkgySEjxRAdf7RgtpjCBNFYP8MKL/MDBq4ZAxQ2E7euza4Mo/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778727; c=relaxed/simple;
	bh=rr9c7b7Bg8HmED96qIytYPhFZybnAlnT+6xjQRz6Vhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h6GvoQNeJ7lfrJwbfW4et2YHhKDcUsXm3Cw1aBdB9J8fs14UwqfpfrEu9KoMm97jF4ujqtfy8+wJGu6/pto/uNKJNaGI4uuilr/ZKAw9FQxcuQ8PcGCKMsQtzolctJbsQO5TYaFFlfYnXT8G3BhD0olDgWAHeu7h97p4sAxD0RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=prJZOGnH; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="prJZOGnH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773778724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YokNPDBKB47On83Stit2XVqNDOPxCXgKpwFpqg0JOMo=;
	b=prJZOGnHkGu1i4Hjq/hZEc7bucV1GxtQn76Yg+4nomNnHfNq2HFTUCGGUeATEz9cQpHogH
	5/pxYddwxRFnayGgi6Cy0GUXTY43Ul/dpmHmBlIWs6W/dIbzWtW3h5Hfp12TVhvYxCwKkv
	5NzUw26qxV6dG4Md6BD5+pFbewD6knc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: nx - annotate struct nx842_crypto_header with __counted_by
Date: Tue, 17 Mar 2026 21:18:06 +0100
Message-ID: <20260317201804.1393389-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=thorsten.blum@linux.dev; h=from:subject; bh=rr9c7b7Bg8HmED96qIytYPhFZybnAlnT+6xjQRz6Vhk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk7t/0xyVm2QfVq6/S8LTv3yptMM800fJ3WNumi3WGvk kccZRmnO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAiluyMDHtY1Y/81P+y4c6O eQeXrBLIqX9UZ26jdq/R3TxPJzXEyoyR4YZH1PLfP+68O3vqtq2MSUGR4NubrMHJ7+3KT+0K5t6 7mQMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __counted_by() compiler attribute to the flexible array member
'group' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/nx/nx-842.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index f5e2c82ba876..a04e85e9f78e 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -164,7 +164,7 @@ struct nx842_crypto_header {
 		__be16 ignore;		/* decompressed end bytes to ignore */
 		u8 groups;		/* total groups in this header */
 	);
-	struct nx842_crypto_header_group group[];
+	struct nx842_crypto_header_group group[] __counted_by(groups);
 } __packed;
 static_assert(offsetof(struct nx842_crypto_header, group) == sizeof(struct nx842_crypto_header_hdr),
 	      "struct member likely outside of struct_group_tagged()");
