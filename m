Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795898493;
	b=UpVByCZc86WKayxM9D6eJpSdf923zSlMSbB7lRYqNcor8CTwwL34zClU3znvVhAr2HmG
	 wHAtQTmTPKmlUpXvfDX/RNAz8137GLFfm7cIl3ohZiVVmFu92/ByBHeGcKf0yu5rnTI5R
	 MVEFj96CzI48O70nQlS1iEY8eu6F7iznRyc2w8fn3L2Wrv3gCZpxy02HVBs3jk06jN8Sa
	 6aBu3bnNoRfZGliUaufeEy8dur06i+241fO5hq22B93sXM+3qNYBWzlcp9wtKeuvFGYJa
	 D2617diGQDBA1YFQ85c9pF0i0g/nvuZ4eOg8j8nIEGUxUnMNqFDmKZujV/N/PJXsXJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795898493;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HMwVJ7dL1ifDT9GveOwwZwoUBpC4UVFhb7MD3nLPAeY=;
	b=jXlXgaX3fDo66zQbUX53BVfkW4uyUYyDv30e/XgbSTz9mUsg2pw04RoEBxNzuL8WLRwP
	 Bmdw4DTX7FQ2MVnhb1R0onL5msvFWGpyWgueoysHpSI9XU9tG63P60JXxbWb3/oSSPq1Z
	 /vYv9ON1ATc4qemB+yFkUOWAWZH3VMlmIeluasyAIlAqYL8khKglpYjqzod3MsjkQqWhb
	 pxyBzhmLNv33Tj5ZDQXc3IbvOiyvaFauJ0lyER/CRoU//JNzsSD4ZHi5DbNvcY6m2rYGb
	 bZPP3RRQ5igImoC15WS/bzrlKh2wVIgn38aNmJmF2PgkGpnX6m5IUckd5URRkU2yR3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ln7vnR5X;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3599606A321
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 20:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3599606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ln7vnR5X
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so8531024e87.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 12:41:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795898491; cv=none;
        d=google.com; s=arc-20260327;
        b=loQDZWKVi828nMEaAJuwT8r7cAE9uR0alrkLx/ZbECpHghtKZMAZ6oKVGdV2fD8zb3
         pZMGU9ijr0AvNYuyNO+iBs4vj4iRBEo85JxneMCUJSqxhAWDSV2iUWmzQBFlBobPo5BW
         2yu3Ob6FiaMc2RGeDNwUqoSb+1igbMFw5D1M1tzrQEQDPrZckEUM+A0uWf0HZ2UuA+Tc
         c3ZKdf700K9CSThEPh2ac7cYpUAwLo6s1wlH0D9XX5hkZJeqdlbgSK98G0tQasUKON8G
         2wabwYO+6qFwZ1qZxqf7cqcuj6hiQ8TU3wikWEkl0ZiGEv5LY+hACn7wIeMweoropLUS
         K+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HMwVJ7dL1ifDT9GveOwwZwoUBpC4UVFhb7MD3nLPAeY=;
        fh=36FIHJZ+4cOJNNLD6hDLRlOxbsX35wHigEIInGik5F8=;
        b=oC9D50QNJMcqTETyyvRyLWAQbuzm9SA/lv3pq72fD7rwy+4J6kBF+PO1/7+Ipxokw6
         pfEJPSmWTA5NQLTky56W7QrhKb4SWnlWGdCZVtoehrpRaKivfwu8we76AG5NA5+bq9R/
         ryU1gy5pwbC3B9NJQ0jzmZrHXldLWho67WYdWIYN1PQBH24d31XnP1usbiIL4/zqyqXK
         /Me70B0x+EpuqUvW1rEk0GuGiPy8dnsZaaU4XOtabW1B34QqhquEwkerIifNKHFdBIh/
         XiIYheOIGeTvC3rx4eLcEb4jMZRKX58bTmnfJAC7Sb4InxTmH/rHz5C4nQi8Rrd4Muua
         tnSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795898491; x=1796503291; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HMwVJ7dL1ifDT9GveOwwZwoUBpC4UVFhb7MD3nLPAeY=;
        b=Ln7vnR5XWSa69danAIeabNYrtMNNUHVmlRCDEC33ER37CiZ8Tq6kZyFrE8OzITgqrE
         /THY3KXUtCLNBe3HjpDvxylW7ie95PLwMmRsNb2vzKpaWNywXcn98bvL3JL61La7/MxE
         0q1wE0hrFhovUbKBKioJQAiMC2WmG8UmOG55knePtzGoRYd+GKC3QOj4OIoTG9XWMpDP
         1QAroyY/815rc5CAmbmjSflu/hEVVP3ctVwPYEkepMkYYGOnl3RlBc0s9fNfdgytLPQ/
         nUz60KCgnF+4tLIeBIUCL87P+lps57qayOvCAk2ClGNbEQeD5Bc058GO5v8c0q5qgM3m
         D1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795898491; x=1796503291;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HMwVJ7dL1ifDT9GveOwwZwoUBpC4UVFhb7MD3nLPAeY=;
        b=0rwudty87ikrKXEOEsEoneasDyTxX3553iXVEVRZwzy4I2PF/YDU/9xry00cxLGHEi
         Y7Zm66umhpjTsUNTw2yIocLAjupfG9M8K0Qa789UBEUOlFGCuqnNMnYWsktN26v2rzkW
         aPICBsLvNYd3c9KUV3YZg4RILhZ8wXfZGzVXkH5Yc0153DftM2SKckBzPTN3tBrXZEWr
         oEf0BFleBCBf8/E2+T8AnZOcoOlD62JNkOct8U1816171gyhd2SlnNIeSMek4j7x+SqE
         rqxjM4hBR7tZBmaO1tnZBYDyNnrTr74XvJhj1sJxTtlRjPEWjA7UdnDakn/CSmMikVkN
         o9xg==
X-Forwarded-Encrypted: i=1; AL+hErEmBbfI/Jlv4RjEvDh0Wqnn8q7wRDYvCYobIlWaI+fvG3bYC0GMKS1NkCpZUaZvE5w4I7jE+Oq3X75uOqE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+5WJVxS4j1BQLNf1Zkutuuye9+JNo4+Uk+QGpNlPwGMVZKT1D9
	jY041i236htaOxxn8N298kff1+D6CbdUEE0Oc7RKr74HBeKIeG70gYtAgt2I3QOydR8o2RUBVhC
	L6wMHWCEI4ij27yxAi0Uk8Ogidvs7p98=
X-Gm-Gg: AZFdTZeBDby9/PzQzx0GZbkW/kz6SKz8VWAzrM/ODU15X3PJNKB4kUT/+emSEAMn5ap
	pEw9IlAKgYkBwj4crhsn0GcZpex+WvZOcnwjlMqHZ3Wsly038SrHhH8SVhlBJ9kQrdaZTiP/m1g
	NRlZyZ0uSYLZLmVQsLvkQy5dejZEpp2kNJ+/hUKJi6wbFhvFuXtyz4ySoIJeMcCYBqwJDgDyNC3
	E5k7wRSj+O6uBPJDYTTGmYRS3jBcDLxQu+W4CP/pb2aWwDr3Ut2a/69DpIQ7NtlQAAQxDMTkaAp
	7I6OrufK8aJFpkqzp1cIlRYsnRyaR94fcY/LahjO42CE5Chyd4sOBevDrF7i6ILkWK2DLGivpt1
	5E8glrtC/vTaLDCjoLNzg3d5jjGZp7pSTOV4T
X-Received: by 2002:a05:6512:118d:b0:5b8:f0d9:98cc with SMTP id
 2adb3069b0e04-5c1bc89f8c4mr8823227e87.61.1795898490709; Sat, 28 Nov 2026
 12:41:30 -0800 (PST)
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
 <awafBxDtUoIQW9iR@gondor.apana.org.au> <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
 <awfGfqMK8FfrMNvz@gondor.apana.org.au>
In-Reply-To: <awfGfqMK8FfrMNvz@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 28 Nov 2026 12:41:17 -0800
X-Gm-Features: Aa3M54rfvpKZ1iXY5H7PkX-tex-X1QEjTsDEgPTNOAO6bTrgL0ONAnYpnjSJHdk
Message-ID: <CACpmpod012iO48=dMSKOBXACwYVgiWw4A+2pjARG1qYSz=7ZJA@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 9:41=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Nov 25, 2026 at 11:08:20AM -0800, Kanchana P. Sridhar wrote:
> >
> > -       if (unlikely(req->unit_size && req->slen > req->unit_size))
> > +       if (unlikely(req->unit_size && acomp_request_dst_isvirt(req)))
> > +               return -EINVAL;
>
> This looks good.

Thanks!

>
> > +       if (unlikely(req->unit_size &&
> > +                       ((comp && req->slen > req->unit_size) ||
> > +                        (!comp && req->dlen > req->unit_size))))
>
> For decompression, shouldn't it just fail unconditionally since
> we do not support batching for it?

Sure. I can modify the decompression check accordingly.

>
> Also how about moving these API guards into the top-level compression
> and decompression functions instead of in the shared path.

That is a good question. I think it is a matter of balancing between
code complexity of the top-level compress/decompress API, and
encapsulating some of that complexity in acomp_do_req_chain(). Would
it be Ok to address this after the patch-series is merged?

Thanks,
Kanchana


>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
