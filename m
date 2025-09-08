Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FA62E22BF
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 06:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757314599; cv=none; b=jr4LBjmBc7I+PJKuBIAYfZPtlkiM5MudtIVQCcQYS4Gv/3MLnJIvFxi7YerWb/PURQ9q3ySrI6QJc39J815LAefT48ut/hZaXfADv1yf6JEvlsKvi+d/FYoUroAIdbY58PfPVkhspFbcD6pUGF4pPdUtQoMQsjmJnwVliXW+Zr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757314599; c=relaxed/simple;
	bh=Csq17eCLJmv7/7QqayNfbYw3ZtrTeNIABT5r2MMdoUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2RZQ91pn96Yor0r/4AiPxWz89suTNtF5kqqGIo+7HuLGV++NGdNmELzy0IunA/WUuS4vcGQ8It2h0ESy1qMFI/iZbU7y07d+EEMpt37J5MdfZY0txavcuvKH/vDv3Rvc4Iubo9kYDzeNpZPj7Q+XM3CXZuZt4VEv5THnasqVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mCDATx/3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mCDATx/3"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24458272c00so46545545ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 07 Sep 2025 23:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757314597; x=1757919397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfO9YzOQHvlcLzI/Oqj9hLG6esUOkytAkeiwFxmfpUM=;
        b=mCDATx/3yiX1K5qsI/04JjsJivHS4KLolpgblY0iOgK/9Zq+BSieBrZtQLVO0Je/ke
         McavgOlHN+BUVOpD+oxZjjwEymV9gaD0mMBDdCr85p3TrUJlFjmbOdK43DBycCFsI3ZD
         Vjj23N7CES8gSNHEl8PutjuSWBoaZ+JbxFm6UhdF8X72cpLYI/vnxcgvsx/1/lBw7pb/
         lz0Y7BJmn9JPQj82NBmoxl79rKYZMoYbA/kMcfHGPLVCG8Mbzx7LisyXKuTPbn80mSzC
         cCgSLUMCPr0VFZZTUL0uTs0dBqjD6sNcvpCaz2GeEXb5q6aqBwrY9AmJ8NIJbaCr74bd
         QOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757314597; x=1757919397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfO9YzOQHvlcLzI/Oqj9hLG6esUOkytAkeiwFxmfpUM=;
        b=d5+2/W7BXwXDcs29cljOjxBogyVcttRMDzhl0noy0HKNIzk1dHWwNwFiKm4MeI/uz5
         ydjP7wsakyoIrCc/RdilGqT88aKv0z5WaU16yk1p3oxjvZi0mruOP1eRLaHR24eAGr1D
         Dpqxn8zKWFenJ8PRrbki7kCwqZCImF5eXRyiO3OMko+EE69qPXBQyoh3ku2GkFp/wbKn
         gnD6itDZUL6gyIs8Zy7Uufx3PF6e67QN0J4mCHSZgCiOK7Tq5WzE4AORqNCHaG57xSnV
         nXO+rLWWtd6CCb+EBre4h35vL6ywiwAijPYuzAOr5P+96klvRZamAxmJSNdJBVbCISIp
         dGXg==
X-Forwarded-Encrypted: i=1; AJvYcCXCPqE1w/WRHYcIe1l+2wRnCLs06sjeq8gLWH1uhUsZTAbX3yHPgfhRLibfslpazwi6rffZeOPncaL9Vb4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/OAGyLHDXHmvdrZH1+ZXaGkpun6+A5jdg+b894JFgfhls30qa
	E79Xu6YFdzz+opbvZGyXubMDfcuGRKL2FPgSJYWDphoAVJbVugj+b669MHOKzjMTvJE=
X-Gm-Gg: ASbGncv32dmLm99H/iOS6wKW8Urk7U8OyVcW/UaHv4Djf35ijnFE0ZW6JV9hZh3rzFq
	KlaMZMVuoRXGo6bjbGvCAMpW3cLy/oZ8GZLDVRmChHBZ3qMQNsQMMT7wepX7YRRBZBzgPUdKmkL
	dEjiwFzahCBmXz0VjrvfVg8f9Rne3Eze7ru2fP1t1B37P65ri9HA1aNIdK2RsKQxBkXvaBVBT73
	WGj4O27HiiBTZckMG4ruScxOr0TGQo7sTrQy/weRxeenULxtRdgv/lq8XvI1Vqb3B9PFDMPOajC
	2blMAV21zaBZbZoGutG0oqxDROjtpw0DQqOa98dRTgz4pl2dOiltQEkxKK6wPtpMtqaxhwS3EFe
	VvyYS0bsCaQtiUDenOLyXVOvPNFCNt871aHg=
X-Google-Smtp-Source: AGHT+IEqN3OfxLAXjoh0BbnNn+jKgNAUzLVPIjM7aPLqTsUdL89FPCgDXAlE/ux9DfFsh6AFqBW7Pg==
X-Received: by 2002:a17:903:3805:b0:24a:9b12:5248 with SMTP id d9443c01a7336-25173ea1a3emr108269335ad.54.1757314597217;
        Sun, 07 Sep 2025 23:56:37 -0700 (PDT)
Received: from localhost ([122.172.87.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b905689d1sm150907355ad.64.2025.09.07.23.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 23:56:36 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:26:34 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/7] dt-bindings: cpufreq: qcom-hw: document Milos
 CPUFREQ Hardware
Message-ID: <20250908065634.m4p4tmjyb7h5bcfq@vireshk-i7>
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
 <20250905-sm7635-fp6-initial-v3-1-0117c2eff1b7@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905-sm7635-fp6-initial-v3-1-0117c2eff1b7@fairphone.com>

On 05-09-25, 12:40, Luca Weiss wrote:
> Document the CPUFREQ Hardware on the Milos SoC.
> 
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
