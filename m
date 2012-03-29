From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: user - Fix size of netlink dump message
Date: Thu, 29 Mar 2012 07:45:04 +0200
Message-ID: <20120329054504.GA1021@secunet.com>
References: <20120326072729.GA16191@secunet.com>
 <20120326072827.GB16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33743 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2C2FpK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 01:45:10 -0400
Content-Disposition: inline
In-Reply-To: <20120326072827.GB16191@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 26, 2012 at 09:28:27AM +0200, Steffen Klassert wrote:
> +
>  		return netlink_dump_start(crypto_nlsk, skb, nlh,
> -					  link->dump, link->done, 0);
> +					  link->dump, link->done, dump_alloc);

I've just noticed that the interface to netlink_dump_start() changed in
the mainline (with commit 80d326fab534a5380e8f6e509a0b9076655a9670), so
this will cause a conflict. The crypto-2.6 tree is way behind the mainline
(v3.2 + some patches). Could you please update the crypto-2.6 tree so that
I can respin this patch?

Thanks!
