From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 10:47:14 -0400 (EDT)
Message-ID: <670273462.127371281451634338.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100810143757.GD3390@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38823 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754860Ab0HJOrY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 10:47:24 -0400
In-Reply-To: <20100810143757.GD3390@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


----- "Neil Horman" <nhorman@redhat.com> wrote:
> On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > Thats why I had suggested the use of a netlink protocol to manage this kind
> > > of interface.  There are other issue to manage there, but they're really
> > > not that big a deal, comparatively speaking, and that interface allows for
> > > the easy specification of arbitrary length data in a fashion that doesn't
> > > cause user space breakage when additional algorithms/apis are added.
> > 
> > The problem with the netlink approach is that auditing is not as good because 
> > netlink is an async protocol. The kernel can only use the credentials that 
> > ride in the skb with the command since there is no guarantee the process has 
> > not changed credentials by the time you get the packet. Adding more 
> > credentials to the netlink headers is also not good. As it is now, the 
> > auditing is synchronous with the syscall and we can get at more information 
> > and reliably create the audit records called out by the protection
> profiles or 
> > FIPS-140 level 2.
> > 
> > -Steve
> 
> I think thats pretty easy to serialize though.  All you need to do is enforce a
> rule in the kernel that dictates any creditial changes to a given context must
> be serialized behind all previously submitted crypto operations.
That would be a bit unusual from the layering/semantics aspect - why should credential changes care about crypto operations when they don't care about any other operations? - and it would require pretty widespread changes throughout the kernel core.
    Mirek
