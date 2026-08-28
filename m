Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBD22D8385;
	Fri, 28 Aug 2026 05:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787893358; cv=none; b=RrJvQmx83YLSCP+U6Xvs5vN/xEZYhs4e00UTwq5r6QrksgkHwa5w/t9e/ZgH4nwPYK7KQvmlVN+pyQCx+u8QwKwzbGponwFieJpnWL6RiGW/Vwm36RM7sKiJz+/UxagxXLgTO11ybwQqUd0c07v2Svxc3o2bzavTwVae9qJRfHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787893358; c=relaxed/simple;
	bh=xc2jrMMftAB3uphDmcLwC4Iya/N10TIxFInNVCqurOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJXr5GIWuBf9lRLpj/ETCLaCWDSVKzuBW4F/b5z3C7eLZHvGeugoBymXWXLQrSKhKptzG1BnEnlq2JWgulVr4j0FsajNFvPCihtSUYVGN8okgTxImRe1J3VG+/ghQvmkVMmfrnkEN2NudycipK0zBOxeChsWjV4YYc3pKh8If3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBozuRKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBozuRKX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4280A1F000E9;
	Fri, 28 Aug 2026 05:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787893356;
	bh=2AeKnpQEc5FuYi17jCmz/ZwCBYps/95FktR9vWPHpK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DBozuRKXlF/oGZ0R5ayjGfQ/4fka1GT03Q84FcAxBCm8hzDxUJzbSDtRzzNEgiDOv
	 tGRgyuyaIn5+pOuwj4TT2Kcuk/U5uoVbktgUopzOTTYSXwZEoT6+wGmdunjAQkxgCI
	 VeaLZ/QUvmligOvrho61act8tQ3MNEsMatYhkUVbwHc5LECkUA3dr0DpC9tSFewNDx
	 nS0szmVxpZ37aPX8XwrwBQgr0YzbQUJjpsQtq5CiR5s2Il5DaQoobRje0eMmxe25ml
	 KRNd8Hrohmy0K8WXxmDdSa+lX215ULG3Av/Lzm7YiTv/xWe2IEfZf3lBGSP/Ve44Lc
	 wttO6vOAFepqQ==
Date: Fri, 28 Aug 2026 08:02:29 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: dhowells@redhat.com, lukas@wunner.de, ignat@linux.win,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keys: reject descriptions that exceed the index length
Message-ID: <apEWZUFe8NmwgPDb@kernel.org>
References: <20260824113004.3755053-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824113004.3755053-1-4ncienth@gmail.com>

On Mon, Aug 24, 2026 at 08:30:04PM +0900, Daehyeon Ko wrote:
> struct keyring_index_key::desc_len is a u16.  User-provided key
> descriptions are limited to 4095 bytes, but a key type preparser can
> generate a longer description when the caller passes NULL.
> 
> The X.509 parser forms a description from the certificate subject and
> twice the raw serial length.  A certificate with a two-byte subject and a
> 32766-byte serial therefore produces a 65536-byte description.  Assigning
> strlen() to desc_len wraps it to zero, after which __key_link_begin() hits:
> 
>     BUG_ON(index_key->desc_len == 0);
> 
> This is reachable through add_key() by an unprivileged user and can panic
> the kernel when oopses are fatal.
> 
> Measure generated descriptions before narrowing the length and reject
> values that cannot be represented.  The boundary input now returns EINVAL,
> while the one-byte-short control still reaches the normal quota check.

This lacks smoking gun type of evidence, and I don't understand why
as it requires an extremely low effort.

If I understood the code correctly, I'd start with a key that I would
craft along the lines of:

    openssl genpkey -algorithm Ed25519 -out key.bin

    openssl req -x509 -key key.bin \
                      -outform DER \
                      -out certificate.bin \
                      -subj "/CN=xx" \
                      -set_serial "0x7f$(head -c 65530 /dev/zero | tr '\0' 'f')"

Then I would simply expect this to crash my system:

    keyctl padd asymmetric %:s @s < certificate.bin

Will this happen? Have not tried it in a VM yet. I just feel a bit
confused that this was not already demontrated in the commit message,
which makes me think that I get something wrong?

BR, Jarkko
