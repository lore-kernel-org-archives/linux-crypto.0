Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845032D5939
	for <linux-crypto@vger.kernel.org>; Mon,  1 Sep 2025 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746772; cv=none; b=t73MlFCZ6Y4VG2At99tER07IpcSkugVEjurNLzg2pGaCXnrgCNkPopUbfCB6WWeUy4ovf17KoT9GKnnEStn2bOBJXMkbPa1jvfTd5bYj1FoGzqmBCsuzw6LWexKbOvVlqHEz3R4ZQIHp5dGBx/lIHb59Y/vubHXLK9J5ShI+1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746772; c=relaxed/simple;
	bh=NgweoeNuvkJcA+MM/dILXJxOoDFdSGj1qjkhxKKs9AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3RyEHvyMXudRPu0XhBVEESN4IgyvYb4TYiK0KvFekk8hSxbx3egzNW7svQYlJxUEc/XVYHehb3zHS7/rj+1+iyRvdmCC8N9gdlwuQ3rYPji+HAebwzA326tpu3ys12MnCxQZgA2SFhz5Rq9V6vtawUASkPPrkuF3JdtY5vfOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6lawVoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6lawVoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AF4C4CEF0;
	Mon,  1 Sep 2025 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756746772;
	bh=NgweoeNuvkJcA+MM/dILXJxOoDFdSGj1qjkhxKKs9AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U6lawVoZDG9J4x4wsR1DyvfDZ2Mt2vbMafW1dhWssjoypTMsZnE+i2A4DqS7loDq4
	 N+4fx/5z3dgGd8zN52EY+cess0zCORN2q8JTjZSmzaNZCF0yfwnW0Yb9pkRUgpy8kL
	 ZGRQ4HJcFpOYQ9rNIglPpef4VReGx/hceES7/WX9gKOBBOZfRh8u6zZQaLZGco3C64
	 srh0JKGKjZzJJzQJFodJERyvXJP7Fuu3IONvrMoixfR4g7VRu4C+AnvErjUBkyzui7
	 yJpsy79rEuBNVOkQEudmV0v/V/Gvxgw4pNgQ81RHUqnieatWur5VOGoFLlOSGVM9KD
	 TqnZ6gVoWUs5g==
Date: Mon, 1 Sep 2025 10:11:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: Re: [BUG] crypto: shash =?utf-8?B?4oCTIGNy?=
 =?utf-8?Q?ypto=5Fshash=5Fexport=5Fcore=28?= =?utf-8?Q?=29?= fails with
 -ENOSYS after libcrypto updates merge
Message-ID: <20250901171144.GA1350@sol>
References: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>
 <17bee9ab-7a39-4968-8778-ab2484ff58f7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17bee9ab-7a39-4968-8778-ab2484ff58f7@gmail.com>

On Mon, Sep 01, 2025 at 09:20:20AM +0300, Ovidiu Panait wrote:
> Hi,
> 
> On 8/31/25 10:48 PM, Giovanni Cabiddu wrote:
> > After commit 13150742b09e ("Merge tag 'libcrypto-updates-for-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux"),
> > crypto_shash_export_core() fails with -ENOSYS for all SHA algorithms
> > registered via shash.
> > 
> > The failure originates from shash_default_export_core(), which is now
> > being used as the default export function. However, this function is not
> > implemented, resulting in -ENOSYS.
> > 
> > Before the merge, SHA shash implementations were setting the
> > CRYPTO_AHASH_ALG_BLOCK_ONLY flag. This caused alg->export_core to be
> > assigned to alg->export, enabling proper state export. It seems the
> > removal of CRYPTO_AHASH_ALG_BLOCK_ONLY from the SHA implementations was
> > intentional, is this correct?
> > 
> > This issue breaks all aead implementations in the QAT driver, which
> > since commit ccafe2821cfa ("crypto: qat – Use crypto_shash_export_core")
> > rely on crypto_shash_export_core() to retrieve the initial state for
> > HMAC (i.e., H(K' xor opad) and H(K' xor ipad)).
> > 
> > It’s likely that the Chelsio driver is also affected, as it uses the
> > same API.
> > 
> 
> It seems that all legacy ahash drivers that set the
> CRYPTO_ALG_NEED_FALLBACK flag are also affected.
> 
> I tested sha256 with the sun8i-ce driver and since commit e0cd37169103
> ("crypto: sha256 - Wrap library and add HMAC support"),
> crypto_alloc_ahash("sha256-sun8i-ce", 0, 0) calls fail with -ENOSYS.
> 
> The issue seems to be that drivers that set the CRYPTO_ALG_NEED_FALLBACK
> flag fail to allocate a fallback because now the sha256-lib shash
> wrappers are marked as CRYPTO_AHASH_ALG_NO_EXPORT_CORE (because they
> lack an import_core()/export_core() implementation), so they can no
> longer be used as fallback.
> 
> In crypto/ahash.c, crypto_ahash_init_tfm() specifically asks for
> fallbacks that do not have the CRYPTO_AHASH_ALG_NO_EXPORT_CORE flag set:
> 
>     if (crypto_ahash_need_fallback(hash)) {
>         fb = crypto_alloc_ahash(crypto_ahash_alg_name(hash),
>                                 CRYPTO_ALG_REQ_VIRT,
>                                 CRYPTO_ALG_ASYNC |
>                                 CRYPTO_ALG_REQ_VIRT |
>                                 CRYPTO_AHASH_ALG_NO_EXPORT_CORE);
>     ...
> 
> The import_core()/export_core() functionality seems to be used by the
> ahash Crypto API to support CRYPTO_AHASH_ALG_BLOCK_ONLY drivers (such as
> padlock and aspeed drivers, that make use of use
> crypto_ahash_import_core()/crypto_ahash_export_core()). Unless it can be
> reimplemented to use the software library directly, I think the shash
> sha library wrappers need to implement import_core() and export_core()
> hooks so that shaX-lib can be used again as fallback.
> 
> Thanks,
> Ovidiu

Hmm, that is annoying.  So the export_core and import_core methods
(which were added in 6.16) seems to have been fairly deeply baked into
the old-school crypto API already, even though they have no tests and
only four drivers actually call them.

For 6.17, maybe we should just go with a series that adds export_core
and import_core support to crypto/sha*.c for now?  I've sent that out.

For later, we should fix these legacy drivers to just use the library
APIs instead, then remove export_core and import_core.  I already sent
patches for qat and chelsio.  But it looks like the padlock and aspeed
drivers will need an update too.

- Eric
