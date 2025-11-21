Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CB2D3720;
	Fri, 21 Nov 2025 04:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763699886; cv=none; b=t0SxbOtvSgSz5iGj9i0/wOoeVA295H/XQNo5JC1ysznlCHZkUgGv8HtkKOmFPIdOomLaWLqGd+jngsrJlRJ4snJkBPHLEz/k/R3f46r0vSEeVLIsfES+FFzLo1s7xDtlZhhfh9cPVOgD4C+W0Hnra8PHYuL6KBGS+6jgvPDqnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763699886; c=relaxed/simple;
	bh=rpljay2SM2oqquc5JdSGLo3WsLi0AG4OHmRZgY0ZAaY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=baqqKccF6zj0dAVL/L1HhJXHHGMs6YE27f7ZC8qz8LDQCiCYOziXteKWSLENJwFgLh2/S7zaU/pIAkmKrtc6qUSiLDmLS7SQMaoWF0rPMEqf9GKUtVJ11DC56/UmMu8L0TE98axFieWRggh+fIYOmL6WbZ3MBeYZP+rmrGHkaVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iN9Y2PBW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iN9Y2PBW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=y7fsiEXUSUVEPwIoKVHP6UdfpujNt9MYfKjW3t+ppKQ=; b=iN9Y2PBWZaDW0JaLIw5uQiOryy
	yGpgAuNrCkJl8cLcefngfhIwxTbknGcBkD8VVAuQlmT8zwzCDQctLmqNR+fqDIBN9lCYE3abIgr9F
	y7Ci63IUr9Ndqx816L56Yzi1g3NytUUbRh5PeJql+7yfjIkFF+78ualrV0zFhZwOeunOn5dEOx9Br
	fTN/xZT0SmWJw+QBe7Xr3JFfPZioYtMqomwSosci0Wd7NY0u3tHYO5RbgTGSestZh+Ytrz99x9Ua3
	JqGlVG0+jrsthIxX/zEYao5gWcKTR7loOtHWXQrnN/q3EVExs+j49UqSviOn5PsWPIHCwPEHcVQhy
	dR42xJUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMIuD-004rDK-1i;
	Fri, 21 Nov 2025 12:37:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Nov 2025 12:37:57 +0800
Date: Fri, 21 Nov 2025 12:37:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joep Duin <joepduin12@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	165405982+joepduin@users.noreply.github.com, joepduin12@gmail.com,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] fix MIC buffer sizing in selftest
Message-ID: <aR_spUmU7FswxA2Q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113135506.18594-1-joepduin12@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Joep Duin <joepduin12@gmail.com> wrote:
> From: Joep Duin <165405982+joepduin@users.noreply.github.com>
> 
> Signed-off-by: Joep Duin <joepduin12@gmail.com>
> ---
> crypto/krb5/selftest.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/krb5/selftest.c b/crypto/krb5/selftest.c
> index 4519c572d37e..82b2b6a3607d 100644
> --- a/crypto/krb5/selftest.c
> +++ b/crypto/krb5/selftest.c
> @@ -427,10 +427,10 @@ static int krb5_test_one_mic(const struct krb5_mic_test *test, void *buf)
>        memcpy(buf + offset, plain.data, plain.len);
> 
>        /* Generate a MIC generation request. */
> -       sg_init_one(sg, buf, 1024);
> +       sg_init_one(sg, buf, message_len);
> 
> -       ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, 1024,
> -                                 krb5->cksum_len, plain.len);
> +       ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, message_len,
> +                   krb5->cksum_len, plain.len);

I have no idea what you're trying to fix here.  Please explain
the problem.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
