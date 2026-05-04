Received: from mail-07.mail-europe.com (mail-07.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3098B37883D
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777910891; cv=none; b=cTTAeM6ptMN3BqFbCb7Pq52y9kxX8O/urO95O7KF1EdjFn2aH9cXUiLlzVpQMs5Ei0e3GB/eM9VtrgpPrsgP2Ubz1yX3MDBmRzA6E16zyWgYm+9UWufLqMlshMQGD66p6RHG9N0iDgN6RzOvqhfqCxcUDwD3+wYWGZOZKr30Z68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777910891; c=relaxed/simple;
	bh=hzjUnwKxhEcQzC7ABb0EA/AlNmtScwWRrUtAfNGi0c4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSNV1qVqo/52bF6KF5RGDreeXay2tv2kQYcxG9ZO32aqIlhyrcx2PlvOQfQia3kNtCZqGiHIB2QXq6EJ1N155S9dMgnXaBt2tfIglD4xN7GwqpOCRNq4E9LsCF4xPALhE2j9eBW74sMwadji9zVzzko0826ZPWhah7pSpLNGsyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chesswob.org; spf=pass smtp.mailfrom=chesswob.org; dkim=pass (2048-bit key) header.d=chesswob.org header.i=@chesswob.org header.b=huAyH/cH; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chesswob.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chesswob.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chesswob.org header.i=@chesswob.org header.b="huAyH/cH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chesswob.org;
	s=protonmail; t=1777910873; x=1778170073;
	bh=05GSM5+JyM2SRqyFSIqHDnC9+SWo8OxGguKKHBB6xes=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=huAyH/cHbrpSD0Sk9mDle+B3gymLRljOUTV1U96rrxxeY/MkZSkoV/M3T3E6iZWY7
	 ZjDPPTfPGTVc7P8c27m+DtzhaDXlSod7BoFIvGFqKrC7SOy3+UagcQcyMyc9NlhgIG
	 /J73VTK5bBQV1ryOzUKSR/qeWNLEFY2Ah975ExdZTqemV9CFWeJmY1WIh1q17pZWcZ
	 GbDWGrpGaoeKQOT+LaaaSJ1QkVANIjIFAsLKp7p09hqYoahFKOLSotnDMLjzjJ3hyR
	 2dSm3lmMPiXo+jJVsZJfmSuCzFwz+aoAGJWX5KR2boB5pma4VhMPlNA0FcGF4WVCqY
	 dGKce5G/BM8wA==
Date: Mon, 04 May 2026 16:07:45 +0000
To: Eric Biggers <ebiggers@kernel.org>
From: =?utf-8?B?4pK2bMOvIFDimK5sYXRlbA==?= <alip@chesswob.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>, Tim Becker <tjbecker@theori.io>, Demi Marie Obenour <demiobenour@gmail.com>, Feng Ning <feng@innora.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
Message-ID: <mCm5pwZUNYtOVDph2baJg3eAzArddjvFpx3Wwh2qiZfZXYtv-aUjlISuRg5HjuIMzGo51hxCazaH47gp9B_q7I4R4LVePKGkvhO9D0P4nCY=@chesswob.org>
In-Reply-To: <20260504061532.172013-1-ebiggers@kernel.org>
References: <20260504061532.172013-1-ebiggers@kernel.org>
Feedback-ID: 36787097:user:proton
X-Pm-Message-ID: 68ef365467466be7dba303109febffd394282967
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="------29d842f5a71d79209d92e6f4552a212d952e63927342755ac3048235f7127d07"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------29d842f5a71d79209d92e6f4552a212d952e63927342755ac3048235f7127d07
Content-Type: multipart/mixed;boundary=---------------------26cee6f8f420a8920b10e2568221139e

-----------------------26cee6f8f420a8920b10e2568221139e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

On Monday, 4 May 2026 at 08:17, Eric Biggers <ebiggers@kernel.org> wrote:

> The zero-copy support is one of the riskiest aspects of AF_ALG.  It
> allows userspace to request cryptographic operations directly on
> pagecache pages of files like the 'su' binary.  It also allows userspace
> to concurrently modify the memory which is being operated on, a huge
> recipe for TOCTOU vulnerabilities.
>
> While zero-copy support is more valuable in other areas of the kernel
> like the frequently used networking and file I/O code, it has far less
> value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
> for backwards compatibility with a small set of userspace programs such
> as 'iwd' that haven't yet been fixed to use userspace crypto code.
>
> Originally AF_ALG was intended to be used to access hardware crypto
> accelerators.  However, it isn't an efficient interface for that anyway,
> and it turned out to be rarely used in this way in practice.
>
> Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
> benefits.  Just remove it.
>
> Note that this isn't a hard break, since the splice syscall is still
> supported.  The data is just now copied instead.  So it still works,
> just a bit slower in some cases.

Syd sandbox uses AF_ALG zero-copy for its Force Sandboxing[1] and Crypt Sa=
ndboxing[1].
Zero-copy means Syd does not have to copy sandbox process data into its ow=
n address
space providing safety and security. Switching to read/write rather than p=
ipes and
splice breaks a fundamental safety guarantee for the sandbox. Please do no=
t break
userspace.

Will sendfile(2) continue to work? How can i test? Please help me.

[1]: https://man.exherbo.org/syd.7.html#Force_Sandboxing
[2]: https://man.exherbo.org/syd.7.html#Crypt_Sandboxing

> Tested with libkcapi/test.sh.  All its test cases still pass.  I also
> verified that this would have prevented the copy.fail exploit as well.
>
> Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for =
skcipher operations")
> Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
> Reported-by: Taeyang Lee <0wn@theori.io>
> Reported-by: Feng Ning <feng@innora.ai>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/crypto/userspace-if.rst | 30 ++---------
>  crypto/af_alg.c                       | 73 +++++++++------------------
>  crypto/algif_aead.c                   |  8 +--
>  3 files changed, 32 insertions(+), 79 deletions(-)
>
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypt=
o/userspace-if.rst
> index 021759198fe7..80eb2819901a 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -325,37 +325,13 @@ CRYPTO_USER_API_RNG_CAVP option:
>     but only after the entropy has been set.
>
>  Zero-Copy Interface
>  -------------------
>
> -In addition to the send/write/read/recv system call family, the AF_ALG
> -interface can be accessed with the zero-copy interface of
> -splice/vmsplice. As the name indicates, the kernel tries to avoid a cop=
y
> -operation into kernel space.
> -
> -The zero-copy operation requires data to be aligned at the page
> -boundary. Non-aligned data can be used as well, but may require more
> -operations of the kernel which would defeat the speed gains obtained
> -from the zero-copy interface.
> -
> -The system-inherent limit for the size of one zero-copy operation is 16
> -pages. If more data is to be sent to AF_ALG, user space must slice the
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
> -    /* opfd is the file descriptor returned from accept() system call *=
/
> -    splice(pipes[0], NULL, opfd, NULL, ret, 0);
> -    read(opfd, out, outlen);
> +AF_ALG used to have zero-copy support, but it was removed due to it bei=
ng a
> +frequent source of vulnerabilities.  For backwards compatibility the sp=
lice
> +system call is still supported, but the data will simply be copied.
>
>
>  Setsockopt Interface
>  --------------------
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 5a00c18eb145..fce0b87c2b65 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -971,11 +971,11 @@ int af_alg_sendmsg(struct socket *sock, struct msg=
hdr *msg, size_t size,
>  		struct scatterlist *sg;
>  		size_t len =3D size;
>  		ssize_t plen;
>
>  		/* use the existing memory in an allocated page */
> -		if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {
> +		if (ctx->merge) {
>  			sgl =3D list_entry(ctx->tsgl_list.prev,
>  					 struct af_alg_tsgl, list);
>  			sg =3D sgl->sg + sgl->cur - 1;
>  			len =3D min_t(size_t, len,
>  				    PAGE_SIZE - sg->offset - sg->length);
> @@ -1015,64 +1015,41 @@ int af_alg_sendmsg(struct socket *sock, struct m=
sghdr *msg, size_t size,
>  				 list);
>  		sg =3D sgl->sg;
>  		if (sgl->cur)
>  			sg_unmark_end(sg + sgl->cur - 1);
>
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
>
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
>
>  		if (!size)
>  			sg_mark_end(sg + sgl->cur - 1);
>  	}
>
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index cb651ab58d62..c6c2ce21895d 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -7,14 +7,14 @@
>   * This file provides the user-space API for AEAD ciphers.
>   *
>   * The following concept of the memory management is used:
>   *
>   * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL=
 is
> - * filled by user space with the data submitted via sendmsg (maybe with
> - * MSG_SPLICE_PAGES).  Filling up the TX SGL does not cause a crypto op=
eration
> - * -- the data will only be tracked by the kernel. Upon receipt of one =
recvmsg
> - * call, the caller must provide a buffer which is tracked with the RX =
SGL.
> + * filled by user space with the data submitted via sendmsg.  Filling u=
p the TX
> + * SGL does not cause a crypto operation -- the data will only be track=
ed by the
> + * kernel. Upon receipt of one recvmsg call, the caller must provide a =
buffer
> + * which is tracked with the RX SGL.
>   *
>   * During the processing of the recvmsg operation, the cipher request i=
s
>   * allocated and prepared. As part of the recvmsg operation, the proces=
sed
>   * TX buffers are extracted from the TX SGL into a separate SGL.
>   *
>
> base-commit: 6d35786de28116ecf78797a62b84e6bf3c45aa5a
> --
> 2.54.0
>
>
>
-----------------------26cee6f8f420a8920b10e2568221139e
Content-Type: application/pgp-keys; filename="publickey - alip@chesswob.org - 0x55838BF3.asc"; name="publickey - alip@chesswob.org - 0x55838BF3.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - alip@chesswob.org - 0x55838BF3.asc"; name="publickey - alip@chesswob.org - 0x55838BF3.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgp4c0JOQkdFWGppUUJDQUNvakdh
OTlKTnVENVFVQUxFeWNsd2Uxd01MVjVySmN5ZUhrM3NIOEVZTExsS2sKNm9wNlJ1bGhjUHdvMW5O
UmdXRkM4ZVBRaVNqMUpFRHFlRjQ3eXU5Y0xDU3BLeDRJWUVCZmxiSkwwcEI4CkpZdUk4NSs1OVE1
MXZaeUJuU3pTclBkcUdjSDM2d05wZ2d0N2lTcHVCVjk3clRWeE1ndHU4S0RtUisvSgpXQWQ2aWJl
UE93b3pnd1ZQV0VJY1NQd0FaUFlrcHJ5YnVCQkNWb2dmbUxLN09FWTNGMlozTzEyeGFHYVUKOGF6
RU5XZkI2YWJPVXM1ajlOaXJFMW5OV1h2V3FPSEVVa3grVmdFTUlkR2JTWWc5Y0dicDljUjZZZUFS
CnlpK0Y0MGJYMWZCS2ZVNFI3ZDVJQXY0Y2g2OTUxMDdrMW9qYmJCRjZDWFZ3V0tSSzBlRng1Tit6
QUJFQgpBQUhOSldGc2FYQkFZMmhsYzNOM2IySXViM0puSUR4aGJHbHdRR05vWlhOemQyOWlMbTl5
Wno3Q3dJMEUKRUFFSUFDQUZBbUVYamlRR0N3a0hDQU1DQkJVSUNnSUVGZ0lCQUFJWkFRSWJBd0ll
QVFBaENSRE81K2JkClErS2JzQlloQkZXRGkvTXNPNG9Ja28wR1NzN241dDFENHB1d2ZRRUgvaXpy
ekJkbzFGMHhYRjdNdjkzVgpkS2xFbWxlVk8rYnVjdU5hb2huNzFCNnl1SW5EM1NLYUM1SHF0dENK
MFlnNEYvQmIwdDlVYjBrWGkxOFUKRnRKU0V0TmxpUXJRTVJLZno3cFVqTHAwWkR1Y2xlaDVKUURs
ZHVZYlBVWEdGRDdnNVN6M3M4OXJuYWdXCnFKZkdxcWVlMWRDcXJYN0l2N0xwU2ZVbDlLdzhwSmRG
aFlsby95RW9SLzVnM2k1Yy8wOWtyaDdSUmk0agpPdVBteFMzWHN0aTVRT0x1U2JFUFlhWmhpZnZn
R3JOcVRyUTY0QUxDSjQ2Q3ZrQVQ0UGptWnpncE03cHcKeURQNEFJM25WRDNSQ0U4SHY3SjR2TmdC
Z1dvL1hKRlcyd0EydUFJV2xzbTd1eFNjMWh5OFVLVzFnTVl4Cm9PM1daeGl0TWQrMk81L1VuakRB
MHovT3dFMEVZUmVPSkFFSUFLOVF1b1pvNnloYlAvTVpvNDZnZjY0ZAo3Nmc5NE84VnJ1amxwazVE
cjg3T0wvVGY1dS9XMVRiZWhCYWppN0s5Z0NLczlVZUtUYldyanVlRnltSSsKY1lGMzZiclIrVFgw
cjFyMGRRbjl4Y0M2UnRDNDArV3lOdER3dTk5Ym1VZkF1dnJ5QmdOOW9aVHF1azlFClUydEUydjBh
ZTQ4MzU1L3AwQmR4c3Z6SmNPTW1FWENDZUpYcUdQa0Nrd3Fnc3JxazRTVHFQS2VRWTZXcgpOU0NX
cnE3WTVVYWVJWXZaUm5kMFRjV0ZLWVJLbk5XNkI2TnplZFdjRGJRazV1OUs2RzN5SS9vTy9EdzQK
a25PanVCWUNBa1Vodzk0M1ZwSi81N3RwMDFzd2hjdjVlcHFCYUhLNVNSYTg4TytOWUlRODdNNE5m
Z3lFCkg3Z0lDY0RTT1lMVURUM0ZmN1VBRVFFQUFjTEFkZ1FZQVFnQUNRVUNZUmVPSkFJYkRBQWhD
UkRPNStiZApRK0tic0JZaEJGV0RpL01zTzRvSWtvMEdTczduNXQxRDRwdXdiNmdILzNsaE8wdFJm
NTZrOG5Lc0hQZ0wKWHlVTUVQZWtoVFVMdG04RXFkekozSkhMUTJlNFBxWTQydlJhNEdEUzY5aVNL
UVR6UlhvdWhQWnBId2tCCnpKTk4xK3AxQ2V0LzNiRzJza0hlMkxwV2tGVVBad256MEE4SkZFMEhr
RmpZcUVLYXk3ZUs0LzIxTGhKUQpCZEZUSDMwbVBOMytiMVU5dmtOblBPY0ZQbHhmbmNzekk2Rk1j
NnU4dnYxNDc3SkFJcE0yV0pQcXRkUWMKSncvT2dHcjFaRW5OWi9icktWK3RQeHlEdmxtUklsQTNI
TnlyN0Q5NWN2bFlkVHl5emcyb3dFZHRMa3dlCjI0eUNUbWdHNnVoL29SazFsenFYcWZHaEpDYVpD
Zi83MlhpcWxSaDFRUko1ejdIM1NMcHF3MUszVXlQbApaNHg4NTliSFJMODNXeGpiR1FLMU8vMD0K
PXNtSUEKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
-----------------------26cee6f8f420a8920b10e2568221139e--

--------29d842f5a71d79209d92e6f4552a212d952e63927342755ac3048235f7127d07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsC5BAEBCgBtBYJp+MQ5CRDO5+bdQ+KbsEUUAAAAAAAcACBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnfJwvFZXqDol2mzFHuTjHqqJed8/EKkbFyzQl
LI8ZUU4WIQRVg4vzLDuKCJKNBkrO5+bdQ+KbsAAA230IAISOb12qrPcKmieN
8W5rdMMoVkbFAl0xGLm841PDrAnFyZzPaU4ilGV/+D15+hXB71LrNcLaMy9U
TX0CLDDmpg6zQOWSNsooGAqsxY/uduCEuaMndf65/85N2hGaplVULhNphQvn
FJ4OCuuYCXLQgA2BvxH9psOdXU6vLcskr9RRZBmSNFsIxMIEl1UsWsaUPvc0
ZQmmJMppN/TbinOVtsp/8UCrjkKP+bHfuRA5tSRf4jD9zGOIB5SFKw7cMoUO
IexhB3gt5LI8h1reFhtIFiiMgMw171wVPYpiSsmJ0LaYEsymEBGVqMSrf+EQ
OGjycUla+ZyvMfXnqvNENjUBj/o=
=vZlg
-----END PGP SIGNATURE-----


--------29d842f5a71d79209d92e6f4552a212d952e63927342755ac3048235f7127d07--

