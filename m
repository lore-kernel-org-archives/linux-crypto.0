Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4109217642;
	Fri, 16 May 2025 11:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747396152; cv=none; b=ScoRD+6yjGXqkEnUcDsSb0ISesN97+O+2XgXIHKX0MLkmQKajTZLZwR3PaA/u9c2bqaM+wupGMSYdwYfLnXv4q/GeWf511Ejs3C5jJ2uB5tyLjOD3EgeSksdPaMmjgcwm61nGZnA05etahhohPXhBrClnEMV0Xmd+8b/ExWYXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747396152; c=relaxed/simple;
	bh=DRCUEKziaUleipRlRH9DHWvLypuZB1j2p6igjfcfTDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L06V3ecnJ9frmpWbVIytMWg1lQV3SQGDayri6KOrg30kMWkVFJKnET0+47irKw688yDlTFhWnGWcONtMpexwi1KCT79tmJ03s7GxUFxaMMIiJq03/eEdjKGShBraxkZB7hgktfPmhH1u8ERhfaSLs9MgWcxqwguudoeupSxeszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nBWTjQIA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nBWTjQIA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DMYQPSw8xpfgz6kQUw4EwQaVl2tLBGwQu1uoyauPgWg=; b=nBWTjQIA9xEL+mt92SH36gD3yZ
	ylvRM7lchdLGgBa5Eh9lVAOUin8xnBrQT3yaiq04pCn4ONsFchYtND2pbBy2aOGH5IguDzjgo4w0T
	Tia6w9OE5BpkATy5gTLHyHuf1e1TQ8iflIlo9zuLBMUSguQ13SfIgAkysq3PJ3Den3M6eIP046RID
	mAk1rE8U3C5fZv5yp0ZHyPHioaI9D2n2zh1egr5QO2qwAH0DCnix1i9n4st6D8NExnKMTWEdtADAX
	z6T01YV/7eFn8CyU2DKQSX8JaMIXphmSuYWYOBFUKw8/eYyDvd6RhrIVcbNkrFbOYKs/X9tqX+ZbM
	+zopuV0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFtYa-006Zte-0n;
	Fri, 16 May 2025 19:48:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 19:48:52 +0800
Date: Fri, 16 May 2025 19:48:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Jain@formenos.rohan.me.apana.org.au, Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: lib/sha256 - Disable SIMD
Message-ID: <aCcmJGuCnuyHmHbx@gondor.apana.org.au>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCcirrsFFrrRqf5A@gondor.apana.org.au>

On Fri, May 16, 2025 at 07:34:06PM +0800, Herbert Xu wrote:
> 
> So what's happened is that previously if you call sha256_update
> from lib/crypto it would only use the generic C code to perform
> the operation.
> 
> This has now been changed to automatically use SIMD instructions
> which obviously blew up in your case.

In the interim you can go back to the old ways and disable SIMD
for lib/crypto sha256 with this patch:

---8<---
Disable SIMD usage in lib/crypto sha256 as it is causing crashes.

Reported-by: Borislav Petkov <bp@alien8.de>
Fixes: 950e5c84118c ("crypto: sha256 - support arch-optimized lib and expose through shash")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index b9bccd3ff57f..e1b0308c0539 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -32,7 +32,7 @@ static inline void sha256_choose_blocks(
 	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) || force_generic)
 		sha256_blocks_generic(state, data, nblocks);
 	else if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD) &&
-		 (force_simd || crypto_simd_usable()))
+		 force_simd)
 		sha256_blocks_simd(state, data, nblocks);
 	else
 		sha256_blocks_arch(state, data, nblocks);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
