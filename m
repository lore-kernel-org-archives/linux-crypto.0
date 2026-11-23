Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795470995;
	b=B4FQqEkvpHM+y9naBXPvjlL5kLFopOPYbSJvs0r4iBDJYwDexaXehXWD44YvCCChekIR
	 eGUoL8jbNlIT+ZahpOVz/uXq9eZ1WVUWlbJi/Fo8aV0epYVtt8FQ+kKBYfPzP2gssdzLE
	 hm3/lgdt8r9KWGL17VZhvs85juOkQ49sx2S0lg9bGy18ec0kPgWa3uQLBzwZbQBlN7mne
	 z7WlTepY8WpwxsfGJxcUjOPPFKRqm0hQcbhtvaEusbf/PI7q89Wc7ifQ3QLrECuX1fp6n
	 skvyMSRRQ09qEB2COC7MNPU0OPzJP2lqPX+0ZwFqATUsOJEUVTRGE4rbXSIb7Jzd09A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795470995;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
	b=vuLVWnuWw2AvpE60RA54ARNHWZEmCOAmMyHUsQiTbXwVKuapVmqCBCww9uhmfFKNSfwx
	 PVDuXBwlvB1GmXNDxRW6qv6ZTSjGC362aqijykYgTPTSqiyq2cQC3utDngdW4FzuLNSOj
	 vmocHLA223TvUccOlWp3K9OF9KLhtysWZFpVXcTiG03nTFMBzjMcNIg0+GEw+SmFwa1u/
	 yCxnTcP64oMRDl+zGy9VOiI1edWlgjJB5YSPdgwtIgf1WbDselGkhVmumd+Zq4rh71etg
	 RwyDI35hBNnAMR7+a607yMLrGZ65b1IXqoZSG6bfq8Okdx6/5o6hMw91M0x8+fQsSvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ry/xtPR9";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8EB606A334
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 21:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA8EB606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ry/xtPR9
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bccecba199so3646790e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 13:56:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795470993; cv=none;
        d=google.com; s=arc-20260327;
        b=UrQn8L/jVdc+IhBvuOjkHRkpaBMeTBCl5t5g4O/Gb8Xr3ny72TeyQpBpHQVNyKsDWE
         evnX7sNbgKTk5yf84uEdRNTi82D6I3/rUEEsPdMlcRnKkjTR+cQexuZc5xeHWp+j5doT
         /szpwwPlChy67Edv+rpeIOGZINdaA/8rOJ1o6VPl4PM6udLuFcK8oHMSigRaw6oKswbf
         EvcOXuY4smyb359UMxYTTN/M7HmHl91DcSRYSS8aZ0Rmz7T1soYeAaBQl0Ovm7Wcoi0d
         uUz/SSP0IvHVlx9pkjSK3cWQd8ilDA0hf9oGoaWKEWZF7k+fcYksUBvkbWcewUUJaCFu
         wZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        fh=AsTWnWv/1pW1E4A602s51Y/SYDBfwikkgec2K77Zs1M=;
        b=DtKrr/VUgjhAAolu9gU8erTEINhkmOLsYF7ARZnIKWliE25hvsB3EGNzWSYsYpuwSP
         Xs2g4U2YlrsNknGVYEIfYDkO/3pT1oCnQIXl9H54d3vmRUaMqutqbsW6+u65rMoTutld
         RRWhULGAnqEdpdPapmNxWC4uXBnW0jNb0wtLkEY0B3QNAohXJrNWud/G10LF1y8g5WsM
         CMoKVI6qnfyVpIgJNYFIc5w3elLMOJUE1ALn3uLAId5dx5wSQEIhEOIaOMWGeBjW9evX
         Gp7bx+9qV7FNVDQ/P6rymj3BOFSC6sqkOH1eun7Zm95sOXjFqDMAFZYSahJWHqJW4F+m
         3UKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795470993; x=1796075793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        b=Ry/xtPR9D4aq2wB40f1JZkU8v9W4ayRe0kKfTu055ttYMDN1TDR+hQenZtdkL8OjV1
         RUx4glQEF/pKKGbpVEH6Q3sA5moyDsXsbuuDvo1oWkSEKeSr0fUSTBxWLL5PZHgVxPRv
         4UfjQOtc/MkteSyzVDp4Y/MtPvKdpFSTt27b+k9x5eXXfm37sYHz9qHA/pkFA9GSGOMt
         L6Z7GmeNrgvL0OUSHXuxq78HIH4ftDBRVobhQ1AyM4ckEbwohhwn/sbsMgMny9Ve23aQ
         LN4HOPid02VYSu+K0XN35zEpFpqEc9XsAClcK6OLZX9Zv43ZfMaCHqzv8Dg83C1suZvS
         KGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795470993; x=1796075793;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        b=tn1NdbOORa5jqeOcM2/7guMhnDtXXrNIfqZgl63TlVptXmTVfPwuZ92JBePgvd671+
         F4lNSt89DdxPtq4piKxlqY2f3o2rEWDVbGzsUnHAR9slcHDb/u+7DKDc7kSOLj+mr7iG
         5x2Z3Ftozwy+Y9ci3u36TWNTDWa6ADR2riMWnrzUhGQo2SPQM39voKSA93DFKiHoC3vC
         Or4p8J/hVfojXqh88I7qa5GhTRXO40ixELP67nUKalxlFm4ovCwJEC75r7O4l/PHbQ02
         LSvXBlhFK2YNUoxBlbM73zwM//QOeEuz0sNc6Birzcq9o3dwBW2a1pMhdm77bV5H6TRk
         nZ7w==
X-Forwarded-Encrypted: i=1; AL+hErFBHLlPxDA+87pLsbw5MgkrOPqVpKT2ZK+YUTghazXR7rGF8+RDGOCEboU76ExKZuY6u3CyVmRdn9N2e5k=@vger.kernel.org
X-Gm-Message-State: APuU4Z+HuU3+tVnEoeDE/tBEPf5xqFU1fZuvqIrnoS5k1PYvDjKNLTqw
	6IP20o88PQFVgZal6s2ExiyJVSj9212vDJMOdGCBuRdX+UKjlbxbgePTzenQcdnYH8afSTT5GES
	LZRLHBKwWgxoJCtyvqND5OoVP8EWneWU=
X-Gm-Gg: AZFdTZc1utzR4+HRxaMk3VtzMQVwdKXAmh3SJiqafiiFTulKvhox9LdTyqqVD+B+64L
	9qYWhGUWn+HS/MwSaWuoXEA4LmgQmxGonQWsymAsYJp3PNtocM6SbScammwNLGY8nAc6/9/UYqx
	OJjTai2SGuKzCnofBR436mu+3dmYTWxmRqEzm207VAw+MT7tbCEuP/FZsfw47SsNY2cLYC/TqTn
	wig8wKm1ZZGaEx0PYSkYfHz2kwhhrjsbt6k34mFitYYPh1tK0Ub+WwHZySUgrwSZquIaZds4DQB
	VbbgdNh/sx7jWM7eeR/sw6Lr3TpvIVi9GOWXgt5jQDhnw7Rq2ocEyZmz2/MOrMuOXnUXgCPEhl6
	n0N3kYjbyeF9rOKi0T1MM1Q0FwlaP/+xa1eO8
X-Received: by 2002:a05:6512:1288:b0:5c3:182f:babb with SMTP id
 2adb3069b0e04-5c3182fbbc3mr874548e87.4.1795470992660; Mon, 23 Nov 2026
 13:56:32 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com> <awQCFZSSng2LLGnX@gondor.apana.org.au>
In-Reply-To: <awQCFZSSng2LLGnX@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 23 Nov 2026 13:56:19 -0800
X-Gm-Features: Aa3M54p_TqduI_blaS975gQ75G_K0GBpeL9JMLLoILwNrNsOHcRCidEuPO6_fQk
Message-ID: <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 1:06=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Nov 20, 2026 at 11:24:19AM -0800, Kanchana P. Sridhar wrote:
> >
> > > [Severity: Medium]
> > > Can acomp_reqchain_finish() corrupt the destination buffer when a req=
uest
> > > with a non-zero req->unit_size uses virtual addresses?
> > >
> > > In struct acomp_req, dst and dvirt share an anonymous union.  When
> > > acomp_do_req_chain() handles a virtual-address request
> > > (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u=
8 *
> > > buffer pointer into req->dvirt before acomp_restore_req() restores
> > > req->unit_size.  Writing to req->dst->length then treats req->dvirt a=
s a
> > > struct scatterlist * and overwrites 4 bytes inside the caller's outpu=
t
> > > buffer.
> > >
> > > In addition, acomp_do_req_chain() is called for decompression (comp =
=3D=3D false),
> > > so a decompression request with req->unit_size set will also hit the
> > > compression-only req->slen > req->unit_size check and write to
> > > req->dst->length.
> >
> > Herbert, is it Ok if this can be addressed as a follow-on to this patch=
-series?
>
> I think this case needs to be outlawed since our API doesn't support
> virtual addresses being used for dst.
>
> IOW the code needs to abort on entry if unit_size is set and virtual
> addresses are used.

Hi Herbert,

Do you think the following will suffice, because from what I can tell,
it should, but I could be missing something:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..f0ff821b3560 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
*req, int err)
        acomp_reqchain_virt(req);
        acomp_restore_req(req);

-       if (req->unit_size)
+       if (req->unit_size && !acomp_request_dst_isvirt(req))
                req->dst->length =3D unlikely(err) ? err : req->dlen;

        return err;

Also, I think we need the following check in acomp_do_req_chain(), can
you please review:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..e04cd3124fdf 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -274,7 +274,9 @@ static int acomp_do_req_chain(struct acomp_req
*req, bool comp)
 {
        int err;

-       if (unlikely(req->unit_size && req->slen > req->unit_size))
+       if (unlikely(req->unit_size &&
+                       ((comp && req->slen > req->unit_size) ||
+                        (!comp && req->dlen > req->unit_size))))
                return -ENOSYS;

        acomp_save_req(req, acomp_reqchain_done);

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
