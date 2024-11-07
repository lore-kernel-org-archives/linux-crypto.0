Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BE2372
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 09:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973435; cv=none; b=EIf1qpGkJNgBYf6gzUWRWUN7eEhyfBtWIyqV5wSqaKn85P1Yr8wn5QGvdBsy6tWlfbDJPGpELYbGo8OQqKfD8ujkTl4ZtF6TxRquVWUUJmRG0ESKIQnj7mrd2brR2fMW9emFxGfy/ePG035okYQ0RQ1p5cvJ9wZCP0DknirUDlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973435; c=relaxed/simple;
	bh=aLOlhpYZ3Lp8vg/BiQdZcomjgXo5WQgMPj5BtEy43kQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YIL/BxE/akAwclP3IicuZEA5MNLnL6Fjq4QRiYfMuuS5EjA15gY0XQci612PtJ5f3B0/3WkZI8wZ3L4gatV+3o75CROhoc7zCKsQLzYnEwokXb/ITwsxi7yvyqPZ3Hv1pAZhx0iG4VlLbc8KzC24B4VQyDlhcRZ9Y0G4R99Vfyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Kb4aAA9y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Kb4aAA9y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9edHWSB7hJbR2XHP9LeFbfxEREZ7F8crpufsNxq+Pls=; b=Kb4aAA9yJJSdPAfWOEF5wTHvF6
	9IfHC81AIr77lGOTXGdAkJ6Kn4lyqq6lzD3N0cQ6ZxnGnM+6sr7qyoF0iTtmTGcMO1fVgQtKGugTA
	fwXxgAKlCUGNI+f35MPXemnSLReaOtDEkzsLGV2P/SC55uRmVDMPPNnA4bpr76wMWkhEKusr9WFvC
	OvAQjN5x1ZiRZLabzjFnFEIGLxPtB65LiuSJoto94NCUzejU+Ros/YE06f2c2JUqlGTURQqApJj1L
	DUhH+kAaAuQxEzeGCXysed3qjezu10KvqBlVnINOR04+YZmFOPNpTnTI9vjED9WoKIYMGAGm+KUvk
	YZ3I4I8g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t8zGE-00F7V1-11;
	Thu, 07 Nov 2024 17:57:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 07 Nov 2024 17:57:06 +0800
Date: Thu, 7 Nov 2024 17:57:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: aesni - Move back to module_init
Message-ID: <ZyyO8mMYxIkWzmQ3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch reverts commit 0fbafd06bdde938884f7326548d3df812b267c3c
("crypto: aesni - fix failing setkey for rfc4106-gcm-aesni") by
moving the aesni init function back to module_init from late_initcall.

The original patch was needed because tests were synchronous.  This
is no longer the case so there is no need to postpone the registration.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index b0dd83555499..fbf43482e1f5 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1747,7 +1747,7 @@ static void __exit aesni_exit(void)
 	unregister_avx_algs();
 }
 
-late_initcall(aesni_init);
+module_init(aesni_init);
 module_exit(aesni_exit);
 
 MODULE_DESCRIPTION("AES cipher and modes, optimized with AES-NI or VAES instructions");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
