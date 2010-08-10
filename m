From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 11:40:00 -0400 (EDT)
Message-ID: <1471481479.135731281454800166.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1036252728.135401281454634072.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47687 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932139Ab0HJPkO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 11:40:14 -0400
In-Reply-To: <1036252728.135401281454634072.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@redhat.com> wrote:
> On Tue, Aug 10, 2010 at 10:47:14AM -0400, Miloslav Trmac wrote:
> > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > > The problem with the netlink approach is that auditing is not as good because 
> > > > netlink is an async protocol. The kernel can only use the credentials that 
> > > > ride in the skb with the command since there is no guarantee the process has 
> > > > not changed credentials by the time you get the packet. Adding more 
> > > > credentials to the netlink headers is also not good. As it is now, the 
> > > > auditing is synchronous with the syscall and we can get at more information 
> > > > and reliably create the audit records called out by the protection profiles or 
> > > > FIPS-140 level 2.
> > > > 
> > > > -Steve
> > > 
> > > I think thats pretty easy to serialize though.  All you need to do is enforce a
> > > rule in the kernel that dictates any creditial changes to a given context must
> > > be serialized behind all previously submitted crypto operations.
> > That would be a bit unusual from the layering/semantics aspect - why
> should credential changes care about crypto operations when they don't
> care about any other operations? - and it would require pretty
> widespread changes throughout the kernel core.
> >     Mirek
> 
> 
> I'm sorry, I thought steve was referring to credentials in the sense of changing
> keys/etc while crypto operations were in flight.
The audited values are mainly process/thread attributes: pid, ppid, {,e,fs}[ug]id, session id, and the like.  Most of these are attached to the netlink packet, and performing a lookup by PID is at packet handling time is unreliable - as far as I understand the netlink receive routine does not have to run in the same process context, so the PID might not even refer to the same process.
    Mirek
