Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042A036F915;
	Fri, 22 May 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779475446; cv=none; b=F0oBr1eaZy4J0DrnQlYPjWVMX3zYutkELQJGL5/13Ijcxeu+C3LOX0UGEg+oWuuFkbKYC12X9B1SibfSdIYwsu/BlOgG6cnkF5d/ZVTeWRVppy4UiiTjbLSRMeRXnQf7UWXNxtkkHtzVmTzowJjcaeso8Yrg8zozeUyPSJnpeFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779475446; c=relaxed/simple;
	bh=SxBWEmIoRrQ+FxxkgsU9aawOCyjuKlP450QulHrJ9qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdEFyzyqN2B61b9miFn4dsk4E8VS8Lb2Qaj1szSneVxfLJHxPCY1kdmHrUp6nGXAV2bAMfmIGY1EczjZCR4T+xGpOCH+0dSlgEL9LxIzIGO8/7oI49a+52uWtD+n6stXusQwsO3vr/PO1zraQ0QCNTiN3FfRCQleLxZvCQxxmrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYCUK/4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYCUK/4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE011F000E9;
	Fri, 22 May 2026 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779475444;
	bh=Ahg815ibM3wTGG80M6VHxl198yKGxtx0lBNAnWR/LKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYCUK/4RTe0OR+r+8W9mQaP8sHGYPGMYuE6H/NHyXD4oieDpQJ7KClgNsFszkN3Xs
	 OJhgjaw3qaa/cO7Us9Z8BkCkZzxisxESgSBylunNjOrk/0xmjqWtEQM/vMc3XEJmLm
	 ZMT0fEqJRHjp5IZJEL91Ieul7hQs76Ih6vKhyWtlJHHC24/0SAvlMRLQ/fwRfYc+QF
	 Y9BbvgLgel8fr0goD6VV8AjcD8OQ9uCnFWi8Sl2UsnAwvx27MCvdTVw/gghstqRFXP
	 aNYWcmNCb8muWeUGNek6hi2Btov5/UD2aJM+77n0vEKWmBrqs9wmBsmpbzkso3SSS0
	 4mtxZP632yAng==
Date: Fri, 22 May 2026 13:44:03 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Calvin Buckley <calvin@cmpct.info>,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: nx: fix nx_crypto_ctx_exit argument
Message-ID: <20260522184403.GA35544@quark>
References: <a3e89c1e8342ffa415b0d29725a0571a4f355d34.1779472902.git.sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e89c1e8342ffa415b0d29725a0571a4f355d34.1779472902.git.sam@gentoo.org>

On Fri, May 22, 2026 at 07:01:42PM +0100, Sam James wrote:
> nx_crypto_ctx_shash_exit calls nx_crypto_ctx_exit with crypto_shash_ctx(...)
> but crypto_shash_ctx gives a nx_crypto_ctx *, not a crypto_tfm *.
> 
> Fix the type in nx_crypto_ctx_exit and drop the bogus crypto_tfm_ctx
> call.
> 
> This fixes the following oops:
> 
>   BUG: Unable to handle kernel data access at 0xc0403effffffffc8
>   Faulting instruction address: 0xc000000000396cb4
>   Oops: Kernel access of bad area, sig: 11 [#15]
>   Call Trace:
>    nx_crypto_ctx_shash_exit+0x24/0x60
>    crypto_shash_exit_tfm+0x28/0x40
>    crypto_destroy_tfm+0x98/0x140
>    crypto_exit_ahash_using_shash+0x20/0x40
>    crypto_destroy_tfm+0x98/0x140
>    hash_release+0x1c/0x30
>    alg_sock_destruct+0x38/0x60
>    __sk_destruct+0x48/0x2b0
>    af_alg_release+0x58/0xb0
>    __sock_release+0x68/0x150
>    sock_close+0x20/0x40
>    __fput+0x110/0x3a0
>    sys_close+0x48/0xa0
>    system_call_exception+0x140/0x2d0
>    system_call_common+0xf4/0x258
> 
> .. which came from hardlink(1) opportunistically using AF_ALG.
> 
> The same problem exists with nx_crypto_ctx_skcipher_exit getting a context
> it wasn't expecting, but apparently nobody hit that for years.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Fixes: bfd9efddf990 ("crypto: nx - convert AES-ECB to skcipher API")
> Fixes: 9420e628e7d8 ("crypto: nx - Use API partial block handling")

Add:

    Cc: stable@vger.kernel.org

> diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
> index 78135fb13f5c..101e7fc7c1af 100644
> --- a/drivers/crypto/nx/nx.c
> +++ b/drivers/crypto/nx/nx.c
> @@ -719,10 +719,8 @@ int nx_crypto_ctx_aes_xcbc_init(struct crypto_shash *tfm)
>   * @tfm: the crypto transform pointer for the context
>   *
>   * As crypto API contexts are destroyed, this exit hook is called to free the
>   * memory associated with it.
>   */
> -void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
> +void nx_crypto_ctx_exit(struct nx_crypto_ctx *nx_ctx)

The part of the comment that documents @tfm needs to be updated.

Otherwise this looks good.  Really there's a good chance this driver is
no longer useful (if it ever was) and should just be deleted, but that
would be a separate effort.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
