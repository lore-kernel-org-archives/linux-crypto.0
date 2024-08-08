Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D60615ADA4;
	Thu,  8 Aug 2024 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723154729; cv=none; b=mMawbaiCoN7wzzKLmiA7Q41o4kUsPKQeuCu6qvSZD/yKMOISCcNBuD1zFEQXkWKop+yEK3qG6fLh+GE/LyBa0dER/y3h6CDQX36+lwtNvVyV9OR4EqAjDbKwx5qKUfERGtBYEHNFPbiaoPVWSeNgHS9PHRuWROCPUbLdbjCzrOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723154729; c=relaxed/simple;
	bh=XltQHJ1O4DYcU49OJPdFCg+IJTmIZaV8GlT/lyMKprQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HafqbqRlMU8Oum7UDxflYN+4uf/LGQ35HLi+0iieXThJ5WX7a9qhISwRSUJFapL1rHPvH+qrSHZ/sKusrhfnWDfSw8pDh2rgdqcPNWaKbr75fXKELBKuty4vAftaHMf4LrUp9WLaCMmYEYQfV2Fp00IaG1sUeZx4Rfd9PP4AUVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frCzq9Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frCzq9Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201BC32782;
	Thu,  8 Aug 2024 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723154728;
	bh=XltQHJ1O4DYcU49OJPdFCg+IJTmIZaV8GlT/lyMKprQ=;
	h=Date:From:To:Cc:Subject:From;
	b=frCzq9WruCNbsC020l9lleSjLy1gS3TjCq3RSgJqC+hWLEyaoJoD5SpuFGHZsbPYm
	 2VQxz0xMFOseVsRhKKYWSeFYpWpt0pPbCaA24N7Op03YfTbDK99H/hBr7qHUbg7PKj
	 WDRVYaqvaJBwRdgu3T8VjONFNK69n3SXV9lsbV9z8jWf845mESRJXAbRG2ZnrwLBKI
	 erG99aHK4Zz2+4Kx8A1KznDRGUjg5gdAKqKVSV5l5BdbB7OMKF4xMYc1KAQUQ7cofo
	 5lGVmg+G1d/v++LPjmgCGAuK7MC2vgIigqKIE4qUHaqgxOuiOgibIpkd6R8+LkbpM/
	 k5l/dpAGNp2lg==
Date: Thu, 8 Aug 2024 16:05:26 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] crypto: qat - Use static_assert() to check struct sizes
Message-ID: <ZrVBJqdL1q3X3Dg/@cute>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit 140e4c85d540 ("crypto: qat - Avoid -Wflex-array-member-not-at-end
warnings") introduced tagged `struct qat_alg_buf_list_hdr`. We want to
ensure that when new members need to be added to the flexible structure,
they are always included within this tagged struct.

So, we use `static_assert()` to ensure that the memory layout for
both the flexible structure and the tagged struct is the same after
any changes.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_bl.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_bl.h b/drivers/crypto/intel/qat/qat_common/qat_bl.h
index 85bc32a9ec0e..3f5b79015400 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/intel/qat/qat_common/qat_bl.h
@@ -23,6 +23,8 @@ struct qat_alg_buf_list {
 	);
 	struct qat_alg_buf buffers[];
 } __packed;
+static_assert(offsetof(struct qat_alg_buf_list, buffers) == sizeof(struct qat_alg_buf_list_hdr),
+	      "struct member likely outside of __struct_group()");
 
 struct qat_alg_fixed_buf_list {
 	struct qat_alg_buf_list_hdr sgl_hdr;
-- 
2.34.1

