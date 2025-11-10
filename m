Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A5823D7C8
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 07:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762759669; cv=none; b=n+Jcr6QxfuuAuUpFUoara7fL8D9dbuE/MeyedNbpiuLJRBoBx5KzE8+lkienkpaFGU9uEI3ep+9x2AlVJPBEoKbfEdF/yfyk0z9dOj+SAc2OT27O89CbJ4/7Y63JBzFfaMKOoWDWb9sXkgXpuIYNHLvU8M5lNk+SZeeyN4mubcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762759669; c=relaxed/simple;
	bh=BPGUWrjgAY/FIkzGZIG2ScY4MT2TLxOz/fQ/kPQXDGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDmhnPD8CBQj49/sEXCnd4jkgaij2+VN7P6tvue5rYn2GFTAnouJe3T+0oEUOHKBJkzefePGpcJthlQKJ7CicSgGwPVM0+JiMB+FCCBmJnjxq4sP6cMRYGMvOAG/ue+rMDftnJN6WHWEW1efSNODsgjhw7kzMseVThut2x7wJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DpY0Ea+W; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DpY0Ea+W"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-37a5d03b53dso26571671fa.3
        for <linux-crypto@vger.kernel.org>; Sun, 09 Nov 2025 23:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762759665; x=1763364465; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPGUWrjgAY/FIkzGZIG2ScY4MT2TLxOz/fQ/kPQXDGI=;
        b=DpY0Ea+WknelsEsJTjGU+Deyl279mDdk9bsQf52d5Q9v2elpN22bM3p6V+3KbWGJec
         7doU7AsAjWt+ZWbbm8bPkf7pTbhXtrgb6j5sA3nijuagpHKw19PNOdf290AEb9CcWBGF
         qjAsQJHlDj2swJFrXcahuFq9kIcytKZ+sSn0eo23vOYjr6Z5MCOmLorK5iYrhG+pOMs/
         aD+3lyhH3PKnSK9uEbhlwDGoChE5cWZwbj90Q3UgjjbtDHvCLJ3/Ts8gM2xhltLHEs/D
         PiqR3pCXDaA4ij2Rug7M3ndbhytqbQVX/eaa7vyB09Us3gUC21NPce2URN2ApBKnOSiE
         89fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762759665; x=1763364465;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPGUWrjgAY/FIkzGZIG2ScY4MT2TLxOz/fQ/kPQXDGI=;
        b=ARjdAZUiG1sDpWEvHR+PK3HvjxEMAINpoGYKdXdVmcXDNG1GYprj1BtB0nee2pMApf
         SM+UG4b5/RChafO+SsLGKYyZKcdu6DsMXGTryvSdngTVGGrqRAOp9RrwwjkaPf3Mc3PT
         BuyiDdWmXj7z1kn9FKntGLb+8SdmPoN7d8ctGbfUkoDAoKZVQtKlO023Dsc+GWXU3QFD
         Hfavv38rkReIqhQXv5cNaWucy2MdU7vEfvYkKeW4ph2qQCJPy7FfDceE9h/juIbfpfq3
         8aGDNrU22rJ5cYmIVUi2Gvyt203YaIQc53T9cYusSUdhlWm724z3+nuLDtiUplkxFy8C
         NVUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLiMmwQ+amZcKaaBPiSBjL9+9U155Tq7buXD0yBWB8qsEtYhfuBYNUSdV+FwuYPMQ/G0jVZXjtyJQupfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM4qTio7JrRxn0nWgTKvh73/4IHUiKtdfXI9PV8qQhHgSA62NC
	QTYCuNQ/xoENqeQF8X9wqhmXMsc0s4FumOUWvACUwmYSVSu6LSo100BwyL7dQ9UbUir/o8zCpDV
	9OBMyb+AgUwDOwP2eqNyQEXQsthEx8ARSv99oRSFiBw==
X-Gm-Gg: ASbGncvtvvmQ7UjP0nSzO9XuqA5rsbHhTJVnZcQHEVkJrqibE0tAzH0yudJJot/8MLk
	Zlj2kOQsVyuQgM5P5x8eYg9Mipxm6CprZD5N2cxyq/pk2KWVIQUka+XG0WZkypviIYrwOqq65q0
	d5OOb2sA1afvhLqM8fYOpGHTx7i1tDgNIDjxs6mqTnieWYeAkOhyU0elExzvP3MH4IfT2a7+0PG
	oOq6AWKEn2ma4JZ2kSlACN3nvTRQP2d8B3OjteENI78iNZc7eQml+ThrHheMIWQIEEhM6s=
X-Google-Smtp-Source: AGHT+IGAgYRHu9qSnW5LSbcNhvv0xfqts/uNRtJg7TapuKfHRukkaL6drJ2+liyQxhPLIOlpQDIO3GNtB5opgS/fuxE=
X-Received: by 2002:a05:6512:2345:b0:594:2df2:84b6 with SMTP id
 2adb3069b0e04-5945f1671ebmr1852916e87.18.1762759665539; Sun, 09 Nov 2025
 23:27:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022021149.1771168-1-huangchenghai2@huawei.com> <20251022021149.1771168-3-huangchenghai2@huawei.com>
In-Reply-To: <20251022021149.1771168-3-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 10 Nov 2025 15:27:34 +0800
X-Gm-Features: AWmQ_bktQciM64p6Jqcdun8oVFww5db_re0mag7ttU9X3A6qMWh7pofHt-DAGg0
Message-ID: <CABQgh9FZRo=3DyuL29msbtc-=YpPVfuRzBLMWJk4s4UJgcJ-9w@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] uacce: fix isolate sysfs check condition
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Oct 2025 at 10:11, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> uacce supports the device isolation feature. If the driver
> implements the isolate_err_threshold_read and
> isolate_err_threshold_write callback functions, uacce will create
> sysfs files now. Users can read and configure the isolation policy
> through sysfs. Currently, sysfs files are created as long as either
> isolate_err_threshold_read or isolate_err_threshold_write callback
> functions are present.
>
> However, accessing a non-existent callback function may cause the
> system to crash. Therefore, add checks before calling the
> corresponding ops.
>
> Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
