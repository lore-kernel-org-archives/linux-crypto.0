From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 10:51:05 -0400
Message-ID: <20100810145105.GF3390@hmsreliant.think-freely.org>
References: <20100810143757.GD3390@hmsreliant.think-freely.org>
 <670273462.127371281451634338.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0HJOz2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 10:55:28 -0400
Content-Disposition: inline
In-Reply-To: <670273462.127371281451634338.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 10, 2010 at 10:47:14AM -0400, Miloslav Trmac wrote:
> 
> ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > > Thats why I had suggested the use of a netlink protocol to manage this kind
> > > > of interface.  There are other issue to manage there, but they're really
> > > > not that big a deal, comparatively speaking, and that interface allows for
> > > > the easy specification of arbitrary length data in a fashion that doesn't
> > > > cause user space breakage when additional algorithms/apis are added.
> > > 
> > > The problem with the netlink approach is that auditing is not as good because 
> > > netlink is an async protocol. The kernel can only use the credentials that 
> > > ride in the skb with the command since there is no guarantee the process has 
> > > not changed credentials by the time you get the packet. Adding more 
> > > credentials to the netlink headers is also not good. As it is now, the 
> > > auditing is synchronous with the syscall and we can get at more information 
> > > and reliably create the audit records called out by the protection
> > profiles or 
> > > FIPS-140 level 2.
> > > 
> > > -Steve
> > 
> > I think thats pretty easy to serialize though.  All you need to do is enforce a
> > rule in the kernel that dictates any creditial changes to a given context must
> > be serialized behind all previously submitted crypto operations.
> That would be a bit unusual from the layering/semantics aspect - why should credential changes care about crypto operations when they don't care about any other operations? - and it would require pretty widespread changes throughout the kernel core.
>     Mirek


I'm sorry, I thought steve was referring to credentials in the sense of changing
keys/etc while crypto operations were in flight.  If you're referring to users
credentials in terms of permissions to use a device or service, then I think its
all moot anyway.  As you say why should credential changes care about crypto ops
when they don't care about other ops.  If you have permissions to use a
device/service, changing those permissions doesnt really change the fact that
you're in the process of using that service.  We could do some modicum of
credential check when requests are submitted and deny service based on that
check, but anything already submitted was done when you had permission to do so
and should be allowed to complete.

Neil
