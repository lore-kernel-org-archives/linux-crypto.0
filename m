Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C8C350D58
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 08:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773216405; cv=none; b=Nw/0g0wToiHjdrxjrdtsJ3YTjDjjzHQc4ciXeWx45/aq96IMpGytpgp6zWrrzfGp7u755YIV3O3ekSamXrb5zquhF0A3+13mlIuc5f48s1kBKTcSMCcp5L5/RgEKVuEm9jz3PSU3z3XjtUa5iPvDKLb5JNYXx0LwHnaKK8qvzt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773216405; c=relaxed/simple;
	bh=I5XePahDdZxkT2lcI/2aGwvT7jVpioZ3NcNMQHdU7Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEsxjG7ydjdDwJ21UBqPCl3Pkol1w5Z8QB9R5SgdmtKQ/+PjqAxVzNvyGpeDY3BodtTZvg7eEyy7/fAVOvNO3E4Pdaku1kuiZOQL/UumIglB+CU6l9UiW+xFqQi6RSVm6u+9LgEHfJywrUuxHdN6txhX1moCVSQjbvDTfNsZz1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h5/Hjhhc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h5/Hjhhc"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439b611274bso6789527f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 01:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773216400; x=1773821200; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QqJVCEF9evLSw9CGf9v4iGyJ+/vqb8/nhU/YNtIqzkw=;
        b=h5/HjhhclbRrnH5/9ayteCfacKDvxrvJw4HAtGuduxqH7txBTyzUaQy8T5Svkngjnb
         N9eZtr5vmwuuV4Hl0eB4t6polvHUvwtti1ynhYBiGotkS7iQiLwoCl8C6W6drqqE5Xd3
         igdmjQcZO83solffJQsbzwH9XME6z+zWqxtLBz4vdr2AXuB+yQX521sJmAXdOrt8YTSR
         kPSKuLuSMkIZgRowxjT3eaOvkoTmknh68nZPqzt3UhBau9kyK6iLxUMcYSVyTNCSuqAv
         nq81IKZD2bsHvgcYwP+B0FUnbAgTyj5tfHE5xp3BBkBwEjWaiKIa0OYs4QRQqkW/gFvH
         8csQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773216400; x=1773821200;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QqJVCEF9evLSw9CGf9v4iGyJ+/vqb8/nhU/YNtIqzkw=;
        b=Bt/d58uOLGc1qrAsurWIhU6ogDe1JgriQnd4hv1Erjxf0E6MkhEyavV+FefPXZ9pRF
         7xHIZ/rBDfik/oHYK+exKIzuexR9DFIbx/zFwtnFf1hYZyPveYKeaHDGhIpd+VbBnzk4
         4Ng9jO9cp5oJQPBu8KynXmNM4b6zlDl+jSIKut2pHruezZT38yIWCVhaK4IXZM4VBuV1
         A4UnE3zwE8hlYf6/D7pMosB1jpK0Ucibl0x8sFrB1GVydu2FUI2iAesAM3eVgM/SjAS8
         gyL9g8pQ39ue4QozIhycro4SdKej+HuWgStApg8LmqlvHH3TLRSzHX0AAS42GdrWzafg
         oaKw==
X-Forwarded-Encrypted: i=1; AJvYcCVI3Sn7QrqIBffn49leffh1JnQ2lmCGmyaA9gj4qqyIwYSyADgHxEQQ77NyVCtqS6I2dTAnrdKCBTjDP3I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn1oUtvGL/kjLWaDHRZUtw2kau8rHWmdV07kqh94g6Wf8CdSxc
	I4fKJm+RNyqJnTuVjFBR458+FrLPn4Ah05nj4H+WM/Z64VxPMTJfE65kkkstIb3YdJQ=
X-Gm-Gg: ATEYQzxPw9+ZXljAkeWkdP7SiCg/EPpq8CFr+IKl+pVsM55PvStSg2OA3/JTqtBvZp+
	zpbjYeVmCcIOt4H4BFwipEoBcsrghg8OOIve+K9lAhE34hYXWHyT8U5wCPY/9Im5A54N0Rf1z2p
	neGCCS24Wbm5rNwUkVxgfZ8KdSNBC/+56VMYzRHUcSaphpz7Nc4TETFI3v2OTcxL+SS53SRdqpy
	Y8aAeEFAEj3wUK/94Do2lovTQ3ZbNoqYlvTdZTn7AWb3t5KXsC3CdT8g7Cf6E45I2RlE8GDCN38
	idBR/Qon7tK37l7A/H8SrrXWFJQ5anCHCIxR/Wt2Fx6Wo5bR35L6N+wHIqnlOQKfmUk20cRI5//
	uYcb3WQi/RYu0XneV8ApXSaMgS2OGtn94e8yWjG3S8aY78aiX1A+dj+WYxSHCbwMnXcW3jMUywC
	GZI7an5n9UF29wMIKDamuHSHwQ7ZAO5ZYw4YhzNtSK4kcMIA==
X-Received: by 2002:a05:600c:1f10:b0:485:3f58:da6 with SMTP id 5b1f17b1804b1-4854b0a55efmr29718895e9.2.1773216399585;
        Wed, 11 Mar 2026 01:06:39 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff23:4441:1c2c:7aff:fe45:362e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66ffe2sm30730665e9.13.2026.03.11.01.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:06:39 -0700 (PDT)
Date: Wed, 11 Mar 2026 09:06:34 +0100
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH v12 00/12] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
Message-ID: <abEiiqKrn62Y_s1t@linaro.org>
References: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
 <CAMRc=MdzjY2UJ3uSUgCabCLqWJcpaVq5eSx3-Ph-AZXcBf-JTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=MdzjY2UJ3uSUgCabCLqWJcpaVq5eSx3-Ph-AZXcBf-JTw@mail.gmail.com>

On Wed, Mar 11, 2026 at 09:03:37AM +0100, Bartosz Golaszewski wrote:
> On Tue, Mar 10, 2026 at 4:44 PM Bartosz Golaszewski
> <bartosz.golaszewski@oss.qualcomm.com> wrote:
> >
> > This iteration is built on top of the v11 RFC with remaining issues
> > fixed and the mechanism for communicating the scratchpad address from
> > clients to the BAM driver changed from slave config to descriptor
> > metadata.
> >
> > However: during stress-testing I noticed that sometimes a transaction
> > would end with an error. The engine was indicating that a write/read to
> > the config registers was performed while the engine was busy (bit 17 of
> > the STATUS register was set). It turns out that we must not just
> > unconditionally append the UNLOCK descriptor to the "issued" queue, we
> > must wait for the transaction to end before we queue it so this version
> > takes this into account and queues the UNLOCK descriptor from the
> > workqueue.
> >
> > With this all stress tests and benchmarks from cryptsetup work fine.
> >
> 
> Mani, Stephan: sorry, I forgot to update the cover letter to Cc you.
> Doing it now here.
> 
> Stephan: I tried to use READ command but it would crash on sm8650, so
> I went with WRITE. :(
> 

No worries, thanks for testing this!

Stephan
