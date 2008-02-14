From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 14 Feb 2008 12:30:31 +0300
Message-ID: <20080214093031.GA5258@2ka.mipt.ru>
References: <47B2EDF9.6020900@trash.net> <20080213144442.GA10683@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55510 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYBNJbM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Feb 2008 04:31:12 -0500
Content-Disposition: inline
In-Reply-To: <20080213144442.GA10683@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patrick.

On Wed, Feb 13, 2008 at 05:44:42PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> Any chance you can apply following patch and check output for correct
> and broken cases (it will produce 2 or 3 debug strings for each crypto
> operation)?
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index dfbf24c..b8b088d 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -1558,6 +1558,23 @@ err_out_unmap:
>  	return err;
>  }
>  
> +static void hifn_dump_req(struct ablkcipher_request *req, const char *prefix)
> +{
> +	int nbytes = (signed)req->nbytes;
> +	struct scatterlist *src, *dst;
> +	int idx = 0;
> +
> +	printk("%s: nbytes: %u, ", prefix, nbytes);
> +	while (nbytes > 0) {
> +		src = &req->src[idx];
> +		dst = &req->dst[idx];
> +
> +		printk("%u/%u ", src->length, dst->length);
> +		nbytes -= src->length;

Ouch, forgot idx++;

-- 
	Evgeniy Polyakov
