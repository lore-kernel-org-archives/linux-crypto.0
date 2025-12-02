Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789C0302745
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 07:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661768; cv=none; b=ILAgBs0ldbNxSOKSgxcIaJnhaChP1Fz8u7QgexcjcwwvKAj0S7/D38EtmGaS/LECi0KNe6xKK+LYZVlSF7snh/rKiJEWvUJyKD2sF3sFywSnQxfX5xiHIyvSXWMyYkriuAF2uwTQEOOZOnPIQJLB9CwXcFhRGOfEhAv+dQqaC9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661768; c=relaxed/simple;
	bh=3ssL8bEyPWOKoaGOkYPImlAucNDLLemdfe+CMvpPTnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yt/VwG6RYCzdlnH+MiMVfLSXu4DRtQRslkLBCj+sfCsRlcq3uvpwbJPXg4YHxu3uxszn/fdeJiqhpMJUzG+iImeAFrj2kgdbvF9TlnwLwhARPrUdfvXVbRVSpxmzz/+gZ5DAMAoYIFBtESe+Ka3rnYHZ74AMKvlmmQJEq/3DWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G56JQVrJ; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G56JQVrJ"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5945510fd7aso4153536e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Dec 2025 23:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764661764; x=1765266564; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3ssL8bEyPWOKoaGOkYPImlAucNDLLemdfe+CMvpPTnI=;
        b=G56JQVrJVVTC32/dN8DSIoc2MWemv/RgDmFx0diOhyRGhUjjCpqi9AFNWPHMNwcOOV
         ZfCopiOj2vnQiSKFnr30BbsXOxJT7lgIHkU9HPlojc7/WgHy2yJprImOJf23pFvU3+oA
         HB5yj5xjmun8hSlZsEfyv6TRC3fYtaSkgYddqWAygTp+eFvLSRbdFzfD2eM7znnJk2oe
         Sh7VejcydDKLg2P9yTIkhMXjHAcNl+2ftnl+Fgj/5pAmTdnDxK5FJviMcEefpT0cqqYT
         WudfoajXDUS3ctSe+UwBQpYIPGRUcUiNFoODHhoXcMaelT1AJK7MTzLxR0++SJgt5Kxw
         12uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764661764; x=1765266564;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ssL8bEyPWOKoaGOkYPImlAucNDLLemdfe+CMvpPTnI=;
        b=OlqrFlUaR8LROUevTXXzmuRigP2j9w/unP9X5RBb/bG66WwCpaKIt2KNLU7mvfyVbN
         2OiW8h5T3bUFmePyCyJ0rmbCwoT7RajeEcAvQ6yDTyLw16r6YI5hkiawSq8zDrgyQiYs
         TooV+p1+WNfs1Y4LRm3Iz3waZk347KobiIKPJe2UHC4KAc7QEZwnK0zlzxhvg4ZeY7qo
         quDnv3o3yfVy4Ua/i4arjE8/ZeO9ndVs+x6AO6JXSMYcPrjWORxLcysFISw7lVrBVtaM
         IgFbKFEnUH4KbDgCaDCCUU0Qsv4jlvHc235L9N9yFmjyJ0kHpUYcFXfVmQ0TY8KMxdVN
         tWbA==
X-Forwarded-Encrypted: i=1; AJvYcCVly7QgV2tJnUileJQj+rMAlUH3bJyzdhihPDgquQ4fBJ8ozg4L1dMe1FVsOCHze3nXb5idO4gciG7p/Jw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTk4b8tVRQxMoEOwI7kYcw6Ub5f+q7HckPfGdS2r4d3gnAdNic
	L6fbiPcjh92lTI+KS4f/j/0LLX8WYOybPkcn1I2T97iYth2jE7rwfNExPhDAlPtwSnaG+RBLxFh
	7x66Ja/RYgrF3Cb1mOrYIXC06CCTOlibvAiErHY1imA==
X-Gm-Gg: ASbGncsurVjHmiLvlTtCqUEaHzP2i2O/DCeHnWYa9kd3G5Hiqnv6ooTaojeoTLF//ru
	HCAxPb+Apg/vEoDCzgowz5tZ8TSXwHLdSRrzS9chguw/DBS7fkcOJtCk1iCdSqaSQ0uEw+c4EEH
	LuNWZ6/hVaqlGmB8DE1eHcMGZxclgKdpDTsfzgi/DkWVfskg8b11sIDApP8nvengo4htLafj571
	yoWXM3u+N3vchfOa/4Syk70Nqlc2pOHPlZQSmQjHeYmLBFsdgoA8+omfLQufzml39dRTNWgAGT8
	Sk7zhQ==
X-Google-Smtp-Source: AGHT+IE+yz7EtxuU4R0Z+yMEJon0dUDP1V0/7zbAWTSTets6jWiJ5CZoYJMUPsjFu6Ze3uig3kvBnRRWURwgxDkVfiI=
X-Received: by 2002:a05:6512:398c:b0:594:34c4:a33a with SMTP id
 2adb3069b0e04-596b5058d8bmr9800256e87.19.1764661763459; Mon, 01 Dec 2025
 23:49:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202061256.4158641-1-huangchenghai2@huawei.com> <20251202061256.4158641-2-huangchenghai2@huawei.com>
In-Reply-To: <20251202061256.4158641-2-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Tue, 2 Dec 2025 15:49:12 +0800
X-Gm-Features: AWmQ_bk_L0GqaaaLWeuZHXK7ksV37IDdZTRn1b7YZa384X77oIw4aeK2Cv-BGYI
Message-ID: <CABQgh9E3vLSwxFzH8UaQN8icGENhbAjsGO5MHO-dZwHNXrXBkw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] uacce: fix cdev handling in the cleanup path
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Dec 2025 at 14:13, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> From: Wenkai Lin <linwenkai6@hisilicon.com>
>
> When cdev_device_add fails, it internally releases the cdev memory,
> and if cdev_device_del is then executed, it will cause a hang error.
> To fix it, we check the return value of cdev_device_add() and clear
> uacce->cdev to avoid calling cdev_device_del in the uacce_remove.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
