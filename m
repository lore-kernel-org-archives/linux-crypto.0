Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027231DDBB;
	Fri, 16 Oct 2026 02:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117048; cv=none; b=BMt0nPr4q17r1rFWjzmu+QXA6MvA6J57Ax5mq11I5V9AO6APSk1oOeCRtEfy9x00ooz1SF7B7MgGl2Mwk1JRFilomJrn99/CPj/Lclb7DVnvPuDbawL1lv8ey75Y78q90SKF5T4y+P9NK2MSkL7E/UfIxr9iO4PRwrM+yDpEd1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117048; c=relaxed/simple;
	bh=PP2/HBaTIQEKH4BT4mVfyUdVg4wlhBM1JsmR0e8Qrg0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NuiNnOObBoDdCNx1D9KpTyNo3bFgM6HFShHtKTwLqYLUb5tkGQ6qH0qJhyRZNFxT7Y8ofHHPY/YX+4LHngb2chnYoP3obqgGvbT2VuZm21b5L0nkQ/SRrwtM1LmUU6CE1r0iasmaDysjSPzzKOjFQoHyJSH4v9fBK8xFxXGlA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=lVBzH/Rv; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="lVBzH/Rv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792116605;
	bh=RcfESTXtlh7JhFl3V3+0pi2boxbvO7WTuGpgouT5dmY=;
	h=From:Subject:Date:Message-Id:MIME-Version:To;
	b=lVBzH/Rv01nBeEjZaeokwEjavHw8uhLl/RYS6VVdTAAypI4KA6f2PFGb92UD1u0LJ
	 3BgsSt9aZ5j3RimXMmArMv1GBUq430avCZgcZbg/OT841+rKCWCxA2eD1v89wtSI2c
	 ypEKqg9whtz1PieisYKFkfaSZQjSTBGEd4DeSPrk=
X-QQ-mid: esmtpsz11t1792116600taa6274de
X-QQ-Originating-IP: FOu4lvJ/1tq8CFGDIkECrleLSIK4D1p9EBUnqafmfH0=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 16 Oct 2026 10:09:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1707299652216232524
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH 0/3] crypto: qce - fix CCM AAD buffer leak and the AEAD
 error paths
Date: Fri, 16 Oct 2026 10:09:42 +0800
Message-Id: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGeH0WoC/yXMSwrCQBCE4auEXtuQHl/gVcRFp1Oj7SOamRgCI
 Xd31OUHVf9MGcmR6VDNlDB69mdXIKuK7KLdGextMYU67KSWLUefuDew2YO11UH5Dr2xIK43Ufa
 hUaFyfiWU5S98PP2d380VNnxrtCwfpf0mdXoAAAA=
X-Change-ID: 20261015-fix-qce-ccm-adata-leak-1ef34f172ba1
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OJ1IEQL1epI3V7ChnsxIRX+frX7lWubEPhMV2XLgHiv3WHib1xq+idEv
	6ghaUiSTbIIVY/92TDj9iQsU+ZPO2xcP4GIGrCGfbnaT4Pv5r2+LV5gUtf/aAZH/zkavUuR
	NaLiUUIAtm0dmHZWkxAwZgFUQ0uOAlcJpDR7+zL4LFWlrXoyHu/klKkjZe3p0fExthUPJHu
	OGrsvcXo6Be3hzqgFVcHCxp/1peLITyNk5Ad97NES6Y5oDHOjicJWIWP+dfW7/E0GShKMa1
	LOL+XpSFQ6wlavDdWI1fhUFo/eBjb3LQ0cKR2ke62cUV2+1Yow3ROsZ1w4WL3i2y5c57H0B
	vXgztYmYbGbLduEAedeVCNfVKE8J0UuKm9UOTjyjFx8Ll6ErINALWnlOWN+LTF6lp+AOiFP
	wDYXCcRIaP4+VVpIBnYSLg2lhIMN04ZW9BGkHrFQ8awmRoCXESM+pzO4F9O7cWSncL8LQ8D
	jUC/yQ6cbP7OFruF4ZaD+sqoj4oi4hAl8f2x0JDJDpcM/zYyqXT3aEOy+9Ou/skZxwAu0Y2
	1kvyaZ8926+ur6dv/WQNssar3Oq4WGdcf+REwECgOuNVwLZgk0nzrGBtg9jS4pWqUszs4mg
	GbZ+UWC8Lj9egohk8A1OoaO1Cpsib2VPDeB14/Trk6NUzzvS3POEoieLrmWmH2Kev+UiduU
	9U9DRhQmqFAzV692VgcO8qf7mk7oKUvp/yI5YHfptthU+Ia6w2SkWMoGC1oM1/ZKhYFNbaR
	HyJiRsWZemHRb7lrysCLR5Hr/PAoGfn25IBydpwntoMpMyAisMJJ4S2w34ZClpdwGi+53GJ
	5QSwQ4Sxlqsnd8p5lI8b0AYVwtgjwO1beesLq88UAl7hfuGq+PXtUroU2y/2XHcPL2Ozsfe
	EifshbLbESkBwWy3dr6CJ/imeKaSux0CXj1A58JwVB9+COMaluZExawO59zuIqPP4VVBoMk
	utnxTQDqCV5eqAd4uyV0Xr2t3MTHqgnrDyHHpVorYTJCOa2sxaZ/k1Ex6yS8j2NHAzXTZGj
	pV8HbNpVuJZJufLeh+6tfk/Lg/fF2J2JC+oF3IHawM2AsB5XAfPvzfmngqhlkN+s2Wkft9S
	A==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

This series fixes a memory leak in the QCE AEAD driver together with two
bugs in the error handling around it.

qce_aead_ccm_prepare_buf_assoclen() allocates rctx->adata for every CCM
request that carries associated data, but the buffer is never freed.

While preparing that fix, two problems in the error path of
qce_aead_async_req_handle() turned out to matter:

  - It unmaps req->src although rctx->src_sg is the scatterlist that was
    passed to dma_map_sg().  For CCM requests with associated data,
    rctx->src_sg carries the AAD buffer, so its mapping is leaked, and
    freeing rctx->adata there would free memory that is still DMA-mapped.

  - A dma_map_sg() failure for the source scatterlist is not detected,
    because the result is checked for a negative value while
    dma_map_sg() returns 0 on failure.  The error path then unmaps a
    scatterlist that was never mapped.

Patch 1 unmaps the correct scatterlist, patch 2 adds the missing frees
and patch 3 fixes the dma_map_sg() check.

All three were reported as pre-existing in the Sashiko review of the QCE
BAM locking series.  They touch the same function that was recently fixed
by commit 7f2345f47dd1 ("crypto: qce - fix CCM AAD buffer
underallocation").

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
ZhaoJinming (3):
      crypto: qce - unmap the correct scatterlist in the CCM error path
      crypto: qce - fix memory leak of the CCM AAD buffer
      crypto: qce - check dma_map_sg() result for the source scatterlist

 drivers/crypto/qce/aead.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)
---
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
change-id: 20261015-fix-qce-ccm-adata-leak-1ef34f172ba1

Best regards,
--  
ZhaoJinming <zhaojinming@uniontech.com>

