Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00EF227B9F
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 07:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762759587; cv=none; b=uYIUfw7i1ig5+auqIO/T6kKAQCBlE5A/4vZcDw6aSp0o5VQUv6N/fuPwBxCVl+u87G7O7O7DR7FuJIeR8dOoXk3bUw7a85nfQNuT0SdrIeEZ6DbRcdL1Yxw2h0TEEiCwvvF6524LTGa1wDnWxKtBelPmwdce8xPZj6oqbMEBP8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762759587; c=relaxed/simple;
	bh=3ilupd5XApR7rZGdr8QHBx2c+QOFvuJ/hW2wtQYbeQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+cuFxH0VbgqZMgShXFzL7yqNNWvh4BRAgpm5LAseyiZNigywJQfeWHTeSpNMbsYCXfAwaVinKBPfvZk0NDLZLcpPNqpvQbBrYz71euDV7qGoN4e6dO73jvODKf6db1/TqJSyl5K1qoM3YyNVjL77tDKXvC/eGuqGrbCV435hX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CWgMCLM/; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CWgMCLM/"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-586883eb9fbso2630669e87.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Nov 2025 23:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762759584; x=1763364384; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3ilupd5XApR7rZGdr8QHBx2c+QOFvuJ/hW2wtQYbeQU=;
        b=CWgMCLM/BDNW+l1eF+WMRRBHZCmXCNfmGeNSvm2dCPnA7IfBRAB6KgN5nXLxnR2PyZ
         WjhCLgxlZ6H0ZcHrHM2qSju5B91CQwnJgAF6QwqY6uy4SnT+ez/oddLvV4C70bxdKMNN
         xBqMg2eLCfZRkZkeYF9q6O/zHwujd+KQmgFeaB0ihcz87oJB3Skh6hvQxdQJo6Vn2A+v
         XfhcCnajVP6l8Y3UaDDQY5GbsJq1IEGYCT/B672IGzz9G9VnF+WpAzwHCqqxypaEqsdp
         JK82ohuw1Xf54aBavg1WIXTLVAk3Rq6Im6OuDhQejOD8PI44lrG2dkGpwXf0MoGulJXC
         SeFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762759584; x=1763364384;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ilupd5XApR7rZGdr8QHBx2c+QOFvuJ/hW2wtQYbeQU=;
        b=xMdk1ZdkXzsNjE6RGzdIautqVnokfPYtat42guZ7TXKbi+DUGP7RY+k3606enwsAgp
         8zXLdbAaYGdgVsTWXKd77OAtXj5dZCyjgpiv/VIO50PSaub12caqdjWltleA6AX1xEc2
         +1csvE4soo9MeeaB1gh781Pt4JJVTHZcVdZIa3NFOz6AYkBhB5UHenGwJg7DArSU6FT7
         2xAu7luuVwYj0ZftcMvoocLqCktzkRWHGL/cHFmpJ03uLhDGw0K3Xqyp1SGs1qS1Pd0h
         B8jxItGuf0Fi3VQF8a9OZoOdkDN+xaHDk6i0ZkLw1VjA7x8/q97ZWA5DEr5F1479UJz6
         FivQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBr5pLSqN4DBLNJ78BG4oggdLKMrMkb7QHKO/PnCxBQS+ji7dlpUaZlm+lBCxgmylGfPy8AJS/BCkHFks=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqcFmNUTFXf1xfGc1oE5Qmf00BEstBUGXuY6XTqxT3MqMjsiZt
	qeA1iyfasO6Zcg+V73M1qd5l4zrn+g2xFZfqvwTAsmvJ7mPrPf63d7PaGfIipbBL7DQFZKLdmWm
	CM01YRZJXt8GQ7D50eViDG5QP3fQFfryPy6YCgP095g==
X-Gm-Gg: ASbGncuwRIGxRJGfn8YrPKXOgUYFN21glLYJxJm38v2FMEuxVDQH4qGtkE/6SMWi/eo
	9uDdkR5o8xZRsupZ5S3TDjZdyV+DGSjfT/MKRHnRvxc+yZzuiIkYJg9IZgGJqVAZry0/POOyxHW
	zjKCrSTha8KpvAuy4I6GjAN4bKBwhF5iIi7cfQQecMsuBSW4fSYdHapTyFi0rCjt4Z/LnP2lGLi
	QpHGHjdWjNuRM/aZADF03sIZGDPERaXmgPw+FGanTrmPeJvdSINGNYq04Xd4B/+yswcoIG3PyM0
	xNRW9Q==
X-Google-Smtp-Source: AGHT+IFCe5dyObTA+KQ90GAxHqE1GkHQMbHN6SYfQnEa97Ekw0SysejTWzzktjK+754MJfcKm9edgZcyej4S3hFmD60=
X-Received: by 2002:a05:6512:3b12:b0:592:fe0f:d9e with SMTP id
 2adb3069b0e04-5945f1598e8mr2160449e87.7.1762759583562; Sun, 09 Nov 2025
 23:26:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022021149.1771168-1-huangchenghai2@huawei.com> <20251022021149.1771168-5-huangchenghai2@huawei.com>
In-Reply-To: <20251022021149.1771168-5-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 10 Nov 2025 15:26:11 +0800
X-Gm-Features: AWmQ_bkvi5aDs5CyGvLRxbcNXY8_0T-HIbk7OOyl6-s-DtjUufmygm8cvjByxuQ
Message-ID: <CABQgh9GDMohphD82y_uf0EfVMz1f3hHTnZ-fot9W0oFdq4oJPA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] uacce: ensure safe queue release with state management
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Oct 2025 at 10:12, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> Directly calling `put_queue` carries risks since it cannot
> guarantee that resources of `uacce_queue` have been fully released
> beforehand. So adding a `stop_queue` operation for the
> UACCE_CMD_PUT_Q command and leaving the `put_queue` operation to
> the final resource release ensures safety.
>
> Queue states are defined as follows:
> - UACCE_Q_ZOMBIE: Initial state
> - UACCE_Q_INIT: After opening `uacce`
> - UACCE_Q_STARTED: After `start` is issued via `ioctl`
>
> When executing `poweroff -f` in virt while accelerator are still
> working, `uacce_fops_release` and `uacce_remove` may execute
> concurrently. This can cause `uacce_put_queue` within
> `uacce_fops_release` to access a NULL `ops` pointer. Therefore, add
> state checks to prevent accessing freed pointers.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
