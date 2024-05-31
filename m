Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573881CD3C
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717134579; cv=none; b=tHjJDhS6X4Wlrvw6LaQiQgohIZRTlIkloUI52nJI1gJXDGCl3zSDM8t1evd2dzNPqdO4ZqaXaCcMV/qBo+7pOsvq4uX2DzTcY40Y8qx6fxWHG+UzIj1PtIjMd6jRQeUrWw3VoDiHG1g5Yqm+CCTiBo8hkLhMqHpa01WbyxixcQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717134579; c=relaxed/simple;
	bh=+gBH+D1MIDGJDhYFaogIooZi8YV4sRdFceObE1mWfcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBg96s/nLtOn+f4cJ654TQjy2CHWI+9XKBYq3yaCuZ+LImkWigo7xRl5l+FYOSN9R8qqet2VDtRuHRj4mgWrDEXWgqLVk16u1DNFrZwiRRbRHL5NPL1/hZT5W9EzW97THWYHXcFIush7YD3jJc4gbdu7cLgxXjrGU33m8FlnRGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XONTkhan; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XONTkhan"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6f8ea563a46so984278a34.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2024 22:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717134577; x=1717739377; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EeubvNzaKYxjtfEwe3dCbYa/rAmM9t1eN/m3KxJV35o=;
        b=XONTkhanB+3P5w8J4a4iRqHzV7vBtBpomac26bNuRDmgcsbfl9FoOH5W9VTfDVNCZ0
         Iv5gtvyNsYTwj1UyaCUzcd+pPUWauZLsbUVgtYt6gIQOhI4y2Kwnn1gX8CeXPYs8Ufqw
         Vv3jaJv/Uq2ze71fr9csA41hVPMxgLyGw06iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717134577; x=1717739377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeubvNzaKYxjtfEwe3dCbYa/rAmM9t1eN/m3KxJV35o=;
        b=SsWIH2T79bmv8DSM1N83kIMTcWu0K82u0t6GYdwTofHyuah45ZrpMyR8qy7lVMUG4k
         60wvwqcu099/1R7N5Ixq8oMcMrDLfRXQuMONgD6altaSWxGqldDwooey1zr/Qccbwm++
         XuPQWHqAwDtLwPn8c4Fqw6nvrqnJ3J6uY2awJT2eRGUOTc4oX8B8qrkXguWdWJXd7Rxk
         RD9ttS6UPJ/V84tOcLU0ZV8+fTw86sD3JUcK/DVME1PhgAk13mYNHcs/3JUyk3QMzJfy
         XMBmou+ehwrbd7M/wcB7hhAiE7cKe1LK7ArPuKqgMApWOlFQxfrcRixSRIVSIJ5qo9TI
         1Zlg==
X-Gm-Message-State: AOJu0YydHy/I43FYggDcOeSmgdoenpAKZvajTGsbrK2zoPvAh9uNIQOZ
	A1x+H/TGkUQLz3avtzDkeh+gxQEskL0krwlq8g/N5zp9IsWubVW0HevQlPO9qJOyLrax1GuCk18
	=
X-Google-Smtp-Source: AGHT+IFiBQzDD4l6Lcxl7yknalcYqSL9azoyNiP4jO80tgeFLw9/K5ZYAVZdvuItYwmu212W3RapRQ==
X-Received: by 2002:a05:6870:a54d:b0:24f:d272:22e0 with SMTP id 586e51a60fabf-2508bd5fce4mr998503fac.59.1717134577279;
        Thu, 30 May 2024 22:49:37 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242c270c7sm654262b3a.220.2024.05.30.22.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 22:49:36 -0700 (PDT)
Date: Fri, 31 May 2024 14:49:33 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 3/3] crypto: acomp - Add comp_params helpers
Message-ID: <20240531054933.GF8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <7b5e647f760c4deacf81d3b782f1beee54de3bbc.1716202860.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b5e647f760c4deacf81d3b782f1beee54de3bbc.1716202860.git.herbert@gondor.apana.org.au>

On (24/05/20 19:04), Herbert Xu wrote:
[..]
> +
> +	params->dict = kvmemdup(dict, len, GFP_KERNEL);
> +	if (!params->dict)
> +		return -ENOMEM;
> +	params->dict_sz = len;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(crypto_comp_getparams);
> +
> +void crypto_comp_putparams(struct crypto_comp_params *params)
> +{
> +	kfree(params->dict);

kvfree()?

> +	params->dict = NULL;
> +	params->dict_sz = 0;
> +}
> +EXPORT_SYMBOL_GPL(crypto_comp_putparams);
