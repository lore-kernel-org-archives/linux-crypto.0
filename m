Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746324D124;
	Mon, 11 Dec 2023 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOnPPeyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C41C433C8;
	Mon, 11 Dec 2023 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702314937;
	bh=MJ+00uPzODpLjfEGtn7k64AAHGSiP2ouDU3nlnvb6R8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOnPPeyLYo/dg5XoNlHDtZMHSS8PR802ejt4+UH6tfeqjSE4Mx8d4W0UXEUJzUdER
	 R4SpDa3vl42ckZiGyA2KJob4C5hryA563Uv3qtmBGcJrBvxpQ0LoHDvLAbhFd2qOJk
	 yMsjGWN2QXtD2bJOBNhx1PWkcbUNN/GeYjQKvPcYXXxUaOyFl0410alb1mRoqj3C88
	 dH/qX0RugVmtoYj6q7LAVAxfjNMip8FgSb7pA66DbYU+ANgRV5+mXte8ifkVN2NAx6
	 /iDNh0K0wDpzMFrUpywU1Rc6KOYjDDdAUI9dwcmUXjQD+TMNOis1qkJboFRlZyAIZL
	 FnZ1pBbr87Xpg==
Date: Mon, 11 Dec 2023 17:15:30 +0000
From: Simon Horman <horms@kernel.org>
To: Srujana Challa <schalla@marvell.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, bbrezillon@kernel.org, arno@natisbad.org,
	pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
	sgoutham@marvell.com, bbhushan2@marvell.com, jerinj@marvell.com,
	sbhatta@marvell.com, hkelam@marvell.com, lcherian@marvell.com,
	gakula@marvell.com, ndabilpuram@marvell.com
Subject: Re: [PATCH net-next v1 09/10] crypto/octeontx2: register error
 interrupts for inline cptlf
Message-ID: <20231211171530.GP5817@kernel.org>
References: <20231211071913.151225-1-schalla@marvell.com>
 <20231211071913.151225-10-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211071913.151225-10-schalla@marvell.com>

On Mon, Dec 11, 2023 at 12:49:12PM +0530, Srujana Challa wrote:
> From: Nithin Dabilpuram <ndabilpuram@marvell.com>
> 
> Register errors interrupts for inline cptlf attached to PF driver
> so that SMMU faults and other errors can be reported.
> 
> Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>

...

> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> index 7d44b54659bf..79afa3a451a7 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> @@ -725,7 +725,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
>  {
>  	struct device *dev = &pdev->dev;
>  	struct otx2_cptpf_dev *cptpf;
> -	int err;
> +	int err, num_vec;
>  
>  	cptpf = devm_kzalloc(dev, sizeof(*cptpf), GFP_KERNEL);
>  	if (!cptpf)
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

This goto will result in the function returning err.
However, err is 0 here. Perhaps it should be set to
a negative error value instead?

Flagged by Smatch.

> +
> +	err = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
>  	if (err < 0) {
>  		dev_err(dev, "Request for %d msix vectors failed\n",
>  			RVU_PF_INT_VEC_CNT);

...
