Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E62843BDBF
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734644; cv=none; b=YL6Y62nmXEqfHrdKFCxy1kvg2NJrtGQLzF+GlVCgf/e+qhr3vIUpSEDNjVed6g6VY5TOB8gQK/lItE6UOR+y0EdtA6QiLkRP6xw72bOfpUlK7dDTQ0PMab5NOMk92Lu69cj/PGZQfxheY1rn1oHtZBzzID7R2FgSjb2+VxAUUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734644; c=relaxed/simple;
	bh=UloBQ8Ez6MOjDxcfoVY4Udfg1eK6fAx1N25vx7IHZAo=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J5guNkCXbr4Cf6KfKhuuMIh3MBwNq9OdJXqQAXxLT9fcT3O/oVZtEtb00qHBKNTPDvSFmWFObDwxUbrya3j8hE4dPals/mw00XjXcrBettd15GnwREa3ExLtORs3drgZYqSThmuAdbCA6/HEVL5eLwiv+eSwxkFVZ+jTqbdHrLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFi8Rf1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFi8Rf1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282CE1F00A3A
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784734643;
	bh=HaoajPDNv29VaTIIf6GrfEb1E+GCgrFVcWpJuxlF4Rw=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=lFi8Rf1IsOXJpIOubPX98Zty9P9JVlsID0tAar9u3iKPprH9il6ipE3Fz1O0aWr5K
	 PNcKrwD6oUrMol+TbiMeIthev6fyQWsaqENJmb9fbOQYRcU4sK1/Lm1M+gF7D8Dyb2
	 3ZGPwfq5ullfZM3mmPFc5z5HZ9bQlVMmQy4bFtjUb481MNdxzlC9m2+nP1zv3BiNEk
	 t2zVL0qjrMqRZoPrMe6rOUWQQRVoZO1oWIudPPMN9V1fRh2YXPT/LL30mMFQVDju5A
	 2US7Cmx4bPQSGjRJ0+WKBhaHfLqKJQK4KM5epckitYuPtxBSsjNZUFJR2dPMHzp5cl
	 YwAggJZIs3/4A==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39dbe684115so46437291fa.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:37:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoG1CbwcZLY/H+t6PMpG4W3XAvnNGQnxOy4TDk3UG33tI5jwAZeazYDAwC1lPEqHgzj5b+6NEVo4aCAFEI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt+vsDclxkp7ZWoZ/WIz4gRSTwk4dU7o6DEww7AzVYFUUO2Olc
	lvjFdwsZel+B2pQHAnn0jGpILMQGDtL9cBEsPUxQZ2reLFUEa8OM/Jn9tXM/i+GRI3QmbR3cBfW
	A3yfpytaYTiNkbtFpbCUBxqt5UfkBasDatSNrB5awhg==
X-Received: by 2002:a05:6512:2c8c:b0:5b0:6343:a298 with SMTP id
 2adb3069b0e04-5b2a9b6b30fmr903822e87.7.1784734641868; Wed, 22 Jul 2026
 08:37:21 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 08:37:19 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 08:37:19 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <amDRxPkdvbA-iVer@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-6-1be02deffda9@oss.qualcomm.com>
 <20260721134853.2B2401F000E9@smtp.kernel.org> <amCGXUUd4VmuQRGD@linaro.org>
 <CAMRc=MfBNB0pvv1kPPcswE4Y2m7PXBO49bwJg=v0+aY=JmJKWw@mail.gmail.com>
 <amC7_M-HjVZ3sQuT@linaro.org> <CAMRc=MdnSyPmbK0skMx686=wSe52nnuWgCNJ0uSoKs_=HyAq-Q@mail.gmail.com>
 <amDRxPkdvbA-iVer@linaro.org>
Date: Wed, 22 Jul 2026 08:37:19 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me523xQbfJvML9taJ-fR128SJurJS4eX9N9E9WtHF5W5Q@mail.gmail.com>
X-Gm-Features: AUfX_mxQ1adakAy8nL_SM-KsxZbJKd9YkddzHJ2sI4McTRRY2kICnwBZ3NzCrbU
Message-ID: <CAMRc=Me523xQbfJvML9taJ-fR128SJurJS4eX9N9E9WtHF5W5Q@mail.gmail.com>
Subject: Re: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	sashiko-reviews@lists.linux.dev, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 16:20:52 +0200, Stephan Gerhold
<stephan.gerhold@linaro.org> said:
> On Wed, Jul 22, 2026 at 07:11:10AM -0700, Bartosz Golaszewski wrote:
>> On Wed, 22 Jul 2026 14:47:56 +0200, Stephan Gerhold
>> <stephan.gerhold@linaro.org> said:
>> > On Wed, Jul 22, 2026 at 02:34:52AM -0700, Bartosz Golaszewski wrote:
>> >> On Wed, 22 Jul 2026 10:59:09 +0200, Stephan Gerhold
>> >> <stephan.gerhold@linaro.org> said:
>> >> > On Tue, Jul 21, 2026 at 01:48:52PM +0000, sashiko-bot@kernel.org wrote:
>> >> >> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>> >> >> - [High] State leak causing hardware misconfiguration on channel reuse due to uncleared `lock_scratchpad_addr` and hardcoded direction.
>> >> >> - [High] Channel state corruption when `bam_slave_config` fails validation.
>> >> >> - [High] Infinite BH workqueue loop and unratelimited log flood on memory allocation failure.
>> >> >> - [High] DMA API violation: `lock_ce` buffer shares a cacheline with frequently CPU-modified struct members.
>> >> >> - [Low] Unused assignment of `hdesc` in IRQ handler.
>> >> >> --
>> >> >>
>> >> >> --- Patch [6]: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking ---
>> >> >> commit 8b44c5e4935cbb61832adb3262df00b3b606a283
>> >> >> Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>> >> >>
>> >> >> dmaengine: qcom: bam_dma: add support for BAM locking
>> >> >>
>> >> >> This commit adds support for BAM pipe locking by prepending and appending
>> >> >> dummy command descriptors with LOCK/UNLOCK bits when starting DMA on a TX
>> >> >> channel. It uses a peripheral-local scratchpad address communicated via slave
>> >> >> config for the dummy writes.
>> >> >>
>> >> >> > diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
>> >> >> > index f3e713a5259c2..411c60c4433e2 100644
>> >> >> > --- a/drivers/dma/qcom/bam_dma.c
>> >> >> > +++ b/drivers/dma/qcom/bam_dma.c
>> >> [...]
>> >> >> [ ... ]
>> >> >> > @@ -1064,6 +1197,7 @@ static void bam_start_dma(struct bam_chan *bchan)
>> >> >> >
>> >> >> >  	lockdep_assert_held(&bchan->vc.lock);
>> >> >> >
>> >> >> > +	vd = vchan_next_desc(&bchan->vc);
>> >> >> >  	if (!vd)
>> >> >> >  		return;
>> >> >> >
>> >> >> > @@ -1072,6 +1206,24 @@ static void bam_start_dma(struct bam_chan *bchan)
>> >> >> >  		return;
>> >> >> >
>> >> >> >  	while (vd && !IS_BUSY(bchan)) {
>> >> >> > +		/*
>> >> >> > +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
>> >> >> > +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
>> >> >> > +		 * already have bam_locked set and must not trigger a second pair.
>> >> >> > +		 */
>> >> >> > +		if (!bchan->bam_locked) {
>> >> >> > +			ret = bam_setup_pipe_lock(bchan);
>> >> >> > +			if (ret) {
>> >> >> > +				dev_err_ratelimited(bdev->dev,
>> >> >> > +					"failed to setup the pipe lock, deferring transfer: %d\n",
>> >> >> > +					ret);
>> >> >> > +				queue_work(system_bh_highpri_wq, &bdev->work);
>> >> >> > +				break;
>> >> >> > +			}
>> >> >>
>> >> >> [Severity: High]
>> >> >> Does requeuing to a high-priority BH workqueue upon ENOMEM cause CPU
>> >> >> starvation? Because system_bh_highpri_wq executes in softirq context,
>> >> >> requeuing immediately without sleeping prevents the memory reclaim needed
>> >> >> to resolve the GFP_NOWAIT failure, leading to an infinite spin loop.
>> >> >>
>> >> >
>> >> > It looks like my suggestion to queue_work() again in the error path of
>> >> > bam_start_dma() wasn't great if we end up causing an infinite spin loop.
>> >> > We do need to retry somehow or report an error though, I don't think
>> >> > aborting and leaving the desccriptors completely unhandled is an option
>> >> > either... :(
>> >> >
>> >> > One option would be to try to avoid the allocation and write the lock
>> >> > descriptors directly into the FIFO, but this will probably get really
>> >> > messy as well, since you would need to carefully modify the FIFO
>> >> > management in several functions ...
>> >> >
>> >> > I don't have a good spontaenous idea how to solve this right now. :/
>> >> >
>> >>
>> >> Pre-allocate the lock descriptors (if needed) in bam_prep_slave_sg()? As in:
>> >> call bam_make_lock_desc() in bam_prep_slave_sg(), store the descriptors and
>> >> make bam_setup_pipe_lock() return void as it will no longer be possible for it
>> >> to fail? It would just grab the preallocated descriptors.
>> >>
>> >
>> > I considered suggesting this, but how do you know which descriptor needs
>> > it in bam_prep_slave_sg()? It's just the allocation, afaict it doesn't
>> > tell you anything about the order in which they will be submitted. :/
>> >
>> > We could always allocate the extra lock descriptors and waste the extra
>> > memory for the descriptors that won't need it. That should work, but is
>> > also not great ...
>> >
>>
>> Oh, I was thinking about having pointers to lock/unlock descriptors in struct
>> bam_chan and to just grab them in bam_setup_pipe_lock() when needed and then
>> next time we enter bam_slave_prep_sg(), we see we consumed them so let's
>> re-allocate them. And of course: don't do it at all if pipe locking is not
>> supported.
>>
>
> Sadly, I think(?) from the API perspective it is valid to
> dmaengine_prep_slave_*() a couple of buffers and them issue them
> separately, e.g.:
>
> 	desc1= dmaengine_prep_slave_*();
> 	desc2 = dmaengine_prep_slave_*();
>
> 	dmaengine_submit(desc1);
> 	dma_async_issue_pending(chan);
>
> 	// do a bunch of other random stuff
> 	// bam_setup_pipe_lock() consumes lock descriptors
>
> 	dmaengine_submit(desc2);
> 	dma_async_issue_pending(chan);
>
> In this situation, we wouldn't have any lock descriptors allocated
> anymore?
>
> Thanks,
> Stephan
>

I'm not really sure this is correct. From:

    https://www.kernel.org/doc/html/latest/driver-api/dmaengine/client.html

"Some DMA engine drivers may hold a spinlock between a successful preparation
and submission so it is important that these two operations are closely
paired."

What you presented above looks like abuse of the DMA engine API in light of
this statement. I also haven't found any place in the kernel where this would
happen.

What the docs say is legal is preparing/submitting a new transaction from
a completion callback but in this case the lock/unlock descriptors will be
refilled by the call to prep_slave_sg().

I would go with pre-allocated descriptors references from bam_chan,
re-allocated (if needed) on each prep_slave_sg() and just WARN() or even BUG()
if we ever end up not having any descriptors ready.

Bart
