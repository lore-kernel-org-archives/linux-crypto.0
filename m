Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB4E42A83;
	Wed, 18 Sep 2024 04:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726632116; cv=none; b=nd2vBDkzdBY2g9r+TzC2kRDNz3umtslwADI0dr6gqjJco5Gm2yZPdMbaeN8Qr/kpTwp64YFFZ5iz/27bGODHd9SSktpxc6kgxqJKaw9euhx5+HbFze0V+SQX5q12UPa9tH0vSjKY2O24YYhs/AcBkyfTjM8qXGaU7hgomPtjA54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726632116; c=relaxed/simple;
	bh=EetZ7NRg8RC6PSg53sNautp6mm6tE2qdVNK7Yz2Q/Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASDh+0SqBLb1CqCQ2+YesUT6KMcq4g2VYbUGsR2Nnkk6sN93IRdKLWJ++79R4B6ldeSJ65N2LUxZdQ3uxnUgsmBW0DbDBDHdSwBLW2nMZHuBBln1skz0ydfzzUgsOjfIPuBejEZ6u2X01JgWCCBJb/oKFgNMCK7HKeMHxnwWdEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I8u86o0j; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I8u86o0j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=16vu6pBQ5wJXN6LWwpO4FIozbq/Ex/lc30KnlLaqc3o=; b=I8u86o0j0PTfJleuAWEzF1A1p6
	VP+HboMfP+C7L8DV6vfQdpe+xbHCuvkHAZxAsrUj21N9YemWgVUot5q5CvB5nqlXKMAlrIqm2HQ4K
	gie9MKKfth2/AT8Hu4Em5cdvWzKRBD/c8PlNEDpHVuNiD0+bAA6WSdV1QgiCo50rOMChzIXJj5DlC
	0GLg4fq/vAsv64JI+uzCCvhNAxMEil+zuPboBJBCCrFKg+04FBO41UGKx/vMPcAVsakmseGcrmkyt
	7hBeyR3+Rys8aWtkXbkOxg+h5yMG5dJc81tewK4HWWFJYQ3NzV33hI5yp7GyTajsNQfFTvGXIHOdC
	Z46GtMbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sqlj3-0038OJ-1X;
	Wed, 18 Sep 2024 12:01:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Sep 2024 12:01:47 +0800
Date: Wed, 18 Sep 2024 12:01:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: [PATCH] crypto: s390/paes - Fix module aliases
Message-ID: <ZupQq2os75c_BFRz@gondor.apana.org.au>
References: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>
 <ZulMEyvIWNtbZJHD@gondor.apana.org.au>
 <4b694c31-5d5c-40b8-8f2e-da858c3001d9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b694c31-5d5c-40b8-8f2e-da858c3001d9@linux.ibm.com>

On Tue, Sep 17, 2024 at 11:54:30AM +0200, Ingo Franzki wrote:
>
> I used 'make defconfig' on s390x, so nothing special: 

Thanks, it turns out to be an existing bug but it just happens
to have worked.

---8<---
The paes_s390 module didn't declare the correct aliases for the
algorithms that it registered.  Instead it declared an alias for
the non-existent paes algorithm.

The Crypto API will eventually try to load the paes algorithm, to
construct the cbc(paes) instance.  But because the module does not
actually contain a "paes" algorithm, this will fail.

Previously this failure was hidden and the the cbc(paes) lookup will
be retried.  This was fixed recently, thus exposing the buggy alias
in paes_s390.

Replace the bogus paes alias with aliases for the actual algorithms.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: e7a4142b35ce ("crypto: api - Fix generic algorithm self-test races")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 99ea3f12c5d2..b8d9f385555d 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -802,7 +802,10 @@ static int __init paes_s390_init(void)
 module_init(paes_s390_init);
 module_exit(paes_s390_fini);
 
-MODULE_ALIAS_CRYPTO("paes");
+MODULE_ALIAS_CRYPTO("ecb(paes)");
+MODULE_ALIAS_CRYPTO("cbc(paes)");
+MODULE_ALIAS_CRYPTO("ctr(paes)");
+MODULE_ALIAS_CRYPTO("xts(paes)");
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm with protected keys");
 MODULE_LICENSE("GPL");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
