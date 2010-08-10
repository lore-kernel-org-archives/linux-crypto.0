From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 15:37:23 -0400 (EDT)
Message-ID: <823121944.164121281469043745.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100810191018.GC9789@hmsreliant.think-freely.org>
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
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45717 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750760Ab0HJThe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 15:37:34 -0400
In-Reply-To: <20100810191018.GC9789@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@redhat.com> wrote:
> On Tue, Aug 10, 2010 at 02:19:59PM -0400, Miloslav Trmac wrote:
> > ----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> > It _doesn't matter_ that I don't receive a response.  I have caused
> an operation in the kernel and the requested audit record is
> incorrect.  The audit subsystem needs to work even if - especially if
> - the userspace process is malicious.  The process might have wanted
> to simply cause a misleading audit record; or the operation (such as
> importing a key from supplied data) might not really need the response
> in order to achieve its effect.
> 
> Why is it incorrect?  What would audit have recorded in the above case?  That a
> process attempted to recieve data on a descriptor that it didn't have open?
Again, the receive side _doesn't matter_.  At least by the formal semantics of netlink (not relying on the AFAIK undocumented synchronous implementation), there's a risk that the audit record about the _sender_ is incorrect (athough the inability to audit the identity of the recipient of the data might be a problem as well, I'm not sure).

> > > > > And
> > > > > in the event that happens, Audit should log a close event on the
> > > > > fd inquestion
> > > > > between the operations.
> > > > audit only logs explicitly requested operations, so an administrator
> > > that asks for crypto events does not automatically get any close
> > > events.  Besides, the audit record should be correct in the first
> > > place, instead of giving the admin a puzzle to decipher.
> > > I still don't see whats incorrect here.  If two processes wind up reusing a
> > > process id, thats audits problem to figure out, nothing elses.
> > If an operation attributed to user A is recorded by the kernel as
> being performed by user B, that is not an user problem.
> > 
> You're right, its also not a netlink problem, a cryptodev problem, or an ioctl
> problem.  Its an audit problem.
The user doesn't particularly care which subsystem maintainer is supposed to fix what :)  The reality seems to be that audit and netlink don't play well together.

> > > > > Theres also the child process case, in which a child process might read
> > > > > responses from requests sent by a parent, and vice versa, since fork inherits
> > > > > file descriptors, but thats an issue inherent in any mechanism you use,
> > > > > including the character interface, so I'm not sure what the problem is
> > > > > there.
> > > > Actually that's not a problem with ioctl() because the response is
> > > written back _before_ ioctl() returns, so it is always provided to the
> > > original calling thread.
> > > > 
> > > > With the current design the parent and child share the key/session
> > > namespace after fork(), but operation results are always reliably and
> > > automatically provided to the thread that invoked the operation,
> > > without any user-space collaboration.
> > 
> > > Is that _really_ that important?  That the kernel return data in the same call
> > > that its made?
> > Not for audit; but yes, it is important.
> > 
> I don't follow you here.  If its not important for audit to have synchrnous
> calls, why is it important at all?
There are two separate reasons to avoid netlink:

- Audit wants the operation to run in the process context of the caller.  This is not directly related to the question if there is one or >=2 syscalls.

- Operation invocation method.  Here one syscall is important for the reasons I have (performance, simplicity/reliability).  Making audit work well with netlink does not override these reasons in my opinion.

> > 1) performance: this is not ip(8), where no one cares if the
> operation runs 10ms or 1000ms.  Crypto is at least 2 operations per
> SSL record (which can be as little as 1 byte of application data), and
> users will care about the speed.  Batching more operations into a
> single request is impractical because it would require very extensive
> changes in users of the crypto libraries, and the generic crypto
> interfaces such as PKCS#11 don't natively support batching so it might
> not even be possible to express this in some libraries.
> > 
> 
> Ok, so is the assertion here that your kernel interface is restricted by other user space
> libraries?
The kernel interface is not "restricted" by other user-space libraries as such, but the only practical way for most user-space applications to use the kernel interface (within the next 5 years) is to modify existing user space libraries to use the kernel interface as a backend (there's just not enough manpower to port the whole world, and quite a few upstream maintainers are understandably reluctant to port their code to a Linux-specific interface).  In that sense, only the features that are _currently_ provided by user-space libraries matter when discussing performance and other impact on users.

> i.e. the operation has to be syncronous because anymore than 1
> syscall per operation has too much impact on performance?
We need to assume that this implementation will be benchmarked against pure user-space implementations (same as measuring SELinux impact compared to kernels that don't use it).  In that sense doubling the number of syscalls is not at all great.

> I ask
> because the
> recvmmsg (2 m's) will give you the exact same performance profile as ioctl.  You
> can let the kernel do all the batching with multiple calls to sendmsg, and get
> all the responses at once with a single additional call to recvmmsg.
I'm afraid that doesn't help because the userspace libraries will only request one operation at a time.
     Mirek
