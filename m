Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6484A2E0E;
	Wed, 15 Jul 2026 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147320; cv=none; b=Mv+CQ5MiXniHVFGDIoySyRwCqo8rUBhOHbdWpQRrmfU9bkWCiek995l//SR1nt33MRPSwxaf1EALv7Pl36tDH5Z4pT+CQ8GTfe2zT708vq1Y6q4xz0U9HREoI8SkC9shPFXubT92SspEqjX3UPw3oznPlJ/fRwSLEKHRzG4ASLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147320; c=relaxed/simple;
	bh=iubWgJn16bXMsGz8Y426Ymi5SeRlYcdL6NR3SWoCYsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6QTtntsH9DTbZbb4XWwsEnxRQC6XJABvU6ySAHOibv52JuihU2yzlXQRnoGZuh7gM70jFLTvw8ic4Xedp8wCHgq13UbH8cV8j5seDW+zeyPFiVE9lnRiINEB3Hwgwqr5R179U/cMyS+mIut71wjNFIcU4VLj7LiWdvkBBqv6Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHHksMSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHHksMSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A76A1F000E9;
	Wed, 15 Jul 2026 20:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784147319;
	bh=tm3SfMmjsMpAGXHZPabitXHLG61Rq0wDPH0iP+uX7YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bHHksMSOqNMc8t3cKGgLK0UtJO6PTXKu5WRl4k8rx9kq/8mrwrRDmQJJLxyXs/C6v
	 wcTiY/ZwqKTakG1HqSFBdGtHz1YJpJG3W+josw8ULdU6d+N8YneU8OMPMPQFFfyLul
	 tXm27jvuu6+Pmb2ucZLBXEtNPZQcrKHEqzsp38yslL5G9rChYUs+Pq+bsjx7KtXRto
	 dQPMJ53XCq4CKBUpfioX80S/f78ArrAVB4a2RVufyFcNe+THbrezU5BnUq+IPNFiao
	 43SLWLoBsp4LfBTD7DTlHuqAh+fUZtEYSLqLUiPKjuJrhUHoc4RvweMFPXuG0ni5gm
	 9ZrorhYyekmLA==
Date: Wed, 15 Jul 2026 13:28:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/33] lib/crypto: aes: Add CBC and CBC-CTS support
Message-ID: <20260715202837.GA64757@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-4-ebiggers@kernel.org>
 <20260714090208.6438dfa4@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714090208.6438dfa4@pumpkin>

On Tue, Jul 14, 2026 at 09:02:08AM +0100, David Laight wrote:
> On Mon,  6 Jul 2026 22:34:33 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Add support for AES-CBC and AES-CBC-CTS to the crypto library.
> > 
> > These will be used to provide streamlined implementations of the
> > "cbc(aes)" and "cts(cbc(aes))" crypto_skcipher algorithms.  Most users
> > of these crypto_skcipher algorithms will also be able to switch to the
> > library, which as usual will be simpler and faster, e.g.:
> > 
> >     - block/blk-crypto-fallback.c (for AES-128-CBC-ESSIV)
> >     - fs/crypto/crypto.c (for AES-128-CBC-ESSIV)
> >     - fs/crypto/fname.c (for AES-256-CTS and AES-128-CBC)
> >     - kernel/bpf/crypto.c
> >     - net/ceph/crypto.c
> >     - security/keys/encrypted-keys/encrypted.c
> > 
> ...
> > +void aes_cbc_encrypt(u8 *dst, const u8 *src, size_t len, u8 iv[AES_BLOCK_SIZE],
> > +		     aes_encrypt_arg key)
> 
> 
> Does embedding the 'u8 iv[]' in a structure work?
> It gives better type-checking for the length of the array.

It doesn't work very well, since callers tend to just have a u8 array.

- Eric
