Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206242A93
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 08:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742372336; cv=none; b=Ky2imOjVvwsZrm7p2OVL2aFkOSihqyn0Sgy+RE7i5WKT7mBV9zOo5EDX4Tso8yyZzC+xuRqVjUEz93TqmG3ckSrYky1DvwM4f9a7EXzsrEVc1Q+GJO3Z0nIk11r4Yy5YAzJsePd4AGXU/tMwm5URsNavKF2F/WoFyb19p5W63aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742372336; c=relaxed/simple;
	bh=r+9L7soLR2ewVEEZZFrhVECtSwFnDlYUvO5VtJQ77yY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9vwi2bS+1hrENBtJzw9ALuF3oMH6pHkz8xoLXb4+1hSFFZ2h6dKwCPanssWgaIaInWde9WfPST3bKXOWZ05CJb1vRSKEC+q9viSAnGpcSsOxoP+hF/fH2fecBDBeybGQ6mVvnGtvGmnGa+iYVdo7tLfdDIWoKEq5q4htmcvIwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaVwjaFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaVwjaFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14220C4CEEA
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 08:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742372336;
	bh=r+9L7soLR2ewVEEZZFrhVECtSwFnDlYUvO5VtJQ77yY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IaVwjaFYYxHCnWavXRdLphqgeuTYGJH4OADL+g/VL49BpmusQGx1UDJqw8r6ZNiRs
	 E+FJsItAYryE/Htq2q0B0NopksYyXsCXvgV1G8AvkeYhlfWu1K6m0LQbrJix9Z/e3H
	 NdZ13Qci/rQhITxRSLKuGB3Y3GRFUw5b6URn4KNCPa7WEvWqnlLKAbdg9iiaecu357
	 vESJa6yQOxhl1b5MQnEkGD5o2SRGyDCrQ4P1gOfCWUTdJufSYSDTOP2wdPbeFTd0rq
	 vTf37/K3Iqs9x2u0tL7IdAbqTmZzAWlphGz7zpjexqTPx9RhOUSfdsCtVWGSordfTo
	 dZE8cB81jsV4g==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5499bd3084aso6505679e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 01:18:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX4lMNUYXV04J7u7dKdAcYUN/dfYyk6G3RfpBUdd6+igL/t77IpG2toekNFmvsbLdl3j+R6kYeIC+D0nig=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCjAVDtVcYzJqA96ucqlIJNhDvt1JkKNUjP2LP6fm1FOQAAXuh
	DSGoB00E5U+UAuzAND3+WuLiY33Qsy7AixK+trkdPmh15/WWXL+Icl59bsCA2xa6zfBiFPy501V
	VjHHn254BDq54PXe4ar9w/H7ebhE=
X-Google-Smtp-Source: AGHT+IENpQjNsfNnjoAHGSlS5k4/2VhB0ByKgy/mIDSSHqj6MhJC3yJGS31F+iUOI4U3La9NCSkkBQGUZcf/tdp3i+4=
X-Received: by 2002:a05:6512:6cf:b0:549:5b54:2c77 with SMTP id
 2adb3069b0e04-54acb1fc6e4mr685025e87.32.1742372334434; Wed, 19 Mar 2025
 01:18:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9pfpHP783E3W6pz@gondor.apana.org.au>
In-Reply-To: <Z9pfpHP783E3W6pz@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 19 Mar 2025 09:18:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFxbUm1NUd2ogVAqOydPhcbU9GwnOhYnbuM9Tg8GNazwg@mail.gmail.com>
X-Gm-Features: AQ5f1JpYbpW4zhBP3qiO85pM4SgMeAY8Qp7p-WmErkPxyUmF2cvZjlNQbDRyiVA
Message-ID: <CAMj1kXFxbUm1NUd2ogVAqOydPhcbU9GwnOhYnbuM9Tg8GNazwg@mail.gmail.com>
Subject: Re: Cavium and lzs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jan Glauber <jglauber@cavium.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 07:09, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The cavium driver implements lzs which may be used by IPsec.
> However, there is no generic implementation for lzs in the kernel.
>
> This is important because without a generic implementation we cannot
> verify the driver implementation automatically.
>
> Unless someone is willing to step up and implement lzs in the
> Crypto API, I will remove the cavium lzs implementation.
>

Not sure whether there are any other SoCs that incorporate the same
IP, but the ThunderX SoC that it was added for is hopelessly obsolete.

So depending on that, we might either drop just LZS support, or the
whole driver.
