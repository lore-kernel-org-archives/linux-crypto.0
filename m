Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DE53559CD
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218829; cv=none; b=KbuJfD4au0vZ1Dos9208YLAW+WupSptG87IFqIs0QaTW3oHujQsbCa82fAluZhaMw2iRXxs+P2HYUBrGwnxFe7t4NgXdEf4q3jYOJJmpUOzaW48OF+WhEMi6WD2zGuuCQwyS9h1ZUxHbN7yPsmCamgkCeuL9DhUVmLlyUqwDEx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218829; c=relaxed/simple;
	bh=vmTytKEFKU0ifzxVpiXhAKs/Bpsn0CVSj3hYAL8y0FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KoxHWhnjIjMxQrPGv8/5kQ3rnZ0sMZcwCUy3Oy6CWi0neJAiHdFDRs+VlWfLzjs5Wvt6vi3PGN8XrdSuphw7Pd2G+tmbfrC4Eo+GyhTcR9skY5F4zqhG9IWjs1MX2Z8U/073j/ix5qwSLSuRgGS0KsT6VzXSp6+qabYE7SvgVO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=dvhz3h48; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="dvhz3h48"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so52628735e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 03:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1768218825; x=1768823625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmTytKEFKU0ifzxVpiXhAKs/Bpsn0CVSj3hYAL8y0FE=;
        b=dvhz3h48rSihr+heN2pL6rYoGdQRt2dmHZF1ED8M+d+xB/IWxP5HWUK2mAc1yls2bF
         k1WwHwk4tqj2tQ7Wik3/ruZvc32KplY4Mi/rWz8FUNXoMKJeUl6xfIy4Gg6vZIHJvmKo
         utM1H9gZDQGJtUDQBgkS3HEB6OmMbVHy9RWkJvah/lgiKJz7TmXaZp6R0bU2f9IwdtUf
         +XJG1rdF+lfYl+GDO2RhrdigWg//eDWQLg856HntCoYxEm9Pa6F1zlZltCz+u2fN18Iy
         /RiXuEg7rmj60wZg/7xLckQSSTrAU2xauQfd+n5XAc9b8S15Zd5AjYwSUaYYpKlKKV9L
         YcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768218825; x=1768823625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmTytKEFKU0ifzxVpiXhAKs/Bpsn0CVSj3hYAL8y0FE=;
        b=Ku3nY4LHpTcvL8slDoEFX+gQ7A5+d1wcuW/3gy3BdxjcH+b4/fYRN4oJRM0T6PHqy+
         HcBqpFXQc+SyUTKPxkVhC16tdsEhjf1jAs58HAqCV1iY2LltnF1N1pDxbMvf0uuqzFUl
         U9FLlfNM8BWU+x27/fd+yfFgjXb/Bzs17K7NJesvpP2e5FW+KNvvhuca45op8EpYHXVp
         KU2RaoxQGyMZZ9xtaCO2ifm4lC2BG8tdCkJd0GcvCZK3kFddumfNcsx2SXBJ0ENTk3Aj
         I653Lkb0WIi9maiARVScNSloTGSF5I+Z6UTUadC5gdTdXfPNHZVB3WuQ92dPK6EuTbrC
         C8gA==
X-Gm-Message-State: AOJu0Yy3/MnwqebAqlJP5xbU0dF3tOAqGk/Mh67rtAP2f6WJ0Vpmv9zH
	fz7OiGNWDC7MMuZd/iLDAhktCmwZalAUdUAY1zYj7vZxBsRI0z945c9k1TFf33Iw9Xk=
X-Gm-Gg: AY/fxX5D8iUIGIxSCKzs3CKwSE0Ol/Wv3qPx5s4MYN751x4nxzAAUDbSl6QhaC70J4M
	lm61DrLb9eQJazntaYnrWbfYUU0Q0lkzVqdXy10Sr6NgASuGmHWbSgOqz+q5FBoQ+Era9mCwZys
	n29AG/GtkPLreNhRqq9glUfzIz1YnDWqO+zsgdk19KMNR5ThMRSJsrMVISZ9P+67D5BQWEA2yvp
	NRKt6dZKODDEVxCpTzAWo3S6SQP+KZ96nfCN16yfgxEdMsMj3QHpVuKZ9L0HmpvO5g0Ez1RwxBY
	6fxP558NX9KvZDArmwnMXdBf00f1Clg90b1Jwz9e2W12WHzVTwL4Mk3g77MxsTYKElxxC9ljNJ6
	M2t+FzM7L+gSF+bttJ5SwWcq58lY4+uY8sXuh7nMPpwqgBZIR92GfsKtKK5Q7PaZ3EgftyjeWBC
	Z8RxFSYU6iWYP5rNt5XYDr85SQm42vhgCzytLBG5/Mtfkm/mNYqQ7s+0iIH9oldHDbfyaxu+eu8
	w==
X-Google-Smtp-Source: AGHT+IHS+X3LSDt5qzxc7wN+ZiHbRa7V37jnrS+IUFcr2yrSlHBW3u8uORHbJtAGSuAyEXEXsweZBQ==
X-Received: by 2002:a05:600c:4ed1:b0:47d:18b0:bb9a with SMTP id 5b1f17b1804b1-47d84b54031mr204347325e9.33.1768218825500;
        Mon, 12 Jan 2026 03:53:45 -0800 (PST)
Received: from localhost (p200300f65f20eb045084e32706235b2b.dip0.t-ipconnect.de. [2003:f6:5f20:eb04:5084:e327:623:5b2b])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d8660be14sm134733965e9.1.2026.01.12.03.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 03:53:44 -0800 (PST)
Date: Mon, 12 Jan 2026 12:53:43 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Akhil R <akhilrajeev@nvidia.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thierry Reding <thierry.reding@gmail.com>, Thierry Reding <treding@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev
Subject: Re: [PATCH 0/2] host1x: Convert to bus methods
Message-ID: <qqdjk5wi5xlily3cfa74lrepglo42ibnpoyam76vwkymju3hkh@b5dc4yg64mhs>
References: <cover.1765355236.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="atue6rojhx5cbpx3"
Content-Disposition: inline
In-Reply-To: <cover.1765355236.git.u.kleine-koenig@baylibre.com>


--atue6rojhx5cbpx3
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/2] host1x: Convert to bus methods
MIME-Version: 1.0

Hello,

On Wed, Dec 10, 2025 at 09:31:36AM +0100, Uwe Kleine-K=F6nig wrote:
> with the eventual goal to get rid of the callbacks .probe(), .remove()
> and .shutdown() in struct device_driver, migrate host1x to use bus
> callbacks instead.

This series got some positive feedback but nobody picked it up yet. Is
this still on someone's radar? The last patches to drivers/gpu/host1x
where picked up by Thierry.

Best regards
Uwe

--atue6rojhx5cbpx3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmlk4MUACgkQj4D7WH0S
/k5w/QgAhE2EAWGMq3JkMD2P64EjS1rMwsjti9FFnLXqoSgWOD1/HpSebIxgHVUH
9SjJD/+aDtRXdiEaEM0CWYWAcTk673HShaX+R5uJ+NUSegWvD1bO8RXbwYW2lW0l
5XEoBJro1TsCECL4gBAlxENblu01RKLwAnTAcCHRjTFEgjM833wJgTFdHrtUAZxZ
uiEOWaOT1mxK+8rPLf3lPzeu/3NAhDsUGyqIMDA1IQ4PUkSxBwR1A6CZPsL916r1
+Rr9xh8Jo7dY4QKqb7SseBTkAoqcbozDpROJPfpUmUbHCPld8WkAx7mt8I/DTJ+M
+lGuvDBluoPISCAslcMNqdQ44lcyOQ==
=kDAI
-----END PGP SIGNATURE-----

--atue6rojhx5cbpx3--
