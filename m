Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F80E428822
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780573852; cv=none; b=q/PNDqSQbvduD4B6bT6zDqAeTTC4wbTs81nEfNmfzsRDeIoepBOgxS0R/Rdfxa91sFqYGYjkYMvzEv5htsIS10mtR9uEoJZTV+752+tyv6mnA1kz1mWiLus1MOQLPxwOqZu+80wyzswfwkr43a8RX/vv0LfIpwTU+V57uPQr1nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780573852; c=relaxed/simple;
	bh=+AP/U3cPeU0fXOEAiHxHazm6k88v5P4k80O8mHj3UmM=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YmuQAGYEWOTxBiG+Bhy9rq6cWMM5dtxABeqa/0ot/VGZdCQorBLoQMMEjXCC3XPTDV3yy3KtJXsqyUY2mESVoIxPcxPtZoTpZjbe4e+0sUF7LvPmv6uAgV5stATg+tM8dmRXkRA0tV5m4cx+gmoXEWZG5jlVgzZWxz7K2Lar0x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPwF9Ksp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPwF9Ksp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB881F0089A
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780573850;
	bh=+AP/U3cPeU0fXOEAiHxHazm6k88v5P4k80O8mHj3UmM=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=jPwF9KspNjzGCXYyS+GMEFcIEpKsT/7uy/LNtb867JKgkmVPqD+frOr4elp9UnnXt
	 U3SDuHGBXV+/7PlBxXhBADvh4RlKCmnKEXmqhbUug82hifbtWjVrAf8qMx6nOg6138
	 QQLlVTEW7dPef0W5MhUajMNQXB+ZD7VpBhHGxCPXMVKJF6CBxIQwXpPwY2i5kRRhz9
	 5/gniVTJCS4K7rB70m4LCqH7aih1aD/PadqwDHTt/oS7/CrrgSTijgarlfuK6ZWkhV
	 qA6AaTNxt8Qg0fJGYvzPPqVw17tdzZUNjWKCNamaXNYoaUd74k7KgqfKUYoi9pSiaN
	 g32hywqnbehLQ==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39661f81eacso7506841fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jun 2026 04:50:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ht6nrXq5OiMW9Q/xKgz/3kEazhbzVTQRic+Wdhc9S6Dt9cJeJ022+fZizlUdQBnClih5K2F+TMIr1ZuM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmHi2p2aj4UAsk1hzs0MDRN7mK9zqwR9JxcP3wPBoVSRzTWQ/c
	zadNXYJ4Fs12mqv4aXyiulVH9gvdwdA9nHaW9kLIcDURGBIPy0jwPhqv4nG/cyN8dBLCZtClW42
	oOfm7X/R7wWiuqhNn61+lRYkuD9A2QdommpYoY1HGmA==
X-Received: by 2002:a05:651c:242:b0:38b:dd55:b71 with SMTP id
 38308e7fff4ca-396bbb2b99dmr9083771fa.20.1780573849639; Thu, 04 Jun 2026
 04:50:49 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 04:50:48 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 04:50:48 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <aiFScCW_NEY3CsEf@vaman>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
 <ah8G_ajPS1KhgPP_@linaro.org> <aiFScCW_NEY3CsEf@vaman>
Date: Thu, 4 Jun 2026 04:50:48 -0700
X-Gmail-Original-Message-ID: <CAMRc=McYB+S1LmqRJbWKirMGqwJHZCTWj6KnB6Z8qUsYQWBqkw@mail.gmail.com>
X-Gm-Features: AVHnY4ItlnHzBWkZf26uoYFprN5coNBr4vZZe2XdpgFnq6HAZyN9LACZLu6Trcg
Message-ID: <CAMRc=McYB+S1LmqRJbWKirMGqwJHZCTWj6KnB6Z8qUsYQWBqkw@mail.gmail.com>
Subject: Re: [PATCH v19 00/14] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
To: Vinod Koul <vkoul@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@codeaurora.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Stephan Gerhold <stephan.gerhold@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 12:24:48 +0200, Vinod Koul <vkoul@kernel.org> said:
> On 02-06-26, 18:38, Stephan Gerhold wrote:
>> On Tue, May 26, 2026 at 03:10:48PM +0200, Bartosz Golaszewski wrote:
>> > I feel like I fell into the trap of trying to address pre-existing
>> > issues reported by sashiko and in the process provoking more reports so
>> > let this be the last iteration where I do this. Vinod can we get this
>> > queued for v7.2 now and iron out any previously existing problems in
>> > tree?
>>
>> Thanks a lot for working on fixing all these issues!
>>
>> I agree there is no point addressing all the "pre-existing issues"
>> pointed out by Sashiko, but have you looked through the other comments
>> for new issues pointed out for your patches?
>
> I hope Bart and Qualcomm can fix these driver issues as well
>>
>> Out of curiosity, I was looking a bit at the comments for [PATCH v19
>> 06/14] dmaengine: qcom: bam_dma: add support for BAM locking [1]. There
>> are 8 open comments there (Critical: 1, High: 6 and Medium: 1). From a
>> quick look I would say most of these could be valid. The critical one
>> about the usage of dma_cookie_assign() sounds a bit concerning to me, if
>> it is true we would be basically breaking parts of the dmaengine API for
>> consumers by inserting the lock descriptor in front of everything else.
>
> Yes this seems to be a valid one. Attaching another descriptor for lock
> does not sound right to me, as in this case causes descriptor to be
> marked 'done' prematurely.
>

Yes, I have a fix for this queued.

> Honestly, I am not quite happy with the way lock is being handled here.
> I would hope we can have some better suggestions. Adding a descriptor
> for lock does not look right to me. We are adding odd hardware/firmware
> behaviour on engine apis.
>
> I had earlier suggested to lock always or lock only for hw/sw versions
> supported inside the driver, that might be simplist solution without the
> complexity added here
>

I'm not sure what you mean here. Several iterations ago it was deferred to
consumer drivers. Mani objected and Bjorn and you agreed. I reworked it to move
the locking logic into the DMA driver as requested.

Bart
