Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792462455;
	b=EZaGFOP9A164+AYHX0JF+eO5Cabceg8Ln+Z7NUTgkhb6+jrSBJzf1FHHevYmrvzwREgs
	 S8JbK7aYGaEKbHVYOm0vX0dORNNrHpUcXqcIRHwdG/Z0iBH2mzfnx79a9gBguuIMQeLTq
	 1VPxW2VOvhkhB7rMiK3TChzutPbTK4hPlsO8MSgNG5At6sUCmyuDSK2BDSZC6G5DK1Qif
	 LAYNpAShjzPp11KovAAAtLc4wtwjHCcR0ymbNGdWOm4FpcfM79HhBpCM5cCu786KeIFfT
	 ZHDcndWc3TkOxRKK5Lzfpa3lpE1vPMZJ/iE0b5RRLcMzLrapcXhbiEA9xpIpYKaV3pA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792462455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
	b=1FVtvJgleG85x2sgD69DdLewh8ojU5huZGDs8pa2ucPSsf8b+I27hLuANnOo/9AUlQkW
	 nFaL3xO52IaDMH0tWTSojHPm/I1DoO6dLjTettJPCZ3WA5cBD4Wq4fvc6c/erUZG2xiDz
	 z0jqg+VICH8dccpZe63mWmtADxTbIu9hWiIzWPKtNyJiLEjbuiFhR8bDFfERIkjz8D8Y/
	 1JH+2FGCGcRbF4CsqcooRBqY6YQoo23EVBageCqdpmYDe8s4XJgIJtc11XsYppWQWAqfH
	 2BxZc9/V/1W4ASMx5XQkcXgTJb+42MS1Q/E/rxesDrCbxKnTiU0ej3ES6A1IiZhI3+A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WN4jNdx2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EF9606A31A
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4EF9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WN4jNdx2
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be3cff0f6cso1976126e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 19:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792462453; cv=none;
        d=google.com; s=arc-20260327;
        b=m1bq0Y/YhbLGeWcwAni0Q/KuQ8IbzbAuXPaL6MVS4NbY8tylie0DKl91chl1C7qwRt
         /LcxdsR9WlLPeBnhnif5cmGPS8OaaBeORj/7mY+OjlA5Zfw1MPwWzgu5RcLIE2fFFsFK
         iIYPzxrj+A360LaLDg4HgNANM+k1HGodMnnmgViTMe7y4ATQJOPUHIEcYmunGW+XYQ8y
         BlQAY/ChQyP3sNpd0UvJ4cLK2CG5sFfNEZPu1KiZzH1dFmOjZxk1+7uAdg8J5F/C4rVi
         +KJP2d9hadU5k9NhK8SP/leHAUMGo4uMsIF3Ip2+8yhcIxfNsHWLq2LQ87Mr/uiJyQTa
         N1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        fh=Sw8bcCmf2v/tPChfhosIDRnHwyPzIUFJ8GMq0S69lS4=;
        b=M//xG8n4uPKJLn1/T1YdVendD7rp66uwkAehg3+w9nc2hlRmi8yWbgHSkGaGLOo0Q5
         +trx+hSSEQUIXZSfmLL7mrU2CmaTpnFFTkmtjoIxcZi0pYOGS6WZXSfs/1eGLTQNEcVW
         5+w/vXB38k8+1LZJDnZOQ1+vJfww8E45zmskmTSLalHENYrJYDxJMcOtQxQ1pjcq8Qjs
         QNqq3E4F4oJZx5w2aIBBIQQ8hZhN1dBRKhnNd/gHICE6sg5XD+V3DKmLZRK1/ue/lyyO
         KGa+YS1lPmgRf75jWhEPRUBwAOekn2+dityCoiHw5vTOMYp7c/ouQFXu4GMQ2vOzWnIz
         lNcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792462453; x=1793067253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        b=WN4jNdx2SAkt0uTHYg63ZoL7ZaeJj3ozqVSkPY3/axls7o3882RIHuo/UCXTMYCBZi
         CUqZ6QS+wlDJtr+kUTD7sixIQMolxms7hab9GYwsGo+siC4ddCMxcvCaPPwuwnrCerux
         yK93HZDDRjkFKtmSOqe7ANaCP5E271t+tCMMVPh6FWrTdp/2mebok59JpF/8yvo8/uY6
         dtH/ksgZrinakTcuuACiuTl1r17QBTsOLRUIcQ/nWJnsa9Mh8ddz8dkjpzf9e6nr8qHV
         Y6us8f6/rukxbuqzCUyMlXlmcDknnn6TDlxq2L+9reJCMDgIxTvz6HD73tc16qBBRqe8
         eeww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792462453; x=1793067253;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        b=2x9cptNTWecNetihLudA4CLhc2a+kB0RD0vJ4SEveuuHH5ttK4eb4HglXvkE8PFIvb
         CXAjzReieHcQm+yzyN4Fp5/qvUsvNiEasV5fwzuopbGfLnvvPx/ScECbVysxZibxQMvV
         b/4HFqwePYJEhVRQasfRZP6LOTOcqf2wc+tlMa3Haxl49Y2+wXKTaNkh6FVOHjlM3yvE
         2zV9EGSmUUbZC5CRXAeApcFN4TqsCc4OmpvGT7PRpFGWmzHatGTNFQMZOMW1cPLBHrsJ
         7zlFx/YGnxTz22sOJxPhBm7e2WtbGznkXC60MbJNBiOX7eNZIQalKqqSAmyet37IMjvY
         JRbw==
X-Forwarded-Encrypted: i=1; AKwUvBz0gIyvRKxXMgbA86a2kWTKsKudCxUf1BcO5kGuFI+swKfD33n/zySAxeryZGXjoPZvyhiuHFekgeGp1kA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLb2RMS9gunNlrYZK7mzl1PGffSZhnZ7W/Q2vYgmvvEnbf3dE+i
	O/dHzP1+cA8HX/XaZ0QVmV3KsKFjbIqKcDRF6CVgJmQC50F+EgF6TeZOM8kqLhOQ4iOgvtOR0Ma
	bncUJKUQLPswCkNvYSnoQeHgGcZAJvNk=
X-Gm-Gg: AYBFou1F0+avKYu4/0WsSMZuk0+w+pQ9AhbGfM/SRxieMSCl6tKR0gizQJKeQ72ATwF
	jOmmWba6itGEWzan3OqTLoAyi5ypLAx029aLRI2Pn0dZSYFGkPtMK6YfHgnDTboL14lGb+Ckb1L
	iAW3lpqqqRGYJU7zg2EU91vMOA7n/2AnbhO0iOfI/Y1L+O818W7GSdyyOvcaFRBBRM3oGjGto8h
	myClM7XQpV7P8V0hrJedFIvgKbirelCdh9q+gY8+dTGVW7OTtxj3JIvdbL0uY3oA0vdyXsWa4JD
	OnnzsduZFJLjjzCCZTNodgGER32vcuRMcG9hv8sNVkhsEunf2/lKQ42nXapdwH2z+/Ji8dmEVuI
	BX+KNMHl17EmWVkwHgEXDqrjCtg2DTw6z4Aae
X-Received: by 2002:ac2:51ce:0:b0:5be:598f:2736 with SMTP id
 2adb3069b0e04-5be598f282bmr1905487e87.47.1792462452600; Mon, 19 Oct 2026
 19:14:12 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au> <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
 <atadE_kZz45KAeuE@google.com>
In-Reply-To: <atadE_kZz45KAeuE@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 19 Oct 2026 19:13:59 -0700
X-Gm-Features: AclHuK-O5GRznQ-4uEfzEMIrac0t16SF_OufPYrMOIRqkz_NpjCJyWmJTsaVlc4
Message-ID: <CACpmpofy3P7ukri8vukWte8x2sYz1pNCVXXAN9YtL6=A3BeejA@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 3:50=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> > On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apa=
na.org.au> wrote:
> > >
> > > On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> > > [ .. ]
> > >
> > > That isn't quite right though.  We need to ensure that it really
> > > is a singleton before taking the short-cut.  So you need at
> > > least one conditional:
> > >
> > >         if (likely(req->unit_size =3D=3D req->slen))
> > >                 take short-cut
> >
> > I added the check for the singleton req [2]. I hope this looks Ok.
> >
> > With the latest crypto_acomp_compress(), the batch compress latency
> > improves considerably:
> >
> > usemem 10 iterations average throughput:
> >
> >    patch 6 (store batching only): 19,119 KB/s
> > patch 8 (+ compress batching): 24,076 KB/s (+25.93%)
>
> This is exactly what I mean by the numbers varying too much to draw
> any conclusions. I am not sure if it's the VM setup or the usemem test
> itself, but previously it was argued that the short-circuit in
> crypto_acomp_compress() was ~10% faster than the one in
> acomp_do_req_chain() (20,946 vs 19,058 KB/s) due to avoiding a function
> call and two conditionals, and now *adding* a conditional improves
> performance by 15% (20,946 -> 24,076 KB/s)?

I would like to clarify a few things:

1) The short-circuit in crypto_acomp_compress() that gave the 20,946
KB/s was missing the req->unit_size =3D=3D req->slen "singleton check".
However, it gave better performance than the baseline patch 3 in v1,
which went through the complete acomp_do_req_chain() protocol (save
req, do one req, finish req, etc.).

2) When I added the same short-circuit in acomp_do_req_chain(), it did
not give as good performance as (1).

3) Herbert pointed out the short-circuit was missing the singleton check.

4) I added the singleton check into the original short-circuit (1),
and this did not degrade performance. It meets the functional
requirements for crypto, per Herbert's feedback.

5) I cannot make comparisons between "a function call + 2
conditionals" (2) and the functionally correct implementation in (4).
The functionally correct solution is qualified with "likely"
annotations, which can explain the performance improvement.

>
> Moreover, for zswap with ZSTD the added check is always true: the batch
> size is 1, so slen =3D=3D unit_size =3D=3D PAGE_SIZE for every request. T=
he
> previous version and this one execute the same code, so the 15%
> difference can only be noise. With the stddev you reported (~5.4k KB/s
> over 10 iterations), both differences are well within the noise.
>
> I think something is wrong with the performance testing methodology
> here. The results are self-contradicting and do not make much sense to
> me. Did I miss something?

The previous version and this one don't execute the same code, as
clarified above.

I don't see how the results are self-contradicting. Can you clarify
what you mean by this?

OTOH, the zswap_compress() bpftrace results are clearly reinforcing
the benefits of compress batching.

"Sequential_zswap_compress" is stopping after patch 6.
"Batched_zswap_compress" is stopping after patch 8.

I hope we can agree based on the bpftrace data that
Batched_zswap_compress outperforms Sequential_zswap_compress.

>
> >
> > bpftrace measurement of zswap compress latency per-page:
> >
> > Sequential_zswap_compress  nr_samples     p25     p50      p75
> > p95       p99
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> > 130,165   323,961
> >
> > Batched_zswap_compress     nr_samples     p25     p50      p75
> > p95       p99
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
> > 124,648   213,962
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >  Latency saving (ns)                   -2,435  -2,876  -10,782
> > -5,517  -109,999
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> I measured zswap_store() (not zswap_compress()), to get the per-folio
> latency, and it didn't seem to change much beyond noise in my testing. I
> also notice that the number of samples is very different between cases.
>

I was addressing your earlier question about why not just stop after
store batching, and why batching of compressions is needed. I would
greatly appreciate it if you can review the zswap_compress()
sequential vs. batching per-page latency data from the bpftrace and
let me know if this convinces you?

I thought the overall zswap_store_pages() architecture had general
buy-in, since we bulk allocate entries, etc optimizations to minimize
locks. Please correct me if I am wrong. IOW, I am focusing on
gathering bpftrace data of zswap_compress() with batching since this
was the main patch that needs buy-in.

If we are on the same page thus far, can you please let me know why
bpftrace of zswap_store() is important, and if I should gather this in
my environment. I am happy to do so, but not sure what it will
prove/disprove.

Thanks,
Kanchana
