Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795202674;
	b=i/VlqTpOKh3/neKd0bPIPX6Cg+dxXXiZUyfUguNJxIhUcmlGSrpnxyIw/8WJG9XIMksu
	 DwTYUhqkRFTzVo8+z6tWG2XYALtLAQUVd5CRBj46iaVK1QpKLmzk1SaZjcttKYeWzMP1n
	 dUsI5stvO/aYAB/4uV2FiMOmRifQTH0ed8CQ5d2ihtBNvk+ikGDHtNXg8pDSPsfTRE79/
	 4iiHhgErDH3/33ExFLzpfR0ClGCOIy9m/uWMLnyctegVHtYSu7mupXVYH4ijLiKt7FrYa
	 n5nSo8DOgaJGgWybNBAYfXrcZ8nrPhbao4Dwy3d6PlD7Znc9EifBuwnFGSjFfQ4czhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795202674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
	b=UE2VNjnec9h56pj90zy9+n4wQIRXR1YlADeUw9KY1JtzZZ2BbrOodCRCLpH2XDg4Iopu
	 RdzjeMvfWvGz5GhgkQmXzKNQh5SSyumYLXRM4O2R94wJX+DAPDpgM7O3lFrx/xDucy7MY
	 2R+1vBQY/p0G+9uLu0wQrw2Q93/TBZ6sjYhJaEJqa7AqWEiFOC03AEMr47caJJbCfoSb7
	 xvd9hsZthYytaHMou23XbY6eDWzA5FXxgDGMd/wxVsaEXG7vPw47J5ofLZtCvioZGUtDJ
	 1kYV7K4G/vbdo2lXEwUaPvVMt9SbFeZiRerHNllILORdZtwyncm/M739CeKpFV5FRvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kOkWALfb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9938606A6CF
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9938606A6CF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kOkWALfb
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c126fa1e3aso759817e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:24:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202672; cv=none;
        d=google.com; s=arc-20260327;
        b=QsKMsLXQ/5dNFQdewaRpUXC7gP3EFBpM1yf8jvoIJwZG21Rbosh7UDNP0UqrLBWp+h
         WZvfxTx8Ulby6Dinzj8mLJ4Pdj/sMaujjF/8Wyzx8zTygqyRJiTBYmmE/ILfaVnN+5EH
         EU89+wVQR8Yu6p/KsHWDvi4pTPT7KOb+udpRit0iWq/XD/2V2FqH4kDO8w4UNtYoKL+w
         UgOW57lcFX54Prsd2ye/2HI7F0geiMCiDI1W/WB0IWrn222rERxTUFqN18lHmtrvtD6n
         cRgjmTpv89u+n9795qKkk1e7VmtI0dHl/nG5ICNCMH8ymawQcvPn2aXlyQimCPaBSb7p
         z7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        fh=SL4wZ3dEOZ1Qfmn5aCbPvKpRe1GY2bWHcdQjFK1iFC8=;
        b=cbKQi4n/0ASDggsCXEDCPaEaTHLhGX57kQgCgdjUsE0rdXUB2uBLadmX2sXiTphO05
         7aQkeLdSqxIw3CvjsfQGiTxWiMDCcgeg+GUD8dRR64xbO5npq3oChffE8uo4hYjBrwrZ
         ZKgTB2FE2C1gMz+UpLfB88WY2HhfsxqEkKf+zfYec2Krj2B0tU87FMXZxkCcrRmmbuXb
         pckLovdQtQy/TDPLGt9+Kazt6lrcd81lfhb8KT/S0Ci8sC9pakCIq9W9jecB8JJimhgT
         bN8focK1U/MWP4Lmw/l2vM7xsOVM93nxYWwCNxaNDW8n4rJ1Wuk806y7wuzlRO+UxQpd
         TRSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202672; x=1795807472; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        b=kOkWALfbXLSO0694AHocK6DiW/UnduFj4uDpr9lzQQ0oS33PpCuJdksr1xIn+9pVGS
         aohn8VC/51IpDHUcOdmQFw460SANKYsDNFjUzoyNsXv2wiwxkTE7i1gRaA+R3KIOFm7+
         ITCO/l4NTO1N71WdLXrhQ67aUgortKmZg2oBOo3pKRDTMIpYrmJHw012N/ZqZ3ijvFM7
         NgrFgoNZ59N9G27DVv6Cl0/Aq12ez/LdBQPzcYfMuBs2Pfy+XRW2Y2CiVVYLMDoIk55P
         uIIBzHFuf72iun+XCDoL0QBIyZCxvARM7KesVkM41zeicCkvcLioS4x77VvMRFE6sqV2
         JN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202672; x=1795807472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        b=zW9ZTJ/jPPyQX3wshaoNoW+bTNIsB2t+w3f1/K1pjTTcsu+GsrvIBeLBeD+5fYz5Ky
         CjMeq/YGvja0bXt2dLuOqgEQetMhSKooA1tBYm7dZYGX2zu0++sV6e7i2VnGPke1uaA+
         V2sNxf8mGHDA4zFClu+KV/SqJqZe53Lwp6A3NUE/gFBhRvYcoj59aX58MOpI54KN2VpM
         PNu/QCJ+8JtSJXRf4Wr2YhQEJ8UDuORmyAUYNmmyNmlDCjY0wH3lBhpn/4UURElb0MTV
         o7FiHhywEzIOew9k61vux/ipmkC4ZhnakVJiyciZLFNnNaBtY9XwJGXZy425X5Jb4L6J
         UFtA==
X-Forwarded-Encrypted: i=1; AL+hErHSIoZftu7U3Nz2O2TxT374Exam6OdqusSeYJEKWLCBCferq+3idOGBADxoG7zQPAgWKJkmMAizZ5rPrkE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/sPhV5H5MOjXiJ63p6sFe4KL9hHdtbpattM68TGoR0piAPQhy+
	8gBksLHHXU1oQ+fNL0X0M6LaLg1CuhUCN3pjtsFx34dea3p8S1VN+9s9tD5MFRTeEc4CWgePE0P
	o2v4MpuFjMc2HYuv27LOjgTnedfmJo1Q=
X-Gm-Gg: AZFdTZfxkuvaDEW2VX8VEgqyypNBVv5jWtQhnCW4AIefVYbkSGwPL5HBZwKAGCV+Dnc
	5Wt9tDwkfABoau9qv/ZkpgpaOuysdJTVi/46SPVmQZmpyHYrRP8EOE4o/tHbhh2SpTrj/kJY7MN
	LN31RGW4b9KoB7yAGIssmLwiouwIOYqQlxVSC+AefF5+5CywVPFGOzmAAMLMHf64ks/IeiBSGgX
	lszTzhfMsutCzatUKivjv7dQei29z+uXy4UkrcmuLFioTpj/4QW4Z5fojv1ugT7F3osYI/d5qcu
	PA0yqoexOYcQU52S91sVzhQ7pwKQSVRTuJaHklG8jNvmWDuPx7am2OYYgOr5WTs5ws5OXHx61Fe
	sSXwjii/jiedMzyglYgXPLc/uyKD3JZK/3B3D
X-Received: by 2002:a05:6512:a92:b0:5c0:a7f:3ee8 with SMTP id
 2adb3069b0e04-5c1bc6f6f92mr1247082e87.8.1795202671893; Fri, 20 Nov 2026
 11:24:31 -0800 (PST)
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
In-Reply-To: <sashiko-outbox-202709@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:19 -0800
X-Gm-Features: Aa3M54rhTUbna5usUdb29tdk64fNtvutRquhcws5sDaGP6EBJACKMJdTqBzkNNQ
Message-ID: <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] crypto: acomp - missing non-zero unit_size check in
>   crypto_acomp_compress()
> - [Medium] crypto: acomp - union type confusion in
>   acomp_reqchain_finish() on virt dst
> --
>
> commit c2a605231cabd5e0e15d6d778b3943a2c118d756
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add trivial segmentation wrapper.
>
> This commit adds a single-segment compression wrapper for algorithms that=
 do
> not natively support segmentation, returning the compressed length or err=
or
> in req->dst->length when req->unit_size is set.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c8b4b8589769e..ac4dc52668b89 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> [ ... ]
> > @@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req =
*req, int err)
> >  {
> >       acomp_reqchain_virt(req);
> >       acomp_restore_req(req);
> > +
> > +     if (req->unit_size)
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +
> >       return err;
> >  }
> >
> > @@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *r=
eq, bool comp)
> >  {
> >       int err;
> >
> > +     if (unlikely(req->unit_size && req->slen > req->unit_size))
> > +             return -ENOSYS;
>
> [Severity: Medium]
> Can acomp_reqchain_finish() corrupt the destination buffer when a request
> with a non-zero req->unit_size uses virtual addresses?
>
> In struct acomp_req, dst and dvirt share an anonymous union.  When
> acomp_do_req_chain() handles a virtual-address request
> (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
> buffer pointer into req->dvirt before acomp_restore_req() restores
> req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
> struct scatterlist * and overwrites 4 bytes inside the caller's output
> buffer.
>
> In addition, acomp_do_req_chain() is called for decompression (comp =3D=
=3D false),
> so a decompression request with req->unit_size set will also hit the
> compression-only req->slen > req->unit_size check and write to
> req->dst->length.

Herbert, is it Ok if this can be addressed as a follow-on to this patch-ser=
ies?

>
> >       acomp_save_req(req, acomp_reqchain_done);
> >
> >       err =3D acomp_do_one_req(req, comp);
> > -     if (err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS)
> > +     if (unlikely(err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS))
> >               return err;
> >
> >       return acomp_reqchain_finish(req, err);
> > @@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
> >  {
> >       struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > +     if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
> > +                 !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) =
{
> > +             int err =3D tfm->compress(req);
> > +
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +             return err;
> > +     }
>
> [Severity: Medium]
> Should this fast-path check also verify that req->unit_size is non-zero?
>
> Callers that do not use segmentation leave req->unit_size at 0.  If such =
a
> caller submits a scatterlist request with req->slen =3D=3D 0 on a synchro=
nous
> non-segmented transform, req->unit_size =3D=3D req->slen is true, so
> crypto_acomp_compress() enters the segmentation path and writes the negat=
ive
> error from tfm->compress(req) into req->dst->length, corrupting the calle=
r's
> scatterlist or causing a NULL pointer dereference if req->dst is NULL (wh=
ich
> can also happen when req->unit_size is non-zero and req->dst is NULL here=
 or
> in acomp_reqchain_finish()).

I left out the check for req->unit_size is non-zero, because it is
implicit in the (req->unit_size =3D=3D req->slen) check, and also because:

  - I did not see other places in acompress.c that specifically check
for req->slen being non-zero.
  - This is in latency-critical code. Fewer conditionals are preferable.


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D3
