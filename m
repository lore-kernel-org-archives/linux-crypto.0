Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795804813;
	b=LRZxc6go+v97iYXFFQvVmRZDE9V5K2m8rYCE0AhjBsjVLZzReA8KeRu3oA9x/7TqUqxr
	 HbtBor3DkXTGJNQpt+uBw3LCRyOlfDgqUiQPy+CfXCBEuteN/xFDQkT7sfc907MwIl1aC
	 1pTFqCBte9FlSygWotRRa0bp5wZ3sK+w5XPx8qihmr0ewq4LLxlt/EywnkU3yTHJ9DtDc
	 I4dF7GGEurdOlvYwDia7Tr/VksgkmRl3w8JiP6IpxoLX3ee5PNmUHXbEtXrD0Y0gjZY6j
	 nIzuUXMcD25VNrtmQshL2rfU+T5DVzAxd8So+dyPUJD/PgS8Pe5I1tPDDKCGDaurVVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795804813;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wdGvFgJwtqkDQ7r6P6Md8ySNN9pb8YID66pcM6026GA=;
	b=uOzg05DCbve70nZFStawWAkKWkz0wTZ1nWOISLaPdBT0R35IqryjR1MYo7O9WKTxL9rl
	 s5bWTRbxMo5COuh4gyRyN33YBSq9PJGlkM2z/Xvc2JXjJeSiDQuSfA2TD6t9LC4DcxRDT
	 JATVS2NEoBblDVUXTsrTG7CmGKLaQDYI8lrV6pY1YAQzdz9wIM+VsXOKBOIfm3/5Fqdtp
	 OspBUppCVEKqHv6PFAVWGEngWfsxaTXyIz9QQYa9xPYBJz2WTeCs211eQ6EY7vDCWU6Dk
	 cwwu3BYIfLnGOWLtPhhJX4ITGvlg6n1mvulwFlFKdu3faF2f57fCcslWY1nlc6qLxDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H1G9M/sD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CE7606A31C;
	Fri, 27 Nov 2026 18:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1G9M/sD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C18F1F00897;
	Fri, 27 Nov 2026 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795804812;
	bh=wdGvFgJwtqkDQ7r6P6Md8ySNN9pb8YID66pcM6026GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H1G9M/sDkjtsCesN2pPzFS5qOp3FJqQMaxltvDHtxG7BE5vEDyhdq4EZCdxy9AmGf
	 n4euCJE4TL3bdeTeJX3lVUkO68wfh5LHsKjXjUcPIcAgxbxHYNrOwKSAXv1LJhbeRp
	 iMvQlkY6SAy7O84mhPJ1DkQejg11drIDDHL9xUFkvLY9RkKo4yNAdDjHhTJBtLzthm
	 w/MDWpqpFxWhhd1flUzWTHcxZDahJxa3Q7wqOXcOnNLXU9nyifcdudcQfzBeCnV0gL
	 3GLMZ++csHaKneIkCFVoqA363xmnNFtHv+6llddQ2CHB7AYGN7idFK+8JLzScrdURc
	 OQqDTdwV1wD2g==
Date: Fri, 27 Nov 2026 10:40:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Artem Novak <artem122novak@gmail.com>
Cc: Jason@zx2c4.com, ardb@kernel.org, stian@itx.no,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sparc: remove trailing whitespace from AES
 assembly
Message-ID: <20261127184010.GA1974@quark>
References: <20261127041853.127855-1-artem122novak@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127041853.127855-1-artem122novak@gmail.com>

On Thu, Nov 26, 2026 at 10:18:53PM -0600, Artem Novak wrote:
> Remove the trailing tab after the key expansion label in
> aes_asm.S.
> 
> Signed-off-by: Artem Novak <artem122novak@gmail.com>
> ---
>  lib/crypto/sparc/aes_asm.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
> index fd90b129972f..0ddf181f342e 100644
> --- a/lib/crypto/sparc/aes_asm.S
> +++ b/lib/crypto/sparc/aes_asm.S
> @@ -293,7 +293,7 @@ ENTRY(aes_sparc64_key_expand)
>  	ba,pt	%xcc, 80f
>  	 std	%f58, [%o1 + 0xc8]
>  
> -1:	
> +1:
>  	/* 192-bit key expansion */
>  	ld	[%o0 + 0x10], %f4
>  	ld	[%o0 + 0x14], %f5
> -- 

I don't think a single trivial whitespace cleanup like this is worth a
commit.  (And the trailing tab here isn't new, either; it's inherited
from the original code from 2012.)

- Eric
