Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2801B960
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 00:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725583459; cv=none; b=du3BXcMuwF+4jx223Ul9k14f/1nSQ20DIqUBSxUTHCw0MIk0EG9lvg8gR7vT0ZsCBm7IBIpBeiLCAIHI+thvEYvaHhi88Nvc8ZkmaxgdoBCrYfnSK2YCNBbj4p/XPuVSSho2qFc/6951ry3fJVzihsTEpX/F9jGASt7Lq7ODW20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725583459; c=relaxed/simple;
	bh=PQF18rIEdOSXN7JRjSUlhnGrJW+ZCNo8FxqEZeUr9DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/grhPV8/qyV0coVojGIIP2nX7+yYevIg3CCHLg1OFGQV44pk6NJzUNxRrns7/apXVOg2d5G7P7YgKei3jpw7uXay+8q80F/JAWHBtDSXbQ28QoctQn8b1kd15N2KqZyuGo7CCa7QkLIdVPbDOmOSjSNs0Ho/+ejx/wCoQ6A36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kPuOWFEv; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kPuOWFEv"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f50ca18a13so17085011fa.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 17:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725583456; x=1726188256; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NXaqIGOR1X4Y7aTWIRPmyaHoaI/4hALLawtAhll2LY0=;
        b=kPuOWFEvCWe13B71nFttvYlnq6vfE593/4nfHw363g6TM9bQqBU/t8CNVICt6oco+o
         6XxcJntKO/MPS2QGEX+ZOANCsvRqO8H9arW1llGbuIQbHG6yChRoWqMIrtcVl2bWyD29
         cAC90OQVaBe4lEbjkTpLjOEYUwV+tTKpBtUDaOvu/9U6Zwgmkgj/lexPqJXRZUniWc0i
         V+u8qYYjQst21IoxPMkbDq4Gjz72wG2sWtdNzYYI46rSISFa/4uQMYrYXnsZeOFCyCHT
         zhM9hTNXLZQymvX//HQzLimgh7cFkDfsMhUZFqLGFCKU0cgoRivl1BkDxE6BDuRz3SAb
         4dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725583456; x=1726188256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXaqIGOR1X4Y7aTWIRPmyaHoaI/4hALLawtAhll2LY0=;
        b=V9rvEq5aLto+R3Cf5E9rA0spFnlOEEcJisBT3Yr7YslrZRBfiHBujeQzETfZGN76C7
         u3uEoqHn2RFV9UkUPcj945mmJgLuKHtomTnPheP0sUySjtFUzWwfjMPzQafYfzlYaBF+
         jfY1Lb2F8dK1nuZp2eu/FPVcWxHVsylAPiDmcGCHDMglyu96DxfPVM5Wc9XCdsDQfsX7
         Eny9A6icqx7QbdzFY01BZQzEeD0ir/B7akjOjAeMTNKjIKTtCfdSIXevjCjolbE6qqcY
         DMzCdZSuHlEvJaBuSVn2IKGxL4C1KJ0VbSza56tgYBAG6d9yCYsZfh1b6AAGO0VU41fQ
         f8aw==
X-Forwarded-Encrypted: i=1; AJvYcCV/3fN7mgWzwju8Zzeq/IZXDaVAHjMEXBzasftTzxSr6d8tguFxRvUwt2UVIggqitHg++G9zVfH9QQOlCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YysYPURuouR4X5WuslCkwTI+TZbG6S5HO53jG29aWfO+14OxOFS
	3puAqhXM83xRAljuCLIdOm7gu7weeLd5ys3JYrkbIuwlHg6l6IFORoPhkK+OamI=
X-Google-Smtp-Source: AGHT+IGxggKKtKTIZ3dZzqgsaHxZwdFmsswJbZRFue5QOk8kbwdqu8SXstjZSNjBYILSGC/DL0CXuA==
X-Received: by 2002:a05:651c:2226:b0:2f7:5239:5d9b with SMTP id 38308e7fff4ca-2f752395e50mr2965201fa.4.1725583455073;
        Thu, 05 Sep 2024 17:44:15 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f7528ff0absm500731fa.132.2024.09.05.17.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 17:44:14 -0700 (PDT)
Date: Fri, 6 Sep 2024 03:44:12 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Brian Masney <bmasney@redhat.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	quic_omprsing@quicinc.com, neil.armstrong@linaro.org, quic_bjorande@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ernesto.mnd.fernandez@gmail.com, quic_jhugo@quicinc.com
Subject: Re: [PATCH v3 1/2] crypto: qcom-rng: fix support for ACPI-based
 systems
Message-ID: <hxemor5teajfz4a6ouv27baepjv6uxj5o5e74kynhizqgdi5gl@p55iombm5rgd>
References: <20240906002521.1163311-1-bmasney@redhat.com>
 <20240906002521.1163311-2-bmasney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906002521.1163311-2-bmasney@redhat.com>

On Thu, Sep 05, 2024 at 08:25:20PM GMT, Brian Masney wrote:
> The qcom-rng driver supports both ACPI and device tree-based systems.
> ACPI support was broken when the hw_random interface support was added.
> Let's go ahead and fix this by adding the appropriate driver data to the
> ACPI match table, and change the of_device_get_match_data() call to
> device_get_match_data() so that it will also work on ACPI-based systems.
> 
> This fix was boot tested on a Qualcomm Amberwing server (ACPI based) and
> on a Qualcomm SA8775p Automotive Development Board (DT based). I also
> verified that qcom-rng shows up in /proc/crypto on both systems.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Reported-by: Ernesto A. Fern??ndez <ernesto.mnd.fernandez@gmail.com>
> Closes: https://lore.kernel.org/linux-arm-msm/20240828184019.GA21181@eaf/
> Cc: stable@vger.kernel.org
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  drivers/crypto/qcom-rng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
