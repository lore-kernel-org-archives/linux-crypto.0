From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:19:59 -0400 (EDT)
Message-ID: <1257297871.155001281464399281.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100810175740.GC3072@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45530 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932515Ab0HJSUN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:20:13 -0400
In-Reply-To: <20100810175740.GC3072@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> On Tue, Aug 10, 2010 at 12:57:43PM -0400, Miloslav Trmac wrote:
> > 
> > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > 
> > > On Tue, Aug 10, 2010 at 11:40:00AM -0400, Miloslav Trmac wrote:
> > > > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > > > On Tue, Aug 10, 2010 at 10:47:14AM -0400, Miloslav Trmac wrote:
> > > > > > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > > > > > On Tue, Aug 10, 2010 at 09:24:31AM -0400, Steve Grubb wrote:
> > > > > > > > The problem with the netlink approach is that auditing is not as good because
> > > > > > > > netlink is an async protocol. The kernel can only use the credentials that
> > > > > > > > ride in the skb with the command since there is no guarantee the process has
> > > > > > > > not changed credentials by the time you get the packet. Adding more
> > > > > > > > credentials to the netlink headers is also not good. As it is now, the
> > > > > > > > auditing is synchronous with the syscall and we can get at more information
> > > > > > > > and reliably create the audit records called out by the protection profiles or
> > > > > > > > FIPS-140 level 2.
> > > > > > > >
> > > > > > > > -Steve
> > > > > > >
> > > > > > > I think thats pretty easy to serialize though.  All you need to do is enforce a
> > > > > > > rule in the kernel that dictates any creditial changes to a given context must
> > > > > > > be serialized behind all previously submitted crypto operations.
> > > > > > That would be a bit unusual from the layering/semantics aspect - why
> > > > > should credential changes care about crypto operations when they don't
> > > > > care about any other operations? - and it would require pretty
> > > > > widespread changes throughout the kernel core.
> > > > > >     Mirek
> > > > >
> > > > >
> > > > > I'm sorry, I thought steve was referring to credentials in the sense of changing
> > > > > keys/etc while crypto operations were in flight.
> > > > The audited values are mainly process/thread attributes: pid, ppid,
> > > {,e,fs}[ug]id, session id, and the like.  Most of these are attached
> > > to the netlink packet, and performing a lookup by PID is at packet
> > > handling time is unreliable - as far as I understand the netlink
> > > receive routine does not have to run in the same process context, so
> > > the PID might not even refer to the same process.
> > >
> > > I'm not so sure I follow.  how can you receive messages on a socket in response
> > > to requests that were sent from a different socket.  In the netlink multicast
> > > and broadcast case, sure, but theres no need to use those.  I suppose you could
> > > exit a process, start another process in which the pid gets reused, open up a
> > > subsequent socket and perhaps confuse audit that way, but you're not going to
> > > get responses to the requests that the previous process sent in that case.
> > I don't even need to open a subsequent socket - as son as the
> process ID is reused, the audit message is incorrect, which is not
> really acceptable in itself.
> > 
> But, you do, thats my point.  If a process exits, and another process starts up
> that happens to reuse the same pid, it can't just call recvmsg on the socket
> descriptor that the last process used for netlink messages and expect to get any
> data.
It _doesn't matter_ that I don't receive a response.  I have caused an operation in the kernel and the requested audit record is incorrect.  The audit subsystem needs to work even if - especially if - the userspace process is malicious.  The process might have wanted to simply cause a misleading audit record; or the operation (such as importing a key from supplied data) might not really need the response in order to achieve its effect.

> > > And
> > > in the event that happens, Audit should log a close event on the
> fd inquestion
> > > between the operations.
> > audit only logs explicitly requested operations, so an administrator
> that asks for crypto events does not automatically get any close
> events.  Besides, the audit record should be correct in the first
> place, instead of giving the admin a puzzle to decipher.
> I still don't see whats incorrect here.  If two processes wind up reusing a
> process id, thats audits problem to figure out, nothing elses.
If an operation attributed to user A is recorded by the kernel as being performed by user B, that is not an user problem.

> What exactly is
> the problem that you see involving netlink and audit here?  Compare whatever
> problem you see a crypto netlink protocol having in regards to audit to another
> netlink protocol (say rtnetlink), and explain to me why the latter doesn't have
> that issue as well.
AFAIK most netlink users in the kernel are not audited, and those that are typically only allow operations by system administrators.  And I haven't claimed that the other users are correct :)  Notably audit itself does not record as much information about the invoking process as we'd like because it is not available.

> > > Theres also the child process case, in which a child process might read
> > > responses from requests sent by a parent, and vice versa, since fork inherits
> > > file descriptors, but thats an issue inherent in any mechanism you use,
> > > including the character interface, so I'm not sure what the problem is
> > > there.
> > Actually that's not a problem with ioctl() because the response is
> written back _before_ ioctl() returns, so it is always provided to the
> original calling thread.
> > 
> > With the current design the parent and child share the key/session
> namespace after fork(), but operation results are always reliably and
> automatically provided to the thread that invoked the operation,
> without any user-space collaboration.

> Is that _really_ that important?  That the kernel return data in the same call
> that its made?
Not for audit; but yes, it is important.

1) performance: this is not ip(8), where no one cares if the operation runs 10ms or 1000ms.  Crypto is at least 2 operations per SSL record (which can be as little as 1 byte of application data), and users will care about the speed.  Batching more operations into a single request is impractical because it would require very extensive changes in users of the crypto libraries, and the generic crypto interfaces such as PKCS#11 don't natively support batching so it might not even be possible to express this in some libraries.

2) simplicity and reliability: you are downplaying the overhead and synchronization necessary (potentially among multiple processes!) to simply receive a response, but it is still enormous compared to the single syscall case.  Even worse, netlink(7) says "netlink is not a reliable protocol.  ... but may drop messages".  Would you accept such a mechanism to transfer "write data to file" operations?  "Compress data using AES" is much more similar to "write data to file" than to "change this aspect of kernel routing configuration" - it is an application-level service, not a way to communicate long-term parameters to a pretty independent subsystem residing in the kernel.
    Mirek
