Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B14052D1;
	Wed, 23 Sep 2026 08:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153237; cv=none; b=LaczoZbw2dLybA7ttuD747pbasQOP04ob11z0CNtWrdkFR826VAabkdn8EiDMI9clJXz12Ct4f2zJW3jS82e3Jiq+dN8BYQFAw6fMTwLiFH8c1s34Dra3D4VAnOmvgTkcjXOk9TiFpbBu0LIBqvEYHXcRgOzQaA8A/uLv6A2Uxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153237; c=relaxed/simple;
	bh=MudnynUlGJlpFDLhq7LmhZ5I0ob72cqhMcdhNB/ouEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwWlacRgNkgfmK3txsQkHutmyFQyi3hGIlZJkWaf1NQ6D1XAAu2gqNWejBf3i3IKEe++9nDZ0sRKpaKed7gekic9XT1XrnvFZY5sLHEF1l41yRGCO/vRu7rhsQ1BFRcy2ulYGcioR8aPeahcq2xr5lcr0jfdWpnf4lLE0uIrUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MgZjH3rT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MgZjH3rT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tg2a81G5BrGxfF/cHjXvw3X5l0+e85gD5tlgL4N1MKk=; 
	b=MgZjH3rTJ0zAZFdy4NEH0TO//TqjQ2c7+4z0FzjcUDgdnoMDi/aNpayRJsaXRlmbgewmtCeI3a/
	4FR/6g8ZknEyCKjuMz5H9UmVBjFA108jaqGHk1xGknljQueD2/XayhgkIJ32sqQLUyafyB4yAv2O0
	I8QZRjx0j8zD2vVWc7jIc/lw6g5PCFVwhjk12wO3+4aWH8wCUTojSvmjP+717YANqjkLE8huAV2L4
	XpsP9C8P8wCnWS3AfUpEZ8MufEcjGcqreLqOEt0Apyluq0tZ7OYzcCvOjIr2s7aGj/wdXPuwKpB/l
	Q8wd7IzcXXFgVjyGFWuETWBa2jthqrF7+5rw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Icn-0000000Gy8v-2kVt;
	Wed, 23 Sep 2026 16:46:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:46:45 +1000
Date: Wed, 23 Sep 2026 18:46:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: asymmetric_keys: copy X.509 TBS for data
 signature algorithms
Message-ID: <arOR9UZ4_5mtD7RC@gondor.apana.org.au>
References: <20260821192502.3942767-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260821192502.3942767-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Fri, Aug 21, 2026 at 07:25:03PM +0000, Jérémy Jean wrote:
> For signature algorithms operating on a message rather than a digest,
> x509_get_sig_params() points sig->m directly into cert->tbs.
> cert->tbs is the preparsed add_key() payload.  The syscall wipes and frees
> it on return, while the instantiated key retains public_key_signature.
> 
> A later KEYCTL_LINK into an asymmetric restricted keyring therefore passes
> a dangling message pointer to ML-DSA.  KASAN reports a slab-use-after-free
> in mldsa_verify(), with allocation and free provenance both leading to
> __do_sys_add_key().  Reuse is also an integrity issue: bytes occupying the
> freed object become the authenticated message instead of the certificate's
> own TBSCertificate.
> 
> Give the signature object its own copy of the TBS, as is already done for
> a precomputed digest, and release it through the existing m_free contract.
> 
> Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digestion it wants itself")
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> Assisted-by: Codex:gpt-5
> ---
>  crypto/asymmetric_keys/x509_public_key.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
