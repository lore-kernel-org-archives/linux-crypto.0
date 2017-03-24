From: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: ls1012a: add crypto node
Date: Fri, 24 Mar 2017 22:03:22 +0800
Message-ID: <20170324140320.GP30608@dragon>
References: <20170322122939.22117-1-horia.geanta@nxp.com>
 <20170324015606.GC30608@dragon>
 <DB4PR04MB0847D837CB2762D5094720CB983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
 <20170324073420.GM30608@dragon>
 <DB4PR04MB0847E3EE8F7FAC11DD85FAA8983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Harninder Rai <harninder.rai-3arQi8VN3Tc@public.gmane.org>,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Bhaskar U <bhaskar.upadhaya-3arQi8VN3Tc@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB4PR04MB0847E3EE8F7FAC11DD85FAA8983E0-tLF+feb1Bz4/w1fYxD+T089NdZoXdze2vxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 24, 2017 at 08:29:17AM +0000, Horia Geantă wrote:
> On 3/24/2017 9:35 AM, Shawn Guo wrote:
> > On Fri, Mar 24, 2017 at 07:17:50AM +0000, Horia Geantă wrote:
> >>>> +		sec_mon: sec_mon@1e90000 {
> >>>
> >>> Hyphen is more preferred to be used in node name than underscore.
> >>>
> >> This would imply changing the
> >> Documentation/devicetree/bindings/crypto/fsl-sec4.txt binding and
> >> dealing with all the consequences, which IIUC is probably not worth.
> > 
> > I do not care the bindings doc that much, since I'm not the maintainer
> > of it.  What are the consequences specifically, if we use a better node
> > name in dts than bindings example?
> > 
> Users relying on finding the sec_mon node will obviously stop working.
> I don't see any in-kernel users, however there could be others I am not
> aware of and DT bindings should provide for backwards compatibility.

Okay, point taken.  You can keep the node name as it is.

> I could deprecate "sec_mon" in the bindings and suggest "sec-mon"
> instead, while leaving all existing dts files as-is.
> The risk is breaking LS1012A users relying on "sec_mon".

For existing bindings, I do not care that much.  But for new ones, I do
hope that we recommend to use hyphen, as that's more idiomatic at least
for Linux kernel.

> I see that ePAPR:
> -allows both for hyphen and underline in case of node names
> -allows only for hyphen (i.e. forbids underline) in case of alias nodes
> 
> In the first case, I understand there's an (undocumented?) agreement to
> prefer hyphen over underline.

Both are valid, but hyphen is more idiomatic for Linux kernel.

> For the 2nd one, does this mean I should change alias names?

This is something I see difference between specification and DTC.

	aliases {
		alias-name = &label_name;
	};

	label_name: node-name {
		...
	};

The spec says that only hyphen is valid for alias name, but DTC works
happily with underscore too.  From my experience with DTC playing, both
hyphen and underscore are valid for alias and node name.  But for label
name, only underscore is valid.  Using hyphen in label name will cause
DTC to report syntax error.

Shawn
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
