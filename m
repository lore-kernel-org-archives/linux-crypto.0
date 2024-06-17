Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC416C854
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 08:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718611278; cv=none; b=hJvpj4vlk7irtDQg5epMPA+trB0pVBn/UJlS6VHmJb6pe2JiYVVjARQZKQLqXFE1I21SDGZY5UnKZHy4K+b8UzgHVQM8mXGe49BaE2xywhqZCGHV0ury+TqW0lh6G5nsB6N9PvtFsOcTd6s88SzAyexVrW1uMYLtuXdIgYBsIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718611278; c=relaxed/simple;
	bh=vuhA+mIQJ2RSX99AvGZDj+nJCxG/WKXFPdCWspBnQ4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mg3+RCEV8kgsGD4yhtRyYMHJNEY0ZlX+lfKIqR47ZFLyjBDgh0CdAlCo2BwWurpJYm3oeh5C3v2PaImnFw6jy8aNcNQEsvokEdUetfTEMXtbZYViD+XHTjfEIEfkI0vL8/llGnSb2xqOBBkqxFJ4VX8Yd1QnEmOQ1RDOAleTCk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ttu1Fob0; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ttu1Fob0"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52cc129c78fso28188e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 01:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718611275; x=1719216075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQ/lnoLnxwCnySxytQb9nQ5xYtOeT14sXw+lATiwThw=;
        b=ttu1Fob0SogLsviZMpJWehzESO7MkINj54O/uV4UrjfKY8zGLixhccbCHK+XR4sTwU
         rsZajLUcTyLOnAS6tkrpzSF+znIIAiKlaFj1nHSjA8LBsimR97X2UqQuPwx2FYgf3JqC
         nbTJ4e/dbPS9disTbUOk3S/vLzeYdS3Aby+R5ye1VYw3KorYuLbvnGY7dYhBxyszE6/Z
         AxuYRvJm0Cm9fLtk50fEG8rElKX64aB6L8lgM9HU+5Iu06r3rGKwnoOPbWMAu+G8k+Ma
         S7TO+0V1ZsxSwxGSbFYvHrEFrCHsbsdLOXEgjDE5Y38spdDCgYrNhygA7kWij6O3vi7s
         KZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718611275; x=1719216075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQ/lnoLnxwCnySxytQb9nQ5xYtOeT14sXw+lATiwThw=;
        b=N3/+9rUtwVqyl3isb5PpYmjDJeiWAl1SyUPEmWdv6q+8ZYfnQrmRxxay235R6wDs1t
         Gk+bpshVKIhYqlEL5CVaREH89inr5V97o/dH3q/ids04JbrxeWeEW/ndYy4PKuea21Tz
         hkoNfOeu85jtL8iVYT5oJnyW8XH6rvmarFkGLyE4yeGbkSDw1toPM+eGyWUWPjHNwFRE
         ULbEKmDKUw/Vi5Rno6hlTo82QlBbw5ciWHM2lbQ7cdX7k/NHl0OgD+ur76mSQLmPy/df
         C55Lx/JYAFzH0FcFoCO2ycoPTMIXZUeeCPLhu+oATtCGbPfXINrnn+SOZjmES6rRGsxB
         BGaw==
X-Forwarded-Encrypted: i=1; AJvYcCUlNy70FOCwVZtkX2PagqdBPRkSbVKMMUyiKk+517RCmhphugYQFqalo69dHX5fTLd8IsolXTWU4qSjo9MVZ+YdJJt9GphHkodGMkZE
X-Gm-Message-State: AOJu0YyCrn1+S4rVujmBsa6hfrzPdVPlLNgBpAyouiExurqmlFWinZCa
	mP/DvMLIX12pAmZTPUw2q0ryH6mEZQ+Y+Y20rc4GepC/AP3mzs4jsG1f6NznHBk=
X-Google-Smtp-Source: AGHT+IG71054E0fvJQuGC+hqCqYraV8STNLzGUuueTN+wKbvGZ5vdciJje61F+fQ08XOpku4G9g32Q==
X-Received: by 2002:a19:f703:0:b0:51b:214c:5239 with SMTP id 2adb3069b0e04-52ca6e9f465mr5226032e87.62.1718611274876;
        Mon, 17 Jun 2024 01:01:14 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyybrhy-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca2826269sm1169293e87.61.2024.06.17.01.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 01:01:14 -0700 (PDT)
Date: Mon, 17 Jun 2024 11:01:12 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org, 
	srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	kernel@quicinc.com, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	quic_omprsing@quicinc.com, quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org, 
	konrad.dybcio@linaro.org, ulf.hansson@linaro.org, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, mani@kernel.org, davem@davemloft.net, 
	herbert@gondor.apana.org.au, psodagud@quicinc.com, quic_apurupa@quicinc.com, 
	sonalg@quicinc.com
Subject: Re: [PATCH v5 07/15] ufs: core: support wrapped keys in ufs core
Message-ID: <dk4y53xrkn3jv46mpr4n62yl5yqbql5gwn3c2syyvai3simcph@s767oanivria>
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-8-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617005825.1443206-8-quic_gaurkash@quicinc.com>

On Sun, Jun 16, 2024 at 05:51:02PM GMT, Gaurav Kashyap wrote:
> Since wrapped keys are not part of the UFS specifications,
> it needs to be treated as a supported quirk of the UFS
> controller. This way, based on the quirk set during a host
> probe, UFS crypto can choose to register either standard or
> wrapped keys with block crypto profile.

No. It is the user who must be able to select whether to use HW-wrapped
keys or not. The hardware / driver can only specify whether HW-wrapped
keys are supported or not.

> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/ufs/core/ufshcd-crypto.c | 24 ++++++++++++++++--------
>  include/ufs/ufshcd.h             |  6 ++++++
>  2 files changed, 22 insertions(+), 8 deletions(-)
> 


-- 
With best wishes
Dmitry
