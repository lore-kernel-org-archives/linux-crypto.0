Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF91DC05C
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461031; cv=none; b=OX0rSwGKGLA5p1lLmWjISMh8PRIy+4sbvcNlc3/HtqcdJuw6LGbXluDq9HreBVd3Xe3GWv4yAy8uddhuXOJSf50K7nRboK76YAPHJGkZfrBsA39Qpu28jDNGfudYpEv+czykV2wN/oYg6lxSTMs3YBP5hHYqMkVo9OjiM7ADdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461031; c=relaxed/simple;
	bh=iKqWCvQaTNzfamaO6Kv/yW7GdXAB81lqclGxtEdqyLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IuXJUS6QXX0movdSsedkMe4y6n/sAqOXeyf0qe/ykMTe+DQ0wA2yAWeI3GBclbW6MFlVY0LqzyvwcfQOc5ELT+VGu+cLr4JkXhx18a+0veKDX+UqaRuvHqcEbtq676t9nrplEP3Ly0Z/giHgzo5N/qxvLMmjD6dynugymX6GOZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFKQFGBr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFKQFGBr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725461029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iKqWCvQaTNzfamaO6Kv/yW7GdXAB81lqclGxtEdqyLo=;
	b=jFKQFGBr0Ptw39hoNkmi4kExyaGiQM14j6bd+pk99W10adyprwEyy3JkSoPeRwriQKz6T/
	Z6AjV9WzNIUybl24Xyv9MZ77ue/qraSSRuJKatkqnOWxkTlSAsUhw+AXBNszeYADxBAqpR
	T97TQxPILKbOXyFUpYZA7lpIO3rdGIo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-_S8YuFNbPuWznOzk6Pt39g-1; Wed, 04 Sep 2024 10:43:48 -0400
X-MC-Unique: _S8YuFNbPuWznOzk6Pt39g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a86824d2d12so572417166b.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Sep 2024 07:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725461027; x=1726065827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKqWCvQaTNzfamaO6Kv/yW7GdXAB81lqclGxtEdqyLo=;
        b=O1vPRKq5R1Mkp09+vxiLs17RdjOkL9Kxa2huuwzOzOIhS5HCZxyQ5DzxeiTiJB8GIJ
         DBJ4h/65CBAm1oWgBLttlLJSodbJm97Nz371GvDQuGRyIXLErEVvqskjU8ygVbKQkcBM
         4m5Ppa0f3mS5Dait56nSjVyAM3XNYNBP4yPTHeCUvMZ0e0lDWUt8Wpt/EdPmJ+fY+X4K
         ROVOZT9cVfRHjE+/K2af1A33her/Sa0StGCddQtm3S8bLpNh+gS0hN0EYWeho4tJNFrn
         CMk4yEckKwA7LX7mHhMY7VmzrEVjAyh9qn7P+C+nH4ryeCQeRnZGm7PK+TZ45/7aDqs2
         V9Qw==
X-Forwarded-Encrypted: i=1; AJvYcCUZMWZzsT30vm1Ib2dR3crKCjiecMvrZRuATKrYrUceHkX0EsRwyGyd/4trpwlvb1Q49lKNzbstbzeDoEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc0bi6vvMnqtFwyNTqywf0qZZcPkXpwR+LETU1CDVR6Qwe89Rf
	sNi7XnMb1Mzpb5mtQvAXIvebG25dI6lT0avaNodItMS4AVY/wSMjhNCZOhnXKG0rFCsA+wQ/eC5
	cMdvWtUpsPmArbI39i57Flpg6QMXkkKCepGHoZB5tIrd1oBLUeymZzPgBlGUHu5yB9KRd2HBZPY
	oOv2UPBMJdaJPfluea19poia9dvNhvfC5zNZNe
X-Received: by 2002:a17:906:c10c:b0:a7a:a46e:dc3c with SMTP id a640c23a62f3a-a89b94a9cd9mr1022117766b.15.1725461026908;
        Wed, 04 Sep 2024 07:43:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo5JYtqte+s3eAerfKy35rLUJR8ZL908LjB1GKu3jHSIElZjWXpFnbsGyYvHG9OxwhFiGpzYAtdwVG44/vrLg=
X-Received: by 2002:a17:906:c10c:b0:a7a:a46e:dc3c with SMTP id
 a640c23a62f3a-a89b94a9cd9mr1022114266b.15.1725461026259; Wed, 04 Sep 2024
 07:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240903212230.707376-1-bmasney@redhat.com> <20240903212230.707376-2-bmasney@redhat.com>
In-Reply-To: <20240903212230.707376-2-bmasney@redhat.com>
From: Brian Masney <bmasney@redhat.com>
Date: Wed, 4 Sep 2024 10:43:34 -0400
Message-ID: <CABx5tqLh_8OMSrZsCFz3wpw4dQf6pQtQ_Ffh35Abop2fqhobTg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: qcom-rng: fix support for ACPI-based systems
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, quic_omprsing@quicinc.com, neil.armstrong@linaro.org, 
	quic_bjorande@quicinc.com, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ernesto.mnd.fernandez@gmail.com, quic_jhugo@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 5:22=E2=80=AFPM Brian Masney <bmasney@redhat.com> wr=
ote:
> The qcom-rng driver supports both ACPI and device tree based systems.
> ACPI support was broken when the hw_random interface support was added.
> Let's go ahead and fix this by adding a check for has_acpi_companion().
>
> This fix was boot tested on a Qualcomm Amberwing server.
>
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support"=
)
> Reported-by: Ernesto A. Fern=C3=A1ndez <ernesto.mnd.fernandez@gmail.com>
> Closes: https://lore.kernel.org/linux-arm-msm/20240828184019.GA21181@eaf/
> Cc: stable@vger.kernel.org
> Signed-off-by: Brian Masney <bmasney@redhat.com>

I found a cleaner and less intrusive way to fix this after looking
through some other drivers, so let me post a v3. Sorry about the
noise.

Brian

