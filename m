From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Wed, 25 Sep 2013 21:11:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309252056090.30035-100000@netrider.rowland.org>
References: <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, <JKosina-IBi9RG/b67k@public.gmane.org>,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380147414.18835.36.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 25 Sep 2013, James Bottomley wrote:

> > Why are asymmetric keys used for verifying the hibernation image?  It
> > seems that a symmetric key would work just as well.  And it would be a
> > lot quicker to generate, because it wouldn't need any high-precision
> > integer computations.
> 
> The reason is the desire to validate that the previous kernel created
> something which it passed on to the current kernel (in this case, the
> hibernation image) untampered with.  To do that, something must be
> passed to the prior kernel that can be validated but *not* recreated by
> the current kernel.

As Pavel pointed out, this seems like a futile approach.  If the 
current kernel is going to do the validating, then of course it can
create something that it will validate.

Or to put it another way, how come you don't trust the current kernel
not to modify the image but you do trust it to validate the image?

> The scheme for doing this is a public/private key pair generated for
> each boot incarnation N as a pair P_N (public key) and K_N (private
> key).  Then the Nth boot incarnation gets P_{N-1} and K_N (the boot

Where does it get them from?  Some place in the firmware, presumably.

> environment holds P_N in inaccessible BS variables for passing into the
> next kernel) so the Nth kernel can validate information from the N-1th
> kernel using P_{N-1} and create information for passing on in a
> validated fashion to the next kernel using K_N.

So kernel N gets P_{N-1} and an image that has been signed by K_{N-1}.  
What's to prevent kernel N from creating a bogus pair of keys (K',P')
and a bogus image, signing that image with K', and then pretending it
got P' from the firmware instead of P_{N-1}?

However...  Let's assume that you _do_ trust kernel N.  Then consider 
this alternative approach:

A symmetric key S_N is created for boot incarnation N.  Kernel N
receives S_{N-1} from the firmware and uses it to verify the signature
attached to the hibernation image.  When kernel N wants to create the
next hibernation image, it signs the image with S_N (also obtained 
from the firmware).

> This scheme doesn't work with symmetric keys unless you have a
> modification I haven't seen?

Obviously these two schemes are different.  Do these differences have
any security implications?

Alan Stern
