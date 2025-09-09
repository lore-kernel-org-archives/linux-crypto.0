Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8419A302CC0
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 05:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757396505; cv=none; b=eaAzU2VTnXjtPLJyYXSGvvuf5/5NbotPlVOWzCCK7BLdB7KGv06KtvI4V/t+pQC2oWp2+okctljFD7rdvhDjV1gysm87sqiUYZ6kSL8ovrYXlWPoYuR4RwUV5dp7z963+vFbO2XVFN172MdPMj4QIQIODPl11PmgWdMV9crIk/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757396505; c=relaxed/simple;
	bh=Aj4O1Tao+kHw4JPDIbAZzTselS6LUgve5hYNNtupXJ8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=hA9DhZmELAco9ddd3RFxt7/8oWJCOFquYD/fDgaXNnD8VZtWmqxiblCn1uxj9Bx/vr/CQNgpvguC7hf+tRmqRbrIkeUDSey2kxprTCFwuQVfNHLAPOO/uDE6yQYSq9MD3iAnJN6Q2kUQ9nP6g35SvIThUYDxhJG05oj1f09n1IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B4KlkBS1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B4KlkBS1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zDJ9retK5NLagDdDPvqJydfHh2cXm/XRBfTcrLgRz0E=; b=B4KlkBS1JlFpbrqz6IiE6c5Qch
	aMQesqzWuHmP/C5qNRpQbASfBZJvpIZc92GMaQ0b0K0B/SBPC5lKjSGzwbbDmhzsybpFMYp/QuYh6
	cTAUtiuwutgwBCjj9KUrRnLtuHTLcPMmrhptkX66AeENjwYFLom5SaXMqxO9ISXerbjXcxejMhG9Z
	FV9ciCJZlcLAxtBC94v7LQ+u0EEHEjKNWsmFJ3gWjGvfy90zYYuBFM6DXTicc1gRoKXz+sX/WbmK3
	DRqjuQiiteoJmtD2jL3slQ0tyC//327vpl9UJyqRP0PTM6gak6EDLD2DeH72oFQCDOOZMrTuSoouv
	eAmFgKrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvqrL-003qIx-2C;
	Tue, 09 Sep 2025 13:41:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 13:41:36 +0800
Date: Tue, 09 Sep 2025 13:41:36 +0800
Message-Id: <6ed112d75481f607c80f3e7131ea43cd64828b52.1757396389.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1757396389.git.herbert@gondor.apana.org.au>
References: <cover.1757396389.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/2] crypto: s390/phmac - Allow stack requests
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As phmac does not perform DMA, it can support stack requests.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/phmac_s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 7ecfdc4fba2d..ead4c0d3523e 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -932,6 +932,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 				.cra_blocksize = SHA##x##_BLOCK_SIZE,	\
 				.cra_priority = 400,			\
 				.cra_flags = CRYPTO_ALG_ASYNC |		\
+					     CRYPTO_AHASH_ALG_STACK_REQ |\
 					     CRYPTO_ALG_NO_FALLBACK,	\
 				.cra_ctxsize = sizeof(struct phmac_tfm_ctx), \
 				.cra_module = THIS_MODULE,		\
-- 
2.39.5

