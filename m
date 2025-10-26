Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE1E1B21BF
	for <linux-crypto@vger.kernel.org>; Sun, 26 Oct 2025 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761478753; cv=none; b=kiWd1SFAtR977QSGnvYIQLnZyOWCs/cdSnLwLlU5ILNSITz3x/6VdkbPjVGBSVWIkoZns9ZpVh2uT7vKXll2k8ifI3kJli3dZTSVjtrkTRzdpTVCx0t19QVGwJbGBTMp/2ONATNIETr+ZJujiPLKIzFmbIBdkQgvqc4lKtV/sB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761478753; c=relaxed/simple;
	bh=j0DSqnJo3+ZWQare0kWlrCZ5/Tm1ZDbwWXOuuuFqhMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l7yB33XmwWlGleRfJoTt2CwD7vG8oR0OZ6riUUw27AEQ04qyO+cNITdmARqFfmdX9nzxUMhpN7d/QFHQhChrXLKWebIrEB8yBjClHhE9ChdF89tEswLpSZ74eiaXhMweyv1HfgiAjdLtZv3t5ABebDA6IHiA+XJP2dUejQJq7Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=E8AIVkep; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="E8AIVkep"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63f5c80eebdso129920d50.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Oct 2025 04:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1761478751; x=1762083551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkEJC8HtsrIv4zgbYuistKh7eAOhGGJ2bEOCqXpaWog=;
        b=E8AIVkepdTKDKBvR/u/Kcau33805U9xRvCzsPNMBzICakqOdX2kC+hwQTleNl6ShvM
         pYrQ4yv7VftTtjJmcER3VQRr1cgbPbCfyOzrafg9I+yYlzH9w3VKhRV+QANZ82/CMBZU
         c+ySz0kNgvfyoQgt6IOTRE6sLl92yiJagIesQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761478751; x=1762083551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkEJC8HtsrIv4zgbYuistKh7eAOhGGJ2bEOCqXpaWog=;
        b=ex81gn8NKEeya2ropExP2p4j3iaJHXl6G96P+OcPOaiRWJgJr7um48y5yiH33dVcje
         DwBk43w8DLdNwsQ6xYYiHFDehDw6LkHRAbX14951rmfvUyMaqOE+BFxC1GBQU22qm/Zu
         7hu7IPZJ790HhNsG+mGGspUwkO9R1FcCAq1nKvvopoXlgsupfFuHLKAcBw5m4MXOU6VK
         UsjU0lDDC5P5aFdojDuDx9VAaCrrxsak14RwD6XxeeYCj+DOJxxLnAvWOhQl7A9Eht5p
         tMqo93yivfSK2YHe7ODogDKImq5LgMg2r/K45sR4Rfqqi/GYDydm2Sx/pkj99eEekRjS
         5y9g==
X-Gm-Message-State: AOJu0YwEQCOAd4qyCzctENx1yvmVfpgcx0DvHNpO7DoxmyRaOQI6dT6/
	1oLliG7alLpe9WoysYhEQQbnmUJSoS9uVIbStJsgmQRny50Z4Fxr2B1JCUWnnBUoN1UE76541mW
	bB2Xj4CuzsQbYyOW+mArEgoFOc7m2SuqbylfSORVoFQ==
X-Gm-Gg: ASbGncu1Y03ffXnRX5RLGPLkacs7a2kPhamcSCNzIdYaKFMwj12HGF30ytgzSE7FbkU
	fXUUBwXvW0w/JQVFOU3Zj7zmP65e+qJyEfzmfCzsqmDxDYTDvi6Muf67oOF49nVGGqzA1yhkQkH
	VHcFvIQcqOF694akwZA+80gWEtgdYUjpKhx/UgPbvjkLGEVn67EU+jxkymtmhk9bQapg3lk7G6+
	7rOeAqWMcu8FJbDdtCdV9p5LGRM3PWCyAjWYRYqkA33rQP3DkIa0iMQ2PDAnYQPf3A7FPE=
X-Google-Smtp-Source: AGHT+IE5wi1pOk5gMg7t44CcjUcuDJu5krHIn2apqIczzrvUxBYy/Gnl8HzIxmhmuF6Z+BqZbysVKsYMZFeUOs31qhk=
X-Received: by 2002:a05:690e:1598:20b0:636:1a27:6aba with SMTP id
 956f58d0204a3-63e1617624bmr24007856d50.12.1761478751060; Sun, 26 Oct 2025
 04:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
 <fe4d7cd9-0566-4d1b-97c0-91cc1f952077@web.de> <CALxtO0m1R0kf5Am+oEPAgqommQph9zs6+xfTM0GzGHV+YEXT3Q@mail.gmail.com>
 <51baad8c-6997-4e3b-81df-6d0380fc48d0@web.de>
In-Reply-To: <51baad8c-6997-4e3b-81df-6d0380fc48d0@web.de>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Sun, 26 Oct 2025 17:09:00 +0530
X-Gm-Features: AWmQ_bloZmHf3HWYJNFPPTUzK-vc0K2C3sQhcOg1pi8KCo8VnNlMuW1t0ziEdx4
Message-ID: <CALxtO0=4iJho3fqVuQbV+CQyhYqc4zbmNNGeSy03go-iy758aw@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>, 
	Manjunath Hadli <manjunath.hadli@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Aditya Kulkarni <adityak@vayavyalabs.com>, 
	Conor Dooley <conor+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, T Pratham <t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,
  My comments below

Warm regards,
PK

On Fri, Oct 17, 2025 at 4:36=E2=80=AFPM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> >> =E2=80=A6
> >>> +do_shash_err:
> >>> +     crypto_free_shash(hash);
> >>> +     kfree(sdesc);
> >>> +
> >>> +     return rc;
> >>> +}
> >> =E2=80=A6
> >>
> >> * You may use an additional label for better exception handling.
> > PK: Ack, I will go with an additional label.
>
> Can scope-based resource management become applicable for more use cases?
PK: Yes, wherever applicable we will make the changes. I do see a few
use cases in the SPAcc driver code.

>
> Regards,
> Markus
