Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0118E77C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926737; cv=none; b=EgC85MYVDuAnq1HRKycRHvvwxxXTpDDNdDF5LrqV4TeFrD3gwNPs3HOkpmsvowgXNC5nhkDgF/92Ok/VrXlVwEoLMCMrq70T26TDmpqnvdE9uFH6jcFBKC/pbiZIo+Zo6KPaqexrB+7ICoSBv2BFmXDXwszbYxIcIVIxYaSoAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926737; c=relaxed/simple;
	bh=OJxg0KaD+aoIs7gHlpT8vHpcJOsMRLHNtQ87Kc81Ifk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XE6IJIDXAku6LL9v0R9N0c3BK6X3qticVDeM9Ax3DhsdD3BUlCZDs0dtRTl1KbX4jipZl5DYEmvmJB4RsmQasB19P+OnVzoqNibd/rqv8bnWhQ/DhbPk1DApZtfG3VRKzXcEP8XqxVU7v9B1OLqUdHdlsj3MecIA1al6YYSaQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k5TlbzDs; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k5TlbzDs"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53436e04447so482069e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 03:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724926733; x=1725531533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UFWlv34nf3nNcH4Q+olrdVPkQmshdHNCgMasyXSoEAE=;
        b=k5TlbzDsqR7hyGzhc42Z3Js3SbOJp/Hy/Qa6CQMe3P6D5AmZVKnUwLulMeMUxa9utT
         e0rJpwbJ7qhv0ymC3v1TV7/+Pqmqubb0WM11EqgSwAJ6HuwJYtkZ57wWuazgshg7T+Jt
         H+AZMoQtGXBo/ftcs4W+Pe1bdyV+rtpNSesJ26zKoVmccgQgbKGcFJYr+ccWU7Y4DQ+Q
         XbrIt5EoUiW6w4DTbrkMpr3fMmvrCgdo+g3YLRqgbgb8OSENqe3WA+ezWkVyqB8oBjHg
         1AEIhizZuaZsGy78DPOJm/ZdE4RtHonxERZcVldo6jPT6JjIKORmfEZq34Ob80IzSEfu
         oi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724926733; x=1725531533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UFWlv34nf3nNcH4Q+olrdVPkQmshdHNCgMasyXSoEAE=;
        b=WHOOXbF+aYvXdtyZRVz0orw8dabiDZsX6ZyS2OlxljM2nuBorutw3SQuvXH4y2txBc
         RlJgz75JI1Mt98Z+qPequa00fNAGEOgaCl38UpuaMo2frHbhT/KzOTN36L4FMIMLdVDS
         3ua5aegXeNo+alRTotn+aRrKpD7WvHpESqYXrl81uFzrk8bHHPIUGK8lcwaCRwn1qqi+
         jYBqSkaylmcLeQ7L85t1+zrx7U9C1aACnkbdhBVpCGmMJ6MJKbNBXk5/c6LjVVz16MTv
         xOActc7EfYWxbF5fbyLfnDs0yEoLx+RxOCMGKPaXAoJE8me1iu9Ipnrtof92o3BunDmd
         hLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVLwpfB+cHPZhkTwPtUCjdoIo672DAL54/uNlgKY1su5hB1CzzOMJ2PTCT65rn2gbd2gx335dmeb411HLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqLRL8jh21bh/ueSQO80AipwHKSzZzqOT6su5+1TyPXCRpMBbG
	rlHoxr+AnBFW6qKWAjpe3zJQ80j2IkwGh7ed5KObtVA3Y4UxkP2CRtyIeOSYyuY=
X-Google-Smtp-Source: AGHT+IG/isTUOnqGGngH4Iw9Bioi2AqWTJg5DsCzUersNkBeh+W9n96KCZnJMK5d4ZuSOcIvogGNsQ==
X-Received: by 2002:a05:6512:3e20:b0:52f:cf2d:a1a0 with SMTP id 2adb3069b0e04-5353ebe8867mr710726e87.26.1724926732689;
        Thu, 29 Aug 2024 03:18:52 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5354079bd95sm117356e87.62.2024.08.29.03.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 03:18:52 -0700 (PDT)
Date: Thu, 29 Aug 2024 13:18:50 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Brian Masney <bmasney@redhat.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	quic_omprsing@quicinc.com, neil.armstrong@linaro.org, quic_bjorande@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: qcom-rng: fix support for ACPI-based systems
Message-ID: <6s2lslewnww2hka6k4zxrevufppf6p3p24hysg3dzbr7ottxnp@sjqpvfuaskgi>
References: <20240829012005.382715-1-bmasney@redhat.com>
 <20240829012005.382715-3-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829012005.382715-3-bmasney@redhat.com>

On Wed, Aug 28, 2024 at 09:20:05PM GMT, Brian Masney wrote:
> The qcom-rng driver supports both ACPI and device tree based systems.
> ACPI support was broken when the hw_random interface support was added.
> Let's go ahead and fix this by checking has_acpi_companion().
> 
> This fix was boot tested on a Qualcomm Amberwing server.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Signed-off-by: Brian Masney <bmasney@redhat.com>

Please reorder the patches so that the Fix comes first (it can get
backported to stable kernels). Renaming the field is a cleanup and as
such it can come afterwards.

> ---
>  drivers/crypto/qcom-rng.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 

-- 
With best wishes
Dmitry
