Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4639919478;
	Sun, 19 Nov 2023 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf4uOkW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92907C433C8;
	Sun, 19 Nov 2023 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700423646;
	bh=mIjg7Dvc14iz7aZ54DdQxZApJrIggM1d3bC3JWviOSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rf4uOkW2UolgtvuKGha0WXZlnxs1NCi0TVUWidHoV7pAvCgZUx8cg1EEwbtD1lpcT
	 noPKzKeXpeahLIHbDBsAaivFnSPYqN/2ixgBITq3A39b+kDLVjJ2/FPJb41LJ5lN/j
	 7dISAHzCKqH2DJengZFR6M+R5FNTY3GrImi97FAYbDuUfWREJlGsNdsJ/KNb9vSFHD
	 UuLpdpc75pUKg67BQm7QPv0aQwBj0yB7k9a8p2fZMOi8zTBvV/7sPTk2CSPXrwDnt4
	 lDuDnDEbDt3TwBZpPgb4eJi3N8L/+AoP6YJ0C+DaJfHDRNh0IwFm82OGaho43xYmge
	 uKXv6zKgKCdOA==
Date: Sun, 19 Nov 2023 19:54:01 +0000
From: Simon Horman <horms@kernel.org>
To: Srujana Challa <schalla@marvell.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, bbrezillon@kernel.org, arno@natisbad.org,
	kuba@kernel.org, ndabilpuram@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH v1 09/10] crypto/octeontx2: register error interrupts for
 inline cptlf
Message-ID: <20231119195401.GH186930@vergenet.net>
References: <20231103053306.2259753-1-schalla@marvell.com>
 <20231103053306.2259753-10-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103053306.2259753-10-schalla@marvell.com>

On Fri, Nov 03, 2023 at 11:03:05AM +0530, Srujana Challa wrote:
> From: Nithin Dabilpuram <ndabilpuram@marvell.com>
> 
> Register errors interrupts for inline cptlf attached to PF driver
> so that SMMU faults and other errors can be reported.
> 
> Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>

...

> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c

...

> @@ -760,8 +760,11 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
>  	if (err)
>  		goto clear_drvdata;
>  
> -	err = pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
> -				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);
> +	num_vec = pci_msix_vec_count(cptpf->pdev);
> +	if (num_vec <= 0)
> +		goto clear_drvdata;

Hi Srujana and Nithin,

This branch will result in the function returning err.
However, err is set to 0 here. Perhaps it should
be set to a negative error value instead.

As flagged by Smatch.

> +
> +	err = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
>  	if (err < 0) {
>  		dev_err(dev, "Request for %d msix vectors failed\n",
>  			RVU_PF_INT_VEC_CNT);

...
