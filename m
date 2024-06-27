Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECDD19A282;
	Thu, 27 Jun 2024 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719510684; cv=none; b=UycHUtlDZx06CM47LsBC5MIZoY8eUwX5Qil6bCOnkScBKEJm7O58a/zxpHxLhl6SHOZJGO/OPKsVJveWpS2xKvurzQk8don5RhFgy+msxcdXkeCZ3CADHaOTbEsMdYKTuVh9a83HWA2ggtnilBH3B7+/OU/OQP7cxaYLvedOrms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719510684; c=relaxed/simple;
	bh=EdawJHuOqiQcN1Jc5GTtGiguPFhxdTyTM6kSrMQxQWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mtRsuqVR3zv8L7gM046ESKUdH6d7JDRZriYuoRnOYLX+6wDqL+lj7FsVi0nhX1Ae8LBwSOooW1/IiMI/f4hYxAQHDQP6hWyoZGsVzB9QIUq2wdmmaIaGR6c7krUG5jHX0vnTrAG+mXXE66GEMtJmp83YxOWmGa9bDQC0nmYoBHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52cdd893e5cso6495085e87.1;
        Thu, 27 Jun 2024 10:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719510679; x=1720115479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EdawJHuOqiQcN1Jc5GTtGiguPFhxdTyTM6kSrMQxQWI=;
        b=MBcHwOja3x4Bx355j3kuIg9Izv02Uespi/Inj3WV94usOfrYdplb82MeFN3fC+KuIW
         q7f6dmEjyLyZIitZUyqJtLYToq0884YJjq8WC2ZZIW7TQrPaI5n6l4FqvkVXYRy04XC/
         2x+7R8xL3Lz/z7RjrHpti3ImkGajQpNa6/f49ShDO1u5rgILh2QitqBEikV3UxFkFiqb
         7GtJLGAUYT4HgSxNNOwuWKdAEhFZqWojty0kKP5M56yjqtPzwi8azk10GHXFI2w5qrLN
         eI5fhMa7jPZwJOcOCwVOtQU78eZXthQ3TK3kvUp01MH5Cxib6xEiVGYGsqdJzhRaYpgS
         Kz8A==
X-Forwarded-Encrypted: i=1; AJvYcCU5XIeZ8mKbfM2MZ7rd9PWiHdVRIhsi/8PMEz4hJgOBk8xR2FrI2Y58lMwNf3nYda+hJcmWSS+8uxbJ1En2U4kiucbmhZcABoX5ulGGVgCQdL0eW3/x8Uf3jMBSsaYqOWHSC8ecbe092g==
X-Gm-Message-State: AOJu0Ywk5SCgeBTpa623AcyGlnWJbvkzX5BdFHkvLz9j25tgPqfJl6+c
	1g8ruHqqb3CynmTVHvkgqt4fqq5l+UoD0JbXBdoTo8YAyRVKghcyz1WT+BDC
X-Google-Smtp-Source: AGHT+IF+Q9v++jO4dY4HcT8pihyHkJfVfqDsOJ5MtC52ps6N7PWn8RR9Zxvj64g6d7vpoeR9eEMTCg==
X-Received: by 2002:a05:6512:312d:b0:52c:90b6:170f with SMTP id 2adb3069b0e04-52ce183ad2cmr10372094e87.29.1719510679303;
        Thu, 27 Jun 2024 10:51:19 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52e7ab2ea14sm3763e87.213.2024.06.27.10.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 10:51:18 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ec5fad1984so72145531fa.0;
        Thu, 27 Jun 2024 10:51:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWIrAvavMXvJgMY+FE3Eavi9qkd+ori0AZkElWivKlPDCUpT8kn/MiPFl0hgfwshTkQJfjyvwgsmhWsKdVaEWf5FZp6Yr4cCraLcXrf0kEVljzl8v0YWATFOsTQHYiNLvVWpdPkAGa0gQ==
X-Received: by 2002:a2e:904b:0:b0:2ec:2993:4363 with SMTP id
 38308e7fff4ca-2ec5b31a31bmr99240051fa.25.1719510678740; Thu, 27 Jun 2024
 10:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240624232110.9817-1-andre.przywara@arm.com> <20240624232110.9817-3-andre.przywara@arm.com>
In-Reply-To: <20240624232110.9817-3-andre.przywara@arm.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 28 Jun 2024 01:51:06 +0800
X-Gmail-Original-Message-ID: <CAGb2v64mzJAKwupzmVnggw30z7ZqquDDL3Fu9gTYpED3aJXEdQ@mail.gmail.com>
Message-ID: <CAGb2v64mzJAKwupzmVnggw30z7ZqquDDL3Fu9gTYpED3aJXEdQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] crypto: sun8i-ce - wrap accesses to descriptor
 address fields
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Ryan Walklin <ryan@testtoast.com>, Philippe Simons <simons.philippe@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 7:23=E2=80=AFAM Andre Przywara <andre.przywara@arm.=
com> wrote:
>
> The Allwinner H616 (and later) SoCs support more than 32 bits worth of
> physical addresses. To accommodate the larger address space, the CE task
> descriptor fields holding addresses are now encoded as "word addresses",
> so take the actual address divided by four.
> This is true for the fields within the descriptor, but also for the
> descriptor base address, in the CE_TDA register.
>
> Wrap all accesses to those fields in a function, which will do the
> required division if needed. For now this in unused, so there should be
> no change in behaviour.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
