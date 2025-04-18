Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B1F267B02
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744944770; cv=none; b=oPynTURravL3KfG+wxIiBqVn945u+ccg1vAtWPSeP1+KLx0A0XvQH0BBUfh6RozvC3gcBUQtv21f+JBHlpcfQ1fAvecRpYDTR/Ft0KZsTFi+zl84fIzhbIMpezpCqLELkofIw1szkvKqScK+ugdpYkvMR/wvic7kfEyRzPXNSqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744944770; c=relaxed/simple;
	bh=6G26RflteXalx7xXlLLC55zcu7ziLBa+FPO8vZwLyS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPgpfmlhTiABLlS13D32BWtCZgGn1vWDJCI2ugfLFeVNOq3WE5g2EdltUhnNXUMqMfIHi9MxI5q13spPMeL39TT3UGJ5NDNMBSns5PliYbV0Ns0hok6z1ZbZlT+D3rJMX4g+ysWFT0n0p93X9HcLPSM7z5ok44lA3s0WxNYQ870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i4bHQWdE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i4bHQWdE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1SNH5jgjESfJPsYcOrnx8xkgg3W2onLsVhFpUuSZTE0=; b=i4bHQWdEzVGURolUJ8zVUruLeo
	nXGP9v5wI9PjQn9kBKWT0fyhq94uFqxKxNHULhForisYymcqXDkqrBZsnmu1FyatOuh55CKeOesB2
	wXw0EQ2+XxSXbLMZC2VZWaV3M4+6YPuvv5jCtNndk393S7daW9CPrjZScXlnAbX8BVpW/0wpCG5dR
	WIam/1LAk9WN6AFly7VXGirXPd3zLjHnZbN0BKSN38QKXPCUsoV3hKfXp7+kv+09cIhfGf/vo5+HK
	HjbfqWhHdtjXbNi15dLVgGu+te4OI6QPoJI7+5re50/XOqqfv34j9PXLzLxFNqItK6/3OkZmUZTNM
	vLgNCarg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bqE-00Gdts-1j;
	Fri, 18 Apr 2025 10:52:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:52:34 +0800
Date: Fri, 18 Apr 2025 10:52:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: acomp - Add missing return statements in
 compress/decompress
Message-ID: <aAG-chUuldQisBIA@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
 <20250417183927.GD800@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417183927.GD800@quark.localdomain>

On Thu, Apr 17, 2025 at 11:39:27AM -0700, Eric Biggers wrote:
>
> And this series does not apply to current cryptodev/master.
> 
> So there's no way to apply this series to review it.

Yes it's conflicting with the powerpc uaccess patch.  I'll repost.

> I think the high-level idea is still suspect, as I said before.  Especially for
> sha256 and sha512 which I will be fixing to have proper library APIs.  I don't
> think it's particularly helpful to be futzing around with how those are
> integrated into shash when I'll be fixing it properly soon.

As I said it's not that big a deal for shash, but the reason I'm
doing it for shash as well as ahash is to maintain a consistent
export format so that ahash can fallback to shash at any time.

I did try to keep the sha256 library interface working so as not to
impede your work on that.

> But whatever, as usual for your submissions this will get pushed out anyway,
> likely without running the tests (FYI the compression tests are already failing
> on cryptodev/master due to your recent changes).

The shash algorithm has gone through all the usual tests.

Thanks for reporting the deflate breakage.  I wasn't expecting that as
the change in question didn't actually touch deflate.

Cheers,

---8<---
The return statements were missing which causes REQ_CHAIN algorithms
to execute twice for every request.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/acompress.c b/crypto/acompress.c
index b0f9192f6b2e..4c665c6fb5d6 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -292,7 +292,7 @@ int crypto_acomp_compress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
-		crypto_acomp_reqtfm(req)->compress(req);
+		return crypto_acomp_reqtfm(req)->compress(req);
 	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
@@ -304,7 +304,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
-		crypto_acomp_reqtfm(req)->decompress(req);
+		return crypto_acomp_reqtfm(req)->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
