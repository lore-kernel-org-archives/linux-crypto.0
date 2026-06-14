Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D332367D9
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781401016; cv=pass; b=uUDmhgYYkF6Fm30TUS7u6ArO6K1i2kuwjbTtPiM5RIXr1oqDlW21HcoPvICc7tpXUm3eoR8eJSimQzfDoRg+/EPM9IQzLvLO5/rl9j/fSJaqouLUwTBiBiJ/wdJvSd4ty/lBaPdjvKaSja9dRUcvNpjRPq3SCxvWUv6OrRdCQcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781401016; c=relaxed/simple;
	bh=tFndD4xhU6TM1v7geR2uc3Y5I7UDLVFeRXl5ob/r77w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D2v9mGQlBE6bt0VcYkID2uLnpKgYd04qUz2wEWmyxqg4qcgHYlj8fW8NUcKWF7Uv77LZx7qZPJp1F+8SMt2aFjebcqt1V5/m5cteO+8au7nTdW26BNgmn024/brbV/Atdity6FeJzet+GaHSE2HRj0X8VFOAl+v4YjaN+kBo71o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lq7oVhaT; arc=pass smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lq7oVhaT"
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-8cceb2ecc03so21307216d6.3
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 18:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781401014; cv=none;
        d=google.com; s=arc-20240605;
        b=dwoI+wDJ8bJRQGywb/Y/MIcsFbjVYN8x6ml1yQsP1tSQ7QVu1R7AyAmqsmEslTrbZ9
         0F0qCan+g0WBty5ekKWeS7CHuar2fYZcDgSPRZwFpv37OTz9G72+nm6fRAl6C7huKNLa
         ATuewcV6RE7mZ0nFDU7iZzad+pivj9gqQSSCZvWxBot6/49yXvC36uSdMf/XjCmUqjQi
         kCEDqmgGszAszuLsRPPENGQdMWgw4aJGRUehZYiEv6OSx3egMiWUpvuhquOmfgyFGvMy
         0xR9XSLQbbJuaYwUCQyzA9FeVLrnFr/S+8h5PXeAAwWqyGEOCPbNtjhWSaNJIGvL74SU
         WTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n5fB2rVLAd0NOe06dMOPUowfvJcEsGLFODQSz7k5AdA=;
        fh=vU5pznvZ6oK5e+2t8sH8xqpjpEF0sfBcAm4CTOcUMFQ=;
        b=foOuPS9xLLtamiA0ig4td+7+dzN3IHNaxS7j/Jy0pT9TOAZlxO6csI46MJXPQGZ5hj
         vnK1Fyvl2q87WXSSOwJi9YGEW4ckSEweWzp99uL8s4AQk0pSGoS/OG3nP9pa7cbKjbYR
         MzNKNYcjAWXNZAgSJKCcdIrxDzuxlhytJkXC+sRBoCr97qTbmozVjVtjrv/683YxmOTY
         E2W/KP4cjRJKjiAffvxgH0ThwTm1/kPjEXZ3aV4K6zEsi7EQSiAK5x8PSNXmYxbUuAZY
         S+eikZfr/2S39NhiaaDi3dgzloPZ9JP6A301dB+kC3NrGme4ogPUnfpvPzGAu0jpQe5v
         KY3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781401014; x=1782005814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5fB2rVLAd0NOe06dMOPUowfvJcEsGLFODQSz7k5AdA=;
        b=Lq7oVhaTp3shuBcI4FV6IeeDy07NOxFCQMIkoGPSGZeQzsGeivts5YzYdZEpdeKbHE
         Rp5o0/Ea9UVbIOq2i5UpJUYQwfOR2eL3py3INDf3ehftrLru5P1SSJT+m0NEKgiE5lSb
         qygXvVB9s9z5Dy+Jv6vKD0MzQifxhiD1QFFzKnnzWrtI2STMWtiOdRn69JThiroCAK9y
         0F5zxy8AuLjGi3PadroDCALDPRoqUWr7PMTn7NrOzEhJ54ycQ6E9PvvR6lo4d+BGQ/xx
         PyNYvHicEtxYgPtEuoRWq2i9didX+FNncszBaLzr6C+Vm1pm04Avkrnt898J7W2sYfte
         onEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781401014; x=1782005814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n5fB2rVLAd0NOe06dMOPUowfvJcEsGLFODQSz7k5AdA=;
        b=SfthV1uCOooNLUurJhO7XRWYouJW+gvACqHa872SUsXhu5WHzXsXslIg8P9+746o9Q
         bXfP0behMMpj6K2+mYzVLIvndiQYI4nZjz/18jGLb1Fqary5O1OxsYiiGf12FsDXSVRE
         PO9D51Mp2vKqapqcHl6Mg4swY+jO5YD7VnIDMsR0mi6oH1yqi3SOtTYSnL4YRgXP+C6M
         VrHrUvH73Ln+b/ZZAd9qRe1A4gLUz3dCiB804LoKhHRihWPwH2YaRU+Zp2p91ndnhXIN
         1IvkJQnXF9AEvrRFrLTNYk9xlK16Rm52997vIXrx+ntQxPdXXqPGgKJjiCclxj+Ot2W2
         6/9w==
X-Gm-Message-State: AOJu0YzqMgCSLnrxMAZCLAsOtSaUhLdn793VfTiLBAbbfqiJk1lJSAgD
	Q6bASgpnhe6K+5XEpHnS1kFfq0MYkZxrH8RLnBVc8pje796+2Qp/TAizmRNvqpBgA4M6LcsrAlE
	wjRQor37iGKQr2BwNRBYIsStDnBPBW20=
X-Gm-Gg: Acq92OEwjRoszSKioS4XYDHnYHCyHZl1sogsREw7TZcKsNyR5ChKeJ3BfK2Dq0wYOKv
	I6n9GvhYjhwppuID0/bUgKWblbZtWAOgGjTn0qBYj7Aue0jZ5T2SZIyY1FnDQjH/0I5cnJ/2OMo
	Uh170Gv+U3/pdHBT9sTAQPk6H9UACTBcAmnCyUdSMc2kxdVic99A8xBDmZtOCe4wWYTnca7Y2kb
	pPgx9NVhbCIkmyLfgLUW1n3j8TGhKC6B6gk3XUVP8kwnobImrCzUJMRVXutnFMQVd5QFNJ3KFFE
	75lSkRH2A61QqNhtWrD7/pTz3HeRcBJ2s6VLZHJ+MDsG5bUq7XEnV7+iKfx7kLZjR3sRag==
X-Received: by 2002:a05:622a:1456:b0:517:6550:2a0 with SMTP id
 d75a77b69052e-5195338b5edmr85745681cf.19.1781401014088; Sat, 13 Jun 2026
 18:36:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260613223648.119694-1-enelsonmoore@gmail.com> <20260614005044.GA1808@sol>
In-Reply-To: <20260614005044.GA1808@sol>
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Date: Sat, 13 Jun 2026 18:36:43 -0700
X-Gm-Features: AVVi8CepR6jF4mFfkqqK9wY4g4xLO3th8OtglCBTM-sf5Kca7lHFvKNbbL4gNGA
Message-ID: <CADkSEUiZHbSGi=Fp4u5dNxZDrXnFpk3WK86JMd+oU5z2CEO19A@mail.gmail.com>
Subject: Re: [PATCH] crypto: s5p-sss - correct CONFIG_CRYPTO_DEV_EXYNOS_RNG
 macro name in comment
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	Krzysztof Kozlowski <krzk@kernel.org>, Vladimir Zapolskiy <vz@mleia.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Eric,

On Sat, Jun 13, 2026 at 5:52=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
> CONFIG_CRYPTO_DEV_EXYNOS_RNG was already removed by
> https://lore.kernel.org/linux-crypto/20260531175932.32171-1-ebiggers@kern=
el.org/

Thanks for letting me know.

> I didn't want to touch this comment which is nonsense anyway.  But if
> you're going to try to update it, it should be updated to correctly
> explain that the driver is working around broken devicetree bindings.

Yes, that comment definitely needs rewriting - I had no idea that is
what it is referring to.

Ethan
