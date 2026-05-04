Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659542D238A
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 06:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777877678; cv=none; b=JzkKbPxd7iWWSpcJfLJcoonQq8IWlXc7EUShucDM20IyhH6x3NAKfjZk9L09XJ5ZnU7gkHr4oNtzSVdy440SCQ/2PBn9KhaHunYijjQFQ/DQHyRvOK55IdMovGVE9kEcpP9nXtYdXU4Ftse2JHZ/8JD3NtiyzWjohFHRUUWTa1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777877678; c=relaxed/simple;
	bh=t3yyCXoUlFSP6J1vBioofcJE0mnlQ9kZBF98z9J5in0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzHQQe6nVDcK6Mn6dYpPeufzoPQ2HwlAaa9V0XMDnfjyH9LrHvMkyoc+zdUQIuDhUW1oPwywl1IjwanafeSEM4c/Yqy27B6CWSn1NHu6d8wLnRgcuCU2q2PNoI2Xo2CD3pVPyfjqQGrw7nSTnKOcoID3dtd/PMRsEvqzHNZs/QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adDGCnUI; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adDGCnUI"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-651b4d09141so4581714d50.1
        for <linux-crypto@vger.kernel.org>; Sun, 03 May 2026 23:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777877674; x=1778482474; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q3PtWOL8UivZc2UE5OchDAX7JIISrPFY46s4A3DMNx4=;
        b=adDGCnUIIDzfScx85smPY4Dm8fYL6QoObfLQJrmEnVlhLtKXPY1QqPIv6rCTHqwcr3
         /Wav789i6WRquPReHO2j5r25MHLidc+uD2NOVZbpMtLRCGCY+O9z8aa/I9YIasSonIID
         uxTxp0s9iLD5sPGKIeFF3fOGxz2OgZ6yfpUfi3S/pmUDJ+HwpA73TlptbKPwdbRyiltu
         +cWTlTDIsz2RZrEXzBE/f+0G8kErOIhaPCcjkPmkmnYtUInqbUxdNnupMb/0BrAKVT5t
         D19qdNwl95k5J0rzUOat9S7bkbPsaosapbEKuGvZzXPRL8OAi/mk5UBapWRsOFtytXli
         ltOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777877674; x=1778482474;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3PtWOL8UivZc2UE5OchDAX7JIISrPFY46s4A3DMNx4=;
        b=HMyTE+INly6W9QHUd/Yc8wVqFtZ7bqNxDP++abXvF9m/VNmSJBdxyiBb7AHcKDyDrG
         16pbMFku8kbyakWV/tSg6iAYKzh8HXkh+s9z9Q90EIiM0xdX629q1AvEbTyFh9ONZDw4
         ECH2NM1nhaCESLRM8A/ja5vZqbGWWDRON/2wQ7ctEy/9J/kiC4WFhbJa0P+51BjLBXNL
         l0l1miPCKP4QJmKH3j88Pxfrr9OjVD5PJMBVbOk//nE1nptTg74HvJI/u04XrSa1KxG+
         B3QVhZRT0UUE1P6ftcyA5nlX/YMdo7nWXfrnBldOtKf2c94mowFx9lz/dvZoq9ti/4c8
         5fdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+SovmG/y2gi7IlYL1svmzB3HQ0uMRocFB4nRwhjLdAl2xiWbmlMMPY3foOY+Q0AjjDSEePbPqxDXDhUw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRxMxquuMel6MCxm0vRZCtly9ZQytVIB9vvfQKW07PSZMp//Gx
	CSNQIML4/kLqI/0R1q0Xg7pVgnY5GEKj0zms6Ka4/JLUpPuxNSjSAFU8
X-Gm-Gg: AeBDiev/8YvTbVYLpPXDiP/tSrpK1ncjDu1QnWh/diSRNyeDp0X6fxGsNoyEC6a3fP4
	tYVOopQGF5zyIlIHP5PCCGQeJ/fqEj8v9RLYb6TM8QZWptEcmyU/qs/ft5BsIX2Obnd73Iv2ZVq
	i6THTYZOLe/CbXQeV9LpBq1Dppd1WhD5GEnAgdqQJrJNsSTzPrtI9Rw8Ha7PNvkaaiCCbQl5XjF
	Q6gWsbDlA9kdQKiAbtmhzM9gUZ2QA2+QuxpMrVM9KUMC4q93JquFU0b9E6CmzUpUus8Mrc5Y9x1
	MhgKUMMz1pb3+6Xa2Bc2oU/U/cWl+R+6DK7ZTIPdbVWDIS5JeEGyjtxSyrr7fDEwNhEmCiUewiP
	6AzWf/FjzUmtPnPxlMnMKBj/NTkdSTy0d9P2kCZMs0ySVIMgsTt4SqnEpgevu8tfxwTCs8atNMk
	4teyTguOhCINRpy/8DMv16TauLMMIk3yf221HYGXnZduBMBD17J2racXq1NMfDVgGOmxYIdNnQW
	yYtyye2LFP0ibmh9Ie9n7BeNTcwfzoYnMb+Z7unjGWOugceWx/oPUj0aYFqmhM=
X-Received: by 2002:a05:690e:1186:b0:652:c12f:18cc with SMTP id 956f58d0204a3-65c3d0296c3mr6446418d50.29.1777877674154;
        Sun, 03 May 2026 23:54:34 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-150-190.cncrtn.broadband.dynamic.tds.net. [69.131.150.190])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c2df83478sm5043742d50.2.2026.05.03.23.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 23:54:32 -0700 (PDT)
Message-ID: <79b24e6f-91a2-4dd0-a5f2-c01a9247ea9c@gmail.com>
Date: Mon, 4 May 2026 02:54:27 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>,
 Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>,
 Tim Becker <tjbecker@theori.io>, Feng Ning <feng@innora.ai>,
 stable@vger.kernel.org
References: <20260504061532.172013-1-ebiggers@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260504061532.172013-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iz8Wad90fpAUJ1vk3kybhMyP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iz8Wad90fpAUJ1vk3kybhMyP
Content-Type: multipart/mixed; boundary="------------RFg6B0Sa8aDCRWUoxK0mZBek";
 protected-headers="v1"
Message-ID: <79b24e6f-91a2-4dd0-a5f2-c01a9247ea9c@gmail.com>
Date: Mon, 4 May 2026 02:54:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>,
 Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>,
 Tim Becker <tjbecker@theori.io>, Feng Ning <feng@innora.ai>,
 stable@vger.kernel.org
References: <20260504061532.172013-1-ebiggers@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260504061532.172013-1-ebiggers@kernel.org>

--------------RFg6B0Sa8aDCRWUoxK0mZBek
Content-Type: multipart/mixed; boundary="------------vKv7YvnUzM2a5flb5KLz0xGw"

--------------vKv7YvnUzM2a5flb5KLz0xGw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/4/26 02:15, Eric Biggers wrote:
> The zero-copy support is one of the riskiest aspects of AF_ALG.  It
> allows userspace to request cryptographic operations directly on
> pagecache pages of files like the 'su' binary.  It also allows userspac=
e
> to concurrently modify the memory which is being operated on, a huge
> recipe for TOCTOU vulnerabilities.
>=20
> While zero-copy support is more valuable in other areas of the kernel
> like the frequently used networking and file I/O code, it has far less
> value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
> for backwards compatibility with a small set of userspace programs such=

> as 'iwd' that haven't yet been fixed to use userspace crypto code.
>=20
> Originally AF_ALG was intended to be used to access hardware crypto
> accelerators.  However, it isn't an efficient interface for that anyway=
,
> and it turned out to be rarely used in this way in practice.
>=20
> Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
> benefits.  Just remove it.
>=20
> Note that this isn't a hard break, since the splice syscall is still
> supported.  The data is just now copied instead.  So it still works,
> just a bit slower in some cases.
>=20
> Tested with libkcapi/test.sh.  All its test cases still pass.  I also
> verified that this would have prevented the copy.fail exploit as well.
>=20
> Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for=
 skcipher operations")
> Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
> Reported-by: Taeyang Lee <0wn@theori.io>
> Reported-by: Feng Ning <feng@innora.ai>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/crypto/userspace-if.rst | 30 ++---------
>  crypto/af_alg.c                       | 73 +++++++++------------------=

>  crypto/algif_aead.c                   |  8 +--
>  3 files changed, 32 insertions(+), 79 deletions(-)
>=20
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/cryp=
to/userspace-if.rst
> index 021759198fe7..80eb2819901a 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -325,37 +325,13 @@ CRYPTO_USER_API_RNG_CAVP option:
>     but only after the entropy has been set.
> =20
>  Zero-Copy Interface
>  -------------------
> =20
> -In addition to the send/write/read/recv system call family, the AF_ALG=

> -interface can be accessed with the zero-copy interface of
> -splice/vmsplice. As the name indicates, the kernel tries to avoid a co=
py
> -operation into kernel space.
> -
> -The zero-copy operation requires data to be aligned at the page
> -boundary. Non-aligned data can be used as well, but may require more
> -operations of the kernel which would defeat the speed gains obtained
> -from the zero-copy interface.
> -
> -The system-inherent limit for the size of one zero-copy operation is 1=
6
> -pages. If more data is to be sent to AF_ALG, user space must slice the=

> -input into segments with a maximum size of 16 pages.
> -
> -Zero-copy can be used with the following code example (a complete
> -working example is provided with libkcapi):
> -
> -::
> -
> -    int pipes[2];
> -
> -    pipe(pipes);
> -    /* input data in iov */
> -    vmsplice(pipes[1], iov, iovlen, SPLICE_F_GIFT);
> -    /* opfd is the file descriptor returned from accept() system call =
*/
> -    splice(pipes[0], NULL, opfd, NULL, ret, 0);
> -    read(opfd, out, outlen);
> +AF_ALG used to have zero-copy support, but it was removed due to it be=
ing a
> +frequent source of vulnerabilities.  For backwards compatibility the s=
plice
> +system call is still supported, but the data will simply be copied.
> =20
> =20
>  Setsockopt Interface
>  --------------------
> =20
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 5a00c18eb145..fce0b87c2b65 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -971,11 +971,11 @@ int af_alg_sendmsg(struct socket *sock, struct ms=
ghdr *msg, size_t size,
>  		struct scatterlist *sg;
>  		size_t len =3D size;
>  		ssize_t plen;
> =20
>  		/* use the existing memory in an allocated page */
> -		if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {
> +		if (ctx->merge) {
>  			sgl =3D list_entry(ctx->tsgl_list.prev,
>  					 struct af_alg_tsgl, list);
>  			sg =3D sgl->sg + sgl->cur - 1;
>  			len =3D min_t(size_t, len,
>  				    PAGE_SIZE - sg->offset - sg->length);
> @@ -1015,64 +1015,41 @@ int af_alg_sendmsg(struct socket *sock, struct =
msghdr *msg, size_t size,
>  				 list);
>  		sg =3D sgl->sg;
>  		if (sgl->cur)
>  			sg_unmark_end(sg + sgl->cur - 1);
> =20
> -		if (msg->msg_flags & MSG_SPLICE_PAGES) {
> -			struct sg_table sgtable =3D {
> -				.sgl		=3D sg,
> -				.nents		=3D sgl->cur,
> -				.orig_nents	=3D sgl->cur,
> -			};
> -
> -			plen =3D extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
> -						  MAX_SGL_ENTS - sgl->cur, 0);
> -			if (plen < 0) {
> -				err =3D plen;
> +		do {
> +			struct page *pg;
> +			unsigned int i =3D sgl->cur;
> +
> +			plen =3D min_t(size_t, len, PAGE_SIZE);
> +
> +			pg =3D alloc_page(GFP_KERNEL);
> +			if (!pg) {
> +				err =3D -ENOMEM;
>  				goto unlock;
>  			}
> =20
> -			for (; sgl->cur < sgtable.nents; sgl->cur++)
> -				get_page(sg_page(&sg[sgl->cur]));
> +			sg_assign_page(sg + i, pg);
> +
> +			err =3D memcpy_from_msg(page_address(sg_page(sg + i)),
> +					      msg, plen);
> +			if (err) {
> +				__free_page(sg_page(sg + i));
> +				sg_assign_page(sg + i, NULL);
> +				goto unlock;
> +			}
> +
> +			sg[i].length =3D plen;
>  			len -=3D plen;
>  			ctx->used +=3D plen;
>  			copied +=3D plen;
>  			size -=3D plen;
> -		} else {
> -			do {
> -				struct page *pg;
> -				unsigned int i =3D sgl->cur;
> -
> -				plen =3D min_t(size_t, len, PAGE_SIZE);
> -
> -				pg =3D alloc_page(GFP_KERNEL);
> -				if (!pg) {
> -					err =3D -ENOMEM;
> -					goto unlock;
> -				}
> -
> -				sg_assign_page(sg + i, pg);
> -
> -				err =3D memcpy_from_msg(
> -					page_address(sg_page(sg + i)),
> -					msg, plen);
> -				if (err) {
> -					__free_page(sg_page(sg + i));
> -					sg_assign_page(sg + i, NULL);
> -					goto unlock;
> -				}
> -
> -				sg[i].length =3D plen;
> -				len -=3D plen;
> -				ctx->used +=3D plen;
> -				copied +=3D plen;
> -				size -=3D plen;
> -				sgl->cur++;
> -			} while (len && sgl->cur < MAX_SGL_ENTS);
> -
> -			ctx->merge =3D plen & (PAGE_SIZE - 1);
> -		}
> +			sgl->cur++;
> +		} while (len && sgl->cur < MAX_SGL_ENTS);
> +
> +		ctx->merge =3D plen & (PAGE_SIZE - 1);
> =20
>  		if (!size)
>  			sg_mark_end(sg + sgl->cur - 1);
>  	}
> =20
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index cb651ab58d62..c6c2ce21895d 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -7,14 +7,14 @@
>   * This file provides the user-space API for AEAD ciphers.
>   *
>   * The following concept of the memory management is used:
>   *
>   * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SG=
L is
> - * filled by user space with the data submitted via sendmsg (maybe wit=
h
> - * MSG_SPLICE_PAGES).  Filling up the TX SGL does not cause a crypto o=
peration
> - * -- the data will only be tracked by the kernel. Upon receipt of one=
 recvmsg
> - * call, the caller must provide a buffer which is tracked with the RX=
 SGL.
> + * filled by user space with the data submitted via sendmsg.  Filling =
up the TX
> + * SGL does not cause a crypto operation -- the data will only be trac=
ked by the
> + * kernel. Upon receipt of one recvmsg call, the caller must provide a=
 buffer
> + * which is tracked with the RX SGL.
>   *
>   * During the processing of the recvmsg operation, the cipher request =
is
>   * allocated and prepared. As part of the recvmsg operation, the proce=
ssed
>   * TX buffers are extracted from the TX SGL into a separate SGL.
>   *
>=20
> base-commit: 6d35786de28116ecf78797a62b84e6bf3c45aa5a

In light of https://lore.kernel.org/all/afYcc-tZFwvZZo76@ans-MacBook-Pro.=
local/,
yes please!

Should there be a Link: tag referencing that email?

With or without it:

Reviewed-by: Demi Marie Obenour <demiobenour@gmail.com>
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------vKv7YvnUzM2a5flb5KLz0xGw
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

--------------vKv7YvnUzM2a5flb5KLz0xGw--

--------------RFg6B0Sa8aDCRWUoxK0mZBek--

--------------iz8Wad90fpAUJ1vk3kybhMyP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmn4QqQACgkQszaHOrMp
8lOMdA/8CvV5k6VlmK8MMHItznw1oSct2L2hpgyojlpEazL4ZWm5xii1SsLeVFJ8
ogn+r57Ww3hxgJOyghwcPfuX8/hejoF5fmO1aT0/b+k5oGA4RXXVOgZE5LJzS+m8
c9Z8VRA4z7CNP2darthmD8qARYpvjnSOqlJBXAW0bfY6vOiesUOkIk2Sje6w73O0
36F1Yc04Ut96PpRfxv4XGC5aI3kKuqFonSz0TQRGPIFq3zuG86QBbTFCo9e2TV3v
iXYj9L67MygPZuOWa57yOosRis/IyAv5kA3UC4w8afAKhBjBt8O8e+ainYKRQ4UN
E/81KLFdU+Zz4BeSNYbYChy0wSr9Z0dYbzxgEbU6Y6sYqxwx5QKdMxoxojFTZUkE
idfifOlTQ2JUF6N93yoMiQ77yyTJu3VftemITFrs8IOYjCLqLgEutv4CrJqAwPFU
VAZPBf9LTCipoFaJtrTEVSQ8Z+IP6p65MZdIrBJwUFzTWdP9UaY3scD6V8XObH0l
NRMeHjZIeoBhZsVhbrb2ZRmpLleXJr3jffRg3lz9MYYYS6YKJfV/yDRBbUY9GZ6s
nl6HKojnGwGPLozq2QVOupv9YeCsJSE0HfHohZkbhNpbhXllhCuPH/41Wi0+v3qa
9z4FkSQ8PctwMtIr5w9LdudI7qdO6APcHlEzpW9mih3BI4IRn2c=
=sIls
-----END PGP SIGNATURE-----

--------------iz8Wad90fpAUJ1vk3kybhMyP--
