Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083943E558F
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783942097; cv=pass; b=bHy7LqqgSCJkuCEVC7ar+uG7FPWd5phfgOYFbMsKEVMo16TJRcREwRWaqyoZsxMkJUfmJOMr81XZqRCNx8a3FA4+Y4VFORD+UJMJqPy4dZdgN+e+lt2EKoiR2LqFYxEROot//Gipy3EIYfmL+3AiYtNqWv+vbqrNHL0qUCFrFVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783942097; c=relaxed/simple;
	bh=CsOQmBvWHRYBm4uU/y67MELpLs3ohV+u3s6To31MyAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FS41j2pFVt1EmbuaBDw8y5bviqnDxnzrWMFYLGzJ8TY++iTn+1Cvq9RZrXFVWQYWOOPkVZ4UL4npnaJLGC7UegeoYH6hAKJMzerRTF8yKMapq2DQUj0A2BXvF9tVIENurCQQcJQsbTl59nAG+Jo1PrjDe5j/zhCfIxX8VrZsA+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Enq4eVeC; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Enq4eVeC"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso31971536d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 04:28:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783942095; cv=none;
        d=google.com; s=arc-20260327;
        b=Mj6fibgAMqQDi0Jtfq2AmzWfRmfZXa1OfywpKqc+Lz5UnIhMx/UCi88hsANnX51Ti5
         2X+yEv3P2lCY+aXjU6gcz/pes/t7/I8TpTe7yEl/F6jF+77nNTsU6J29vadIXznic5H6
         UjK/lFYxLH/FNl1skDxkRFRYexomeb20EokJtQOU6gU/cxOZKSuo41YK3fHjqfrj+LC2
         1j3EdbgxUvC1JTL2omHbgovHyGzLTMUiWL0CdHjP/ArJVBoqjc8y1bLFXLYGtx25JElW
         dD3z8e+NnvbBIvzSWGChwtg8GN2Kz60Y8wyUDulFE+vXnSzZ3AG1WnAI+Wd4b9Ovcugs
         lvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=st85seCDQwEjU3U5r3+4UcGdfGWDn3g9mE+v4yLDsIU=;
        fh=L2YGrALHz9HfOH2MmkVpHEpTqcVafO8aNmjINja4FdU=;
        b=o+EqGSrrlZYYUWMOMTsIdF6rLJ4r3EdtKYYELevnHQVF+phAadqUz2NDP2uv1naTCJ
         Tdz299PDcG3PfXkGObivNphlASDElB4akQHVg+6exiyGzjF2SSVn+3XhGWeTSHRCxtGY
         CJptQtbKnKo0QcwGJBOYsplVbvAW1ebcwtl2CjfVGUTNnDbZaq/2iGgV/ZdcjoNQwbR+
         vDFIE/rCPN4bgMek2x9WHsIFxE9tVaZPScPN1lqakqebZFTTUJX864k2bX6cV4d+7bKJ
         LVMm2nZ6AmLeEy9R/49JT2reXwQPNzZp/9lPX2G1CZkWQ0/KSnnfFKnI7bXWIRicmO/O
         Titg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1783942095; x=1784546895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=st85seCDQwEjU3U5r3+4UcGdfGWDn3g9mE+v4yLDsIU=;
        b=Enq4eVeCkOzKqbJjk6D7a/97bEzyCu6FfHzlVFvbRPquQXZ1Ik/upWeOlBGTuFcryK
         9oAlVUP7AxzD5zZomvy0Z47s64Vqeew4qbTwvBkMNYexEeJdn/XFgudLtwMoTzBFTvXI
         CKdveI+FdAqghKrYREm6frvdbFo9FuXj0BgNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942095; x=1784546895;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=st85seCDQwEjU3U5r3+4UcGdfGWDn3g9mE+v4yLDsIU=;
        b=tUL0XxkY6BTJzInYQF58niN5PDrZ79Cpwc3CXe6FsaLXDj5Tp5trIGtNNLY609qIH4
         qObFeJV7Zgq7xmSZZm1KPRZxrSzZ1dW0jLdPCIPGmKxlF8kxw7NMZxN3pI/oZK9rjA4B
         4B/1G1y1Svl9Puii1mRdDzO/6st290Kz7baJpYsANhfjpbg2BuCbVmdsWc9jjwBIuxvS
         Z8x0rFxNyp2Y3L+2sf+PeFmOsme6rDGUDxtbh8fPzgubnRIcD8o92oMAZg/l4D5MJCa+
         t3P5L7bLuymHp3HcWnFL0227cxOuJ5n+rOptp8UuibRq4sk3BDd0VfYXqGXy1m9sN02J
         55Mw==
X-Gm-Message-State: AOJu0YybYLy/VXcSH4ZnujdTLz0YTjBlyR7Vin7j4dZSiWrkx7EZ6G/w
	i9rpwUHcBDvNApVX1qMlc4gMI9mUnmGYBw5m1d2FpPVa5fGDNXuD8tSGUHclrlahOW/5qzl86Ma
	a0P48GZGoTDUBww6zVu4V052bxF9gT6NEiETFdHUrIg==
X-Gm-Gg: AfdE7clRSzMmha5lUHiGV7xUMHbETkm9Rv+HZCJ9rumI1I3yKuDRD/zN2++lVO84ena
	21Twp/Weucm+en2EhrFVVtmVUX8yq7sirlBDS+zFEopxWf8Gi2bX3aWhZGPYTRxA9nm8ci808uw
	QPvnDZYmyna/NEglHawhF+xPsxGyR1NHsdt8kdoX4WqFuXM5Jvg1UuBRdlEMReEaABlvrCgXQVt
	22MuewckinTruh7gpawFyLeqnwT+ADj0/wvC+7QltIeGRv4XqOeWIsSNOaEuL8twjfvwx7/2CEl
	+EPAPQV8OlA9DZa+QXsguStRPSD1X7mn20IlguWb4nvHJMRaHdAX97W0fQIudGXWROwOwWmdtCL
	Xuchr1fRaxmVBsg==
X-Received: by 2002:a05:6214:8012:b0:8e9:51b7:2d49 with SMTP id
 6a1803df08f44-902345906a0mr148749056d6.2.1783942095017; Mon, 13 Jul 2026
 04:28:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707125311.2398031-1-pavitrakumarm@vayavyalabs.com>
 <20260707125311.2398031-5-pavitrakumarm@vayavyalabs.com> <5ca48a5f-086d-4372-ab3c-1535dcdbe5fc@gmail.com>
In-Reply-To: <5ca48a5f-086d-4372-ab3c-1535dcdbe5fc@gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 13 Jul 2026 16:58:03 +0530
X-Gm-Features: AUfX_mxxRYylWlJQx3AiA3TRbsGOMz5d4Ea_gZ0i5xT0xueRWcdr-xwk7DjwwJY
Message-ID: <CALxtO0=0y=FBpB7h0v6q+w=bovtpGuiqyoxoWGVyiuGxphf7zQ@mail.gmail.com>
Subject: Re: [PATCH v16 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
To: Julian Braha <julianbraha@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, Nazim Khan <nazim.khan@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Julian,
  Ack. I missed that in V16, I have fixed it and will push the update
as part of V17.

Thanks and Warm regards,
PK

On Fri, Jul 10, 2026 at 5:57=E2=80=AFPM Julian Braha <julianbraha@gmail.com=
> wrote:
>
> Hi Pavitrakumar,
>
> On 7/7/26 13:53, Pavitrakumar Managutte wrote:
> > +config CRYPTO_DEV_SPACC_CONFIG_DEBUG
> > +     bool "Enable SPAcc debug logs"
> > +     default n
> > +     help
> > +          Say y to enable additional debug prints and diagnostics in t=
he
> > +       SPAcc driver. Disable this for production builds.
>
> This help text still has the indentation formatting issue that I pointed
> out on v15:
> https://lore.kernel.org/all/deb73385-a7a9-4ea9-8338-b7da999a5e9c@gmail.co=
m/
>
> - Julian Braha
