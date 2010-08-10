From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 12:57:43 -0400 (EDT)
Message-ID: <1588375167.142801281459463292.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100810164045.GH3390@hmsreliant.think-freely.org>
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
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51303 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932414Ab0HJQ6A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 12:58:00 -0400
In-Reply-To: <20100810164045.GH3390@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


----- "Neil Horman" <nhorman@redhat.com> wrote:

> On Tue, Aug 10, 2010 at 11:40:00AM -0400, Miloslav Trmac wrote:
> > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > On Tue, Aug 10, 2010 at 10:47:14AM -0400, Miloslav Trmac wrote:
> > > > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > > > On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > > > > The problem with the netlink approach is that auditing is not as good because
> > > > > > netlink is an async protocol. The kernel can only use the credentials that
> > > > > > ride in the skb with the command since there is no guarantee the process has
> > > > > > not changed credentials by the time you get the packet. Adding more
> > > > > > credentials to the netlink headers is also not good. As it is now, the
> > > > > > auditing is synchronous with the syscall and we can get at more information
> > > > > > and reliably create the audit records called out by the protection profiles or
> > > > > > FIPS-140 level 2.
> > > > > >
> > > > > > -Steve
> > > > >
> > > > > I think thats pretty easy to serialize though.  All you need to do is enforce a
> > > > > rule in the kernel that dictates any creditial changes to a given context must
> > > > > be serialized behind all previously submitted crypto operations.
> > > > That would be a bit unusual from the layering/semantics aspect - why
> > > should credential changes care about crypto operations when they don't
> > > care about any other operations? - and it would require pretty
> > > widespread changes throughout the kernel core.
> > > >     Mirek
> > >
> > >
> > > I'm sorry, I thought steve was referring to credentials in the sense of changing
> > > keys/etc while crypto operations were in flight.
> > The audited values are mainly process/thread attributes: pid, ppid,
> {,e,fs}[ug]id, session id, and the like.  Most of these are attached
> to the netlink packet, and performing a lookup by PID is at packet
> handling time is unreliable - as far as I understand the netlink
> receive routine does not have to run in the same process context, so
> the PID might not even refer to the same process.
>
> I'm not so sure I follow.  how can you receive messages on a socket in response
> to requests that were sent from a different socket.  In the netlink multicast
> and broadcast case, sure, but theres no need to use those.  I suppose you could
> exit a process, start another process in which the pid gets reused, open up a
> subsequent socket and perhaps confuse audit that way, but you're not going to
> get responses to the requests that the previous process sent in that case.
I don't even need to open a subsequent socket - as son as the process ID is reused, the audit message is incorrect, which is not really acceptable in itself.

> And
> in the event that happens, Audit should log a close event on the fd inquestion
> between the operations.
audit only logs explicitly requested operations, so an administrator that asks for crypto events does not automatically get any close events.  Besides, the audit record should be correct in the first place, instead of giving the admin a puzzle to decipher.

> Theres also the child process case, in which a child process might read
> responses from requests sent by a parent, and vice versa, since fork inherits
> file descriptors, but thats an issue inherent in any mechanism you use,
> including the character interface, so I'm not sure what the problem is
> there.
Actually that's not a problem with ioctl() because the response is written back _before_ ioctl() returns, so it is always provided to the original calling thread.

With the current design the parent and child share the key/session namespace after fork(), but operation results are always reliably and automatically provided to the thread that invoked the operation, without any user-space collaboration.
    Mirek
