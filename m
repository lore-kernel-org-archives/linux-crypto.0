Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11055280035
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792104843; cv=pass; b=mT1vTcrEzuAB/cTFakExOajYQRttb29JTHhptYoi3Z6raQkcIcKG4nFP+5OAZ6irD9hCTwESUQe4X3KjISdNbVDZTXwEeEdl6viDNzcs1cqYoocCfHfaPRrrL0j8aeTK1eI4VF/2xdjiTD/RRW+3mdgifFqgF5uhp6+a6u81LZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792104843; c=relaxed/simple;
	bh=akJSZf05dfo8ZB1BNAXdg6JKZt42Pqg3iN8HG2G8ViY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZ+4YGYRE5YsKeGVXiwJ9165aap+/4b4NrtugtNHkPn7VuyjH+ljxmGLNA9UZqWp+4QHMystDOZfCdAgSx/jTLcPqYBaWM/8TJ1pDwC9rEJTBPE8o6oScusiqlYozeKkJx0B67RRWnIMf1OeZR1BkL+q0lWLq5TKnZeMT331Icc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qQWc7lFx; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQWc7lFx"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bcb4f23ddeso2085737e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104840; cv=none;
        d=google.com; s=arc-20260327;
        b=lLUdGsecOsU+4Zt0sWbXTW0N1Aasy/+NN8b3/EkXI4bISzGxX+Kq+VkJe0/1SwAc6E
         vFSmbIAuxBhmV5CzQ3q4aYBpMOyCkZxjGT07CItZax/7T2RKgZ6NPBDVODm/suUxvRX/
         mWBn62c8uZth1fPjTWr4WdsLRp1hPdRKIpm8CK8Hg+ToGquXv/s+RWu1pnkGiDB2a3CV
         z15ppLMnfYzIxB1vW7MhcJU2ZUldbhaem37VH+lMsKFX1wW7Mpf/5wkyFgsKSyqh7wWK
         TlZvADH+hS5PYAW2HwlteLonqV4bf1SU+tbApn2YoHRSqgLPtNsgYxIyHjrSZLxUALIV
         sODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        fh=iY7vmfUGJZJxx8QsYs5wyCkqDDTcYMzmv97VKu4hD5Q=;
        b=Cq3V0l18Rb2NQhbGuhalUDCrq1oO9N7wczT42JWwZ3tS5myHjXv4JFF683s9JUsLDg
         RJq7d2XJ4GvgitEfuc6S4qLzAsH4UHVmyB5OD36Z+ThqKoF34vcBJJIKYmDXSQtdR3Jf
         jnEs34tgQjxXOiKExwAaWEBxyTz2pigXtHhoFroS99uhAiOgS0XrU+ZOY7wcdCJ6j+cr
         r01pwa8cD0+ioqXNcq+toxALg5Xeku5g3wZhq+Z0N2z/HIhfi88HWA++jVALv2g3ZdHD
         2PXtVDOVYIEEVriCtgPuzo3S1aAKQw/IiEEDs1oErGHXalWk0vY4YNjfbsxgz95UqOJT
         W+gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104840; x=1792709640; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        b=qQWc7lFxJ1RyoCqcSDOjxZ3ETc0DtXIHOCtsy6twsT3sGqlNYQRpT5HWjv9nPGUIh6
         VO9TiWrWriobZtdSf8o1ULX39jDmKJYGf2KKZSmXc+G3gQwaOAN044cycCC93U6RcsVs
         qrypXVmOX1fV3YxZICFwciWbsVVTmwJsf1EBuyZY1Wnc/ZjfPZHNEth2BtrZESrY7+y/
         6ITnDNPSGUVfiVPyZELB9xW8mBI6QqLskDUKz2B9Ct/XRWnLe2Yf01YgLbrw7BuNrRRt
         HegR95tYxLisIYPS7p6d27IFl4+KjZwq+3yb76kRWloxrgZSt6XO2F13UQzJBtQ4SXDp
         bFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104840; x=1792709640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        b=GHVWozJX3ODnoTFh9W4K4X/BrtRMYGT15taKGPmV1DBh2G80WHVdSOT0Lv7192iIN9
         JFc4MFALHU228wli6dWi2YWrAeEZNYpA/jzrqvtzlIBnXBbEwrv3Z0smM/4n83hIyiDs
         y532xWqYXWh/MUr6lCVWAon3RIyeLNx9/uhpu4AXbKNVXyP+aXLa6egXgFbsy9pl9KNk
         YOdroGUIZZhWVt6cpTu5fWNlm8XfJBasdQjasXqwGY4Jst/yGnMbMWNmxSdkvveJVVt9
         bDbEJmiyureVvTcffC1FVGaza9sXpQ89KkQzFeHBltPybX+n0scGtZZpYsMD7TaoJDV1
         6pAg==
X-Forwarded-Encrypted: i=1; AKwUvByqY0eWMUBjjAQHI69h+A+0x8GHhhcfIpnUA/rYKrLsc0D6a9M6atXIq49eTj20mkzNxsfUXOHQFVUg6OU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKGmuCAKsh4ZUkO9Lrl8d6039kUkWxWwc8AbcQQkf2YoGWTNv+8
	mSyE+KY3n7xy8CCih9+yymKcbFI6iTa55ZJ0w/t1FKcXU0kvbqB4nmXOhBlqL7n5cZRTNhHJrom
	p7yOZ3+7oTR0D5Vqv16njyLv1tETf7Pk=
X-Gm-Gg: AYBFou3fDL8G9ytAMvataG+ps/0wDgiJaniSOACBrk5YzvjsnCgtzbPGmSuJMZvCp+U
	PinizKhSTK+yb++cLeqZll4+o9M4LWv0IW83G/MyTTZsGvM2s+QfgGQ+Vk673diXfJzUfp3Y5Dt
	H5gDAxbOdwMSHA1lrwjqJ4rOCSTmdShZZVPgfiaPnNx7Du8LTsqDhpQCMRPp6Q4pDsRr0dpZG5X
	J4yapJ3yBrg8roZjGhOkHA5IBQxID0BJXe7BxnfmIdWo9tGhDTXTKZ6fR7a/P7dyjnRtZSzfmVt
	cGLmeMtVW/pbRlW5NjJ9pDSQynoElfzGRq/78VYyrCC2UQxC7Y8vEzk=
X-Received: by 2002:a05:6512:4022:b0:5b8:f15d:7a59 with SMTP id
 2adb3069b0e04-5bcde362a09mr6934603e87.7.1792104839491; Thu, 15 Oct 2026
 15:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
 <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com> <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
In-Reply-To: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:53:47 -0700
X-Gm-Features: AclHuK8XCRmndmlU8lQlUVHlY-_F-OMKekh2ybGWDMTVBykCkJfOyvNAoky4LzQ
Message-ID: <CACpmpodjZ60-r_VWu9ui+5o2WDSJ3gWEY79dRNp5Bei4dPwsrg@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:06=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 2:49=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > > > Place and align the members of struct zswap_pool and struct zswap_e=
ntry
> > > > such that members used together in compress/decompress hot paths ar=
e
> > > > able to share the same cacheline. Minimize holes within these struc=
ts
> > > > while doing so.
> > > >
> > > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > > ---
> > > >  mm/zswap.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index 8ae67fd10522..ade84ac4076e 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> > > >  struct zswap_pool {
> > > >       struct zs_pool *zs_pool;
> > > >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > > > -     u8 compr_batch_size;
> > > >       struct percpu_ref ref;
> > > > -     struct rcu_work release_rwork;
> > > > -     struct hlist_node node;
> > > >       u8 idx;
> > > > +     u8 compr_batch_size;
> > > > +     struct hlist_node node;
> > > > +     struct rcu_work release_rwork;
> > >
> > > compr_batch_size is added by this series, why not just add it before =
idx
> > > to begin with?
> >
> > In patch 0006, where compr_batch_size is introduced, I was attempting
> > to place it in the same cacheline as the acomp_ctx. This increased the
> > size of struct zswap_pool to 248 bytes. I later optimized this in
> > patch 0007, bringing back the size to 240 with the addition of
> > compr_batch_size.
>
> This doesn't make much sense, and the size of zswap_pool is not that
> important (usually only one globally). I would drop the patch and add
> compr_batch_size directly where it needs to end up.

Sounds good. Thanks!
