Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CE2F8E93
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373717; cv=pass; b=CZIJ0SlWN/AcJDCTMaVTi3s623sEsO3qfBjsk9yGSLvbbaZfWAaLcPjKFDvz2zNZiWKq5nUirsgBjKjCIYUnzzqwiS52yu3AZz0qUSlt6NI6F6AWsLO51Vh16I0knwzzRUpcnRJwbGPzf/hIFhkO5pKL44EHvVXfitWDqObdcMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373717; c=relaxed/simple;
	bh=fgreZAMX8MnAOZ25NX2h7jfgiwNikIoWWf8fFdIykMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwo3my74gKr602vaRGsDEtAiKEu9lCnkX4Vdob1lv5Re5o5yJTOE6aV49d5EG/HxYoE4dlPauPBoHTDffq79T8e5tSF8HTFHAZP9gJHP3EpRD9jLgVnKEqARkuS66LpeDG7Rcb8xrq0sGUTrBtaD9q4qo7PMnoXefQaYZCXMw7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKXroTej; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKXroTej"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso1428002e87.1
        for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 18:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792373714; cv=none;
        d=google.com; s=arc-20260327;
        b=Jq1AsI9KbeM900JNvnz173GgzdN55H6UtH1c5opIZrapuwsX1BHn4L07UKiPOLRgZW
         XUUNTk1IdguQIkY9BEi1kO8wOjuzoS3BamiYjElLXe/xWbLn4BmrzQrAhPJKySQkJ9hS
         rP40NEYNh4QwRi6j+NgTGarO/xEO2zKW8ssCGRJHR+hU7bahAeyq3zaEimH/Nq/e2mVv
         CXRI+vf2txY0+Izaoyvvv26QiSUPmhqmfrnCCQjqRkrutLFhmf4y2MgVEFH7zgZ2a5E5
         M6mBPBNxZV6GPArSFAgbu5NA7ULtBF3Gu1ZdWbh/gkL/MHBl37i3803YGvs9lC8+fRIc
         51Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        fh=rjuvPaSQV97uj48Z4Xz/gv7MTjxF+CRYyB28syfC418=;
        b=JU14hqeWOP+Cz0inFan+LPOrIsbp0fuMiHyNvxaYiDmvB7LJaaR9vBPlEcZ1EDiwP4
         JyyVe1kf8xIXNqPLUb93Z9MB080nAWc9CDK1ICN1shCImwhF3Wm8obtZCVlbegosIzcI
         DBKcJgvgg4cCAMTbYLexVbfEwm9MKOSmuKj6dy0tO1RRW8qIndXO8rIWvyy/mk2uk3E1
         q5uhIQU09IYxheJkpgqvy2/B0rR/WsG+851lD5Jh+mqSeq2ICtUSO/CYm0YO6tpEIrDL
         DmIiOtv7p6ezAqfzL/D7mW7n1CJoVthSpxDf5ZPJeCSqcZtAlBfbr6+doRqv59O/Ezx+
         xwSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792373714; x=1792978514; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        b=FKXroTejjVQoQdCyPAiikjFkN1ZUcN9V9urWiTZGFxwb/qU5zXCf2YrrkRNOOXqe9p
         /BGXENwMqZVhbedYrerjIk6rqUGdrGbgZOZ5hJTzFiL1C+911H2zUtbUpqj0N/UyvgxE
         a+hlnyjqf8mJ88LiY8F/gaw313Nye8qsI++6doBoRUw+z7lA1fa8sXvyQSeb7jyrdbRJ
         jhg0Deb+Lkl5MAjoKYGrTMLtDUA4aquS5bSetnsasvpdtRiEVqlo6hXuSFNcKLnzbXqF
         s5kvq9SnM39HXXw37FPBmUQvUJmqbeBj9QamHvuP2GfkULuqkTStfdFZtkcTIGY4ndK4
         a+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792373714; x=1792978514;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        b=p4kveSHNMFMkuSZFWlbCeh8tsplWtGhu7Rk+mLfP8nMPLCUIf6ixhcfokp88zwMOS7
         I7s6N/7VtvgevOA+5gU7ZnWObkkQbnfalJtRrKCUwUWvuDK6N9ivmYMMHB5ZomnS3M9y
         eGRUW+2B0WDjG4sKRLazFgAYUQz2RfOc1nVaeUCv3nefJP0F1fy100wbF4VRQb2VIdDx
         8GUJWdPVSNXlOfdVzXOakB7+hqg/8X0tRNPpIBDASTsMm0JlaspTeOZ7m8TWpBVrkOUv
         64mXuKwVx/rlwEOUOLb/Tfms01UgIuC3UETnZzqsoWxujjRSz4KXOCSw6/LAEvdiYiUC
         O8hA==
X-Forwarded-Encrypted: i=1; AKwUvBx97KYZ4jYrWaJBw1mioNk5RTuXvLV/UfQvrsZ5f0l79MYA0ochnTagNlHXRFtpaQYrbbaIlkL14ktszI8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIGT8UmadJ2ZvvYZMTWwm4BALUrKNsPNG+9u5FI499mSWigcOAS
	H11RI0fZ4y0+FPppIcH2+SC0Y3i6XLnNAvOxq90sNJIAcOE5QUEY7NiQ98ARXEBKUv71vYqFICI
	kibyjxVEdqxAA7XvjDZ075J97AlvgOacPN1lL
X-Gm-Gg: AYBFou0vuLFKmBpXKa8Nhb/lZhJmb6TDqW3v6PaSrPZgsbQCD7W1H50Y1SBcMIbW7cR
	sKgLwXpkfwivx7jxhTMUvn7Eb7JcQzKHKp6+5n1HSIV530KHg20PADio8tFl4gsuyHRCcGPdndJ
	xK9FJMaZs0VKW/SnFaXldPKMLsR+ICyoATJ8Zeu3o/FEiknyHlytiVXyyp5sMyGfsKC2WYj1Rp7
	2SUNpEt4gryTztEJxUvuI3En4ZTX3c8QAucyWzS/ch6HZ5fTbE48IMhBigZy/8fquLVLTvtS5Or
	BYkQWhrcS5wqkNwHyoQpOD0ITro0Mrx/x+AC2Y7aWJhrGu7IRNiP6GL1191yz7WW+Q==
X-Received: by 2002:a05:6512:691:b0:5be:540f:ce48 with SMTP id
 2adb3069b0e04-5be540fcf96mr1950051e87.18.1792373713661; Sun, 18 Oct 2026
 18:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
In-Reply-To: <atMCfhB63koot230@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sun, 18 Oct 2026 18:35:01 -0700
X-Gm-Features: AclHuK-sa0bPZwSQVwxADRhzmdY4PA3aAYNaQTZ1DmSolcYDHA8wcYiAtLkFuj0
Message-ID: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
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

On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> [ .. ]
>
> That isn't quite right though.  We need to ensure that it really
> is a singleton before taking the short-cut.  So you need at
> least one conditional:
>
>         if (likely(req->unit_size =3D=3D req->slen))
>                 take short-cut

I added the check for the singleton req [2]. I hope this looks Ok.

With the latest crypto_acomp_compress(), the batch compress latency
improves considerably:

usemem 10 iterations average throughput:

   patch 6 (store batching only): 19,119 KB/s
patch 8 (+ compress batching): 24,076 KB/s (+25.93%)

bpftrace measurement of zswap compress latency per-page:

Sequential_zswap_compress  nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
130,165   323,961

Batched_zswap_compress     nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
124,648   213,962
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Latency saving (ns)                   -2,435  -2,876  -10,782
-5,517  -109,999
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Please let me know if [2] looks good and I can include this in v2, thanks!

[2]:

int crypto_acomp_compress(struct acomp_req *req)
{
struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);

if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
return -EAGAIN;

if (likely(req->unit_size && acomp_request_issg(req))) {
if (likely(!crypto_acomp_req_seg(tfm))) {
if (likely(req->unit_size =3D=3D req->slen)) {
int err =3D tfm->compress(req);

req->dst->length =3D unlikely(err) ? err : req->dlen;
return err;
} else {
return acomp_do_req_chain(req, true);
}
}

return tfm->compress(req);
}

if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
return tfm->compress(req);

return acomp_do_req_chain(req, true);
}


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
