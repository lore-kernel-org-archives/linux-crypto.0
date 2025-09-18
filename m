Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEF024166F;
	Thu, 18 Sep 2025 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192519; cv=none; b=kv/l5uoavs8WW9WgGmUvWGbJQlce70jS0mkGmPB2Qmxmj3A8/7BMFTTzwEnVwekoVS0CMnYO0jk+U+VDvCNqg/tQJ1ntbyZitsb6DT8GAoR0iNvKlJHJyAB09bgXKH9+s2Jhch1clhVyalVhmDfchZCaYOgcJNf9cWG4sHJ/L6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192519; c=relaxed/simple;
	bh=9NjkYuJY3+x5/AVuF5jgy3dsg/Iv+22Qdc3J6XcWOJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LriDviUnwNUH9GE/5tparErHi/+OVLAmUfbKqR1TSGJiiIL+uLLB+Ry6XtQxfTGTCbf1/nwAEyvsfuApkA2QX94oODvQH9W90cRpL7LOMKHVHjTDGD1Wn0vRJ0YAMczehRJlr2S4a5hbFtiGLWIxD12v/WnznsUHYxD8Ap0/Lko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bbb9lzHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bbb9lzHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C98C4CEE7;
	Thu, 18 Sep 2025 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758192519;
	bh=9NjkYuJY3+x5/AVuF5jgy3dsg/Iv+22Qdc3J6XcWOJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bbb9lzHUXVMU6nb0dI7vnkCsNLiunoec1CdEu/KV57EaU6xY3/3CocA4bJFQ9U3b6
	 4gwqfqMqXc0eBltOHR45KjWMGRJXHfElcikTepDsfUrvnV0FQvAB73aOLaUNxpCqX9
	 AkfcLy3olhsOxh7Wr7Xk2ZfisdNvqcq4cjGOJFSk=
Date: Thu, 18 Sep 2025 12:48:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Douglass <dan.douglass@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: Add check for kcalloc() in test_len()
Message-ID: <2025091847-glowing-ripping-df0a@gregkh>
References: <20250918101527.3458436-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918101527.3458436-1-lgs201920130244@gmail.com>

On Thu, Sep 18, 2025 at 06:15:27PM +0800, Guangshuo Li wrote:
> As kcalloc() may fail, check its return value to avoid a NULL pointer
> dereference when passing the buffer to rng->read() and
> print_hex_dump_debug().

But that is not what this patch does :(

> Fixes: 2be0d806e25e ("crypto: caam - add a test for the RNG")
> Cc: stable@vger.kernel.org

No need for stable here.

> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/crypto/caam/caamrng.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index e0adb326f496..d887ecf6f99d 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -183,7 +183,6 @@ static inline void test_len(struct hwrng *rng, size_t len, bool wait)
>  	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
>  
>  	if (!buf) {
> -		dev_err(dev, "RNG buffer allocation failed\n");
>  		return;
>  	}

checkpatch should show that you can remove the { } now, right?

thanks,

greg k-h
