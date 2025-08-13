Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6662EACE3
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755092651; cv=none; b=P+gql4T7wkeIV8D9RcwqyoiFVLyeyYa2vGbk+grSSEVFed3gwPHhjQceyJmgqiNWFaEE660Dil4uQGqugvHdyVLtEhq7aBsTceCcOcvCf4ySmmDoGwH5k+H/X+a2IBWC32LwuJh8UEPVJnx1a8Yf6INCiYhw/R2vMQc8KLcaCJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755092651; c=relaxed/simple;
	bh=pHojtpD3YB3bImqUFSr8KZ9T2OCJ8IHdeXOjUzwksWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MDNxJh0dujAO9NR7KbyjJkRiGxQ9jh57jR9qHBVGph8r6/ZKnvY9Zks2zeUmPZx9KwrNwAi2CGmlkg9mMDDf7wEiBGStqxXi49cVz+GqT4SCDTjS/MFXpsfixaHHToGGXMOnOLm0TIs+BZOaRTlz/ZuIg+i3NCzAm98QFgEwdhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UmI0TM+L; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UmI0TM+L"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2ea58f008e9so4380842fac.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 06:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755092649; x=1755697449; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eihVYJrWZXZh50n0+ltviNDHEcxJdrJFasVcbGTuMaM=;
        b=UmI0TM+LryQ18vaonvGnmaUUUfgrK+nuO1Lhso/Ch3ka0+7cIqkVh9q1m39A3bKnG8
         +PlZ3rD0d5nvmv2KANAdT71OFKxHUb9vrjBEoyOoVnv85aIoVVInZ8bn7mFtF+g2LdLA
         C5RGrGgUmw6yhjMf4HHulMK94a2zoUeT1obfO7S7Asc9qDOvRap+gTrZTRdNzOFEFAYB
         TbSFnNPtV4YoGwQvl4CLs3xmaWwFcyNmSlnoYatF4hc+bjfe6MwkFVYEo+wuXxFzSaI2
         eWX0Q/MhCB+6XSyTdnhz8113QOvDp2kM5MLv9AeH5izABWNNToNRCLhW63h/x+aFNHh2
         lzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092649; x=1755697449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eihVYJrWZXZh50n0+ltviNDHEcxJdrJFasVcbGTuMaM=;
        b=Crz03CSVEn+fNHBuCLRmR6/1wxH8R54LEoaqzAH9Ymu9wczLlUD4ST2MbZku47f+NS
         aZmtEd68SGTH/wZ/vaKYcNeQk4OZOcOKg/YbHiyF+QszQSslISuYpxORfoCzcjilbUvN
         TeaxtLu//JT37HGSgWcPiZGmh8r/y/UtmRUULsMmOn+hJOBDJm0EG6qeo9cjLu7nAFD0
         dc4dtCr8XCm8+UgG36AiiEFVM7ft0MG/6jL8l8EUYny5kTOcBWgPVFzQwpPBu0yRUldb
         P+Cg3396EwUPfxWGfuD9WEoknNGZpkZTAdicWmxVEzKXWN3OI2O0R/KOPwZ7YJyAQh4S
         A9CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQk2EKocmewAqNPsk0rqTuPmZx1yPnldAb3f58AiKYx8NRp3Wo5JrcDWEa7u5+Ea6bviAXzcMLZME8nNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwIkckNGvNEiBTuqmNMiEYj+7XICIT0Q1uyvpL8nUMlEZ/ZUVM
	djRcfQOr6cEFtfArB5Eh+fa/3yBfV7SqO44qBguqeJ1SC4uifl6rJFOW0YoXwpGFObmVrPdu4l4
	t0QHswq0bRrQaiqFA5BUuzaTtT0v3sIyt9powPwe0tA==
X-Gm-Gg: ASbGncs5Qz7kPnJU7zY+A3XHr3ccemoKTbgTu4iN3AQinB3Ait4m6CN1WQIprsTiK3q
	ID/92hgtBZYcOSEuGzKWTZrEj+2GrrNaJVLIn+OTUR867PFjfoyVextmrRCI5D1fqkuNBwAhvzu
	g/RNofPIfSpcchi1qXRmXrn1MlpfywUfVfJ9MV6n7ALY9Ssu4yzoFhX4t8IIlpBnXw4b2loVyom
	svDXMBUkuIV6A/29i8=
X-Google-Smtp-Source: AGHT+IFU/NdbN7AcOZEv17USCBNw7GfCExUxIp81La73W0v9orSy0kbUcXLAKbnNYawjG6YyllhAALem09uD1POoEws=
X-Received: by 2002:a05:6870:9a1c:b0:2cc:3e39:7352 with SMTP id
 586e51a60fabf-30cb5bf9975mr1878664fac.18.1755092648901; Wed, 13 Aug 2025
 06:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801235541.14050-1-ebiggers@kernel.org> <aJmKDyD4weX9bR0U@sumit-X1>
In-Reply-To: <aJmKDyD4weX9bR0U@sumit-X1>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Wed, 13 Aug 2025 15:43:57 +0200
X-Gm-Features: Ac12FXw5rXcIObB1VY8YLwwvPYahf_MM_W0QzWG6bpFq_kd5MWctpI_dBq2BBok
Message-ID: <CAHUa44H1V0qR7omO8KpNxaW_bkXZAbaka=8r-zp+f6vdYs6fQQ@mail.gmail.com>
Subject: Re: [PATCH] tee: Use SHA-1 library instead of crypto_shash
To: Sumit Garg <sumit.garg@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, op-tee@lists.trustedfirmware.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 8:13=E2=80=AFAM Sumit Garg <sumit.garg@kernel.org> =
wrote:
>
> On Fri, Aug 01, 2025 at 04:55:41PM -0700, Eric Biggers wrote:
> > Use the SHA-1 library functions instead of crypto_shash.  This is
> > simpler and faster.
> >
> > Change uuid_v5() to return void, since it can no longer fail.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >
> > Note: this patch depends on the SHA-1 library functions that were merge=
d
> > in v6.17-rc1.
> >
> >  drivers/tee/Kconfig    |  3 +--
> >  drivers/tee/tee_core.c | 55 +++++++-----------------------------------
> >  2 files changed, 10 insertions(+), 48 deletions(-)
>
> Nice cleanup, FWIW:
>
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

Looks good. I'm picking up this.

Thanks,
Jens
