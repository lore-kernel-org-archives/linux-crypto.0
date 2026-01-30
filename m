Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE09308F1A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817215; cv=pass; b=rZpamEZGPIuvDzBrOZabxtEdihwXRkaNqiT+729ObVE3p4QPZKTYpc3awX+pw1ITCjxQ/LwiBN+C/DjCcVNJ5zZ7vhiMm3RUeozOpGRM6zndVpy2BOwiQ4/vXghVmvefYUKFXiNm8bl2UEGwydgSSpkqZfLnHgD4ik8xdnYlUNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817215; c=relaxed/simple;
	bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZV2ho1Ikhh7UUO7Xvp6DjLDtG4x2pvVmZaOjH8W9iM9apq9Jj1cUtwii3xZfO9W2llEs4meg6bQNtXUSmUUb4tGM71FmHWAZdc5j3L9b35GPhP/5wmp8ufUIaPygidwo2iu1P/FnC1unkWYpGpRKQgavLPjt5KEZF6VgN7Ue/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEf0nwml; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEf0nwml"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4805ef35864so22216935e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 15:53:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769817213; cv=none;
        d=google.com; s=arc-20240605;
        b=bNQFGl5Xgfzl/PwrWf09dQg8atW0fSeRBbF6j7PeKZUx3A4o1Gir/cweL16Gvy+nEl
         AigYXHWkGN9tWFRKgOgkMH0VPExBuBuFSc6/zhqK/YZErjbBlkvwLdKktBvAq5jUao5l
         xcHdoSpINmQwI2NFaPXg/FYIrENK0X2QpjR8fhgRm8v2z6Oht3dIoz85P/I3XaFqJUgO
         TeRCyh+6Czb7reHOfjTqjV8VgkwOisj1ZZEJpDuMZjK+oTS8lVWd4iFfbYVA1rHGq0iu
         vT+yuPQFaR3U/eQGwV2L8hO6oiCZVG2lUXYXEVAG+zTT/9ZAIiSLuZRpgcy1wFIJTkXV
         l2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        fh=Aos3Nwranals4xZ0S2zzBo77eoknBF42ciG7qTpyDAY=;
        b=QsWa3zhpltmfz8E/8cZwB/Szk/xDa8CxcFRr+PqeeqTVe0PArjnPMnpwUkG8QofQgd
         ebzsd0PBRY6SVKxGQicCr2c1AJZTeMhWV8WtHKJA79zwvYq6oAV7SfAnwGJfLdIUPezh
         +8QoEz3ZZM5Di1efj9Q2Fsssc0fCCnSq2AIBBKI6kq+/U3nM1GbzSbLZ6WwqguFWhd3/
         vv5E3CmV+4RgEa/oZeIIpFPg1j4gmBHVHzr7IN500CIZauqgDj+iPqUoNWD1L3m5jzE+
         0+AJT5EgS1Xjtwksmw9aX2BdM3qqlTmPZZdj8E5m+enmyTWUemNVgjX0/5B+Rn74iMVB
         wlqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769817213; x=1770422013; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        b=jEf0nwmlAZIUsE4uUMyddA960TzUGox7TIQ7M3769CSeyGmdqp3Hi+3EPTjiexg38F
         Xan0aqiEyw+8+POM9vnEFbf5HAEyGjIXJtpIMBKcZiL7a/gYKhqht1Yk2r7tFx2XJMje
         6TLNr1Fa5K1nlosYDIx4sghEnV71UHODYCI6d8RdAau5iKVLsoc4jIGY4iaeu05wceGC
         WChjWRUPvJNvGwAjMfj3ZGTJKFnKI6eemcOHGwrdjj56pr3F3X0gavt31BapMzf0ou5G
         e9gB+nnlwleNIH16OWkUn4Q27ifM1DoGJNvf1NTy5yCTvqZgzHYKdi0nxY29WJcEuXSG
         WGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769817213; x=1770422013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        b=UFcmXUPrJh5rRmtiuwsUaHHwAhV4L7PNnPioOd+lEFwk8PUo8TOJcQYLRvTQF3WjmS
         4FeJ2Rd+TI64d/ihXg1VzaeN12tDDdiY3/jcyxmZ8AnxtzJxn+ip6SygqdnseDNTrjtE
         MJ8uYE1udbLu+UumSE5pfB2CZemzbfHu5qbwaQ4TFRT1zEdmVQQrG8vrA235EVODT7ZY
         ICw0G7uKiKicSq38QaJ7jsewthS6yIIRGvVeWYdw3g73indnOIBdVo6TxOa2GXg8HG3E
         UIquKsS8lTucUB6Wvc59ggiFNx9YuNvRZvWVKWs+ft6zxh492vt7TMh04clO2f82ga6W
         TKpg==
X-Forwarded-Encrypted: i=1; AJvYcCUJZTLqWBYFVetLLIJRZm21osMSQSI6b075gb1O0s+zb6kexG4z/xOix2LPWbLd0Mx/gmr3729pbjagbK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEL1OgC9KBkPXteIW8NgDkpS50soOUaowxfx/t6LNIbjlwZFMB
	zN3wdjBUlDb5jgim7cqyXWuXkubbfqXsR8LLiyYRuUbMCqSoQ7Le6R+Md4JeTuyqxtIdm4qfAx/
	F/76xh6oelYA08UosUFisrpkjCHoh2jc=
X-Gm-Gg: AZuq6aI2ENqaN1PnfmjPFR0Mb3+3xSkl9kaRRP21H1MlS1YGmQAUuCxXpnZMu80iF7D
	O9i+N2zXoyjzkXOMJNbHQ8iuTQXwkqCtkZoWMHWmJyNGGTVEvcgV8c329f/CyWQQGnPbDxSwrOx
	4JCJEitQx/geVph2lTVeYiA2yBciLV91jnoXOZ9yNhWAYj8w5TUiyBd3F+48u4ivUszUMe2qYMb
	d/sZ3YPbJaZwKRlQdrcvCTLInB4af8KgfUheyCUWILOuYuOA+joHI/fpqi72/owSZlB9ubH74zN
	ufj5satWD7E=
X-Received: by 2002:a05:600c:34c1:b0:47e:e2ec:9947 with SMTP id
 5b1f17b1804b1-482db491eecmr58235085e9.33.1769817212473; Fri, 30 Jan 2026
 15:53:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 30 Jan 2026 15:53:20 -0800
X-Gm-Features: AZwV_QhoRCJFgeduCa2tipPOIslOoLlL1iXAkLMz0pxK4ueLAQLeijerNFt9390
Message-ID: <CAKEwX=OL1Lt88tToA7pxDAJ4QkxV=PpGZ0zAVD=oexQbEArEZA@mail.gmail.com>
Subject: Re: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL() to
 check acomp_ctx resources.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
> acomp/req, making it consistent with acomp_ctx_dealloc().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

LGTM. I wonder if this is technically a fix?

Also, considering submitting this separately if the patch series stall
- so that you don't have to carry one extra patch around every time :)

Anyway:
Acked-by: Nhat Pham <nphamcs@gmail.com>
