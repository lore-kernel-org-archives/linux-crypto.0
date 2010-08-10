From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 12:40:45 -0400
Message-ID: <20100810164045.GH3390@hmsreliant.think-freely.org>
References: <1036252728.135401281454634072.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <1471481479.135731281454800166.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab0HJQpH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 12:45:07 -0400
Content-Disposition: inline
In-Reply-To: <1471481479.135731281454800166.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 10, 2010 at 11:40:00AM -0400, Miloslav Trmac wrote:
> ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > On Tue, Aug 10, 2010 at 10:47:14AM -0400, Miloslav Trmac wrote:
> > > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > > On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > > > The problem with the netlink approach is that auditing is not as good because 
> > > > > netlink is an async protocol. The kernel can only use the credentials that 
> > > > > ride in the skb with the command since there is no guarantee the process has 
> > > > > not changed credentials by the time you get the packet. Adding more 
> > > > > credentials to the netlink headers is also not good. As it is now, the 
> > > > > auditing is synchronous with the syscall and we can get at more information 
> > > > > and reliably create the audit records called out by the protection profiles or 
> > > > > FIPS-140 level 2.
> > > > > 
> > > > > -Steve
> > > > 
> > > > I think thats pretty easy to serialize though.  All you need to do is enforce a
> > > > rule in the kernel that dictates any creditial changes to a given context must
> > > > be serialized behind all previously submitted crypto operations.
> > > That would be a bit unusual from the layering/semantics aspect - why
> > should credential changes care about crypto operations when they don't
> > care about any other operations? - and it would require pretty
> > widespread changes throughout the kernel core.
> > >     Mirek
> > 
> > 
> > I'm sorry, I thought steve was referring to credentials in the sense of changing
> > keys/etc while crypto operations were in flight.
> The audited values are mainly process/thread attributes: pid, ppid, {,e,fs}[ug]id, session id, and the like.  Most of these are attached to the netlink packet, and performing a lookup by PID is at packet handling time is unreliable - as far as I understand the netlink receive routine does not have to run in the same process context, so the PID might not even refer to the same process.
>     Mirek

I'm not so sure I follow.  how can you receive messages on a socket in response
to requests that were sent from a different socket.  In the netlink multicast
and broadcast case, sure, but theres no need to use those.  I suppose you could
exit a process, start another process in which the pid gets reused, open up a
subsequent socket and perhaps confuse audit that way, but you're not going to
get responses to the requests that the previous process sent in that case.  And
in the event that happens, Audit should log a close event on the fd inquestion
between the operations.


Theres also the child process case, in which a child process might read
responses from requests sent by a parent, and vice versa, since fork inherits
file descriptors, but thats an issue inherent in any mechanism you use,
including the character interface, so I'm not sure what the problem is there.
