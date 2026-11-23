Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424806;
	b=FIqnpHAaCxqV5OuMgILZf5QVbyAZDtFODsw0IkjSGV9C6hMt0ggSQH6BVnog49bGgix0
	 ssnYFTe2+9lJ736Fuy4wBLz4uIm3o7PZeltGtmbPba+Folclf7+Z93idt19UgD7KCaNoU
	 ZRVWRX+BBvpL2yvvIhJDNcGsnTKY7w7Rw8qms2rqRICKzFqfkFrbFjgDCYQqD9N6kHUAc
	 LtwMua7xzRH2/pHxVmJnoh66CI589iJ9/HPwBMJwd2I1bG45ydL5IVUu57AsNq5I2HBLf
	 v9W4ewHOpEzz0KgHmNXFndlgbwkiyncFQwQXIIlJUqS+PT7cSWTMOvREfVfPjsLKSHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424806;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=aszNWFm3AavU3Fw6Y6RtvpwqKpNfGOGtFmRMkuOvBq0=;
	b=1tjnwAQoQlFrvLWblvuhPLEmOpLzWi322cmenVcHbddu9CRCI6APwV4JaXmUd2dz70Eg
	 dtSzpHXz+j/usu7icXqSqRZwMpGSU3SXRYIuN6+yFbbx/3RlOiKQFrHzavO1srJHpFvZB
	 GuBTpMNCMD+qDvbVbBsY+UAI+ScQzapM/tV7MvQLkzrvAn5T/OVfWvMKdtk+Rfug0FrWL
	 q4WtuXHndZuM9Js1JNomCR4D/SlLpD9nvVh5nzMLi+yW2u/Dkhc0zVmB/WZ1Af3diNo+7
	 wyTObtpZqApgvbnBYUPjC+Anm9sPD1BEQyZCVKPtm0C7zWRwTjUCq1lmrWY5F90y90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ByF24ktn;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D091B606A31A;
	Mon, 23 Nov 2026 09:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D091B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ByF24ktn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aszNWFm3AavU3Fw6Y6RtvpwqKpNfGOGtFmRMkuOvBq0=; 
	b=ByF24ktnu3YoMJEhhcWrvct1F6WCpHNZsauPWZ667prMGxTjbliQImxa0Mt4kWN9ueGby05UztW
	ay3SV/2JiGaTL+pLfXhSNkHR/eHB4J6gG/V1/9WlnETY7nRV/TXPAMJ2lSoetC5CoWs5tifvLbUW1
	7504tFDwrRf4qra+0MFVcns7siFxWBtt4XzVYicUQ92t9hdi1RdkeymNZ8Mg3Us2lgEXIgupLFxJz
	BcIVq6kaSDZahKXJykdT+815t1efSIVyde17MAJ6ATtav9IjdU1gXXjEGDDvp/fgbrZWmm1Y7ERiD
	XPlhp+sFQZn/mmjKpZ7+QM5ooEkeJs9VdUFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xVQ0L-00000000tqn-3uaG;
	Mon, 23 Nov 2026 17:06:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Nov 2026 17:06:29 +0800
Date: Mon, 23 Nov 2026 17:06:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awQCFZSSng2LLGnX@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>

On Fri, Nov 20, 2026 at 11:24:19AM -0800, Kanchana P. Sridhar wrote:
>
> > [Severity: Medium]
> > Can acomp_reqchain_finish() corrupt the destination buffer when a request
> > with a non-zero req->unit_size uses virtual addresses?
> >
> > In struct acomp_req, dst and dvirt share an anonymous union.  When
> > acomp_do_req_chain() handles a virtual-address request
> > (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
> > buffer pointer into req->dvirt before acomp_restore_req() restores
> > req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
> > struct scatterlist * and overwrites 4 bytes inside the caller's output
> > buffer.
> >
> > In addition, acomp_do_req_chain() is called for decompression (comp == false),
> > so a decompression request with req->unit_size set will also hit the
> > compression-only req->slen > req->unit_size check and write to
> > req->dst->length.
> 
> Herbert, is it Ok if this can be addressed as a follow-on to this patch-series?

I think this case needs to be outlawed since our API doesn't support
virtual addresses being used for dst.

IOW the code needs to abort on entry if unit_size is set and virtual
addresses are used.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
