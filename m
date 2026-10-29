Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793297523;
	b=Akbn+NtPVg0i/QCE7Dba+nM7XmptZ+HjJs0FiPKbQPCceGy6YXL26ZI6Y7jZ0cOlMKEs
	 HxwMRcoOEWktpusng/6MlkSTVMTz2ntNrDEldn/OKxAQPL/4f9T7kpZQOWNm9lNDp+Ew7
	 Mr60tl3p/dx7o9QCPQoDPw90a3m9LN6okm+fT6uAuYck5kY6AqBqwIBISZt9urUTqjMQo
	 IC12Q7TY5V1dWzklUwDYrD2WrL9kwBHb4JyzLAJ1Qbq/z8RF1p2lO9Gl0cZXe2tf8Yau0
	 iA0w+stu1sHmsNa3t8E4AhJHYr9AkTbHsxdaBx2semwn//Oz8dWAYsQ5RxPsLpLm/3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
	b=NSECeqKDpYcQyfJuQwx/1QTQiXhWPYwWsXSXfJW6LaLNvld5BsrnAbiu78xZGTFcWXXt
	 RLewAXQh+Ef05ybNHs9rZVjfYar99BRqZRmX6CDE4BuDh9YDeh/brD82CIbZWmqt+Fx4I
	 WzBzao6hzuUeHEhwiZKhM1lYk9Sis4aTfMkBT7hMMe0JYwWVLBDGcUpd3SBkxv5CG4bum
	 3OeSHSx5VmFcvghJcnHc9YiiTJOYCe1T/sI2zF6anluTaApnkVJQ4T9t9QGH3fP17Mf6g
	 YQ30CfU5KuqepmIYUQ5IUge4Vic9+OeU8v0ywz8Jx2AF+5/JkvT/6BT5WfkKQc7kl/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jdz1y9Sa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75FA606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 18:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B75FA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jdz1y9Sa
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ba3b1199f6so2582724e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 11:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793297520; cv=none;
        d=google.com; s=arc-20260327;
        b=FUceLXn/t1HpBi9VecWx/PprgNTN9b5AOFRiaSZxL0kDSXRDqWXDvTD6qtU7w626dJ
         Ec1gOOvgJMddXhiTEAd52joODQcTfKExbO/9vMx5vTYmymTDWt6u7Q5QlULAq/cIEg/W
         jFj52t4GmsW7iV1aH25CgKFmqoIyKVwW5JlZYOC46ZKqweRXWOuiBXQNfQkXcwZr1nXs
         EmQsc9AOf0/w5X/13MuDa8aTIBVbsXe9EeFJpL9jeJRp40TqpmpHxaf+3WLz067iwZnR
         277EjAKal+/WyC9mSO8kKCSKt4UV7S0sHDFStr85+QqhbAKvX3gtgB+EOlVbKKtow/o/
         6EkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        fh=KDQpy2Di5QssKFBEWpY3Sk3SnP+sgQSsaWmGzdUnJBw=;
        b=IGY2LvmW6RJGSmEHoCQqFBYIKuWL/8aqmwXPZ6IOWfGBekhAAD13tN3P7WmMoVwlVK
         WitnKG8RjLWTf/AAbWRCUBYQAMfe17cXbTlV6RL/jH0CIcIWOisByMBz4RFZhM17JZ63
         y/5Lg73V/KX7maK859cxGKTPXuVBzGA8cR9f1jRlpCuEp/hdzRXfpTVirXA5BI+/+bB+
         pEETCcX6k1lDSPxphbiB2twEe/9fNeDPCGaEKZyQT0lnybs1gU5dNctz0Bn0M1BDMVOC
         L1apTU1S7KLSZSAsHRe23c5WliQRKMDnZZYG9jdVXiMrRlFyttlnghMVGIpvS3p1Zq3/
         TvkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793297520; x=1793902320; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        b=jdz1y9SaM7AMp594Gnw1ZOQjhquT1A/dXVp7Ykq3r13e/Xz7zjva0wMKofBUKkdk0I
         FB8JUEimAGyNGrnw/z22gx83h+X1LKyj/k4O4wq75TC9ZigHa8Q/IlRAkKhNBztmaRGi
         zgRMRMzGc/PsDEz084HK2j+EdBUhdz8WgHs8ZLt9e8cmDMlVFWr0xWrrSc3NUWnSrXvB
         nGprRivT0OhNPzD9Be6yjUBHYJjFqJTBDdwz1CHqKenXJWspwMpsEh1SlO/td6INZhWV
         R8yHueOfoBu5gr0vELx7gM8aNu2oFZeJa36tNTID4CgMtA0PoNDc+oxMqahvjnw+/3In
         NNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793297520; x=1793902320;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        b=nWQZjr/jfHIE6F1EHy3k2rk9O+Hac0VKv4yioMCeQ6bApXW97EGRNblSZ/cSxCx76Z
         +V4oCeDXDgBB9RMeFiZ1U6HGxtSScuwl3xLl0j4DbgNfyRAJ5t6zvc9IhTdZBpbRHzUo
         jX6XS+pYw+UiDDh/s2NheJBKU44GAvacQXlRCu6u1edFcJRILIbRXdlQ8GUgEZ4Wiiap
         BA1BdYyYLh7nOsJfTpJeoX3TgIU4VKMUe3S0vhkoIqqjQ1dvpJpLf7H7vSri0MVUx8s2
         IDH4x6Aq6aRmluuroBn10mDVB0Ykz2+86avd8f8zvwdKzcu+t6yuC4y/KG7HbJA5VoCH
         xadQ==
X-Forwarded-Encrypted: i=1; AKwUvBycOzPF0aKUy3i28Np+t5pXy4e75HyIEmTd/hMnJBIO5QM3WRORZJDJDF+XXULftzxeLzLJfhIzLzCdwwU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJrPld+dw4us/9x5o6K/QTOcMylf+yX+gbUbxU542Lolo3lpivV
	hjmO1c1FaeDIU1z5sFB/uAL4EbfslnPh2rUoQXF2XB5g1jcoU41hFF3BLhvrAx7WlYE1NGCvVgU
	CkE9k+kawEI6QzZt1taONqK4+obrK3vg=
X-Gm-Gg: AYBFou0lvlyQ5OajaMGSNPVvYXhX3Zx1Retv4bPQc37w9EzHfqAQuTKNvzE/d0YhA2t
	nada5C46DsWc0q9uwHhbQVX/8UTpn32eB6s2sI+SfOiePoGfLTPwvr6CfY2l2XfKHRlkWprxK1a
	NzYyjYTjy+BuQf2WIBgkIVHkdKMY4yB0T2w4fh8HiY7Xa8Jemm0MbPRDPKz63X6VqEZYQv3kW8y
	uWuXmgao7Dl1LT9nvKJ1XsOdhs9F6I/9fZxNzB+YXxYzRoyazZdcidyDVyzp2Z9IGICbPz6F2BB
	PTWh9sWAZpXERNIu33wYZRIy0qKSvULEuqrB6siknaiP43HijlJCXbYNNnsEBEKP4KskmWMF3vs
	DUBE0lL1f1ThEpbMf45YgYfq2JPr/ju8fDL5S
X-Received: by 2002:a05:6512:23a5:b0:5be:414b:9032 with SMTP id
 2adb3069b0e04-5bfcad46342mr2523158e87.31.1793297520237; Thu, 29 Oct 2026
 11:12:00 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
 <auLbyon-KaV5Sw5_@gondor.apana.org.au> <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
 <auMCV1AFlEFuJnk7@gondor.apana.org.au>
In-Reply-To: <auMCV1AFlEFuJnk7@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 11:11:47 -0700
X-Gm-Features: AclHuK8R6xznrwfhDJPyC02DpxmXLxT-47zHrOdZ1Ogvg0ySBRqlzEwjpCqqoJ0
Message-ID: <CACpmpofnUbi7gf=eBdCH1k6ZpeiNQUdt_tRRZhvipmhwkhwRqg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 1:23=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Oct 28, 2026 at 11:03:55PM -0700, Kanchana P. Sridhar wrote:
> >
> > I was under the impression that if acomp_req_on_stack and synchronous
> > tfm, it would go through acomp_do_req_chain(). Please correct me if I
> > am wrong, and I can modify the conditional accordingly.
>
> It's perfectly fine for a stack request to go to a sync tfm.  What
> isn't legal is for a stack request to go through an async tfm.

Ok, thanks for the explanation. I will change this as you suggested.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
