Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7561FF1C4
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 07:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762759648; cv=none; b=bi+GeSLqVQhuJmZsnKmhluqjJOJSUAYQGLfiBcnLd0sbGDnZmURLXZUMqZ6jpGyEupOkvRvXX9d4LBkorno6abwkHzZTq673Y2L9PDFDMauBHUCdlUgQ/H8+zCyxmmcigO2dC76iPFcWw6XQmdPImQRqSTUNAfpPY5VvHn14DJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762759648; c=relaxed/simple;
	bh=zFmRxrbyWI+Xkw+KlL1s3bZGp1Og2TOouxgOW1jpar0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5bTMeS/rQV+ILw1d1RQBApcYtn4gBz8HMv2cpdldT0v/CC+MELAoeqKozlzoMp/MAk9dgdeNb+xaqrFguvCLD9s/1flyr8CAwNJhvCMOBnE8lxrdhQ5drXEiv4p4nq326depazWHucClk1FpQM9FCuJ1w8a9Y793K214UVURiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PPW6ZLMG; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PPW6ZLMG"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-378d54f657fso20977041fa.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Nov 2025 23:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762759645; x=1763364445; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zFmRxrbyWI+Xkw+KlL1s3bZGp1Og2TOouxgOW1jpar0=;
        b=PPW6ZLMGKdQwg7X65igynJLyOb/DV9MWO7k+ZjKp259k+JJ0DNLn1h1NSJl3F1EjBe
         +Y5+eiaKphSv6tccBCP7iUU86JIvwIOywDVUXQNd07qUFNoPlh7vXtZgXENbmtfwy58/
         LnOVqNa7XXhUnitnDGpDpq2sK0MPTsaHGYnx8iACBSOTGGvZ96S1861KNF2PB4WeAkKq
         Ecj6aDdDalVHXuNOinCqYSQ8J9uIKIgIZrvcukXisLNKTvqqeuUNUMqg/tjFRUhiAw5E
         kNDYot8KYa9E1oHX5vIhI+mIjJq1/dMTHKa7rqIsd17eqN11V+7WWkGG46Tu6Yvgpy/+
         HXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762759645; x=1763364445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFmRxrbyWI+Xkw+KlL1s3bZGp1Og2TOouxgOW1jpar0=;
        b=uu/ycPAa/XYKeYe++7f2013OpQdG/NALqMXoboTMXuDynouwU6+czZUkKMPSfcEvWe
         91vEjAft4fqCHkSD+TzpYHr4hj9TwU1w59rwCUflGmpcolNo2BUcR1eXxXKFl8mKdLc+
         ILg0q1bV9jdQTe8rKuBbt7CLazg/h5XW/K6UV+8J7TrfXVtgaH81JZmjkHKsXAVQNmsT
         0R3rxiOJwAFsHnNG7e+miQYii1DEvJ8MQHL6mC+iFYuGa2YGLL6jgCcS/u6f3Nq10oL5
         xnZxBc/FzCqJ3UygA3OVZB5io4RcQjEoUd8ZnUgNTWJiNTE0a4DReaNowXIHof3G2MVO
         7xVw==
X-Forwarded-Encrypted: i=1; AJvYcCUwyK7G1RG0cMv+gZWyr8utr0FMD3oD4Ar3ziBchhv/ql9JHhuJVrSCHWPW0EKcRWvHK/Nub2zYqf6WtO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyNJlS7aFFa3yfHF1YjmSDAkFTWj10cFZ6fCVI4bCmuCIH5EAB
	QKSUKyoS6gw9hC9XKiKPn5DpCxTrcrRVeWUtVDzeKFgQS2llWJGjA1s8DHcOnJMQCamMqTOCRbr
	PFkT1vrIpKcBX20nRcTOMH/FD8xcWAjBIVd2Jwo8LmA==
X-Gm-Gg: ASbGnctWVhLR/AOddskBDFaG8w46B4Q3r4GqkB4jh1RGXs6w7v4xX4OZfGObzNdf59s
	Xrl7ljS9Fa36AcnfBYDpAmEGeNqfYURHwsQxi+mmz8Tu7gwGWi1ZJwDiuWT9ccLtdKYoyT+PJiG
	ubbNbsH5QFBfTq2YQONJQnif1xp2oQoqAP7s1c4N6AOezyS7Z6zwmbgG0+CctRhkrLr0j4r7uqW
	eQ3CXm3CQsjteMvT9IYqckDDVQE9VcxghWWrhY7+Lh415EMirtwFRWfin0/9+yLDJLAVtZ9Lt2i
	7vCmtQ==
X-Google-Smtp-Source: AGHT+IGlioU1T2hP3Cx0sc7+Mr7UkNaal7O9PAL61dndO0rtpsV90YULtsgVShH5vUrfvjL9XfatE7BTdO4oqCTJ9rw=
X-Received: by 2002:a05:6512:158b:b0:594:2d3a:ac3a with SMTP id
 2adb3069b0e04-5945f1cbad0mr2332507e87.50.1762759644829; Sun, 09 Nov 2025
 23:27:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022021149.1771168-1-huangchenghai2@huawei.com> <20251022021149.1771168-4-huangchenghai2@huawei.com>
In-Reply-To: <20251022021149.1771168-4-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 10 Nov 2025 15:27:13 +0800
X-Gm-Features: AWmQ_bk8AETv2C5IZ93gSpurFxtBryq9dpTt1s-OPrxlqyqvEB6Pt4mlGsBJqt4
Message-ID: <CABQgh9ErFGWke8M8oF8eUcgXDfObY613Sb_KeC1R2h_NqXi2hQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Oct 2025 at 10:11, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> From: Yang Shen <shenyang39@huawei.com>
>
> The current uacce_vm_ops does not support the mremap operation of
> vm_operations_struct. Implement .mremap to return -EPERM to remind
> users.
>
> The reason we need to explicitly disable mremap is that when the
> driver does not implement .mremap, it uses the default mremap
> method. This could lead to a risk scenario:
>
> An application might first mmap address p1, then mremap to p2,
> followed by munmap(p1), and finally munmap(p2). Since the default
> mremap copies the original vma's vm_private_data (i.e., q) to the
> new vma, both munmap operations would trigger vma_close, causing
> q->qfr to be freed twice(qfr will be set to null here, so repeated
> release is ok).
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
