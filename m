From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] crypto: fix build failure in mv_cesa.c (missing of
 header)
Date: Sat, 10 Mar 2012 20:42:26 -0500
Message-ID: <20120311014226.GU5050@titan.lakedaemon.net>
References: <1331323105-21034-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: michael@walle.cc, linux-crypto@vger.kernel.org,
	linux-next@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:36839 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2CKBma (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Mar 2012 20:42:30 -0500
Content-Disposition: inline
In-Reply-To: <1331323105-21034-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 09, 2012 at 02:58:25PM -0500, Paul Gortmaker wrote:
> Commit 737b75872487f560397ba34846a19823b1addf88 (linux-next)
> 
>     "ARM: kirkwood: mv_cesa devicetree bindings"
> 
> fails to compile as follows:
> 
>  CC      drivers/crypto/mv_cesa.o
>  drivers/crypto/mv_cesa.c:1139: error: implicit declaration of function 'of_match_ptr'
>  drivers/crypto/mv_cesa.c:1139: error: 'mv_cesa_dt_ids' undeclared here (not in a function)
>  drivers/crypto/mv_cesa.c:1139: error: initializer element is not constant
>  drivers/crypto/mv_cesa.c:1139: error: (near initialization for 'marvell_crypto.driver.of_match_table')
> 
> because it is missing the linux/of.h header file.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Paul,

Thanks for the patch.  Unfortunately, I'm not learning fast enough.  ;-)
This series has been in a lot of flux lately, as you've experienced.

The good news is, after talking with Olaf and Arnd, I think I have a
good workflow figured out.  Hopefully, failures like this won't happen
in the future.

As an fyi, I'm probably going to take kirkwood_dt_staging down (or, label
it broken ;-) )  I intended it as a publicly viewable branch of "what's
coming down the pipe", but it's not working out the way I intended.

As for mv_cesa, it's next on my list.  As soon as I figure out the irq
stuff.

Thanks for testing.

Jason.

> 
> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> index b7a3d48..093e214 100644
> --- a/drivers/crypto/mv_cesa.c
> +++ b/drivers/crypto/mv_cesa.c
> @@ -10,6 +10,7 @@
>  #include <crypto/algapi.h>
>  #include <linux/crypto.h>
>  #include <linux/interrupt.h>
> +#include <linux/of.h>
>  #include <linux/io.h>
>  #include <linux/kthread.h>
>  #include <linux/platform_device.h>
> -- 
> 1.7.9.1
> 
