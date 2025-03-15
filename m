Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BFF1F9F60
	for <linux-crypto@vger.kernel.org>; Sat, 15 Mar 2025 12:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742042263; cv=none; b=NQIkbDlp4SWCGdPVmtzbob0Ba6a5TA2HpzNkEDLvkT8NrR+slUlXcRw53Fpz6Co57Ynuwqwn/RGt8zw1ufQHyH3csV0MkVddkNI/AdgCpWx4DSfn1P8mKiIiR8OXQuemcuPqcuQmMjHDJOTOnzeDwfW+0wHmfWcn85kMzBFNShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742042263; c=relaxed/simple;
	bh=wRZfS2NRSlj+i11vb4axQygGLFT1xNXEH398u7U/U2w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IYMuKIVxOHEit8W68qZGcCLm7jm3mMHjjhctTGohjNFiaOtxzi4fUr+m+uoJQyP0wkPkNOHxUZwUWlrbpH5q1ay+SZapzGfyNG1OWN8UsmiTuFVu+FkCSO0vyHWffdwNMr8llWJB8kRoCMQKD+wXYCs7pFFIVD2PDABsqP/QRHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NsQ+UIZl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NsQ+UIZl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xE4pZni37CZcaZttUIqTwqnncKlqJUC+lVwdyNng2E0=; b=NsQ+UIZlxmb9C/Swz9t6L6jRuB
	h0ePCsEA76vRFYPAy1FF2HXdlW+R860loyicY3WR2xja2Z9pNL324yTc1fFM0nULNbS5zfuYi08bt
	ihN90Vox1pi6oVKw7er9bZx/BMd8ovOzKQ2XEvSsO7hR5sInTgBWck/SRHPB1kEPvUTVdeVUtP9YB
	nZtbjtOarQRSB3YWo+/AUgniOXI1Cy79yOocZOOmaHK15ZcIoZ4U5dV5U7NU6kPm2fO6MQv2qQIu8
	wrSzo7GVVoi6Vp0+Oc3xmlnTt50orHNeUQCGq6Il55XZKq8OJ/4RjcJPHhZPl4Hf3jWzeCA69M5+D
	JrUinQaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttQlk-006qS7-0h;
	Sat, 15 Mar 2025 20:37:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 20:37:36 +0800
Date: Sat, 15 Mar 2025 20:37:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: scompress - Fix scratch allocation failure handling
Message-ID: <Z9V0kBchZ8N8JG9n@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If the scratch allocation fails, all subsequent allocations will
silently succeed without actually allocating anything.  Fix this
by only incrementing users when the allocation succeeds.

Fixes: 6a8487a1f29f ("crypto: scompress - defer allocation of scratch buffer to first use")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index dc239ea8a46c..57bb7353d767 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -159,8 +159,12 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 		if (ret)
 			goto unlock;
 	}
-	if (!scomp_scratch_users++)
+	if (!scomp_scratch_users) {
 		ret = crypto_scomp_alloc_scratches();
+		if (ret)
+			goto unlock;
+		scomp_scratch_users++;
+	}
 unlock:
 	mutex_unlock(&scomp_lock);
 
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
