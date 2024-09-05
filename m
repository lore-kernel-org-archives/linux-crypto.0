Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11519D07B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725542518; cv=none; b=EYvGZ2In7oeF1zBhYGUzdGNQ4BjBqNhNYhhwg1awQ9Z3+99wo6ba2s5qTHkeohmUgtlZvbVdYJcR+gRHjysNk/uHMi8GD3RkBpIgrVmEzp2HhtH0KLZC9JZlYppgMQ26tnVz17778viLtrUV45qtEJ3iq2RjsK8nGiGbXcEc3vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725542518; c=relaxed/simple;
	bh=tvMGH6acHpq0mf3wOpKqkyCyArZRu2SdyTDclFxOFhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9KDV4KN3am9v6WB9swsrAtAlvbTM2JwKPb0qJHwC2+2G1TLJyP1fGgnV74UpbZp4P5dZw6/WzXbdflnl0xGSxPQ4mAbnKnpcRxeOmyjq1wxqNPzM8AM4ejXHgiyNw+p0VcGp+QLFqnD+UOP3Avv1nEjfz2EtKigxFy0qttv2mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A3lPMym7; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A3lPMym7"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5356aa9a0afso1272948e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725542514; x=1726147314; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lmlFpgXruyMe2tR2xQCFFCz5LQ41UoitHBNzmaLBXlg=;
        b=A3lPMym75YWCZz8EinkWZYCKvPIPxjaPXnNG6yUBR0Tj2kdX+v6bjRIpUDbdq3GKUO
         bCWePp3AwiAJjO0SsJHVsG5eHVVQnvHoTyKkT5KYofW48jtvsvrDV39wR19TDLWk1Sgm
         djA9pjfOzF72oPZZwHjZz4B6wFja0eR3qYPxmoW9C3bYdpbWcpGcsFrXyGDpzf4pkGC/
         onKuZi07fNWILlqsBuVCVu2dEyOfD17tvaho/FL6eZ6Tfhp5GR0rYhTyQLPNizFST4Lp
         pxjsFq2MFe7cRwBjZHFje3n0xdDu+bYUuXSeli25yMQFdpRvK2caCEIdE83okvIxtuEo
         MYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725542514; x=1726147314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmlFpgXruyMe2tR2xQCFFCz5LQ41UoitHBNzmaLBXlg=;
        b=FvnYKw16yvAyLgbN+q9gy1senr6T7HdG/vsNiHffNxHDF8xM+HIt7FBSxNZSE5UnD4
         Kv5O4TneH+kvK8DjPyKsWvLK7nZVl9MtfnHLhuJNnDbknUVXm7umD+f3q9pNPzlx0zX9
         FWybPYsdbwS8vFqj2Je0VHAQhSmQO/GIgFIupE/uCvI1+helaPD2Bl08s+vcXgbAp4nX
         A+2UudTfxdMm0IMnrashRqDS3IDdNcWcmVbBz4gZFrUZlUnRhjk862WaeRhon4/7PCu9
         aGdWmeTy+n/HSzOb7ymJN6TEt7ItMrtV5jVYtzgRB1cYIGdLtPT1VBkl97mt32LhneDV
         kaEA==
X-Forwarded-Encrypted: i=1; AJvYcCVj40FFdc3zTRgp3Yg4FhGof+czpOeXzo673zNTCP9H7DsuMP2Aj1TEIWv/GesDEiBSKg2J7iaA5Xricug=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgR5piTt8yBK22Utzbh1s3UARnwhVi0ee+xXvF/odR5Y/2gLA
	D7Eo4I9h/EogidhJX0MB3hZEiB55kQqONYvRjjagaQ6r/8gsYm5jlgVQ5y76gzU=
X-Google-Smtp-Source: AGHT+IGX+rtcdbYxBe2zl/yQqy3m4+s8S5Tpbx76wjpbCC2RqHyz/t9kDhohpfiwytRMDDou5RYhfA==
X-Received: by 2002:a05:6512:a8b:b0:536:54ff:51c8 with SMTP id 2adb3069b0e04-53654ff53dbmr899587e87.17.1725542513261;
        Thu, 05 Sep 2024 06:21:53 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53653a926besm140835e87.302.2024.09.05.06.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 06:21:52 -0700 (PDT)
Date: Thu, 5 Sep 2024 16:21:50 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Nikunj Kela <quic_nkela@quicinc.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, andersson@kernel.org, 
	konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	rafael@kernel.org, viresh.kumar@linaro.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, sudeep.holla@arm.com, andi.shyti@kernel.org, tglx@linutronix.de, 
	will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jassisinghbrar@gmail.com, 
	lee@kernel.org, linus.walleij@linaro.org, amitk@kernel.org, 
	thara.gopinath@gmail.com, broonie@kernel.org, cristian.marussi@arm.com, 
	rui.zhang@intel.com, lukasz.luba@arm.com, wim@linux-watchdog.org, linux@roeck-us.net, 
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org, arm-scmi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org, iommu@lists.linux.dev, 
	linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-watchdog@vger.kernel.org, kernel@quicinc.com, quic_psodagud@quicinc.com, 
	Praveen Talari <quic_ptalari@quicinc.com>
Subject: Re: [PATCH v2 16/21] dt-bindings: spi: document support for SA8255p
Message-ID: <kyy6wb46zt32e6mxcw66xrzlourhvwxnxhhq3pxioxkabs3ny2@hyhb5bjeuoka>
References: <20240828203721.2751904-1-quic_nkela@quicinc.com>
 <20240903220240.2594102-1-quic_nkela@quicinc.com>
 <20240903220240.2594102-17-quic_nkela@quicinc.com>
 <sdxhnqvdbcpmbp3l7hcnsrducpa5zrgbmkykwfluhrthqhznxi@6i4xiqrre3qg>
 <b369bd73-ce2f-4373-8172-82c0cca53793@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b369bd73-ce2f-4373-8172-82c0cca53793@quicinc.com>

On Wed, Sep 04, 2024 at 05:48:35AM GMT, Nikunj Kela wrote:
> 
> On 9/3/2024 11:34 PM, Krzysztof Kozlowski wrote:
> > On Tue, Sep 03, 2024 at 03:02:35PM -0700, Nikunj Kela wrote:
> >> Add compatible representing spi support on SA8255p.
> >>
> >> Clocks and interconnects are being configured in firmware VM
> >> on SA8255p platform, therefore making them optional.
> >>
> > Please use standard email subjects, so with the PATCH keyword in the
> > title.  helps here to create proper versioned patches.
> Where did I miss PATCH keyword in the subject here? It says "[PATCH v2
> 16/21] dt-bindings: spi: document support for SA8255p"
> > Another useful tool is b4. Skipping the PATCH keyword makes filtering of
> > emails more difficult thus making the review process less convenient.
> >
> >
> >> CC: Praveen Talari <quic_ptalari@quicinc.com>
> >> Signed-off-by: Nikunj Kela <quic_nkela@quicinc.com>
> >> ---
> >>  .../bindings/spi/qcom,spi-geni-qcom.yaml      | 60 +++++++++++++++++--
> >>  1 file changed, 56 insertions(+), 4 deletions(-)

> >>  
> >>  properties:
> >>    compatible:
> >> -    const: qcom,geni-spi
> >> +    enum:
> >> +      - qcom,geni-spi
> >> +      - qcom,sa8255p-geni-spi
> > You have entire commit msg to explain why this device's programming
> > model is not compatible with existing generic compatible which must
> > cover all variants (because it is crazy generic).
> >
> > Best regards,
> > Krzysztof
> 
> I will put more details in the description of the patch, though, I had
> put the description in the cover letter for this entire series.

Cover letters do not land in the git repo, so the next person coming to
perform modifications can not understand what was so special about this
platform. Please always provide all reasoning for a change in the commit
message.

-- 
With best wishes
Dmitry
