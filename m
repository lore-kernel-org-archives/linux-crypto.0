From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4/6] crypto/nx-842-{powerpc,pseries}: only load on the
 appropriate machine type
Date: Fri, 03 Jul 2015 11:30:32 +1000
Message-ID: <1435887032.3665.1.camel@ellerman.id.au>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
	 <20150702224049.GE1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dan Streetman <ddstreet@us.ibm.com>, linux-crypto@vger.kernel.org,
	gustavold@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:43946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbbGCBad (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 21:30:33 -0400
In-Reply-To: <20150702224049.GE1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-07-02 at 15:40 -0700, Nishanth Aravamudan wrote:
> While we never would successfully load on the wrong machine type, there
> is extra output by default regardless of machine type.
> 
> For instance, on a PowerVM LPAR, we see the following:
> 
> nx_compress_powernv: loading
> nx_compress_powernv: no coprocessors found
> 
> even though those coprocessors could never be found. Similar pseries
> messages are printed on powernv.

I know I've been converting init calls to machine_initcalls() to avoid these
sort of issues in platform code. But for a driver it should be trivial for it
to only probe when the hardware is found.

By which I mean I think we shouldn't need these.

> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index 33b3b0abf4ae..6b5e5143c95b 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -594,6 +594,9 @@ static __init int nx842_powernv_init(void)
>  	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
>  	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
>  
> +	if (!machine_is(powernv))
> +		return -ENODEV;
> +
>  	pr_info("loading\n");

This is just too chatty, drop it.

>  	for_each_compatible_node(dn, NULL, "ibm,power-nx")

It shouldn't be printing anything unless it finds some devices in this loop.

And you should drop the print in here:

	if (!nx842_ct) {
		pr_err("no coprocessors found\n");
		return -ENODEV;
	}

And that should mean no output unless hardware is found I think?

> @@ -625,6 +628,9 @@ static void __exit nx842_powernv_exit(void)
>  {
>  	struct nx842_coproc *coproc, *n;
>  
> +	if (!machine_is(powernv))
> +		return;

You shouldn't need to touch the exit paths if the drivers were never loaded?

> diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
> index b84b0ceeb46e..75a7bfdc160e 100644
> --- a/drivers/crypto/nx/nx-842-pseries.c
> +++ b/drivers/crypto/nx/nx-842-pseries.c
> @@ -1091,6 +1091,9 @@ static int __init nx842_pseries_init(void)
>  	struct nx842_devdata *new_devdata;
>  	int ret;
>  
> +	if (!machine_is(pseries))
> +		return -ENODEV;
> +
>  	pr_info("Registering IBM Power 842 compression driver\n");

Again this is too chatty, just remove it.

>  	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
		return -ENODEV;

That should do the trick shouldn't it?

cheers
