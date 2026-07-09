Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9294218AA
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783600333; cv=none; b=hqJhrVA6+YBnYOQ4m4H9FLUW7HUqRRq2buz9/4gTRa/Ssx5T+x97bo7Z4nHnYLSi69UztwkrifxkRCMqs50cZTyI5L/xHsMRKPz3rhZahI8BWJK92kTJ0eM2k+Pj2/falIPx50R83QGnFCmI3u6OrtjxYz6B8sXtVKu2mhdinlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783600333; c=relaxed/simple;
	bh=oD7sVcKI0EP5wbCBcbErCM6cSOoSEbzddvyLGpoAsBI=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sv8zlUVWmZrg6rI5oeDAP4JyZgBr1AphdHDRuGsL4U4xMOm60wWm2Zuu2pUjPYEjLi2voQpOuo1FTh3ckDAG8HZo0H+Q/E3NplQCTe3bKmFrqWVnvca20C4S+YxgIPRzXyj2mQ6Zokr8ULZDiCv2yk0jV0WVWFpKxzD34GySFvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SO0DVmru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SO0DVmru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9299F1F01559
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783600331;
	bh=4aR9R9rWW9lEHBtHD1X7oe8tDfOcExVaxQWxI0iwWpw=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=SO0DVmruKzGhRCEDUhvR08+VaUPO+EXfcFiEUq4/kCU65mP7IoJMaFZlkS29qL85z
	 jJqVr+be51s9PC+n6LxjenfQicQBWU32x3EIrjs7o/hMtZB2cOSXQFXBPVWyZA37s+
	 oKn8SU8hXX0zXwTCgFwdn7WykFJ0ofTRsbWH7aBSz65+B1qiEIpHw5b8/h2JIoeVpm
	 EORHEOYRb6ulLk49aBGhA5mNE6BpjbffZ6cO/hT199i4VW+7qhIazzFa1Qeeg5rVGs
	 0Tlrpw2m9NyIusahdzqvKHIIMwUyY5lxR3fLthjVU6h87fT5qGJS4DpYLy8E+bmBQg
	 4R7ZRsOUP/47Q==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39c8dbf4ef0so4607691fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 05:32:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpzUo4VJrf2jfF4I0ipXUqzEQ8b0Dsn4gnkv8+5cZVosJDdYvFK3h81Xlg8gF+CHGVjFL8lo8w87ClEnb8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfPTuA8ccELfRyHXMAhM+H9OWAmy2Zlg4cdFOPmy29xTNucAae
	0n8mBgpVO8Ao0DF2T+dRpmys8NUZ1NiuN373MOOGvsBPsm7UZE3JaMD/fwuGaDBhMUXI1GWb9c2
	d/FKMaWjQ/qrLe2++BTOHjVTF2xQh234ihCsdL5qfbg==
X-Received: by 2002:a05:651c:a09:b0:39a:d7f7:9823 with SMTP id
 38308e7fff4ca-39c798813b4mr15252851fa.17.1783600329964; Thu, 09 Jul 2026
 05:32:09 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 05:32:08 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 05:32:08 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <ak4_vsdef9MJd1Yv@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
 <20260629-qcom-qce-cmd-descr-v20-6-56f67da84c05@oss.qualcomm.com> <ak4_vsdef9MJd1Yv@linaro.org>
Date: Thu, 9 Jul 2026 05:32:08 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me93OOyk5gzqD2kSEbR=SNXbOC7azsqc14BLVirnkEmjg@mail.gmail.com>
X-Gm-Features: AVVi8Cee9x38eRLPwnHC8PzzhrHOdP202SPN2_gv8BvqViABwY4y57pWiMje_Lg
Message-ID: <CAMRc=Me93OOyk5gzqD2kSEbR=SNXbOC7azsqc14BLVirnkEmjg@mail.gmail.com>
Subject: Re: [PATCH v20 06/14] dmaengine: qcom: bam_dma: add support for BAM locking
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Udit Tiwari <quic_utiwari@quicinc.com>, Md Sadre Alam <mdalam@qti.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Peter Ujfalusi <peter.ujfalusi@gmail.com>, 
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>, 
	Andy Gross <agross@codeaurora.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 14:17:51 +0200, Stephan Gerhold
<stephan.gerhold@linaro.org> said:
> On Mon, Jun 29, 2026 at 12:01:08PM +0200, Bartosz Golaszewski wrote:
>>
>> @@ -1064,9 +1220,23 @@ static void bam_start_dma(struct bam_chan *bchan)
>>
>>  	lockdep_assert_held(&bchan->vc.lock);
>>
>> +	vd = vchan_next_desc(&bchan->vc);
>>  	if (!vd)
>>  		return;
>>
>> +	/*
>> +	 * Wrap the issued work with a LOCK/UNLOCK pair exactly once, at the
>> +	 * start of a fresh sequence and only when there is real work to lock
>> +	 * around. On a re-entry after a full FIFO, we see the BAM is locked
>> +	 * and must not add another pair we simply continue loading the
>> +	 * remainder of the same locked sequence.
>> +	 */
>> +	if (!bchan->bam_locked) {
>> +		ret = bam_setup_pipe_lock(bchan);
>> +		if (ret == 0 && bchan->bam_locked)
>> +			vd = vchan_next_desc(&bchan->vc);
>> +	}
>
> I *suspect* though that Sashiko is right about the new race condition
> here if new descriptors are queued while the hardware is busy processing
> a locked sequence.
>
> https://sashiko.dev/#/patchset/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05%40oss.qualcomm.com?part=6
>
> Any idea how to fix this?
>

We could move the bam_clocked clearing from the IRQ handler into
bam_start_dma(), right after the UNLOCK descriptor is committed to the FIFO.
Basically track the state at queue-time, not at interrupt time. Once we commit
the UNLOCK, the locked range of descriptors is "sealed". If there's more work,
we'd call bam_setup_pipe_lock() again with a new "sealed" range surrounded
by LOCK/UNLOCK.

Bart
