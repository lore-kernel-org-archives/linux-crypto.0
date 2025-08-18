Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F95335BC6;
	Mon, 18 Aug 2025 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525052; cv=pass; b=llgMwrBbzJVbaHrsISYLL7/dpl1P3BKlMfZuhqdO/V3/0LQQl4jgg4gfTZPOiJs1JlHLDllmrtiuYe9ViAIoF/MIXGA3h0V7/woXcO5yueFk4dr4SlTbMC7ynDg389DOuO5l/fVmXYiMrktNeHdZgllMwXLXWSPGnWffCK9nLic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525052; c=relaxed/simple;
	bh=+s0IBbOlIkEqcYFWxsJGtno7Sqd4WsfU8DnxSquCTv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5U9bWHhVP4va4mqGqCSyVn09Ns0qLepAGSv2yRgQbQalDgM1/JB3e0zUeqCNc5idqQn4KqTIMc7mtnOZW/PD/v52VQufz94VhYfEPGkEWHbc+BEQbWCG4/e0FJRUIFpPdQYg9ehyshnY2IpY1X1S8fDV12b5xKE7su9Asv8XlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=AL/uq1mr; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=NBiBZgxu; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="AL/uq1mr";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="NBiBZgxu"
ARC-Seal: i=1; a=rsa-sha256; t=1755523964; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Jtr5V/JwOkXxjJaG+T0rUgAXc+RSUFrkY2pWe9AKT3T0QpFh+DAg1XXH0JVbS6UKci
    kG/UxzaPkcuhnr3cFPDT7ahaukeObsnd8KBft8cPPPDPIGBeYxCd8alekxircIib8nQl
    EGVDao6ySslTyo57RseqCidI6pHcuVYSxSdBrSV4VMaDrqJxqpEZHXRiKw13aL5pSUe8
    q08jyI/xW7Is1FOVZ94YqWitiSfi1YRhOOkM13N8EqJhxdWvI/juVCXGyO2Up5qxBFgK
    B0adMjzHcof+Rt++i3x42zUc0+ZOhj44Fwy4/xCnIUv/I21jReHHp8unULn417NFLo1c
    uJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1755523964;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bGPJDDIK0A+1nB5ACwSZqwTY1dyeSldR3vEYMiGGouA=;
    b=a9q/MUKj+/I3h8s4gD0cHNiTVX4Gdj44mEbqRLx5yzXcuoV3zfKgbl/4B8EtBwSvLM
    nIP+otzpRd/MSS68sekjwiCOznAZ55DMD5eeRiEAh3PaWxMwc3cBu+4scU/IJvFe23DH
    lnqf2xjRYOgsojDhWcheyz517oLXK7wEOrsbI46lK1gKRqkLs7upRuMbPUQgMFYKGXfl
    7zVYkO6Aatb0ZBT0Ig/EKBkJx3rqXNEuGsNe7iE03sVCGhE8LOhFjqv+IS0MELoMoBbZ
    ptnU4liA/qnvqWqhuf/TwaBjQDk+tFQrQ2l+cP0pxBuv1w0u5aRIhWvBktP51xF/2+cT
    RE8w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755523964;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bGPJDDIK0A+1nB5ACwSZqwTY1dyeSldR3vEYMiGGouA=;
    b=AL/uq1mrJxcb5au+Qz0F8RIBE41VqvlA/bs+WGQlMnwDSpY49etWrX6TiDVPT5sEyI
    QOqd2tCvwhM1KoZYiq/gencxdljJeB8dIcuX/rSTlMdMofIk41+8ldush/62ylxxHf4e
    G0ORiGARmHu0Sm72qTfEfr+xbxL3tpT30VFF//RPKV+wG2W+a8JIV5TQnE0ZXKWUQfKT
    +XDbUwm4lBeYYmQwu1H5WNnI/KYlYsb9Cs8v/Arnn3hixVBjfpbjyqoatbhZVHbDrXw6
    1KxOnkzGG7m9vbJzGDyx/Qv4m0h2GVApvmE0g6JqCWaOdzT6I77jiTx2DmZ2ED6fgZ+k
    KPXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755523964;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bGPJDDIK0A+1nB5ACwSZqwTY1dyeSldR3vEYMiGGouA=;
    b=NBiBZgxueyqwXBCxmgVlQeK/iebqkrsTDo/syadgWKGfRJH7kMjb7td4HGOl1AYW8b
    wopu6MWR+LTRqpkjDNBw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJPSciIGX"
Received: from tauon.localnet
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id f5f78e17IDWhySG
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 18 Aug 2025 15:32:43 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, eadavis@qq.com, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V3] crypto: Mark intermediary memory as clean
Date: Mon, 18 Aug 2025 15:32:43 +0200
Message-ID: <2401599.22IY78Rhhi@tauon>
In-Reply-To: <tencent_65C6578989EEED6EE78C8B67E586DE92EB06@qq.com>
References:
 <7740195.jRhZ6ZUK3Y@tauon>
 <tencent_65C6578989EEED6EE78C8B67E586DE92EB06@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 18. August 2025, 15:24:17 Mitteleurop=C3=A4ische Sommerzeit schr=
ieb=20
Edward Adam Davis:

Hi Edward,

> This is not a leak! The stack memroy is hashed and fed into the
> entropy pool. We can't recover the original kernel memory from it.
>=20
> Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De8bcd7ee3db6cb5cb875
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

Thank you for the patch. Just for the records:

=2D the intermediary buffer could be initialized to 0 without any effect on=
 the=20
Jitter RNG, because all it wants is actually the execution of the Keccak=20
operation as part of crypto_shhash_finup.

=2D the intermediary buffer is inserted into the Jitter RNG state to ensure=
 that=20
the compiler cannot optimize away the loop if the intermediary buffer would=
=20
not be used at all

=2D the intermediary buffer is not credited with any entropy as we only wan=
t the=20
Keccak operation

=2D by keeping the intermediary uninitialized, the Jitter RNG may get some=
=20
variations from the uninitialized buffer so that its internal state may=20
benefit from it

That said, I am fine with this current patch. But if there is still lingeri=
ng=20
concern, I am equally fine to have it initialized to zero.

Thanks a lot
Stephan

> ---
> V1 -> V2: mark it as unpoison
> V2 -> V3: replace to sizeof, minimize the possibilities where
> inconsistencies can occur
>=20
>  crypto/jitterentropy-kcapi.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 1266eb790708..4020a6e41b0e 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -117,6 +117,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8
> *addtl, pr_warn_ratelimited("Unexpected digest size\n");
>  		return -EINVAL;
>  	}
> +	kmsan_unpoison_memory(intermediary, sizeof(intermediary));
>=20
>  	/*
>  	 * This loop fills a buffer which is injected into the entropy pool.


Ciao
Stephan


