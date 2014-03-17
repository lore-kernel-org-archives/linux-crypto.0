From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 03/22] staging: crypto: skein: allow building
 statically
Date: Mon, 17 Mar 2014 14:52:52 -0700
Message-ID: <20140317215252.GA24150@kroah.com>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <e3d822cba2ff9e9bbb57fc613039bd0983186c05.1394570067.git.jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaCQVuv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 17:50:51 -0400
Content-Disposition: inline
In-Reply-To: <e3d822cba2ff9e9bbb57fc613039bd0983186c05.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 11, 2014 at 09:32:35PM +0000, Jason Cooper wrote:
> These are the minimum changes required to get the code to build
> statically in the kernel.  It's necessary to do this first so that we
> can empirically determine that future cleanup patches aren't changing
> the generated object code.
> 
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>

This doesn't apply to my latest tree :(

> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -65,3 +65,4 @@ obj-$(CONFIG_XILLYBUS)		+= xillybus/
>  obj-$(CONFIG_DGNC)			+= dgnc/
>  obj-$(CONFIG_DGAP)			+= dgap/
>  obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
> +obj-$(CONFIG_CRYPTO_SKEIN) += skein/

Care to align these up with the way this file is formatted?

And I have no objection to taking the drivers/staging/ patches, the
script looks useful, but I can't take it through the staging tree,
sorry.

thanks,

greg k-h
