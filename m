Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3001F936;
	Wed,  8 Oct 2025 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759917708; cv=none; b=mMYB3273/IN7otrBmZYwYvKCO3ssF1PdV8525bEb3krC9Hgh/vUnDX17Q4XW1FP5ozP+e6VBGPFnFoUkO9Mdm23/KcVxVKibDsiHUSc/BapeTB8OmO4hVyHDGxsTyCMa6y9UTUMm5CXc/IUDiwc97f7jVuE1VKD158POnEMXero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759917708; c=relaxed/simple;
	bh=M1blxd/mKUNiZQ6/0sH3xYrIOPjliqElO4KW6JDypVc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KXRCtKT9FC1VKG/nzas811UcFzwkX9EYJJbWhEmM4dvr2M7q09s3QtrnaFdO1A78oAC34MFMhiKnTYj10t768W6clUJyR6/CGwQM5mAjGkvJ5OjmHkmHjkrjb2pvxOF8cXVg4Rfai4ILYiaX5cIFmJt4DPm/+O0gihf1B4zgw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Rz21MMKZ; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Rz21MMKZ"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 598A1etr4017440;
	Wed, 8 Oct 2025 05:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1759917700;
	bh=cTxDlhTEVr5LCo55gg3H0iUO4ew9aXKpaM9Ax2tgf6I=;
	h=From:To:CC:Subject:Date;
	b=Rz21MMKZIHnmJdY07aJNoKk7PDNuRAiJoylOLhPnZvluG+dPk62HD4dZfQehSfRFT
	 hozcovL0Ku1Xdfb3FYD63JaZEP4fvdIC0gAklNFVTHvJkPDvDgKvtDmGp1c/63abpr
	 mrUqv2ENaiuXK7VMj/2ihbnXcuca5zpjD4dlIFiQ=
Received: from DLEE202.ent.ti.com (dlee202.ent.ti.com [157.170.170.77])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 598A1e6L070818
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 8 Oct 2025 05:01:40 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Oct
 2025 05:01:40 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 8 Oct 2025 05:01:40 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 598A1cRU2600584;
	Wed, 8 Oct 2025 05:01:39 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: aead - Fix reqsize handling
Date: Wed, 8 Oct 2025 15:03:14 +0530
Message-ID: <20251008100117.808195-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
introduced cra_reqsize field in crypto_alg struct to replace type
specific reqsize fields. It looks like this was introduced specifically
for ahash and acomp from the commit description as subsequent commits
add necessary changes in these alg frameworks.

However, this is being recommended for use in all crypto algs
instead of setting reqsize using crypto_*_set_reqsize(). Using
cra_reqsize in aead algorithms, hence, causes memory corruptions and
crashes as the underlying functions in the algorithm framework have not
been updated to set the reqsize properly from cra_reqsize. [1]

Add proper set_reqsize calls in the aead init function to properly
initialize reqsize for these algorithms in the framework.

[1]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b

Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 crypto/aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 5d14b775036ee..51ab3af691af2 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -120,6 +120,7 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
 	crypto_aead_set_flags(aead, CRYPTO_TFM_NEED_KEY);
+	crypto_aead_set_reqsize(aead, crypto_tfm_alg_reqsize(tfm));
 
 	aead->authsize = alg->maxauthsize;
 
-- 
2.43.0

