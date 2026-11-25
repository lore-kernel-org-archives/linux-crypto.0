Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795633715;
	b=cyjyflX2K0IzCGH1HA11tGOkZ35vnhOK7kXL+P8a6SL+C7HmtEhCHrYEpLniaGuhnuqI
	 7ad3Iq+p7yqUnz4Lwdnx+632WTv9qGhfVw0dW9gtjsujv8mP1tfhdkjWH6oQBoRnD1kZq
	 QRre9kHvmprW+oNZustfqdjZfDvbo4LLkGhtA/kOD8rf/rd+fXIWmBTYDMPdPR28xb9qT
	 RWgqGFkO1IxT2GbZM90xX96v5yTnN0ZjJxdW1zZAqWa7RNmNax2uCUi80ZO14HonjbtCA
	 kyZK1FKAbdLCHyhFNNoXxnk5zv+DYSvcRywSdp2N3otlA4Xu4AQ3LnJCUly63s5k0aA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795633715;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
	b=vgXY89IFNq1bKL2CslsfnwVX0r5LdYQjWarkr9ye1BL0Rlz5hCB5hCcyyKOJpEaOrfaG
	 V8BdgqTCtqf18Ln9bvriCnBUCv1BVRi69bfqzQVsL239PiL2hwhCJQtDycnJmt0kkeIDN
	 cMEwoUb7UkGEIPpDztmJla1XvcnbZ0U+HxCBePF0JT59Xwa0fSYX+Gbu93P0Lx/I6xfRd
	 z0CtzpqZcBDKxXReInFSo4c7O4pOQJB9CUCl21Hwe8Pxx7JiLURLeJE9zIYUFzByD6oD6
	 EMchwqEjUNZrpLCfzIB/vPXbdp5FkNxJDB3QsyeGwLTPVoOR9uBddYXfT9pjNz6WGfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="oPh/mdkJ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2CB606A327
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 19:08:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE2CB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oPh/mdkJ
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c1c0c8d61aso4138220e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 11:08:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795633713; cv=none;
        d=google.com; s=arc-20260327;
        b=C9+OJVzpIsK9pIVygySWorO3fGKo0y1SZqpSO/NpA8morgOLcI7ez62IH0hEFnvWdu
         Gk8sOXo/TnyDsVTQSN40YxsBDAKmtEoTP5zZprOZdY68XW1gxx1bSP4ZUWYcOOWCWqtZ
         FPGOPswTXtvF8k2Li01/48ROvG0QVfU8Z/7gsWPN6ubiOdgmS4KKSQqTu3ODQKEJF3mT
         4EDKYqlfh0kkX8l6GniPszHIvs9bG8IIY9dNVA/LPV9w5QF4LR6/z8u7rsZloKoHSW8e
         7uH0TyQnabatC1Z6WBn8iQH+i/xONi9wo1wqA5ksYMm8e8cIaJ6cQjqyO5/DQV7i94Gp
         WpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        fh=psWweiCO8eeDKJnpoAkOJJLCsPWFOga+tOHnFc/WK6c=;
        b=HzP54jzVUhEVzpLGzK8Ccmnu6+VQ21Z9b/qRtXLio02zTHlCjYdoYll1J0WUQ6HU+D
         Cz+LEEs1+8FyLnQgBEULa4ofrzf3sHnKyUSprueaET4Ay40gzWg/QIOApKI4/lNRg0f0
         IxNLCjh1BZGKYQmu32//Vf/gnzXDnmK35kLx/3gVw/tm9BqP8vK8vD8/IeAhHfNxj5bT
         a3Inknub2gSkeMBJG+Ej/MeFj3Pv3R2PoF+4hQ7knHgvLSzvOkodJkrKYYkPdgw5ufDd
         4ROeTiYwt/OurC7URoV8EzJ3qjqj/VQCY4xT/q5X1wkwMQmDSQvykA7UrvVLOK4Ixjar
         f1SA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795633713; x=1796238513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        b=oPh/mdkJ1Z7bQ07PWsDTG5mmWdM3dwjI39LK/4lbaFqBqXuKuhu6OmZglrplYGvqP7
         4p+yndq8c7UnRAp3fOau/1buMt9aeWNzaQS1bsewp6CHW5TClGCK02i2jMD+AyBOo3VQ
         fxNICPWucAOI2R6Ziff6GxQkltVeOp90SaO25Soo1d9398E/va/22yEfDE8sDoJR1ZcG
         QDijd5u5ct5gKI3TpZGqGYx52B87R6PTUC2jAZ+gnOzYtSVeCXR37P/eLPIoheuClU8p
         qrwBoFdg6heWRCmRsYyPcjqYmvZ83pyJtlS2yzZk/wKSlCQdguYTkG1mOMzT/FqDEqax
         gqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795633713; x=1796238513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        b=axQuXeVVHmw3dnV0G1aDhsDd/ma10fIW394UcB8g4mH4xwKWaXD01OX6DwbqTnVvuF
         u0HsQXPc2DV9QIOXngI1m2Jx2aRslxhBQgWj4jqA49ma35tKpqQeaE5LyHTsGExI7vS5
         cH8TFe+st4yv9YsSk18shjIjlUwFg6Zi3T6aANmtGisWUHptcDWKId/It0HZefZVEaj2
         /SYUobiQpIQznH+LinF8u+XEtbpaeR6m6dxmdLkHX9enVrS4FD4dXL4KeGxF+y+gRtSb
         Nj6yHX43iVTQaJyh0VsO/Q9Pk8N2z7p30zgd/fuAH5ywLINNSBiAoKHvduKawSqbmbfF
         CcgA==
X-Forwarded-Encrypted: i=1; AL+hErH+ThfWn2ACWYwxGCzd6EH2jPLdQSb7rKS1QYam8B6Z9as3t0oH1ygfG/BMtwGI7kSindmkSggDg5gERmc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+lG24KWG49p7p/AF0AqEOQp2MvoBm3bPGoqCedZy+O9I9Z0nFZ
	m5kttoPpAwpYJe8oI/DiK1HSJ8ztQEtHJwAJwv1CDrV+W4SGKik0RNfOsfsaW3ie1aBxqDazzzY
	9VOU7uXOoCXhV0WcwBkPc7zegwUZBZU4=
X-Gm-Gg: AZFdTZdk0o9UOckO++1P7npgbWgBCSOX+ILbf1DyAdwPvLDYi5KwZs21N66NrlL/ylR
	PIM8EDrxerwHOMfqefNpCHQxdDfv2rTrv0fyRMH26D2wtcqGvqATdWONHvLRKuooPRU1CoiKXmf
	RWgQb6eFS+dVsxp99Mbh7k34XkeBUzonn60bK6YM6x31R9+JyiiWkWsFDSp4lEEZl03GTjnV5ey
	WhZJfOd+rwiylZ8MFxFKvFegByyJnF3SeMi3J8lnXEVTOajwe3vwPJI7DiByfZoYo85O7raDH+2
	lTLsvXCcbkE9BiuPxe2/bR6/kHdLAor1GKHCbei3ufQKZYjvbsiFWRko4nDw1TI7S1kqxNQfWds
	XOZggcpPlJIavNNsp4DANWoQwD1P44xCtN38b
X-Received: by 2002:a05:6512:2255:b0:5c1:4f2b:a2ba with SMTP id
 2adb3069b0e04-5c1bc7da45bmr6431675e87.34.1795633712661; Wed, 25 Nov 2026
 11:08:32 -0800 (PST)
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
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au> <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
 <awafBxDtUoIQW9iR@gondor.apana.org.au>
In-Reply-To: <awafBxDtUoIQW9iR@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 25 Nov 2026 11:08:20 -0800
X-Gm-Features: Aa3M54rDO2n4sQnCYgEeJJ0BwJAh3cqFRPzK3u4L4boBFDbFL3ETCr5fTYtU7WA
Message-ID: <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 12:41=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Mon, Nov 23, 2026 at 01:56:19PM -0800, Kanchana P. Sridhar wrote:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index df9e42f519c3..f0ff821b3560 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
> > *req, int err)
> >         acomp_reqchain_virt(req);
> >         acomp_restore_req(req);
> >
> > -       if (req->unit_size)
> > +       if (req->unit_size && !acomp_request_dst_isvirt(req))
> >                 req->dst->length =3D unlikely(err) ? err : req->dlen;
>
> I think this should return -EINVAL in the sense that using a
> virtual address with unit_size cannot be supported as it makes
> no sense at the API level.

Sounds good. Does this look Ok to you?

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..88f912103e8f 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -274,7 +274,12 @@ static int acomp_do_req_chain(struct acomp_req
*req, bool comp)
 {
        int err;

-       if (unlikely(req->unit_size && req->slen > req->unit_size))
+       if (unlikely(req->unit_size && acomp_request_dst_isvirt(req)))
+               return -EINVAL;
+
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
