Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567E11FCFEF
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081155; cv=pass; b=gepymoUmLD0MgUEf/OViOVijiRyj7wS5YskNJxtuz5ZcOQihICeaH4toTMa9atX0cF01ZFSLA3xpnHlNwGrnE0pJhrifgVNmSDFDeHMRK1J8PszQ82bcXCYBysN5GEm//AOAUlqGH+duc+Ty3aNy8K5ZgzWudnxDyxOvYRQ4eDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081155; c=relaxed/simple;
	bh=MxbHQSc36+Cj3qvwqFUOVnGFSlLCbZBNP8jpCDyMX1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sTRm/38QCmEk1yrL49dCSJE7nje8p8/k5Yzb4+Tsknt+ibmCxDKuiGTZnoMUSu1ivRYC3wZP2BaJWoa0R6c7L48qv987JJ15JnfetmLV+m5XWkOnYJaLeAKfaSGu/SPTVw+tf6UnsRvkhdXGB8dZJwVp/a2sLcEyVTqUFlCmglM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HPqT79Kx; arc=pass smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HPqT79Kx"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALUQ7Q049418
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:59:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=0jfNGAEM+OQZAg1bxzAMB0kFZfwSkZpEu8EAe
	BmzArc=; b=HPqT79KxZ9SGeVYH7gEM4p4JtAPZkBbGPMMEgJ/HzOWf0WgZWAIhg
	qg+BN3MFSzy+k6O2gcgklC6qIsFiu69/NDF3rAuN3g8gWUpyXtKaL8pXfgcmNdTL
	ddUbZDPpCJJNloiw9cLz7Ayuw+maeO9r/62YO/XAljpOZbQ5MfVjzoHh/RPHEpSk
	TVX2xh8S/G4riSUIc2IdpgiMq9aDX6VuC5bKcNR8cdibrf31/Dc8Nfj+X/zOaypN
	5k7Ehkf7YEToBrh7eBCjPfp/qV2eEfd/8sreMlwQ8b62oz8tHL5zVw6BXyMDA0Km
	s8sMe7zkpctGCTA0sKlkgAB2tgOmPpkjQ==
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcycjb23-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:59:12 -0700 (PDT)
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49cc954a3edso1797895e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789081151; cv=none;
        d=google.com; s=arc-20260327;
        b=W4hedW5C9krY/wkaI4AjaqBs42l3lnsVt2R43qOpnfeoyrQOmGLSUMBwJtOxIUOrRx
         YKairgjYnlE94DvE5fuPw9E54ZutjHu5RS8tytbYSZJQLLi6pjwtEuQkA2vVSrYOwnKA
         MYiLKBRzkTCYMGmkH0WfjKYRR7BAhiQyBJQwIX/AUHj/WS9SohplZVnEfyWD8ywSzZ4F
         p6tGnQ6/H0oKYUwNA79JME+oweb104T1J1w/zWtYMFzzUFLN1LE2VIMoUzbseEg6jFo8
         wJ7J4F1ZBEjoZWiNOmZBdrRGp03vcbAEi5jifbvJPdYyBpbW2BOtOmCZXJHdrcVGpsaW
         c/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=0jfNGAEM+OQZAg1bxzAMB0kFZfwSkZpEu8EAeBmzArc=;
        fh=SPOjwhN5/26RsPML0snulUfGGWCxFdBInXq/kBu8sTM=;
        b=ryRLZyZu7Ppz5eKeCKKUFzXFjpAKug55kiTlNLvJ1n8JsgWMQb0A2Qe8hYEmdZVPBn
         h0Xr5SKKaYhGTPpTsd5D3ZnyIRHh462oEK6VBI+D0nDR93XHw2ExlhD3dkTTv+q8aftl
         S5d1WyrJcJjvd+kFRdfqPIzRFLkYT9VN/1jqj9Aqvefq5BiKzJSCrIBN4SC40fIs30jS
         xOxTbZUr65K8bH6T+0ZP2AzWpqcV8gTtC06k0MIgMl4DG/F7nTxnVFu9roNizuLnbKDC
         9lljVGMsQTGwsTqBKXwJcslGf4v5E/yZcZKyeaAwwFCtx98H6x+d55CJFSZwQ9Qw/Qd0
         BmIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789081151; x=1789685951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0jfNGAEM+OQZAg1bxzAMB0kFZfwSkZpEu8EAeBmzArc=;
        b=YrtB3s8T4S721RPx/qZA43G4D0/1ikgEN7rLb8pCKL0I/2KpE4Id1uL3t8bMYEniMi
         uC5vrzFI61IwtzgD1Q7AZX2mHyZmAt9KhL1lcpy6eun/cFr3hjCIR3cthr5lEZuQFzRv
         S3LAvRjEulT/jgsQdzG/NkpDIPaskAqI/dLGRPBLfOk5rrFUHHyR42MPgY9WT6wHew5R
         uDQRPz3k/324zFXlDVIY4HOJpWMb7ru2LHdt8XBGNcc++m2kb4VCz7g9Cbzje6NgOYM7
         BOmXqiG13AGjiupLFvT3n62OvYejShtA3Y3H2Lvj/GGIJpASwqLXGBLe1mna28xtplD0
         mHng==
X-Forwarded-Encrypted: i=1; AKwUvByYOwDvk8zrQNGepzgzc4V1TDluRjdSpfh1+/EYIbcY13izkkcsmFz34IPjaRCjdDwLetC2hIdWYUwe1mw=@vger.kernel.org
X-Gm-Message-State: AFuF++ntPt8+hqqbhKYUKWzOM1NMxVYBFbdohQ1/iI1xEHcSeFioJMBx
	GW29+/ynvFw+h0Bcz4rmISid3RobJWulrde0gNuhR+VaOvPQdNOTGOFfxqdXEhAejRv0jtaDURA
	PCWp/MXRa/whhkgr6QBgii5JS8Ng3QF+1WWLkeOa8bAP2t/HzdatcMFmtrnxmGzGPmcv/ABr3KS
	wCpWTP3adPFWN7RN7zaCt+/K5qKDZPEiinR2SYNkM=
X-Gm-Gg: AYBFou0WzSRiu8CjlxJbp0QbRH8ZSgvsYrjAO5sC5RPcZ2lBV8ObAuzFBvN632KFS1f
	sKWzdIkRCqA6fpPXBUBohTiG69PmFHHEuFdm1Nw0vbjWA+0yK15nRUKBNIZKMlqD3OxgnN2lfhw
	9zhLujHlvOFXvf4TnNF69D70C3HaULGjGO9LO8dc+LtuCOsa2m0tkPdQ1Q6g==
X-Received: by 2002:a05:600c:4691:b0:49c:fea1:f792 with SMTP id 5b1f17b1804b1-49e6198f947mr15649215e9.12.1789081150934;
        Thu, 10 Sep 2026 15:59:10 -0700 (PDT)
X-Received: by 2002:a05:600c:4691:b0:49c:fea1:f792 with SMTP id
 5b1f17b1804b1-49e6198f947mr15648885e9.12.1789081150567; Thu, 10 Sep 2026
 15:59:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825220616.3842633-1-usama.arif@linux.dev> <20260825220616.3842633-2-usama.arif@linux.dev>
In-Reply-To: <20260825220616.3842633-2-usama.arif@linux.dev>
From: Nick Terrell <terrelln@meta.com>
Date: Thu, 10 Sep 2026 18:58:59 -0400
X-Gm-Features: AcwNN1Xkkvpw5kh_J4iDqvwaktvZZyPgsMQn5je-Rl0y9F9lfAVGewsJgep96yk
Message-ID: <CA+BOzqrLj4AKQT-O+MyUPYqgYiz3Q-hY5=HSG8oFPjNwd0ZYRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: zstd - Avoid redundant cstream initialization
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, dsterba@suse.com,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, terrelln@fb.com, hannes@cmpxchg.org,
        yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
        shakeel.butt@linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=KZlHIgYD c=1 sm=1 tr=0 ts=6aa33640 cx=c_pps
 a=Q4jRaax7EcWM5fECTC1wcQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=-natSxOHJVU2ER_2Es0A:9 a=QEXdDO2ut3YA:10 a=nJq5_VNI1X7IEIKzvdHs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI4OSBTYWx0ZWRfX15hhQsgGdCP9
 OV11C1HFkx4WLEr2vG3I9MXdMjZb1jzUeE+gzBGckMTFHGxEkz7jndmR+yDiDJCaiZ2dWMg01Mf
 DsUsT1X1kOEuTXBNYZLicVB/rGKPtyo=
X-Proofpoint-ORIG-GUID: i1_pMHMWBlDD-hy5DTw9FWQ2mZ2qMOw4
X-Proofpoint-GUID: i1_pMHMWBlDD-hy5DTw9FWQ2mZ2qMOw4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI4OSBTYWx0ZWRfXyBwkzcUyg+l3
 vDaXS9vHV6ehDSR+Mdk9zl4nDbjMpxhky/ArggAktNNPeUN5v6ZsVaMc0vCEyfNweI8u43D3lFr
 1J74wVGdpqTAQSvlG8Yq/m9kHOr+qXxBiPnsxOsv+BmN107FP39mx8GPx5ow3D+atJnJJozuaOu
 ovhkoSMRyWElVfDUu8aEik3z2uSWS/+n/qgLKf5gEP4H3K3eU4rtAJmposvdAPfPy3VkrnhaNTq
 013PHT6WwlzH2c6X3S7Ip407qwr6voxWN8AbDSbefVofKPUXdU/FllfsqjDh7r4HMvPwkSLCZOk
 daM8aBr8+kSiqx/afM6A2RyjMx0KYijF4iM6/Ay2s2Y1YHX0C8JZSO66WpRCA4IYx+83TLMe0JM
 VwE4Lj2YeLgP/yhCNXo9hZ9yB+6NIlw6V3+XePlOiwC81WpzmnpLjmpuzpVSz9Gqgj4TBbl7ysj
 cIF7IjLuSRfOxxfxI1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01

On Tue, Aug 25, 2026 at 6:06=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
> zstd_compress() initializes the shared workspace as a CStream before
> entering the walk loop. If the first source and destination fragments
> each span the whole request it then hands off to zstd_compress_one(),
> which initializes that same ctx->wksp as a CCtx, discarding the CStream
> setup without having compressed a byte. zswap always takes this one-shot
> path when storing, so every page it stores paid for both.
>
> Neither is cheap: zstd_init_cstream() redoes the cwksp layout, zeroes the
> ZSTD_CCtx, probes for BMI2 through ZSTD_cpuid(), then resets the session
> and parameters and replays ten validated ZSTD_CCtx_setParameter() calls.
>
> Defer the CStream initialization to the first walk iteration that needs
> it, guarded by a flag because that iteration can be reached more than
> once. The first inner iteration either takes the one-shot path and
> returns or initializes the CStream, so the trailing zstd_end_stream()
> cannot pick up the stale context left in ctx->cctx by an earlier request.
> Unlike the old call site the new one runs with the walk's fragments
> mapped, so it has to release them before failing.
>
> For a 4 KB crypto_acomp benchmark for compression, twelve runs of nine
> 30K operation rounds, on the bare-metal host the median per-round mean
> request time fell from 52,283 ns to 51,038 ns (2.4%). In the one-vCPU
> KVM guest it fell from 16,675 ns to 15,050 ns (9.8%).
> The larger improvement in guest is because of the pair of CPUID
> instructions in ZSTD_cpuid() that the removed initialization runs.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

This optimization is a clear win, and makes sense to apply even after the
BMI2 patches in zstd, as it also removes other initialization work such as
zeroing buffers. Thanks for finding & fixing this!

> ---
>  crypto/zstd.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index 556f5d2bdd5fb..d64472f3e11e5 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -96,6 +96,7 @@ static int zstd_compress_one(struct acomp_req *req, str=
uct zstd_ctx *ctx,
>
>  static int zstd_compress(struct acomp_req *req)
>  {
> +       bool stream_initialized =3D false;
>         struct crypto_acomp_stream *s;
>         unsigned int pos, scur, dcur;
>         unsigned int total_out =3D 0;
> @@ -115,12 +116,6 @@ static int zstd_compress(struct acomp_req *req)
>         if (ret)
>                 goto out;
>
> -       ctx->cctx =3D zstd_init_cstream(&ctx->params, 0, ctx->wksp, ctx->=
wksp_size);
> -       if (!ctx->cctx) {
> -               ret =3D -EINVAL;
> -               goto out;
> -       }
> -
>         do {
>                 dcur =3D acomp_walk_next_dst(&walk);
>                 if (!dcur) {
> @@ -142,6 +137,19 @@ static int zstd_compress(struct acomp_req *req)
>                                 goto out;
>                         }
>
> +                       if (!stream_initialized) {
> +                               ctx->cctx =3D zstd_init_cstream(&ctx->par=
ams, 0,
> +                                                             ctx->wksp, =
ctx->wksp_size);
> +                               if (!ctx->cctx) {
> +                                       /* Release in the reverse of the =
map order. */
> +                                       acomp_walk_done_src(&walk, 0);
> +                                       acomp_walk_done_dst(&walk, 0);
> +                                       ret =3D -EINVAL;
> +                                       goto out;

The other error paths, e.g. when ZSTD_isError() is true below, don't call
acomp_walk_done_src() or acomp_walk_done_dst(). The difference is
that they are returning -EIO rather than -EINVAL.

I don't know enough about the acomp API to know which behavior is
correct, but want to flag this as it seems like one of them may be incorrec=
t.

The same question applies to the next patch for decompression.


> +                               }
> +                               stream_initialized =3D true;
> +                       }
> +
>                         if (scur) {
>                                 inbuf.pos =3D 0;
>                                 inbuf.src =3D walk.src.virt.addr;
> --
> 2.53.0-Meta
>
