Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7473CC327;
	Fri, 15 May 2026 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840434; cv=none; b=kMNvhzu0FGENgarj7MvizQuxnK7TOBFfUP7ZJCSzs4FA2QMecaaybl1enzp6RhHvTjwI/PQPT4ToOD/UQup3WjoFPSXLGTwrPQrepsncdaov3hlzLTI+ZmluaGS0aM3kn4+Y/+SRTxkI0v143dCjkN3XOy3b4t/Ft5P6PgHLiQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840434; c=relaxed/simple;
	bh=tHFLMun1wtVzATNSFjBdJNYSPC2BYvie//tpOc7NXQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIjlfTKhrxrqW/tly/FJcooQD+wSf1yyny6wcwTzQvQPQxhqFA8233zGixsIyCBQZyhWNwZVVk9xhcHv0gBqFlgyIMtmVvYtEccyvN4hHofOGBAtzUCCkOX1hpVzZTcBgdRmXJ2dB4dCR6+9MDUfEFoDo3W0AUkwySl7BbZSFcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O4r3sycc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O4r3sycc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2AT8elKE1MlBJx5JrgUDTfk75SjOASfSg/8iD3G8SZE=; 
	b=O4r3sycc8MkWEc52P67aAKrmfcQ2ihQ+IaVL2k9BQjFpWrN4oDh2OzAN3BGTosNkh9cZrwJHHK/
	DGPe5RKUv4WvLN7iAsc8UCpp+v5QqUC5eVyl8l+P4Lb2I4C2/51QmbuHqfkBlLMKEaMHi3vcn1mAJ
	9bJ0vKiRgeCcrSQmWn/7e/WGuPjO2ieHz+YxgBaDQQtv++inXMkwgqtUd9HPIme6jeIz+7GnFo/EV
	+4oAyhRA3har0HVWH4wWsyhJ+e19odmffUz/DF2+AqvWlc4j9nwqD1YK/k6k0OX7PwIMUW50RFdHW
	LCaIZQ4i0huLokTxJFE0j8GhKXo5Vv9kx62Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpee-00EOTJ-2l;
	Fri, 15 May 2026 18:20:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:20:28 +0800
Date: Fri, 15 May 2026 18:20:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Joachim Vandersmissen <joachim@jvdsn.com>
Subject: Re: [PATCH] crypto: drbg - Rename MAX_ADDTL => MAX_ADDTL_BYTES
Message-ID: <agbzbF2HJuRDtAmu@gondor.apana.org.au>
References: <20260506000217.70738-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506000217.70738-1-ebiggers@kernel.org>

On Tue, May 05, 2026 at 05:02:17PM -0700, Eric Biggers wrote:
> Give this constant a name which is clearer and consistent with
> DRBG_MAX_REQUEST_BYTES.  No functional change.
> 
> Suggested-by: Joachim Vandersmissen <joachim@jvdsn.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/drbg.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
