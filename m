Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB351B87DD
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732554282; cv=none; b=mGKOQt+Y6ytMo+aR+ytXyyjjeIPAPU+Z1rIxot2fSEEF64iNzTAyzshGiAEO91XpQ6jLdTAlO+E1ZCIYjWZQpbgMAeqU4lYzL+HTnKbMy0GsDppFS+AZnX831+WQzQkhVLqaFilHBfHt36e0iPLfXbn23Zdu4u+L4edj3te4kVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732554282; c=relaxed/simple;
	bh=/Cs4hfj9obntVomONyvV6xiN7rgE7OfVdzENAMostJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6TwhQyZLGMh4nz6oP7OhNyW2geozsdXeFK/q9dTPCOtJweKtxYIWGFMemsuxLfUHUN6Et7dRmW8B4Yyrz/T50WaSKox3ZsN/dWtKl4lXzjxOaC4zpAN9Jj1ZLOj+XitbGfLWvny4vhkowEMLwBrisracgYDLG1w17Pi2oTm9m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ij2t0Ehl; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ij2t0Ehl"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb388e64b0so51685711fa.0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 09:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732554277; x=1733159077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOqS7XycPVasCpLUmsgPysaSQK/jkK7vxYxhUtuGR7k=;
        b=Ij2t0Ehl9Zljn86ExxgiSFiNxYrI5HuIEjRtlouGz4ERFzf3PoS3LBoZv4f0RGoeAM
         qSJw2gmPvITWt1WeNVLdLpg5TDDcgsKpoX96uVGRzAcdWXOnHa4JUlqa2uYjLwHYohj1
         iHF5pIkrAMOZ3wcq1FBdEmeoQNahLK3O3nxHKMPzaIY9PZtfif9ZiCUUh14IoA5mnp9+
         zUOBG9+ODXlmAbP3lIoghprd0a929dZPXjbumSuOquB+7YcAZfRnPqmZKedJcbKaoqWk
         Q4PF1/42ub24pvRJ4BDrh5jW8MU3pYt1SHl3Q8udYkd0XbRZHU1JFW0TYyJyXoOFltpw
         Hszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732554277; x=1733159077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOqS7XycPVasCpLUmsgPysaSQK/jkK7vxYxhUtuGR7k=;
        b=sSrshRixeD2G9YgbYoOoLUOrxBuB82mS5Fu306+pmfKJ0cnqaERQXSurIdLTZt//Jt
         tyFHHsNZOohGEJGCzvTz3rBl4rKThaX1l+VVqMkpNGdEigU6lLIOONjSBUcokzS8VHfp
         QwJlV+/pvlcOH1OHsY07y0d/MUA2jBMvsKjmFEs/v9LDncWgY88RMRL+Rjt1u2tBwdmc
         iPu3kRvxFaKIAbZGJRuRpabonQqJZAD+ngh5Fu+IB0YSG7IGj4lDsxrzPyYveNqBh8fH
         w1LwvEt7B3QLBkdmR++5w0kLf/Xv1VNLJdEuJEjtKAj1yhcl5TKIhdHJ+6qx/2VcN1eQ
         fFbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU16BZ4/cMMSV/25coR9uNU89F236dSmEhrduQfFc6BfX4NVDByDDwBgTbZyGPtLm/MdFu1p8VP4dAnqw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSREpReSYMSu8GfHC/JqjkJuU4dw8300yCOMjAD0BuN15wIbl7
	lf03wSkTEXhrVNZEpBIEO2EnCF974Mc2XkxAK7lVcwHzpZEr+Tzblm93YuigIL4=
X-Gm-Gg: ASbGncuuL1jgrs5kMSp4Xdv9TtG7yxxXVHqyKY3CX9emN5J10yQ1nGK1MDDk3pmNYIO
	YHuYwXJRgvuDN5IQDjvQEkL6Dk7YI6m77Z9z22sYl/BkocIq7K9hokFhXmFLV85Fy7AOMYimJKf
	NGXk+YbfSSfJUNP9xIPegdlrAOmGA6F2FCXrW0Sx/tHBhweaC8e/AAUbQ9ozZhL+20SEZLUYDYq
	sYVN45jkrCtYSmfEiZ8XdRvdNrGQiCADRt7BbWG7m5soQRHLcHJvTthGhxCOUCXv5Q+aRY2r2vu
	Rlt7LB/lyDR/xxq3dsbK7XL+QzrRNA==
X-Google-Smtp-Source: AGHT+IHAWOCIhn3v6jdT3oe9Kgmdlf5AUqH+NzlAaOE4/2CkcMdsXewmUrNDNbExMP9HdvEzf3cYWQ==
X-Received: by 2002:a05:6512:1252:b0:53d:e397:2ddc with SMTP id 2adb3069b0e04-53de3972fe2mr2227535e87.5.1732554276908;
        Mon, 25 Nov 2024 09:04:36 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--b8c.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53de59e1ea6sm283947e87.53.2024.11.25.09.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 09:04:35 -0800 (PST)
Date: Mon, 25 Nov 2024 19:04:32 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/2] arm64: dts: qcom: qcs8300: add TRNG node
Message-ID: <ulzzcla5vkwil7bs4himipguovx2yegp5k66ehornzmzix557g@wlglv6up5ey7>
References: <20241125064317.1748451-1-quic_yrangana@quicinc.com>
 <20241125064317.1748451-3-quic_yrangana@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125064317.1748451-3-quic_yrangana@quicinc.com>

On Mon, Nov 25, 2024 at 12:13:17PM +0530, Yuvaraj Ranganathan wrote:
> The qcs8300 SoC has a True Random Number Generator, add the node with
> the correct compatible set.
> 
> Signed-off-by: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/qcs8300.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
