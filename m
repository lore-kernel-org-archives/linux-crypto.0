Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74C238AC8C
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235452; cv=none; b=e7cG2dy9LaOceNnIO1do+CYGSD0BA0n0sse41pQz9x1YjNCvtCZZxEFhPsWEJt1jHPPkV3j+hZi+3LpuT0Qi0x14+xIfHrYD70eSWm+9vHcEiylIro7jrgfIeF3CXwGRBKWW5QujjHtho6NEnXz6vWrP42HGULw19PxnPE8SgO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235452; c=relaxed/simple;
	bh=fBD+5DExfaYK3P8CKt7zVDHJXxAAt+bPfNDioBKgBz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fyxe+aYLIcW0MTKThDqbWC18uxQkNn7eU1kDOM9EcCT2m4hx5zgZnc85uThbi5VbwdNzkpj66uTiH1CU6SDvD/EMHAEN9ImWCfrQJ2UC5WJoFyLeJATLZHQ5R1eVjxlHwFD0ZzvdyPKrZjhHJ5X/8ir1HPzFnD47Zem3Xzm+ui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VR7fqfMZ; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VR7fqfMZ"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7fd3801ca22so1634377b3.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782235450; x=1782840250; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ToN0gHsD8VJSvIoHxpeRalPyzQFarCO6q3R3P+Q79UM=;
        b=VR7fqfMZgPuKmfYjlk2Sx+0apFswIxWX59cLTC7795djcRFqaHAGuhStN+x1Wn9whp
         /eWeqG2ikj+0CQ3F3wib9P8RUxR5sg6+KYaLTx2pRCDeCEWBzNkaS7VTv0sdKt+fuHyL
         +GSrIBUeaYlJPxF4RCHj2dK6aCGX3OjKzYbF3RqVjR5oqoOhWstZXvIxjvAm4zmkHA48
         tZod/Qt+J+RdMO/SlGqj/lxyd6F94YKLyKqQr6ZX1DuiBbAAV2ZuYn8OlmLsSMKQmZ8Z
         +9qbMItRXluqx1MafLoLewUUR/ZBIjZAe/2tX2sKFDRVL3ADKmYPl9Bcm8oksWsZ8bCa
         w2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782235450; x=1782840250;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ToN0gHsD8VJSvIoHxpeRalPyzQFarCO6q3R3P+Q79UM=;
        b=ARSXd7YcteO5kdHMnPaA/yfMRvNcvt1xRgZvwP2jsRH7A8IecLRQJmAGV3kWvEm6SX
         604QGI/f2+AEd8/qOxYAM7MLyKtLK+TLxFP0ZoVm91ZrenqRwm/U9y12lAVS903LYx3r
         vv8mwlxg8gVWgE0hBbo2mtGw1lDsJ4YYW0ITMLNj/J5XSEQDrqkUs/KjWawE5BuhC/ZN
         6TvrPTECLQ0TtLkECkRWebF9qQTTnUJNgVVJUwgE2z6Adyok9Xfi9eo+k8HCWG3VwdSE
         qL5c0M6CNOOzaPRnWXVu5CkMkW91WNbpdmGvQUXMEekO+WO6LAYyyiV+e4roNE2q7uUn
         jSCg==
X-Forwarded-Encrypted: i=1; AHgh+RqkjjVEv293KqLZ8v62lHCIZol7I4jVrfhH930qA9SrDPFYgvU6EGc26iNV5tBydmS5tTGGqVCpE5ISJ7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxKP5R6bNAMDq5jopczAvTa9dbT8n31MM1SRoTToQfVLcAy6MX
	t2mv2t3AVWGlouOr9l0Ipr0zGfuD0U5bLuqp4xlulJXx43fDiVfvMGdm
X-Gm-Gg: AfdE7ckwBD7JSMlmcOwDq6isyxH3IDaq/M6dee4CvpQffSQSH/+NUHS6rTY7954Mhwb
	IO7Ry2QpNiILAUIjGVHbVSBNHET90TVCk6g3fisIGiKGf0V0D/fcbCxDGFR6smF4zCYzCW/KKBj
	q7Ksnbocy1vvmIwzd4XQGSgl3rxL7KNan4GE6pt0zMKt9n1jtU7j1wV8TxM9WAtkSUjfV5GRVGu
	TvhZ1McbQDKVW4VE0AwxuvqaFGiuEjSf9tcnl6pCdd9VThjeylfavphEGLzJ5kvyb7SX0aoArKZ
	fycF5mc6841SjX11jdEV3U9Zd9xWwlX27aJrVkq2x+NHxRoExzVk1xoVMaw9i+DA0cauy5iA4Sg
	arrxRTjjdgM5dw99CO0Hz+LvXigtM+exwdPp7cROKx13+gOSMTmzBHxnU0OQONxTyDL/FFajKlI
	d83MRpqyzhYa3ggU+qvmIx0PlxoUseHDW6kDu2dxpcirFRTo8iT9P/dBYWpzS7rq/0VRBW24qUH
	wZFUaPWZJozo/vLJ8BsTBom9gCn
X-Received: by 2002:a05:690c:e36a:b0:7ff:1000:9c1a with SMTP id 00721157ae682-80266163257mr190396367b3.26.1782235449584;
        Tue, 23 Jun 2026 10:24:09 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-147-66.cncrtn.broadband.dynamic.tds.net. [69.131.147.66])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025c96fdb3sm48164007b3.1.2026.06.23.10.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 10:24:08 -0700 (PDT)
Message-ID: <34e20a64-17d3-4994-89f1-6084cd4fae36@gmail.com>
Date: Tue, 23 Jun 2026 13:24:01 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
 linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
 Andy Lutomirski <luto@amacapital.net>
References: <20260622234803.6982-1-ebiggers@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Q0SecAFdwyfq6TUsxDpKlVgR"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Q0SecAFdwyfq6TUsxDpKlVgR
Content-Type: multipart/mixed; boundary="------------06Jbuzx7taoAbDNVcFc1QAHk";
 protected-headers="v1"
Message-ID: <34e20a64-17d3-4994-89f1-6084cd4fae36@gmail.com>
Date: Tue, 23 Jun 2026 13:24:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
 linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
 Andy Lutomirski <luto@amacapital.net>
References: <20260622234803.6982-1-ebiggers@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>

--------------06Jbuzx7taoAbDNVcFc1QAHk
Content-Type: multipart/mixed; boundary="------------452gzRjdYchSV4WeKzfxX0An"

--------------452gzRjdYchSV4WeKzfxX0An
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 6/22/26 19:48, Eric Biggers wrote:
> AF_ALG is a frequent source of vulnerabilities and a maintenance
> nightmare.  It exposes far more functionality to userspace than ever
> should have been exposed, especially to unprivileged processes.  Recent=

> exploits have targeted kernel internal implementation details like
> "authencesn" that have zero use case for userspace access.
>=20
> Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> libraries exist.  And when it is used, only some functionality is known=

> to be used, and many users are known to hold capabilities already.
> iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b8=
32d@gmail.com/).
>=20
> Thus, let's restrict the set of allowed algorithms by default, dependin=
g
> on the capabilities held.
>=20
> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
>=20
>     0: unrestricted
>     1: limited functionality
>     2: completely disabled
>=20
> Set the default value to 1, which enables an algorithm allowlist for
> unprivileged processes and a slightly longer allowlist for privileged
> processes.
>=20
> Note that the list may be tweaked in the future.  However, the common
> use cases such as iwd and bluez are taken into account already.  I've
> tested that iwd still works with the default value of 1.
I think there is room for something in-between the allowlist provided
here and "no restrictions".  For instance, I think it makes sense
to have a mode that allows modern=C2=B8 widely-used algorithms (AES-GCM,
ChaCha20-Poly1305, SHA-3, HMAC, etc) to all users.

This makes it less likely someone turns off all restrictions.

XFRM allows providing an arbitrary algorithm name, and it appears to
be accessible in unprivileged user namespaces.  That also needs an
allowlist.
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 787aac8aeb24..b9217f9086aa 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -32,10 +32,15 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
> =20
> +static const struct af_alg_allowlist_entry aead_allowlist[] =3D {
> +	{ "ccm(aes)", true }, /* bluez */
> +	{},
> +};
> +
>  static inline bool aead_sufficient_data(struct sock *sk)
>  {
>  	struct alg_sock *ask =3D alg_sk(sk);
>  	struct sock *psk =3D ask->parent;
>  	struct alg_sock *pask =3D alg_sk(psk);
> @@ -342,10 +347,16 @@ static struct proto_ops algif_aead_ops_nokey =3D =
{
>  	.poll		=3D	af_alg_poll,
>  };
> =20
>  static void *aead_bind(const char *name)
>  {
> +	int err;
> +
> +	err =3D af_alg_check_restriction(name, aead_allowlist);
> +	if (err)
> +		return ERR_PTR(err);
> +
>  	return crypto_alloc_aead(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
> =20
>  static void aead_release(void *private)
>  {
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 5452ad6c1506..a8d958d51ece 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -14,10 +14,28 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
> =20
> +static const struct af_alg_allowlist_entry hash_allowlist[] =3D {
> +	{ "cmac(aes)", true }, /* iwd, bluez */
> +	{ "hmac(md5)", true }, /* iwd */
> +	{ "hmac(sha1)", true }, /* iwd */
> +	{ "hmac(sha224)", true }, /* iwd */
> +	{ "hmac(sha256)", true }, /* iwd */
> +	{ "hmac(sha384)", true }, /* iwd */
> +	{ "hmac(sha512)", true }, /* iwd, sha512hmac */

Should this entry have privileged =3D false?  sha512hmac doesn't
need privileges.

> +	{ "md4", true }, /* iwd */
> +	{ "md5", true }, /* iwd */
> +	{ "sha1", false }, /* iwd, iproute2 < 7.0 */
> +	{ "sha224", true }, /* iwd */
> +	{ "sha256", true }, /* iwd */
> +	{ "sha384", true }, /* iwd */
> +	{ "sha512", true }, /* iwd */
> +	{},
> +};
> +
>  struct hash_ctx {
>  	struct af_alg_sgl sgl;
> =20
>  	u8 *result;
> =20
> @@ -380,10 +398,16 @@ static struct proto_ops algif_hash_ops_nokey =3D =
{
>  	.accept		=3D	hash_accept_nokey,
>  };
> =20
>  static void *hash_bind(const char *name)
>  {
> +	int err;
> +
> +	err =3D af_alg_check_restriction(name, hash_allowlist);
> +	if (err)
> +		return ERR_PTR(err);
> +
>  	return crypto_alloc_ahash(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
> =20
>  static void hash_release(void *private)
>  {
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 4dfe7899f8fa..bd522915d56d 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -48,10 +48,14 @@
> =20
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
>  MODULE_DESCRIPTION("User-space interface for random number generators"=
);
> =20
> +static const struct af_alg_allowlist_entry rng_allowlist[] =3D {
> +	{},
> +};

Can this whole file be deleted?  You wrote that it isn't actually used.

(snip)
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index df20bdfe1f1f..2b8069667974 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -32,10 +32,24 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
> =20
> +static const struct af_alg_allowlist_entry skcipher_allowlist[] =3D {
> +	{ "adiantum(xchacha12,aes)", false }, /* cryptsetup */
> +	{ "adiantum(xchacha20,aes)", false }, /* cryptsetup */
> +	{ "cbc(aes)", true }, /* iwd */
> +	{ "cbc(des)", true }, /* iwd */
> +	{ "cbc(des3_ede)", true }, /* iwd */
> +	{ "ctr(aes)", true }, /* iwd */
> +	{ "ecb(aes)", true }, /* iwd, bluez */
> +	{ "ecb(des)", true }, /* iwd */
> +	{ "hctr2(aes)", false }, /* cryptsetup */
> +	{ "xts(aes)", false }, /* cryptsetup benchmark */
> +	{},
> +};

Do the cryptsetup ones really need to be accessible to unprivileged users=
?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------452gzRjdYchSV4WeKzfxX0An
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
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
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------452gzRjdYchSV4WeKzfxX0An--

--------------06Jbuzx7taoAbDNVcFc1QAHk--

--------------Q0SecAFdwyfq6TUsxDpKlVgR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmo6wTIACgkQszaHOrMp
8lPcqxAAoFqgS6oQcaTSm23ZpuFp00BPOleSqDD1mTTKjRm+C6x/d/U2hTVCtEls
jO+o0069EBlaGa9murt3wA678qAiCJNGdxQByltMhA+WdRFVB/sP3I5PYFHvmTm8
nzFnOR/1nTr+nLXNmY0DpPknZ2Gin8OF3R8KBguMU0mfT1uUeDigCeEnVBF7Cygk
NpT/PAhAN4qn48rojNmRNk0q99kKUdIUwk8fN4thE6Zjgs7r7u6nwpaH5BZ3gOwV
9GiJCwzeFRDHW1B8EbT9JZD/L9g/0+JJGHZEz2r9uHnpJw5uEQ56LFgUYQp4EAhc
GYLdx13pnkZw3bkRlxUbZ5loPLiEO3QGlSILlu+ua/dYTbcBsdADqUu1tkHGKmyG
60PAe9P1X4JKqvotTEp09E7/qm2ssAG3ITeQ+FPIvhm0Dy0An8EJV/PSMHH4Mk6B
8/mv7e6SWpU/dvYob4TrZUMS3JPCFZI+KJluCT+u4j6wi5DahyP2BJXKxjhn7A93
B57eHvAuSPIUkbOSxOK6lOAEdu6zLb+JXluw+Jj6LRwrz89epKhZq8QdDvKp6Hxu
D7/y3BwIGxDST6i7o0sMjvh2sY41tOkzn6Oi0/5oElL0T76OMLCbWhCmBkb0ypoP
7q/qoneFpYV4kzPmETnZ58MpY1IzlBOHFPk8SpVmZ5XKHGXG+p8=
=ZdrN
-----END PGP SIGNATURE-----

--------------Q0SecAFdwyfq6TUsxDpKlVgR--
