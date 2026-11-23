Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448274;
	b=Zy4XzM7hayJ5XCCj8VLPWrAh/9eEkyi1zxAUiWEuYQW2tyEeCS+XTqIQJRBxxPaIClh/
	 62UT4feTxPvEH6umcLKgGbGd1H+PGRO7DNgUTbbE6GxKUoKzivLj/xd4uwe909rryflok
	 4lmr28KqgBVQwbWuFTmbl/l7LXn/0Bj7+7ZD/jc4fUrh+84g+SFJtlvunNLEBdpTLfbaN
	 qPoZDODMajcIY4KSrJTdF8PNi+8zeyomCzzy2jSF2h8/IjM6UtlPUjuc19KNu/r1vKCXz
	 H4oMF72VJQtCE4HkURUn56mMvfjSMjeEVR1lE/6CjxYtcz9UWdcgwFiI6dc77nmKq0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448274;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2crCq0yQ/HYHKeHt29ATUUe8VLTaIPIAejwpAipPP1E=;
	b=MjxAu9l+6MjnhRcjz1GCfrIYwhEgKxHGmPSVbXdgC3cbtgt7dIaXMspTiRdqfKVIhBL5
	 P+PufdZbo4ztyLuwR/KsgUGCq2AwiQWBi7qeAwm4JqmtN7trhj2ONE+wy3+c035NmExOg
	 ltLavtJYxOBIrXvP0b48oNM4H4lI9K33Y6Gvuig7qHmATqODHocRcQBoComDUFzDVi8zg
	 m563R8o4+R0PhrpXrPmOabtAMzA7mrzheP79nV6RU7KAZ5jSf1o6vA2kQsdhE/5xdkV+f
	 D+vPx0Jsi7gtNEAHGQQLabBn55L8UDeyktepDjWff0xwjvPlKCGn9EQncgvC9TQzjhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYCPWwqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0A9606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYCPWwqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B671F000C0;
	Mon, 23 Nov 2026 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448274;
	bh=2crCq0yQ/HYHKeHt29ATUUe8VLTaIPIAejwpAipPP1E=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=LYCPWwqM0abaqFXBJPa/FBcORfeBWHLRz/sboObyoDUWcullke27uwL9u7Vj/q8R4
	 5UYBMTI9U48jG4wIhnAyTz5t2fyjBW0vZzbut6QjDKwyrnPA5u4idvG+2j41TReWws
	 JQ9xCKNaqgJlAa7lz2McQpCxUAYG7eVaMIOXVFEQ4xwqEzARPqMln1tk4B8AFMBa3W
	 +u3EOBBb9ahufhYBUGvNSnnsF7TsakTnmewuA1NENBrcLI7SRqo3XgAz64lrxbWjFs
	 c04gwlzbxbz1JqcpwRKLDUDemjHMMRBkr83NDdKZnTef34Mu8Y4oBYsz8/vvW2OpHu
	 dJWxI9+Kc1p5w==
Message-ID: <sashiko-outbox-229585@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/10] crypto: nx - Fix bounce buffer copy overflow in
 decompress()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lee Jones" <lee@kernel.org>, "Haren Myneni" <haren@us.ibm.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1MgR1JP?=
 =?utf-8?b?VVAp?= <chleroy@kernel.org>, =?utf-8?b?Uml0ZXNoIEhhcmphbmkg?=
 =?utf-8?b?KElCTSk=?= <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Thorsten
 Blum" <blum@kernel.org>, "Bulent Abali" <abali@us.ibm.com>, "Robert
 Jennings" <rcj@linux.vnet.ibm.com>, "Seth Jennings" <sjenning@linux.vnet.ibm.com>, "Dan
 Streetman" <ddstreet@ieee.org>, linux-crypto@vger.kernel.org
In-Reply-To: <20261123151055.2533735-4-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-4-lee@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 15:37:53 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] crypto: nx: out-of-bounds write in compress() [1]
--

commit 6d00d8097910c1ed1be4ad69177b9d0594c5365b
Author: Lee Jones <lee@kernel.org>

crypto: nx - Fix bounce buffer copy overflow in decompress()

This commit validates that the decompressed length does not exceed the
remaining destination buffer capacity before copying from ctx->dbounce
into p->out in decompress().

> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index b4404a1389621..4f96c2b2397be 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -427,8 +427,11 @@ static int decompress(struct nx842_crypto_ctx *ctx,
>  	if (ignore)
>  		pr_debug("ignoring last %x bytes\n", ignore);
> =20
> -	if (dst =3D=3D ctx->dbounce)
> +	if (dst =3D=3D ctx->dbounce) {
> +		if (dlen > p->oremain)
> +			return -ENOSPC;
>  		memcpy(p->out, dst, dlen);
> +	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can compress() also
overflow p->out when copying from ctx->dbounce [1]?

When compress() jumps to the nospc fallback to use ctx->dbounce, it sets
dlen to min(p->oremain, BOUNCE_BUFFER_SIZE) and dskip to 0 without
subtracting hdrsize:

drivers/crypto/nx/nx-842.c:compress() {
	...
	if (dlen < c->minimum) {
nospc:
		dst =3D ctx->dbounce;
		dlen =3D min(p->oremain, BOUNCE_BUFFER_SIZE);
		dlen =3D round_down(dlen, c->multiple);
		dskip =3D 0;
		pr_debug("using comp dbounce buffer, len %x\n", dlen);
	}
	...
	dskip +=3D hdrsize;

	if (dst =3D=3D ctx->dbounce)
		memcpy(p->out + dskip, dst, dlen);
	...
}

After compression completes, dskip is incremented by hdrsize and dlen
bytes are copied to p->out + dskip.  If the compressed output reaches the
dlen limit, hdrsize + dlen exceeds p->oremain and memcpy() writes up to
hdrsize bytes past the end of p->out before update_param() checks the
remaining space.

[1] https://sashiko.dev/#/bug/linux-f0b43673-8815-4f13-a7d9-658940af36b2

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123151055.2533=
735-1-lee@kernel.org?part=3D3
