Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D3440F8D7
	for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774461605; cv=pass; b=saRATmCT4shgoHHmFTPeD21EZNbUeaeRA62Ve7lSspcJy7MYYf9qVxj3M/uRSA/cjtSNpUu+tZxZUS9rWAib9K5073N/8NLPQCFGMz/frRheXRsIgDVn7FYsTre+y323nNnkou+n5aTCSGp6zhIkD/n0QsuQEV6oylkmNa9yPO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774461605; c=relaxed/simple;
	bh=b22F29d92okOuVhFZjzjJ3Mw4gc1RIWD7RrO6Frnx5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BsqjobqYuoMIn6xSPZw1u/mVu3FEsrF2zWm9knttHD5CivdV4OSwPbh2ddN9wWxjWzSDwmZ8nZa/bhiHOo9Y/vs3Kk27qkk8d0QW1u4cqDPhPmIbbleW2OX3QEnUxSAll1PJV/orFF0duGtNeiiCxAUAXrt5TGKlg1I7+dCA+uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=YELG1uVR; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="YELG1uVR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439b9b1900bso60377f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 11:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774461602; cv=none;
        d=google.com; s=arc-20240605;
        b=Q5sJ4UbIbDXZXjuNeZEawqFzaFuWWxzimtGtbhSj6NcE3xNkjZ4ks1t/O4dlCtbCPU
         lLbau4ahXfmkNWbu/h8Ka3t9uZADEQIAimG3nPHD3cxxobydD5A7yjAT4cd2HXe/ZE26
         Oi8hqaXq8Vz4uWpNEYKgNFveJMuttxKkMuKOhgGkhW/xJVHpKTd3shGOck6O4rpSPVI/
         /pQ19zvJEbeL5pzgCZVucp0vezxsVnMnYSSldNLcJyGObYFDCKO11tquPk6tyiHC4fnf
         8SSE1M3mX2mzNk1ATJOsSA8DkFbLrCRiB/RnLjzwhQaKgACl3asORyb4/CrAjBlqB7Aq
         vSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OvANr5VJGTIvIepqdzwF8TZzJNuHZQnFTWL0easjFTc=;
        fh=CuoFY8wqoeDTMQCrrHQwFswDkfUb3zP2XhjVmuT5HqI=;
        b=A9DY+hm4+96v0R9Kdc+rAsFKEGgInRt99dRT1Lafzcl0utXbHUc1n8WSokFaNEazhA
         nqnmSSHRd7jJZ0gWYEq5jHmVSm/rzgZ/44wyv1dmQcYM8GpzFk1PfaIZ1+W/p+rID3s0
         4vtr/rkT/FK/6Nbz2ghkjCmN2NfhtuRTHGVul+AgNUPAD9PnKWol9W/lyz3fS29BtrZu
         p3vR5PIcQkSpA5TNEcVBrc5Wx671SmRNWXuV/5kVy/t5ntJLFqCfl+tCKOmg/tS+WzVM
         Z1XNiqKqbnso3aUyBDU1/iVPNjlgKusAILXwSc/pKGbkpFji0ZmpURMmfMsKRi4q2X+K
         OsiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1774461602; x=1775066402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvANr5VJGTIvIepqdzwF8TZzJNuHZQnFTWL0easjFTc=;
        b=YELG1uVRZOU6vcNbriBRsEpc4FMnK0jtAoOzqg6mQINOIumdrWi+vxExbf2ye3l+Z3
         QDuD4k7KKBcTf/4+qANYKRfAj3D8i/Zjmk3WJbqvXVGFEPEMwPdAm/wvScbQArLLRhvk
         AMocRhnsBY4uEupj72CU9l3euisqJzMcM+pSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774461602; x=1775066402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OvANr5VJGTIvIepqdzwF8TZzJNuHZQnFTWL0easjFTc=;
        b=dY8LY9l8gGddqPJ76+LrRNeE6UuGywAzDYVvrlANbYhiQlWl2hhC0Gkq0ihNAmYIhA
         rzfinQ5VzlT8K1NvZ46sr6fQxla2Ca6W5fuAZ7+ovKJ49Vkp55nm29CVoZt3FaFhRGEK
         leaFSBljKZwh9EheOfGQnBXgAqPEvxe8xQippPG2KAAUzYq1c8SRyPWCMYjY7PPdNX/y
         lGAKjSETQIF0V/LoyZ0EgPHjWf88BUC9GIv7lxYTzNLEV9DkH1QxBwHuEVSzhNVDIZpJ
         +/MTOuRQyCuhfB02MGvh/Y9qtUNWpCws2k6v9eOGFjc3oExIvN9P+IoqwnlKXLfz1BYL
         hAOw==
X-Gm-Message-State: AOJu0YwCiov1otOgSOVFju0tyIWvu8Rc+nIBjH/AOOq2VUBjd13HqkpU
	fTABaPHSNvwQgrPiboq0HrUvV8tq0MwOb9sSehA+NOjk4Q3+xSPkRkaWxuzLQyuDwXq6uhY5TCo
	YtIUcHNPnDv7rQp/z4xzBCLroRV+xFF6b3p2IKHZp+w==
X-Gm-Gg: ATEYQzytu7Ne7GM+h4vRl8Tx/jMzAh33yD7cK8GHj8KUZDvuZKCcvQCiXlJCohXMwge
	Qv7DWUi86AwZcy7Ch9mxftE5nEZk3LKV19iUA3yMbKowfXcYkh5iSI6iKWVCEJx/JYdKEBbqlI7
	PP9E1XZ0e+vLvvSqXCd0qRkR50Cj/gs1TnocIU9qdsfwsLojHSK5l4zBNhdA9vVWRObFrcLfW5n
	FpzWkU0dMxbcpPT6HwvlJE+IvRHUHotqk8TwCicdHwBDYmiyHx+vcPTJrPTEtF1cdZ7bl7E2DwL
	7VNj7c2V/QchEcE=
X-Received: by 2002:a05:6000:1a54:b0:43b:8f54:5ed3 with SMTP id
 ffacd0b85a97d-43b8f545ee6mr2608458f8f.34.1774461602077; Wed, 25 Mar 2026
 11:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
In-Reply-To: <acOpDrnN3cVfiASk@gondor.apana.org.au>
From: Taeyang Lee <0wn@theori.io>
Date: Thu, 26 Mar 2026 02:59:24 +0900
X-Gm-Features: AQROBzD6aMQ6_rJ9Y0j2EJIPgFp60u1NJGUCvoXOYr4sPY6KvNJLd_i_vwSTKc8
Message-ID: <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
Subject: Re: [PATCH] crypto: authencesn - Copy high sequence number from src
 after out-of-place decryption
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net, 
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert, Thanks for the patch.

On Wed, Mar 25, 2026 at 6:21=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> When decrypting data that is not in-place (src !=3D dst), there is
> no need to save the high-order sequence bits in dst as it could
> simply be re-copied from the source.

I don't think checking only `src !=3D dst` is sufficient for the issue I
reported.

In the AF_ALG AEAD decrypt path, the child AEAD request is intentionally
set up to look in-place: `req->src =3D=3D req->dst` on the RX SGL head, and
the TX-backed authentication-tag pages are then chained behind that RX
SGL. So from authencesn's point of view this still takes the `src =3D=3D ds=
t`
path, while `dst[assoclen + cryptlen]` can still resolve to TX-backed
pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.

> Reported-by: Taeyang Lee <0wn@theori.io>
> Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface"=
)
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> index 542a978663b9..fae8c1dbf495 100644
> --- a/crypto/authencesn.c
> +++ b/crypto/authencesn.c
> @@ -215,9 +215,12 @@ static int crypto_authenc_esn_decrypt_tail(struct ae=
ad_request *req,
>                 goto decrypt;
>
>         /* Move high-order bits of sequence number back. */
> -       scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
> -       scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0)=
;
> -       scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
> +       if (req->src =3D=3D dst) {
> +               scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
> +               scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptle=
n, 4, 0);
> +               scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
> +       } else
> +               memcpy_sglist(dst, req->src, 8);
>
>         if (crypto_memneq(ihash, ohash, authsize))
>                 return -EBADMSG;
> @@ -273,10 +276,12 @@ static int crypto_authenc_esn_decrypt(struct aead_r=
equest *req)
>         if (!authsize)
>                 goto tail;
>
> -       /* Move high-order bits of sequence number to the end. */
>         scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
>         scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
> -       scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1)=
;
> +       if (req->src =3D=3D dst) {
> +               /* Move high-order bits of sequence number to the end. */
> +               scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptle=
n, 4, 1);
> +       }
>
>         sg_init_table(areq_ctx->dst, 2);
>         dst =3D scatterwalk_ffwd(areq_ctx->dst, dst, 4);

More fundamentally, I think the root cause is that authencesn decrypt
uses caller-owned req->dst as scratch storage at all. During decrypt it
writes both into the reserved destination AAD area and into the first bytes
past the documented AEAD decrypt output region.

Per the AEAD API, even in the out-of-place case space must be reserved in
the destination for AAD, but that area is not supposed to be written.
So my preference would be to fix this in authencesn itself by removing the
decrypt-side `req->dst` scratch usage entirely and keeping the
ESN temporary state in private per-request memory.

Thanks,


> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


--
___

Taeyang Lee, Security Researcher
Theori, Inc. / Xint Code
Website. www.theori.io / xint.io
Email. 0wn@theori.io
