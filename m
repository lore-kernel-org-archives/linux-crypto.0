Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B163A254A;
	Mon, 11 May 2026 07:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778485598; cv=none; b=Ullq0aeV5KMXk5GU7nSaoOIc6eyx5WP/qGorvExI0EJdHy/XsyUjm0DSwy01qPHtQ3ixEvu+6l1URyTQWVuINmFFgXJNdIl5MrXlYw7iuEhdVQFE7GoB3xV11GIozVWfxv/n3jZHxecjfGp5ZubL0bXmvBXUY9awuXG1kxV5H8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778485598; c=relaxed/simple;
	bh=JvOWyQk4lINiu0MqPPT7d60s3npyWE96/e3rZ4L1sqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/QoFgv3vJHhDzuVA9Ode3UQMk/Ti7oJ6lzXEgY1ztpBPF2q/tkxmUFrKkuCJ0y2JeAg5qGlS0hCer04FsnZvsCJLtLWlB8GQsdl7+PESAxmnmKwLs67O2b+HJyKZEQ4t8QnAc+ky27bkkMpi49oDT0aX9g9/mQhfLrVsqUSLCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrM7mawJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrM7mawJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A446DC2BCF6;
	Mon, 11 May 2026 07:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778485597;
	bh=JvOWyQk4lINiu0MqPPT7d60s3npyWE96/e3rZ4L1sqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MrM7mawJEwpjwgMceY+cOOEaQB1EYkkc8kJCnEYSMJToq5kEWBJOlgLah4z9F4Vxz
	 1qoagUfl7ePg7XX3iQ/nG8LHmSiTAwQUPFSie4I6vkqGqJND67o2O00+nlxnRUgVfs
	 TBzRjkRaOJjTHeIeAnSS3+MPz04/OkXFwxaqhbgEOPHktB1X6Wnukn3zjWcHnnCI89
	 lOvcDAEKEqxQtv0hvZ9ghh5Mg1v4FYhXy+7odebp5V3pNn7jDVr1VtdgoPEZtCqAu9
	 t/x4431wARauIigv2P6itTHn9RvORxU/N/jA02ouZ9y0W24FbGviBqxq+UBBxB/4LG
	 PUqUsvseKvtaw==
Date: Mon, 11 May 2026 09:46:33 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: atenart@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, pvanleeuwen@insidesecure.com
Subject: Re: [PATCH] crypto: safexcel - Fix potential memory leak in
 safexcel_pci_probe()
Message-ID: <agGJOTq35e4C9XCg@kwain>
References: <20260508090347.74176-1-nihaal@cse.iitm.ac.in>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508090347.74176-1-nihaal@cse.iitm.ac.in>

On Fri, May 08, 2026 at 02:33:45PM +0530, Abdun Nihaal wrote:
> The memory allocated for priv in safexcel_pci_probe() is not freed in the
> error paths, as well as in the PCI remove function. Fix this by using
> device managed allocation.
> 
> Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development board")
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
> Compile tested only. Issue found using static analysis.
> 
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index fb4936e7afa2..2bd8641a07b3 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1893,7 +1893,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
>  		ent->vendor, ent->device, ent->subvendor,
>  		ent->subdevice, ent->driver_data);
>  
> -	priv = kzalloc_obj(*priv);
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>  
> -- 
> 2.43.0
> 
