Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7813D390224
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 03:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206203; cv=pass; b=HUmofPtgSsH9VNY2j0uvDekp5j1s0WuC6G0ZmYrGVk8N7sK7xKVX/urxVET618/u8u3EfDKAOLltCluy/IvoDsHpC0OAFGw4xyOTAfNzmhQu3BLZE/yiNfovJV2oiArI4jUjsa3ITdDITMv6wSzIzsj2LIeLIv3pPaFN840rr8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206203; c=relaxed/simple;
	bh=Y758vtkUylvdUTjnWxG7o3+mdkQeB1hyCOH9J+3c3Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQU4CCJQ/q0bfMKmbJofYAyf1uJ1u0i3puYch5yT8YLyFgKl7A5kRyfnRtk9G+R8B5CUoicckhon2mpQkKcwIrtQ7A7dAyvcHSXW0QCq3XpDMrRjDUKZmYv/uLg7dzPcGtj0dKBdrsAfJF9V+gWuMReRt2/Lgy4AmRva9MRP5yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4t3YT/r; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4t3YT/r"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be42ae8eadso330143e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 20:03:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792206200; cv=none;
        d=google.com; s=arc-20260327;
        b=WS+Y/JOs0MdfdWhgSB+p1Hu34FGkAYVwYT0LYcnbyQHJx6m+xOXWm8VbDuMFDKT0fe
         Tir176B7QlcD01BxbbIt5yUAh77Eu6PcUanr3J2sm9aTv+cPHKwAnE4WGl18nkwD4pTb
         lCOk+Vgs11TriUVH00e5cPhia/2NJN1dd/E6rWvcE4BSTkGeKuxGKWyFrKlifQ7wjCgm
         p/DOLlns2ENXg8dAw79aMry40oBs2MqIz70cpz2Iicp/3TNbRKA3jXCKY3fNyLos1z7f
         l/R1VtgxD8ry2SLs28VZ0vGI6Q2IH/gmSdfsWiNEHmLhKb/mMEDeW17odHeKNSlgriqP
         kPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        fh=/57VVHnJXe/6Nu1syzyZ/lauDnRcDjyCG9f7XvtLjyM=;
        b=ErpVBHAFjqA299gLMIajYxSvRAbHmseGuKf9wKzTKdK3rfo0MKES4bV2lxKllRupCE
         FlRFtGCnCh/YaaQZr4uEijj5CHMx88BSRQzAPC3lK5Yqg9xLTCSliZhP3QoO/Hxp6k66
         mXFhKt5l9n7TXGNIAo491qh4nxJcYvLxaqmiHNPe6iosrw5maH7BLEdlzSOaxXtQ7Q9d
         XyWegOkQPMPO/AOf8imN5ogDFrGzskeeJ7dS0qmYjan+NJqXeA1nea0d6PWf50kaSatG
         gL5a99lLDqenEE9dCT7FwxFbc0kT5ZsiQVfEZ+P2NAjnpKGi9Cs/DOY1Oi1U1+NnMuxS
         XM5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792206200; x=1792811000; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        b=X4t3YT/ri3D/xAtkQk+SXgjIGTSBycyg6zhQbySFaKsPrjbMwDFD1OQGz/awzxcskm
         M86w8X/wwk/2CfvXjdinM1akbWIVJJZCDj2py8svhI+qpq1DJv80bCzbJDFJ8uKhT6g9
         bZTVg9BDDzWQGxSLYjFAO2iQlQlcHFRn8onofRy0szfWmBF3DhlQPQK0Pc7qouEzTBck
         gb+xf5bTDICfYPYf6dXtMvgMBuch9xzONaC7jCQZ7MQ2F+gWEw2wNi/Kh3yKG7zIE4az
         iX3Taan8ITvv8vSHCB7er2BD33A1lt9qCYSD7B7jAhdSDk5yfcuFh2KdI2guAo5Wn3oV
         gKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792206200; x=1792811000;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        b=tCnYWLbRS+T9Ekf0Dq74+oWqCTraGjnO1ciZPv9GBrOjQQLL7lWbTejEr5+q54NhjD
         ESRpABYvOZinUGE2tSFmnpdN2CQQbeVK5h4v/40X5lSjGhw8qwDByu6VTfJw27ulSgZX
         SoYqZxnbPSLJQpFy/y28rk5XOKXZZp2pjRpuJ/4WUFHoRwzoLIB6/qLvs+Dam309fXO7
         u8KiudGvwv1Pnvd4YzwhaEwm/QokMBnmmvq69FaLazzCt/4bqN0DP3Gy5I1X0sAie2lJ
         TFxeHtUT6Egr6Iq1FK9I65lWo04dk7gheE6aID/R+DtZUvoWAVNIUrg/wRn7gYdyJEPp
         1yHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxm4TZmtBGw7QsSaQvgq++cX/KaZCyTbIvYi/2KjGyHewBZdVlFoiekU+Py5Z2AA2X3Ooa7xbvMAUR7krY=@vger.kernel.org
X-Gm-Message-State: AFq9FYLY62RKhyoxA+NeRby6NmUdnDuW5UwoIbU2+pwrZzFfvNlxlSFo
	LAn9P1T/+Z65dT9RHds/ojVEV7oRaUzC3eHQOo7syVOqJJWIBPHlhvWOHn07sDoeKrMu9zEEOW4
	gFhC4ZTaZs6rS7loCEbuofG/bTL/eXOE=
X-Gm-Gg: AYBFou0nPoUGVYnN6orhbo4EXQEHr9bCx7CFNwCqTVZU1+tDBE89unnfOcLQDJMJTQe
	Q1YGlRLdvG20ADmTCaiA9s1yyhb6T+W7t8M0zMIHZY9/5p/50KOE4coV8sKsQrdyhyCKMSDUS5O
	BoiO6OjsfNzd0Naas+bAKaCeL4fHhiMggg8SNiESqUr6arg2rqLP8IfOwt3RReoxlafH/rfkNDS
	aayu61x4eJsbTpCCQynCBmlFXPsxM2oRFDN8qW516eZksLVV8VWbIYuH756OmKGmi50rEgvFT8/
	veI6MPlOgnuBIAZWH/mDTTMiWUgS9IocH3GyGqe1NAI2jMu1clvRLHM=
X-Received: by 2002:ac2:5691:0:b0:5bc:e13b:3922 with SMTP id
 2adb3069b0e04-5be509a6de1mr460213e87.0.1792206200169; Fri, 16 Oct 2026
 20:03:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com> <atGqPIpUfX0LDokV@gondor.apana.org.au>
In-Reply-To: <atGqPIpUfX0LDokV@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 20:03:07 -0700
X-Gm-Features: AclHuK9xQKLEm9ED0FPrZSYZivJi3qifBTa2ucE7flkZGwWDvl2MosDfqLg1aQY
Message-ID: <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 9:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
> >
> > If you are Ok with all this, we will need Herbert's Ok for this change
> > in patch 3:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..db8e4c82b900 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (likely(!crypto_acomp_req_seg(tfm))) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
>
> What if you put this short-circuit into acomp_do_req_chain instead,
> does it still give you the same performance boost?

I made the suggested change as follows:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..6697cf5944a3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -271,11 +271,19 @@ static void acomp_reqchain_done(void *data, int err)

 static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
+ struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
  int err;

  if (unlikely(req->unit_size && req->slen > req->unit_size))
  return -ENOSYS;

+ if (likely(acomp_request_issg(req) &&
+   !crypto_acomp_req_seg(tfm) && comp)) {
+ err =3D tfm->compress(req);
+ req->dst->length =3D unlikely(err) ? err : req->dlen;
+ return err;
+ }
+
  acomp_save_req(req, acomp_reqchain_done);

  err =3D acomp_do_one_req(req, comp);
@@ -293,7 +301,7 @@ int crypto_acomp_compress(struct acomp_req *req)
  return -EAGAIN;

  if (likely(req->unit_size && acomp_request_issg(req))) {
- if (!crypto_acomp_req_seg(tfm))
+ if (likely(!crypto_acomp_req_seg(tfm)))
  return acomp_do_req_chain(req, true);

  return tfm->compress(req);

The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
don't get the same performance boost as making the localized change in
crypto_acomp_compress(), likely because of added computes per compress
call (one function call, two conditionals).

I think the localized change in crypto_acomp_compress() looks a bit
cleaner as compared to the special-casing for "comp" in the generic
acomp_do_req_chain().

In any case, please let me know if the above data helps.

Thanks!

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
