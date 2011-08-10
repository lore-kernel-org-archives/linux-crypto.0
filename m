From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: picoxcell - convert to platform ID table
Date: Wed, 10 Aug 2011 19:01:59 +0800
Message-ID: <20110810110159.GA2649@gondor.apana.org.au>
References: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46423 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1HJLCC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2011 07:02:02 -0400
Content-Disposition: inline
In-Reply-To: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 01, 2011 at 05:25:17PM +0100, Jamie Iles wrote:
> Use a platform ID table and a single platform_driver.  It's neater and
> makes the device tree addition easier and more consistent.  Rename the
> match values to be inline with what they'll be in the device tree
> bindings.  There aren't any current in-tree users of the existing device
> names.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

All three patches applied.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
