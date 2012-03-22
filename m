From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
Date: Wed, 21 Mar 2012 20:39:57 -0700
Message-ID: <20120322033957.GA16914@kroah.com>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
 <1332366068.3858.50.camel@key-ThinkPad-W510>
 <20120321221517.GB30748@kroah.com>
 <1332381004.2982.65.camel@pasglop>
 <1332385050.2982.71.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59699 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2CVDkA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Mar 2012 23:40:00 -0400
Received: by dajr28 with SMTP id r28so2498491daj.19
        for <linux-crypto@vger.kernel.org>; Wed, 21 Mar 2012 20:40:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1332385050.2982.71.camel@pasglop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 22, 2012 at 01:57:30PM +1100, Benjamin Herrenschmidt wrote:
> +int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
> +			const char *mod_name)
>  {
>  	viodrv->driver.bus = &vio_bus_type;
> +	viodrv->driver.name = viodrv->name;
> +	viodrv->driver.bus = &vio_bus_type;
> +	viodrv->driver.owner = owner;
> +	viodrv->driver.mod_name = mod_name;

Any reason you set .bus twice?
