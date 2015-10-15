From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v4 8/8] zram: enable contextless compression alg in zram
Date: Thu, 15 Oct 2015 11:48:14 +0900
Message-ID: <20151015024814.GB7566@js1304-P5Q-DELUXE>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1444808304-29320-9-git-send-email-iamjoonsoo.kim@lge.com>
 <20151015020549.GE1735@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:40533 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbJOCr1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 22:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20151015020549.GE1735@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 11:05:49AM +0900, Sergey Senozhatsky wrote:
> On (10/14/15 16:38), Joonsoo Kim wrote:
> [..]
> > @@ -352,6 +352,7 @@ static ssize_t comp_algorithm_show(struct device *dev,
> >  	size_t sz;
> >  	struct zram *zram = dev_to_zram(dev);
> >  
> > +	deprecated_attr_warn("comp_algorithm");
> >  	down_read(&zram->init_lock);
> >  	sz = zcomp_available_show(zram->compressor, buf);
> >  	up_read(&zram->init_lock);
> 
> oh, one more thing.
> 
> deprecated_attr_warn() should come with `Documentation/ABI/obsolete/sysfs-block-zram' update.
> something like:
> 
> diff --git a/Documentation/ABI/obsolete/sysfs-block-zram b/Documentation/ABI/obsolete/sysfs-block-zram
> index 720ea92..ad5b59d 100644
> --- a/Documentation/ABI/obsolete/sysfs-block-zram
> +++ b/Documentation/ABI/obsolete/sysfs-block-zram
> @@ -117,3 +117,14 @@ Description:
>                 Downgraded to write-only node: so it's possible to set new
>                 value only; its current value is stored in zram<id>/mm_stat
>                 node.
> +
> +What:          /sys/block/zram<id>/comp_algorithm
> +Date:          XXX
> +Contact:       XXX
> +Description:
> +               The comp_algorithm file is read/write and provides information
> +               on available, currently selected compression algorithm (read
> +               operation) and lets one to change the compression algorithm
> +               (write operation).
> +               Downgraded to write-only node: use `/proc/crypto' to get the
> +               list of supported compression algorithms.
> 
> 
> ---
> 
> 
> And I guess Cc `Jonathan Corbet <corbet@lwn.net>' (doc maintainer) and
> 'linux-api@vger.kernel.org' will be the right thing to do here.

Okay. I will do it in next spin.

Thanks.
