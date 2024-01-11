Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2914EB28;
	Thu, 11 Jan 2024 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="M+1hxecl"
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 5DDDF5CC;
	Thu, 11 Jan 2024 16:35:32 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5DDDF5CC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1704990932; bh=lxbMwgaCj5UW1Y/FCB9H2dwcciiTULw8Q9ix+lEkNWU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=M+1hxecl7+TX+LPT0Z9uLpMngKCfvyA9Vek4D0wR8CNCZwKf0IDHq/oucYrB1HVON
	 xia15KL6dbRzy6szG3nr6Lb2oM1/e+1DMxcaC/ctnEgE/voj1Lw0KY9rhLa0zLACBA
	 zPmBjs6twVEWbAOX5kV5r9/BcgapR7KM9BWxmefo0Bf6qOZbDtDqYsXIOSMlBHRmGr
	 /FgmTsDGgFMrRnKoVgzZ7fGxI45BfPrHwCeRoM1oIUdruCQaCyJxpInEyjd1gvdXyi
	 0q/BtjdRGhrGe9J6Jn3ZQKYWhLbEJPmqPGL3JwvCz31SAF7rj0XQACxitiyummi5e/
	 CQcCEuRoc+7LA==
From: Jonathan Corbet <corbet@lwn.net>
To: Baruch Siach <baruch@tkos.co.il>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, Baruch Siach
 <baruch@tkos.co.il>
Subject: Re: [PATCH] docs: admin-guide: hw_random: update rng-tools website
In-Reply-To: <ef52ace5008fa934084442149f64f5f9ddbba465.1704720105.git.baruch@tkos.co.il>
References: <ef52ace5008fa934084442149f64f5f9ddbba465.1704720105.git.baruch@tkos.co.il>
Date: Thu, 11 Jan 2024 09:35:31 -0700
Message-ID: <8734v3n7zg.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Baruch Siach <baruch@tkos.co.il> writes:

> rng-tools upstream moved to github. New upstream does not appear to
> consider itself official website for hw_random. Drop that part.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Documentation/admin-guide/hw_random.rst | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/hw_random.rst b/Documentation/admin-guide/hw_random.rst
> index d494601717f1..bfc39f1cf470 100644
> --- a/Documentation/admin-guide/hw_random.rst
> +++ b/Documentation/admin-guide/hw_random.rst
> @@ -14,10 +14,9 @@ into that core.
>  
>  To make the most effective use of these mechanisms, you
>  should download the support software as well.  Download the
> -latest version of the "rng-tools" package from the
> -hw_random driver's official Web site:
> +latest version of the "rng-tools" package from:
>  
> -	http://sourceforge.net/projects/gkernel/
> +	https://github.com/nhorman/rng-tools
>  

Applied, thanks.

jon
