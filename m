Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795683483;
	b=fXvMn5RPRV8N0HrW0OkV4IonmMq21iGp07BKHRQ1uwYMibsoFIKQjLs5TnRdkZavCiMZ
	 okMWQdsGDyXxyE+NzK+lg+VKE6USKvXuCGq+JjOwTzlOHpxDV2eptvwy9gsn1cvuVHmuc
	 DBJfqyCIVx9UnfL7/ygdgvYHF7SNWwrosn7iOvDBj9sU44GMDJpcF6JRc/705ufFeAXbm
	 LxXxVtBAJTtgqg4Eyw98h3E5ioNtZEodceH1UQFOJumh7T97QtP6alcfZlfTwOsDl4QH0
	 jUyTXLGHakl+nc30ZCNklViNUbGxMVa1+Cen+Cho1QRpNqXcrkJWqP7Mo79kkcCGIdA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=YIg1MlMF3u8HPPAvDDKpapxWNkVM7jyo/FfJ8kDzLF0=;
	b=4lmPnqHzSYAHuuSSTsMXTVYDngwNE5gvj9zHY7pLgDLxa9mwk6RuAUfFLVOy4IRcNltG
	 gy3RvXikQ7+heJ86awEsNmD7JEBC686OKILXRYokwwIqAa/3+XgYGHj+sBYCoJ0XGrPRe
	 x3nIoRY0p9uOZ3tqkJhkbugDyem/9VjoJVQ5Vr509oSJX4xXapnzV9fn73T0ZYWBv3QSk
	 hiUcivsMeVrSBXm5csSKZjvtOW2fpMZrkeW9hLy/aB1nReOxOoRdgIu4ezvuHeiaaYuVj
	 07kVOoqc6Y9MD07Yy8x42kkv6rY10ILZVXgBYRDB9w9TsAjoRnGjabw1NF7ynOxbzog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jrAfBUqx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4D606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 08:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62F4D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jrAfBUqx
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3adf89523d8so6488281fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 00:58:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795683482; cv=none;
        d=google.com; s=arc-20260327;
        b=Q82OeAccIBYUfANRhpJMWl19T9yo6hdV8zldGJ6qHacvb5ST6tyKHiCyx6hAutQk1U
         u5dJEQpzedLBB/nW+uK+LPXEAtagLa1gE/YF5Kk9Wq+KosPFEVmc4F1K3nklwt3dyCNu
         6wAPO14601+cXJewHy4Z7VeVH/lOqCn5ttv6UwFKkQ3f1ohHOcnMTuoUUMy5L9mn2D6i
         Enoqx6g+9TlC4msdHabG2CNas+yOwBulbziyIQrbeGD7F6yAuWWG5+36fl1hf6rAym9v
         KpL02KBUtp3rEGi/d9z8Nqp7N8JTNzudxlihcJRLUCcpfU1mfRZdUs49vUYUicxwEztn
         0S9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YIg1MlMF3u8HPPAvDDKpapxWNkVM7jyo/FfJ8kDzLF0=;
        fh=PgRewiUH1hHnV21v1TcgFwnUcJAwTbgYUUICZt+9wI0=;
        b=AZI4f5mmA9kTKxQpm20UZsvECwiZY2I0xRUqNpFOjtdNkJIQxcg8KMrPFphSxJbWzu
         w8i+eZOh8BE8QKdDt4QIWx/esj/Y3BVFJp70G/cukg7aT5RrL/7HX/8EnfETQJSA6ARm
         UKC2tbUa03v3wINEg6HU4cPa5O7C5zYgnz4FOF2p6Vg64cMDQrZQ6XHun3huTkkgf33y
         pE+42x5UKMRUx0WityryBsvdOEkICT9KlKSUP6Pg8sMQlYYWc048GnBH19TTIj5DeYbV
         KwewHmoyU002IQoqnZAjy3mGRX9vZDcMZKkKbaMhszNHTCRWx9wu3ku9UsUfHqnta00W
         v1KQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795683482; x=1796288282; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YIg1MlMF3u8HPPAvDDKpapxWNkVM7jyo/FfJ8kDzLF0=;
        b=jrAfBUqxTPRrUwm9XyJ0uv3lp4bWKmBCrMAXYhMMT7as272YN8v+jHYsyOtLs4YX4h
         LCfJQdFaMzGSPOFJJCAd0IQ0Et8Msvk5zgjhdxLiajy6OrdeVCaqU+Y6Br6/u2S1F+2F
         r0VViiuZ/lMJxscVUet2kefXChLLsN4NxLB6mPy/cRlicAokK4fQIS2h8ZK/t8J0pA0i
         BxErLKSD4fmUm2zYVOqTzWIHYkRJGJk0VDyKNRT0G1HGyLkbPAQDSSHYs15tKNkQ2e0e
         m31nEMNNSxfsspWGBZDSiZjoPvgefhfh9/ZNUQLI8lUv3E704CW0jAGaiyeiW2SDRbbv
         URYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795683482; x=1796288282;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YIg1MlMF3u8HPPAvDDKpapxWNkVM7jyo/FfJ8kDzLF0=;
        b=DXUDJoTXe6ffnassVr4WcxBULzZtc//42Whx7KjWqj9pD41BuZG01DwZzPey2Cgjje
         x0vHn46ug50UNyfZ5N9mDl/WUvlQHYrKMczX00ZTyfJGGHVtg6ab4XPT5xAR1Q46Is6r
         iVJDrXDuUno321KYZes4lBxB8/P2TiYuUeixedQww4AIg/oVCqc67fTwJ7F3Y1oVmYhT
         rHu+zhNxFHGdicNqS5DBzXdm7wRjqhmHgdBE4l/zduQWJeQ2WA0okGHskUo8d2l7hRdQ
         CkUDIuubtuQciGFhQ0HErOHfF7b91J/cSXczArZF95CIguoGEZMBlUXlYcAiZF0XifIa
         C51A==
X-Forwarded-Encrypted: i=1; AL+hErHcFHJJMkY8q1/OVDGbSy/9DYspbOJyF6zaI1f12E3SBDBB7GxNdPiC3s+Kq5nIffyCkXhOfdpRBrVDG5o=@vger.kernel.org
X-Gm-Message-State: APuU4Z+8zwcSYjH2XAPdcn43vzJw3RIrdpdWuDrZfWqZzJG/MN9lvkjy
	NDdJR1oJZywaH8ZSc9gRd+c7XCEy512jyOG1pDhP2ALt3Th3HYiyIjkC9YaS3dIfbRMbxj0hVzw
	16hHz6vP63KPcBCjwCec3HAMqqyaHNRo=
X-Gm-Gg: AZFdTZfnaVtmHi2oXzxGo0nn07pwp2Xs8Lpcs1BeinGnhta034IcsPmYC0MeexCB4cj
	OQuliI3l0ItWsLY7I32xa2NPLBnU4eM7lQhfXKO64B1IfQn4xAZEXVhESSiuoTHqcbUKTts52Mv
	vK6QlvKBmnhFrsk3NRj+A3WO/8v1+B6uetn3Y51fxicjKBEEbW1hxlAj/xyXqyCmp1w4WKL/z2M
	KLJUY3rgoJYb9pM6L6Nz8NSv/a8Al5g68G/+RCerZWdo+Be+lbQOLbDGDoacuTmHpjMkFGsiFSl
	/eZHseIDGlK4XrZ5Dj+5Rnd61RDjv6DwZoBTIFlrG7mqzVEHCQIxbI+gMZgocZSIQzL42bnPmaS
	ggftXRiP9VmEviabRxUp4vIwHHru5quqzDHdqvUtxFLjqwbzAHbzQmXAxX4EXgR6BtDj4TEM=
X-Received: by 2002:a05:6512:318d:b0:5bf:d00a:b6c0 with SMTP id
 2adb3069b0e04-5c1bc78eb99mr7714957e87.3.1795683481551; Thu, 26 Nov 2026
 00:58:01 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-ecc-p521-small-scalars-v1-2-7b114f076b33@gmail.com> <20261123033705.91056-1-laveeshb@laveeshbansal.com>
In-Reply-To: <20261123033705.91056-1-laveeshb@laveeshbansal.com>
From: Arun Iyengar <aiyengar1990@gmail.com>
Date: Thu, 26 Nov 2026 00:57:50 -0800
X-Gm-Features: Aa3M54p44oBlSMt_NseT8QNw9zL5o2sUlh_BC7KfHA_Wix_VB7brgmTVGhl3_PU
Message-ID: <CAEy9hNXzvwUCUHkERWgq+ziqqj0K4ttS4XqmrpYKrc8K=Ma2FA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: ecc - Fix P-521 scalar multiplication for
 small scalars
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
	Stefan Berger <stefanb@linux.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Erwin Pawliczek <pawliczekerwin@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for testing. v2 will add the k = n line to the commit message
and a KUnit test for P-521 key generation, with your Tested-by.
