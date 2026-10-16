Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDB2F7EE1
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121558; cv=pass; b=Qo8ShagPo1RAU15zRBKpPVa4EVO9dVcsBEvXGR7f3rXkoh3I/CO+7/MkC1bZOMxpFUzqh0ot0zYogN2cY8SHxYqu0ezNuVGe8GR5brRJZUsSMHLZiwiMCRODvZYp6TgS72yK1fq5gYm99pySKKC7LB5wsvpPSWNnAzd6q+EFlss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121558; c=relaxed/simple;
	bh=06zrE62fKrgiwoRcGb8h+2HCp2UBFMGvqy4x7WN+014=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LMDfWh0oLtGGINBLjlW16CyMfIeH9TBcoPVDxAf6q0CgqnFEd3oHXymV5mMlGHMsWnT2TX44uF98WIZozvVN+hbjOZYnXrcLr5pujp2K59lZk1flXwV13HmrJJTCwiqbMXExMB/Dx47/J+K96sNLaf19rLxcwGJquX4OIZoS3kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qEBIBlM+; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEBIBlM+"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5ba3ec92031so6184941e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 20:32:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792121554; cv=none;
        d=google.com; s=arc-20260327;
        b=sY+LAOmAW/26qff4/+pTaanMMNdKnF8AbfdFDEkGsyC9xKuCe9+PDP4j64NeotO92p
         wJnRoU+MPMBchcOnK9S0Jucnw4KcpoBNqHkDhoRXtYx49RztPls6rwipw4D1uz4LQZok
         mPkSCyTi0rcWdswB84HwzAtwdHhvDHBef5UnXl7GTP78VrTBufVyXKtruXwmWONti9Tf
         aNS4GrztNDH2gQzObCZ0y7B2I1B2x3llryKah68lsRYfogyHlVOigk9RtWrJZgAenGfN
         JtaLbKGjm8sat2MLpDbssPpoCUiCufybOcmBjtAWw+eNEIxuMKzmN3TwtueTnyKUu/rj
         gK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        fh=1LckI8XCX3n9+OPgRE1glmN9OCCBkySfxiA422DgmZI=;
        b=Oiiv7pB3NZfeYGfTwoXyeym2/M+TH7Fr3Y1LC3WmY43m06C5w92UJDuOwcPJwhTGDj
         rCcdFnff1rFAy+2eCNudQWvBFET/2AYFjdqzKu3AEwSXnhF4wShTZGBij+dqm5NL48O5
         cqjMnz/hCi7Zw3MnKN1Q7IYf0aVjVvK4Zwc9NPvxy8bD6zliVDxT0yk158ZozJpYlO4U
         tepOhw59SL72akiEcRAbNlRFmiRVk00BVIYFlDu3qYBxHH0+4uikGrFNjMExrLX7sCPh
         oqYbTvjDQ47OlNUz8gPgX/rJbKC9tllNIHkGsWN6ldRgXcJV6VEgpwxOZZUu6Dp1aRXM
         5oPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792121554; x=1792726354; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        b=qEBIBlM+XtKRBkaWrZHx905ToXnVkqofsohd+gI5tyoKyiFKYXcUOtFiQxqzEJGBc7
         vVR8AcBgwumHAYQl0V9dYhb/Yl+3yJ8yFLK5Ib+BRSU20qegSmuz/IN+ImLLltShMGXZ
         ASdh5Wy4/PY8QIqH61cRft5nZYt0F049w7Txfmmufp+w8vUiStBXKI8C3MrZKaHsPibG
         9AjZLX92ySlPTwoFJj36DIMczg7CBrDagjJTCOm8+h2H7/HMx584YVQtjUTuHEu+Vt2L
         lyqtuu+4Wh/YUmKdukcpcIKxApKMPYmZfd7Nd4DrDiYxzwBp/zAXUPfvlDStqNRZpe8/
         JAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792121554; x=1792726354;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        b=NBmle5CNbwCULfaxakBVPTT1IPEfkzPeMYIUs7BDmBIOut8bmuWkBmTy3RQJmZzXSp
         /CJXr39oj7n8fO9xYdrhMGcLPHMaLcpyNedVcqrKbzmb+T3GClzM6s13UZX6CEyVGdHH
         mxkdCr7oWCdr0/NL+as43t1wnNMeo4e6/1FrjNczlWCF+tijBEHSBaV0ZF6utPFFynCb
         bUF9Rjp0vYpZH/sOeQ4f9LCKilJO6utZi6+PZ70ztJY0DA4xggVE8FAvWRY8Qb5z9Eor
         UEa/3d/779YxBYaHAZs3h5aXjNSjlmzuTnj8gLbkAwDhVtJMdfMo0OjZQeqA/lR74bHc
         ZkYg==
X-Forwarded-Encrypted: i=1; AKwUvBz97ZqCjDFN0SsGeLMcW96CyIaQuVQI4GlvKofzBYqpNcP3nIZ/7G44rKHVaAL4mKybb6F+gQBQ7CEGXH4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJIR6Cg3X9xylGdDaQJCeOGVsMCTiM7V0RcVD/t6e1a3ARdY61U
	QYmd+vn04wVPMjmPZNl1umbMqS1iWFRiX9h7SRWu93fWs1jvtiz0jzKHTGrpcr3ygf0XC5dfrWr
	VI0q79m0l+ywSBclGYaVruFRO6FjImZfR9b2R
X-Gm-Gg: AYBFou3uhkOeSONl/diBDefQK5Ldmwqwgg/3bl7mn825GJ2VlDOvFrnkdQy7pzhoG/n
	J85bAds+kkyFUL++HfaTbHJy2J3jHW0esExl841QpqqKM/TAMIbOR18t5agj0Dr58j5RNMiqYyG
	qRJMwzhLJJOU8ElBYSMZdbt5sRRlbPiBE5UC5TeUQ4pGc2aIErlp2Ag9bm4bdFXowVA+wCA0Vt3
	1S9p9M72uP+N9gRyaRRdPXqqrVGNqj4XPgt3yjDJrg8HXOLDI/oitBTAV/ybY8qvvteQs7LN0m1
	ftBecUQzusnzP0towXPN4OpcGPwyUCDDo6ShZFVZaGBd3mEJdnwH5rU=
X-Received: by 2002:a05:6512:6687:10b0:5bc:e472:11f9 with SMTP id
 2adb3069b0e04-5bce472122dmr4219021e87.20.1792121553829; Thu, 15 Oct 2026
 20:32:33 -0700 (PDT)
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
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com> <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
In-Reply-To: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 20:32:21 -0700
X-Gm-Features: AclHuK8EwiGuB9ddUtL4cQ1Is2_v69m3igeGciRO29KLyhbEMLCUdPXew-h6hcg
Message-ID: <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 4:45=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > > > How much of the performance benefits come from patch 6 vs pat=
ch 8?
> > > > > >
> > > > > > This is how the performance changes: Average throughput is aver=
aged
> > > > > > from 10 iterations of usemem.
> > > > > >
> > > > > > patch 6: 19,119 KB/s
> > > > > > patch 8: 17,593 KB/s
> > > > > >
> > > > > > So the acomp_do_req_chain() path that ZSTD goes through with pa=
tch 8
> > > > > > causes a regression, even though it provides a generic batching
> > > > > > framework in acomp.
> > > > > >
> > > > > > I was able to retrieve performance with the following change in=
 acompress.c:
> > > > >
> > > > > Why add it to begin with in this case?
> > > >
> > > > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > > > co-developed with Herbert. The request chaining for non-segmentatio=
n
> > > > algorithms was as in Herbert's original implementation. Since this
> > > > causes a regression, I would like to get Herbert's Ok on replacing =
the
> > > > request chaining in this part of crypto_acomp_compress().
> > >
> > > I mean, why add patch 8 if it doesn't improve performance? Seems like
> > > even with your diff, we only recover performance, but we don't improv=
e
> > > it after patch 6?
> >
> > Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
> > KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
> > in zswap, which is the purpose of this patch series.
>
> No, the purpose of this patch series is to improve performance, be it
> through the compression batching framework or otherwise. The
> compression batching framework made sense as it provided greater
> performance gains with HW batching/concurrency. Without that, I am
> honestly skeptical. 2.4% can be within the noise.

I seem to have left out patch 8 after making the crypto_acomp change
to not use request chaining.
My apologies! This was an honest mistake..

I have regathered the 10 iterations average throughput of usemem after
applying patch 8:

                                        patch 6: 19,119 KB/s
crypto_acomp change + patch 8: 20,946 KB/s (+9.56%)

The purpose of this patch series is still the same: to set the
framework for batching of zswap compressions, and not just of zswap
stores of large folios which is what stopping at patch 6 would do.

With SW compressors (ZSTD), patch 8, i.e., batching of compressions
and storing the compressed data in a pool, demonstrates significant
performance improvement (sorry again for having missed applying the
patch earlier today). This is because we isolate the working set to
just these ops, which benefits from cache locality and minimizes
evictions: as against the vectorized implementation without the patch.

One of the immediate benefits of this framework is that I am using it
for bulk allocations of compressed data for a batch, for entries that
map to the same slab bin. This proves the forward-looking benefits of
isolating compression and storage from other zswap_store_pages() ops.

The crypto_acomp change I had mentioned earlier does not hinder HW
compressors in any way. As mentioned in the commit logs, patches 1-4
provide the API that can be used by HW compressors as they see fit, as
long as they register the segmentation bit in the algorithm creation.

If you are Ok with all this, we will need Herbert's Ok for this change
in patch 3:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..db8e4c82b900 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
                return -EAGAIN;

        if (likely(req->unit_size && acomp_request_issg(req))) {
-               if (!crypto_acomp_req_seg(tfm))
-                       return acomp_do_req_chain(req, true);
+               if (likely(!crypto_acomp_req_seg(tfm))) {
+                       int err =3D tfm->compress(req);
+
+                       req->dst->length =3D unlikely(err) ? err : req->dle=
n;
+                       return err;
+               }

                return tfm->compress(req);
        }

>
> > zswap is the
> > first user of the crypto_acomp compress batching API provided earlier
> > in this series, which I think, is a great starting point for us to
> > evolve this further, as mentioned in the cover letter.
>
> Without a non-trivial performance benefit (e.g. with HW batching), I
> don't see enough justification. My advice is to try to push 6 (and its
> dependencies) separately.

This doesn't penalize HW compressors, while representing the status of
what exists today (sequential).
