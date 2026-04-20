Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED8150997;
	Mon, 20 Apr 2026 20:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.218
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776715258; cv=pass; b=q879wqeYaWuFAMTr7qtNdW6jLM8ELW0FRmduQw3yxTDomxwqP24cHMmiog+OqYhDYQtlHuVZ7iyJHAe++pSMec6jiU8RC36NDBJdk6usxw371g9OgLVGVexr/zp7oozRlrpP9Ot70mbRBtYoLgECjEiioJUSmWQzOO+WW0eE6yM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776715258; c=relaxed/simple;
	bh=eDwrB29ZVOrmTiWDSGnUUFbqOw3QX4341huCYoNKYrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAraA15xtJ1yhU10+9WJdyx2gJwIndeTJ4FMSvqhdfvwlH6Jn0cGFeQo//2Ylq5l7h8wrKIjaj1yA5g2E8tRHV8j8KTpN5Z7VQ8LhOwhEHBOFeqL1uxEqxUol99w7TcLm4r1j5OWaH46i9teIDgLrL5Hh4k8Rq6srds4xRTF+1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=KlR54cJ7; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=nkYWydtP; arc=pass smtp.client-ip=81.169.146.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="KlR54cJ7";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="nkYWydtP"
ARC-Seal: i=1; a=rsa-sha256; t=1776714895; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TtNnRvMTiOnqI1GrBYf3UtrgLNap4lAYtkbuMqhCYaoqf2JXU2JeGAsfZ10RjNUwci
    QEHthygqRvxRKCJp3J3bop4QehjxA5o3yoFRnRTmRAy3mZMe0SSSjjA0sR84rhko4FYu
    TxG7K7KCB/tcZ34yr+nNqfUNt+7Km9jqmuih5Gd4RwGEoTCPiPcTdziJs3LIWMRGFmB3
    mPEf8KTBqJgwT3q2+08DqCQ0qjzosxO2Axxckk9yt2FByxu4EHSwHSESv3bnpqy6g0ja
    vxxwpn6KxHa8mSv+hoTEtsbbKImgG665XnEI+M+MA4x0R9xspNI/NZyyRHLM8MQzMK8x
    DdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1776714895;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QnX3+jeSl6BuXpki9fATllvSzJ8fZETdgVtuyf+V9U0=;
    b=tpX/WFlZs/dfyL9MaocdDYc7LzYpRNMaPPdyfLRvvsauflkPKxxM2HE7tMRdEj8Cbx
    oa7HIngi0gbHFAs1kk8DGPftZHg2tmrnGbSZj3uFAmF0qHexJUYNSR7aq+aiWeay8X0W
    9IUL1JiA28XuJIkLuu/TVerUQSROeuWw5pL+zYC0qKvfkt2QfgaCIBq9z8X1jyAIfoqs
    2abseTHyquAKf5jRbKgfzasjIdiU7Cv/REyf943zibRiaCALphhV8cvHN2mV4ak8yDtY
    HWK6uO2a8lqyx4Rw19dXsdTW7AZPbZb9E5JRqG3oXovWloo907NoQwXwQwzCpGcjBhX+
    V6LQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1776714895;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QnX3+jeSl6BuXpki9fATllvSzJ8fZETdgVtuyf+V9U0=;
    b=KlR54cJ72FFqvx5ujz5gpBTMwkzeZldltsMamuGe9P6etz8scFKgqbDXQ2wq+DBbW8
    IlKA5qCGj+1i0v9W1sYlVoBBplwGsR/R7zSEA4CW7JsOakmceKdfg8KqfJyLtIVtEt2C
    jLPd16rM8/O5w7UM5o3whAhJqywSulRp5M+HZU97fUpNlpruNQIVdvdwHAa5eI7plAiG
    b3PSyaydOk6CHOfaqrRPUUGcysDpbalfDUAOBmLBtUZQbk3Gbjffx+pLPpP4J48h/0zj
    jtRe6A7908yBCMMlAoQGB3aMkTy+BKc4/zGPjoaBF14KMKQU5h7f/pi8x7Vfd8tFDDQH
    Tk8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1776714895;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QnX3+jeSl6BuXpki9fATllvSzJ8fZETdgVtuyf+V9U0=;
    b=nkYWydtPIFBMHZIP4FIWAOFzVU2oFMR5Lir13jl6UOsTUqB5uP04P/s55aWKEX3sD/
    pJqu6vqR8/JLZFlkjOAA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yWsdNeIHyFbS0Vgyta8="
Received: from tauon.localnet
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id f7792023KJsqx0b
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 20 Apr 2026 21:54:52 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
Date: Mon, 20 Apr 2026 21:54:48 +0200
Message-ID: <10862605.nUPlyArG6x@tauon>
In-Reply-To: <20260420174713.GC2221@sol>
References:
 <20260420063422.324906-1-ebiggers@kernel.org> <2300345.NgBsaNRSFp@tauon>
 <20260420174713.GC2221@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 20. April 2026, 19:47:13 Mitteleurop=C3=A4ische Sommerzeit schri=
eb Eric=20
Biggers:

Hi Eric,

> On Mon, Apr 20, 2026 at 04:40:18PM +0200, Stephan Mueller wrote:
> > Am Montag, 20. April 2026, 08:33:56 Mitteleurop=C3=A4ische Sommerzeit s=
chrieb
> > Eric Biggers:
> >=20
> > Hi Eric,
> >=20
> > > Remove the support for CTR_DRBG.  It's likely unused code, seeing as
> > > HMAC_DRBG is always enabled and prioritized over it unless
> > > NETLINK_CRYPTO is used to change the algorithm priorities.
> >=20
> > Just as an FYI: the CTR DRBG implementation is used, because it provides
> > massive superior performance. The CTR DRBG implementation is lined up to
> > use the AES-CTR mode directly. If you have an accelerated implementation
> > like AES- NI or ARM-CE, your performance increase is significant.
> >=20
> > For example, on my M4 development system, the generation of 1GB of data
> > from the CTR DRBG takes 90ms whereas the HMAC DRBG takes more than 4
> > seconds.
> >=20
> > The default of HMAC DRBG, however, was used since it has a simple logic
> > and
> > smaller code.
>=20
> I guess I have to ask: by "it is used", do you mean that it's used by a
> significant number of users, or is it more of a personal thing where you
> happen to be personally using it?=20

I see it being used by vendors that I work with. I neither have concrete=20
numbers or do I know how many machines are covered by it.

=46or any personal operations, I use the XDRBG anyway that would be separat=
ely=20
implemented and provided.

> Note that the only way to select it

The selection would always be done during compile time for those vendors.

> is directly by driver name (which has no in-kernel users), by running a
> custom userspace program that uses NETLINK_CRYPTO to modify the
> algorithm priorities.  I'm sure you know how to do the NETLINK_CRYPTO
> thing, but this very much seems like an idiosyncratic expert-level
> configuration that isn't really used in practice, similar to some other
> things that you've added like CONFIG_CRYPTO_JITTERENTROPY_MEMSIZE_*.
>=20
> And even if it's being used, does it really need to be?  Do you really
> need more than 250 MB/s of "FIPS-approved" random numbers, and from the
> kernel (not a userspace library)?

The performance also implies that for a given number of bits, it uses less =
CPU=20
cycles.


Ciao
Stephan


