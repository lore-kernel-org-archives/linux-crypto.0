Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0393D6B
	for <linux-crypto@vger.kernel.org>; Fri,  6 Dec 2024 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733472936; cv=none; b=hfdr5Y8s6CbdLMTRpS+esWGDntB1XZbXTygA+k3VDgxlg70ZdXcg3wPKIqgeLjqWlYY30Q3Q+A8JUgwA1sXQv+LCa8p9wo5h6NmampKMv4Zg1xD2185Bge7W5Uxxx+xKKctNU3OBJ0Nz2RrW1nfuljgI/j0Pu67i9XAyLQzprRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733472936; c=relaxed/simple;
	bh=Sod9pnsPpuXfuVogpHiuE/K18ZpMyz6JucYURUqKGn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/1F1OupX5cmK/r4H0obxqKkzDSX6rgGmhBRGRpJdNBBpK1LCvJ7QwnJNu/JF1WdKbHSkWDjgnnL8Kg29leqGi4i/bcM/Kt8vU7Y3J4og3SAtnuyRD2Ee1B6fts3+zUlmGKVcAeqkJeEFaLUlS3elgUqx+2lhD9JUB1gt1/m8eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id BB691280072A2;
	Fri,  6 Dec 2024 09:15:23 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A3642C7197; Fri,  6 Dec 2024 09:15:23 +0100 (CET)
Date: Fri, 6 Dec 2024 09:15:23 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Zorro Lang <zlang@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-2.6] crypto: rsassa-pkcs1 - Avoid pointing to
 rodata in scatterlists
Message-ID: <Z1Kym1-9ka8kGHrM@wunner.de>
References: <3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de>
 <Z0ly-QVERkD5Wtfu@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0ly-QVERkD5Wtfu@gondor.apana.org.au>

On Fri, Nov 29, 2024 at 03:53:29PM +0800, Herbert Xu wrote:
> On Fri, Nov 29, 2024 at 08:46:58AM +0100, Lukas Wunner wrote:
> > @@ -185,6 +187,16 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
> >  	if (slen + hash_prefix->size > ctx->key_size - 11)
> >  		return -EOVERFLOW;
> >  
> > +	/*
> > +	 * Only kmalloc virtual addresses shall be used in a scatterlist,
> > +	 * so duplicate src if it points e.g. into kernel or module rodata.
> > +	 */
> > +	if (!virt_addr_valid(src)) {
> 
> Please don't do this.  You cannot turn a virtual address into
> an SG list in general.  This is just one of the many failure
> scenarios.
> 
> The only safe way to do this is for the user to tell us that it's
> OK.

The dmaengine transporting data between memory and crypto accelerator
may have alignment or buswidth requirements not fulfilled by the
src buffer.

The caller cannot predict which crypto implementation (software or
accelerator) is going to be used and thus cannot know whether
location and length of the src buffer works for the dmaengine.

Hence I'm thinking that the sig or akcipher midlayer may need to
determine whether the src buffer is usable, and duplicate it if not.
The proposal above was meant as a step towards such an auto-detection
mechanism.

Thanks,

Lukas
