Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151552798EF
	for <linux-crypto@vger.kernel.org>; Thu, 28 Aug 2025 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756360804; cv=none; b=HVmwxDmDze5GdOAcmNXJfdQzGl5dhm1jCkxlkumqkeUbvmn4QMjb7OIAFF+2kRxhuOdqr9pUuUK2Hrvlng62rFaHpiNyc5+zNpJAHAHFirY/6lGdepatrFDEaZoIRWY/MHHuhcdbP6bM4dctKhceaUFCQRnG3YZIlOqfmGNXOFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756360804; c=relaxed/simple;
	bh=g46ASAdi8+NS6QmsGWpE2QiRL6zXPUMgNvK/241uVFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZdVVMFBwNEl/SWev2qjVAJa6c3Xfccfpdfq8ubQvbxjK9irAz6yR1FP8ancguHnhIJlUSkfCeHwSc+OLcyA35aLiRW8/C3SqdwRLa8bS8gVzOjGjRn/T4GMvNz85OS1v2P/SEG7/ex5QHfwzt8fYdinYcgstlXkHW1V0SKlQgJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CKT1d/qt; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CKT1d/qt"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3366f66a04eso3905361fa.1
        for <linux-crypto@vger.kernel.org>; Wed, 27 Aug 2025 23:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756360800; x=1756965600; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6obYxdQZbQQkXntMQNrFVlekuN1SbjxG4jhBhsGyaPE=;
        b=CKT1d/qt7wTHu0/z3NZ9plHYeqaQg07SgJA2Hn9R6VGBtNjgAqgP2ohfoB0Nqim+r1
         fVEi/z0t5mgUeEzZtGM8fMpjixKVRSt1wzF+b7KNuQymgWYwJbZzZbcgxwvbRtbklTlY
         N1E2HdKN4PYJE/cfynHJGAjpJ6BgubN5ohWdk/p6Xg/DMI0a51/dLT+tPxQuF6qI8ydy
         xGI9VEL77Azwuu3aeXy0vvmsHSPNZSJ3HnxI3lJRfyed+bEaw6fp0xqKC5IFkS91F87w
         T9zB/9x5HqsGMjGHop6bJyCCd8427jCc0O/WksHAaoNKSffrPlah586cxpQQK5dbcWNJ
         miDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756360800; x=1756965600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6obYxdQZbQQkXntMQNrFVlekuN1SbjxG4jhBhsGyaPE=;
        b=ePCY4WeKgXvUTQtBkoJZXWysihAubbGumAO+prbbLlcUHmFV0nAtyEHCofTrwpku1L
         m4oJELXPhwM5CuJ0UwUNi2zh56O2Ng4mkR9lJnMG5jSFPCamrJcQuO6kPRHq9lHt820o
         tg6Cw7l/0PI3NqC3ZPPZIATS7Kh4lnG/1FnkYATScvxN4hoG7pGl1nWjwH1Sx8Ai/F7C
         qc5fFzv579rgpvJt0H+ZxaN5pkOIyZLE0A0jIsMVC0dwXTz85CfnglDs2elG/OkJeiAk
         sjSc02VZQeQGsB4PDbW5w8pco+I6TDhURLbPItWRK3oHeBTlT96/VaHivU6MzGIzkxQr
         ZpAg==
X-Forwarded-Encrypted: i=1; AJvYcCVb+9x1XrlHoDZo1w9RDHeA5uMq40XcommiBYIurEozk1ORNfbFRX/ilANOqXVStTLM/R8ujOaLcxeadEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9IycLW7vWbm2Ap2t8szkkqcnh6lrv1Stur3rY3y2dwf2UJSkG
	hSKhISNaZk2+Cj/E5UlBVkQI0/5IpnVCNfyaJTCdYehIdkCr54n8KkyUwUxnQkEgkw8ad5vrQWM
	w2gsKbJ0IQKmLeUVnuPa0+N3CAVKLVAOiVs8x4qBgmw==
X-Gm-Gg: ASbGncs7xh9qfZ68/Vh1bAh9yaOeY4iWCIWCZoIpSLMSiHB54B8mbQyOn+UyHFyukt5
	AHkoZEx0gZhDQfZloZoTmJni4jFKZLDMr+4T6t3XEQJ1xk6q5OHjz4AmLASkeBy2rH42IXE4zdW
	iSl5jO5wd2AwcR26zR54PeeXcWgLDCJKIIfEb1y6zXKcQi3e0Se8Ts4giHss3pwrzPDQtLb8oDs
	M4qA6J0UQ1K
X-Google-Smtp-Source: AGHT+IHVaCzDaFtPrE1UmGfLvEWrXQlxwAQ3V8jcgB53C1/poR2mJ8VeHTMDCceb4g8gPnECFJRfk0bEOcyZT6HSczk=
X-Received: by 2002:a05:651c:210c:b0:336:7e4e:3b2e with SMTP id
 38308e7fff4ca-3367e4e5f7cmr24551111fa.6.1756360800032; Wed, 27 Aug 2025
 23:00:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com> <2025082208-coauthor-pagan-e72c@gregkh>
In-Reply-To: <2025082208-coauthor-pagan-e72c@gregkh>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 28 Aug 2025 13:59:48 +0800
X-Gm-Features: Ac12FXy0xmKbJMThB0QCZYzvDHbHlhs84wmRMzZsPbL-Woatwl_DQ59csbRq7Ac
Message-ID: <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linuxarm@huawei.com, 
	linux-crypto@vger.kernel.org, fanghao11@huawei.com, shenyang39@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com, liulongfang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi, Greg

On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
> > From: Yang Shen <shenyang39@huawei.com>
> >
> > The current uacce_vm_ops does not support the mremap operation of
> > vm_operations_struct. Implement .mremap to return -EPERM to remind
> > users
>
> Why is this needed?  If mremap is not set, what is the value returned?

Did some debug locally.

By default, mremap is permitted.

With mremap, the original vma is released,
The vma_close is called and free resources, including q->qfr.

However, vma->vm_private_data (q) is copied to the new vma.
When the new vma is closed, vma_close will get q and q->qft=0.

So disable mremap here looks safer.

>
> And why is -EPERM the correct value to return here?  That's not what the
> man pages say is valid :(

if disable mremap, -1 is returned as MAP_FAILED.
The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
man mremap only lists -EINVAL.

However, here the driver wants to disable mremap, looks -EPERM is more suitable.

What's your suggestion?

Thanks
