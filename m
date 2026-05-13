Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E93D2C027B;
	Wed, 13 May 2026 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661181; cv=none; b=LP46JZwGH8fsbjVpb2MGxACAuxkaXRsgaVCLD1kkeGUFC2ZNmsqtNCgjHd4wBKclz/Hi5DuLfeX03GukrqzqcgyN278zhiPR2ognvUIYxuQrbQWsTAyZSATyDwLqiLLfMFSrbDhPOxadgjwO/26vE6ERvmDCAMAj//uHbGPAPwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661181; c=relaxed/simple;
	bh=fD89QneNtlgWMvxQLZaiuxVzs/7YD1JOaiDFtR6vW7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5AWimqep3BT1dHK4FsxfwGCx67EhcHNLEJ5R/Yzb2dPZS+YFWccESK6N2gwzYywSEduTz8cOiM66zbvRnOQpC4RDDAgZMQdkTw2Rrxf9aLDg3/H676Nm1NyqeY5/ifh7w8XMZKzZ2r7l6lE2MFxKVrjlRN43r7aOOo8HxhqoNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 9FA82249B;
	Wed, 13 May 2026 10:32:31 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 8C58A601BF85; Wed, 13 May 2026 10:32:31 +0200 (CEST)
Date: Wed, 13 May 2026 10:32:31 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Anastasia <sv3iry@gmail.com>
Cc: Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
Message-ID: <agQ3H3562zUgGA5p@wunner.de>
References: <20260508114844.29694-1-sv3iry@gmail.com>
 <agMvm_bA-OcDWhbc@wunner.de>
 <CAMtNSrhkfsGL04DtOb9M9fijHK=Xy0D-pBahiCqV+zPuJyRSLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMtNSrhkfsGL04DtOb9M9fijHK=Xy0D-pBahiCqV+zPuJyRSLw@mail.gmail.com>

On Tue, May 12, 2026 at 06:20:14PM +0300, Anastasia wrote:
> However, I have a few questions regarding the proposed
> check_add_128_128_overflow():
> 
> Should this function return u64 (carry flag) instead of bool to be
> consistent with existing overflow-checking functions like vli_add()?

I think if the return value can only be 1 or 0 (carry or no carry),
then bool is clearer.  If the carry can be > 1 then u64 would be
merited.

I think it's confusing that vli_add() returns u64, but this was just
copy-pasted from the micro-ecc library, whose uECC_vli_add() returns
uECC_word_t:

https://github.com/kmackay/micro-ecc/blob/master/uECC.c#L333

> Regarding argument order: if the function returns a result, shouldn't it be
> the first argument rather than the third (like vli_add())?

I think by convention, the result or destination is the first argument,
as e.g. in memcpy().  I don't know why check_add_overflow() doesn't
adhere to that convention but suspect there's probably no good reason.

> And replace:
> r01 = add_128_128(r01, product);
> r2 += (r01.m_high < product.m_high);
> with:
> r2 += check_add_128_128_overflow(&r01, r01, product);
> in functions vli_mult, vli_umult and vli_square

LGTM.

BTW a small nit, the commit subject contains a superfluous blank
in-between "crypto" and the succeeding colon.

Thanks,

Lukas
