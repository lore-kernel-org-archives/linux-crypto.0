Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65037C914
	for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2026 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776081505; cv=none; b=SXlXfaQvXbSLFCh+k7VZY5Y8y3xL1XDiWRrFoWpfXkIS2z45mX+bgd2f7I6EOOZNwVUMbRBAwowVitpEzZkdi3lGgh04wtW/fbADUNZrStxCaZddpr3eidubK6w8C3tdNywXY+zj5KOnbfgHHuQLVGhsQq5ycE15Z5g8lI1eGuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776081505; c=relaxed/simple;
	bh=okS2ETBuQ9uKfB0uN9rufSyTr0vTdhbAhvNPLht4dF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7hcQN3KW0eU15iPB7385Y+BtJfZRG12tSINK1hK8JH3Xoe4GtYirzJT1fvOIfFY2f9T+Jaiwcoj8pES4mMczv2r83ENc3Ltbelj8I40Gnf7rqT2LEt5MJVr0RZEa38iCBugPdzSutmWD75iJtni8jJNzoWbVZdAweZUX2RElEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 49FC738A;
	Mon, 13 Apr 2026 13:58:13 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 339506017530; Mon, 13 Apr 2026 13:58:13 +0200 (CEST)
Date: Mon, 13 Apr 2026 13:58:13 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Eric Biggers <ebiggers@kernel.org>, Jason Donenfeld <jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ignat Korchagin <ignat@linux.win>, David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in
 mpi_read_raw_from_sgl()
Message-ID: <adzaVYg-TEYpL0C8@wunner.de>
References: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>

On Sun, Apr 12, 2026 at 04:19:47PM +0200, Lukas Wunner wrote:
> Yiming reports an integer underflow in mpi_read_raw_from_sgl() when
> subtracting "lzeros" from the unsigned "nbytes".
[...]
> +++ b/lib/crypto/mpi/mpicoder.c
> @@ -347,7 +347,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
>  	lzeros = 0;
>  	len = 0;
>  	while (nbytes > 0) {
> -		while (len && !*buff) {
> +		while (len && !*buff && lzeros < nbytes) {
>  			lzeros++;
>  			len--;
>  			buff++;

As a side note, in 2018, commit 8a2a0dd35f2e ("crypto: caam - strip
input zeros from RSA input buffer") copy-pasted a large portion of
mpi_read_raw_from_sgl() into caam_rsa_count_leading_zeros() and
duplicated the bug as well.

One year later, commit c3725f7ccc8c ("crypto: caam - fix
pkcs1pad(rsa-caam, sha256) failure because of invalid input")
fixed the bug in the duplicated function, but unfortunately not
in the original mpi_read_raw_from_sgl().  The fix was identical
to the one I'm proposing above.

Thanks,

Lukas
