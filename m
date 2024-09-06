Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFFBDDC3
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 00:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725583933; cv=none; b=JNJHHyUbCcg/sRi4feC1hvp4iUADVWq+LgQ7b62bDkV031Lpohri4p6XOH0OASrYiNIjjhnnSu7RMEsDgOKFbPlNgt5odW87IiZ62QkbDpsizjBpMOpggx5kT8G84ZcBsJXpmykMhRvS59ruBxnkj7OKUZ1cdd6prBdBEQmRHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725583933; c=relaxed/simple;
	bh=jIgbO35t0FjK78L3vHKAhnfNwuVwbXjQi1f3jtHTYhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Al1HnM+9gH4At1uTSIYgDoFM54Pkt8aYlMHqjJUHi9Y51DNLyy8HD7vsRVtECnz/yrzZLph/Z1GAaU1kwvXHip7mnUoAld+DwuONJTCPCwblrs9kV3D2MLPDXkzTt+JCSxf0mvJnpypkAx7E7lg/G6e6mcTMctUhByZmSL0gX9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AiPQSMK3; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AiPQSMK3"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f50ca18a13so17119301fa.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 17:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725583930; x=1726188730; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k67V4d6U+a4ymIwtTxfSVTqPn5Mjm51cyPX5ZzN9RPQ=;
        b=AiPQSMK3q+Qb8+GD9oePIIoeDrrwLq4L7Oo2FkiQ2GIp83VASKDp0TX6rCBD8SIwii
         BzX0MrpcCzNnWF8HQCuGLhPU38CRJWpsXedX58/IbaNY5jgxXUMfePdoDNlt+L7u32ru
         L4axjuMwSvwTWnyMTZvi76aektq+K6vQNi/eQE1hpu57dduaAm5xoP7J9PkfhLntJOf4
         Fczin0R4fJt2H4CdXt41jct+RCwZ0TH76dPDtM+GtZ6ACVnCoMc8Cg1ggnoaP9VLX2ao
         WjXuEN3cPw/jxu3jpRqSndsmmXlz3sPMzsKSTCUedA+aiURaDlqhaZs/5vmeV2NClQsp
         NppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725583930; x=1726188730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k67V4d6U+a4ymIwtTxfSVTqPn5Mjm51cyPX5ZzN9RPQ=;
        b=DYlowFaPviaiVoXqOwrvMkPxTc9MJfgoM3saXlnVCZbvh1Mj6WM348Y3zRIAv8ie0f
         KghoH1xoGe7i0mtLEGYv+IziZQTxxM1Vf4aJOx/LOVmhQb8THwrTYze+Mu0Mk7hhA9uX
         n7BBJxAiRVG+ADcUlXdmSIw3VUjHBm8oXtvJOGKHACxPvVoGgPJjqx28Pb7gr7zv1Auw
         ErKlBjM8Z56RC+WRCoH+42Hq9e7AzMjCyzBxKKaOoRm0Ep/YGas2yySJUPtwMZ2VGI2f
         m2amwHWda6Li7t2NyNNKwloOb6Ws73Zvpk+F/13yvwVRHXZkN4254BBhfMdsoARKcPce
         QP+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwVr5D/c15xIu7n9Ty0tRDbKqbtIpB5PxR92zmodhdlmjoBdnoqRcPjLABfCh0ByzL7kv/RXymOfz6/4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLA0j3rkHmU3sRxyC+QyFTHm4Rg6tRzhhCO8Q+a6/noNyPrEVp
	RTHxu/KXZTonPm5uORpinrHfLYfXBAQZGhq0jU073HHl4ltSqwnWdmWRYpU0TsA=
X-Google-Smtp-Source: AGHT+IEo6pJRSCOhheQ4SHdYsdjC/ga3+gMi/ZowkV+pSmPbkIvf+DoWz4LWwxKdAClAIbRTj5eadg==
X-Received: by 2002:a05:651c:2226:b0:2f7:5239:5d9b with SMTP id 38308e7fff4ca-2f752395e50mr3013471fa.4.1725583929638;
        Thu, 05 Sep 2024 17:52:09 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f614f37dc3sm29897021fa.59.2024.09.05.17.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 17:52:09 -0700 (PDT)
Date: Fri, 6 Sep 2024 03:52:07 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Brian Masney <bmasney@redhat.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	quic_omprsing@quicinc.com, neil.armstrong@linaro.org, quic_bjorande@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ernesto.mnd.fernandez@gmail.com, quic_jhugo@quicinc.com
Subject: Re: [PATCH v3 2/2] crypto: qcom-rng: rename *_of_data to *_match_data
Message-ID: <264n2b4dwknzxs6dyce5kmhxy2i6bzybuur5n6kqp7rhwy3r5g@7gcz5f2ym2au>
References: <20240906002521.1163311-1-bmasney@redhat.com>
 <20240906002521.1163311-3-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906002521.1163311-3-bmasney@redhat.com>

On Thu, Sep 05, 2024 at 08:25:21PM GMT, Brian Masney wrote:
> The qcom-rng driver supports both ACPI and device tree based systems.
> Let's rename all instances of *of_data to *match_data so that it's
> not implied that this driver only supports device tree-based systems.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  drivers/crypto/qcom-rng.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
