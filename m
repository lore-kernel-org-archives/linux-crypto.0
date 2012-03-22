From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
Date: Thu, 22 Mar 2012 16:39:56 +1100
Message-ID: <1332394796.2982.78.camel@pasglop>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <1332366068.3858.50.camel@key-ThinkPad-W510>
	 <20120321221517.GB30748@kroah.com> <1332381004.2982.65.camel@pasglop>
	 <1332385050.2982.71.camel@pasglop> <20120322033957.GA16914@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120322033957.GA16914@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2012-03-21 at 20:39 -0700, Greg KH wrote:
> On Thu, Mar 22, 2012 at 01:57:30PM +1100, Benjamin Herrenschmidt wrote:
> > +int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
> > +			const char *mod_name)
> >  {
> >  	viodrv->driver.bus = &vio_bus_type;
> > +	viodrv->driver.name = viodrv->name;
> > +	viodrv->driver.bus = &vio_bus_type;
> > +	viodrv->driver.owner = owner;
> > +	viodrv->driver.mod_name = mod_name;
> 
> Any reason you set .bus twice?

Nope, just a typo. I'll fix it up, when I have feedback from Dave.

Cheers,
Ben.
