From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:45:44 -0400
Message-ID: <20100810184544.GB9789@hmsreliant.think-freely.org>
References: <20100810164045.GH3390@hmsreliant.think-freely.org>
 <1588375167.142801281459463292.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <20100810175740.GC3072@hmsreliant.think-freely.org>
 <201008101414.24749.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Miloslav Trmac <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab0HJSuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:50:03 -0400
Content-Disposition: inline
In-Reply-To: <201008101414.24749.sgrubb@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 10, 2010 at 02:14:24PM -0400, Steve Grubb wrote:
> On Tuesday, August 10, 2010 01:57:40 pm Neil Horman wrote:
> > > > I'm not so sure I follow.  how can you receive messages on a socket in
> > > > response to requests that were sent from a different socket.  In the
> > > > netlink multicast and broadcast case, sure, but theres no need to use
> > > > those.  I suppose you could exit a process, start another process in
> > > > which the pid gets reused, open up a subsequent socket and perhaps
> > > > confuse audit that way, but you're not going to get responses to the
> > > > requests that the previous process sent in that case.
> > > 
> > > I don't even need to open a subsequent socket - as son as the process ID
> > > is reused, the audit message is incorrect, which is not really
> > > acceptable in itself.
> > >
> > > 
> > 
> > But, you do, thats my point.  If a process exits, and another process
> > starts up that happens to reuse the same pid, it can't just call recvmsg
> > on the socket descriptor that the last process used for netlink messages
> > and expect to get any data.  That socket descriptor won't be connected to
> > the netlink service (or anything) anymore, and you'll get an error from
> > the kernel.
> 
> You are looking at it from the wrong end. Think of it from audit's perspective 
> about how do you guarantee that the audit trail is correct? This has been 
> discussed on linux-audit mail list before and the conclusion is you have very 
> limited information to work with. By being synchronous the syscall, we get 
> everything in the syscall record from the processes audit context.
> 

What information do you need in the audit record that you might loose accross
two syscalls?  It sounds from previous emails that, generally speaking, you're
worried that you want the task struct that current points to in the recvmsg call
be guaranteeed to be the same as the task struct that current points to in the
sendmsg call (i.e. no children (re)using the same socket descriptor, etc).  Can
this be handled by using the fact that netlink is actually syncronous under the
covers?  i.e. when you send a message to a netlink service, there is no reason
that all the relevant crypto ops in the request can't be completed in the
context of that call, as long as all your crypto operations are themselves
synchronous.  By the time you are done with the sendmsg call, you can know if
your entire crypto op is successfull.  The only thing that isn't complete is the
retrieval of the completed operations data from the kernel.  Is that enough to
make an audit log entry in the same way that an ioctl would?

> The audit logs require non-repudiation. It cannot be racy or stitch together 
> possibly wrong events. Audit logs can and do wind up in court and we do not 
> want problems with any part of the system.
> 
> > > > And in the event that happens, Audit should log a close event on the fd
> > > > inquestion between the operations.
> > > 
> > > audit only logs explicitly requested operations, so an administrator that
> > > asks for crypto events does not automatically get any close
> > > events.  Besides, the audit record should be correct in the first place,
> > > instead of giving the admin a puzzle to decipher.
> > 
> > I still don't see whats incorrect here.  If two processes wind up reusing a
> > process id, thats audits problem to figure out, nothing elses
> 
> True, but that is the point of this exercise - meeting common criteria and 
> FIPS. They both have rules about what the audit logs should present and the 
> assuarnce that the information is correct and not racy.
> 

Can you ennumerate here what FIPS and Common Criteria mandate be presented in
the audit logs? 

Neil

> > .  What exactly is the problem that you see involving netlink and audit
> > here?  Compare whatever problem you see a crypto netlink protocol having
> > in regards to audit to another netlink protocol (say rtnetlink), and
> > explain to me why the latter doesn't have that issue as well.
> 
> That one is not security sensitive. Nowhere in any protection profile does it 
> say to audit that.
> 
> -Steve
