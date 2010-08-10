From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 15:17:57 -0400
Message-ID: <20100810191757.GD9789@hmsreliant.think-freely.org>
References: <20100810164045.GH3390@hmsreliant.think-freely.org>
 <201008101414.24749.sgrubb@redhat.com>
 <20100810184544.GB9789@hmsreliant.think-freely.org>
 <201008101510.12638.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Miloslav Trmac <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0HJTWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 15:22:25 -0400
Content-Disposition: inline
In-Reply-To: <201008101510.12638.sgrubb@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 10, 2010 at 03:10:12PM -0400, Steve Grubb wrote:
> On Tuesday, August 10, 2010 02:45:44 pm Neil Horman wrote:
> > On Tue, Aug 10, 2010 at 02:14:24PM -0400, Steve Grubb wrote:
> > > On Tuesday, August 10, 2010 01:57:40 pm Neil Horman wrote:
> > > > > > I'm not so sure I follow.  how can you receive messages on a socket
> > > > > > in response to requests that were sent from a different socket. 
> > > > > > In the netlink multicast and broadcast case, sure, but theres no
> > > > > > need to use those.  I suppose you could exit a process, start
> > > > > > another process in which the pid gets reused, open up a subsequent
> > > > > > socket and perhaps confuse audit that way, but you're not going to
> > > > > > get responses to the requests that the previous process sent in
> > > > > > that case.
> > > > > 
> > > > > I don't even need to open a subsequent socket - as son as the process
> > > > > ID is reused, the audit message is incorrect, which is not really
> > > > > acceptable in itself.
> > > > 
> > > > But, you do, thats my point.  If a process exits, and another process
> > > > starts up that happens to reuse the same pid, it can't just call
> > > > recvmsg on the socket descriptor that the last process used for
> > > > netlink messages and expect to get any data.  That socket descriptor
> > > > won't be connected to the netlink service (or anything) anymore, and
> > > > you'll get an error from the kernel.
> > > 
> > > You are looking at it from the wrong end. Think of it from audit's
> > > perspective about how do you guarantee that the audit trail is correct?
> > > This has been discussed on linux-audit mail list before and the
> > > conclusion is you have very limited information to work with. By being
> > > synchronous the syscall, we get everything in the syscall record from
> > > the processes audit context.
> > 
> > What information do you need in the audit record that you might loose
> > accross two syscalls?
> 
> This is easier to show that explain. With Mirek's current patch:
> 
> type=SYSCALL msg=audit(1281013374.713:11671): arch=c000003e syscall=2 
> success=yes exit=3 a0=400b67 a1=2 a2=0 a3=7fff4daa1200 items=1 ppid=1352 
> pid=1375 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 
> tty=tty6 ses=3 comm="ncr-setkey" exe="/home/mitr/cryptodev-
> linux/userspace/ncr-setkey" subj=unconfined_u:unconfined_r:unconfined_t:s0-
> s0:c0.c1023 key=(null)
> type=CRYPTO_USERSPACE_OP msg=audit(1281013374.713:11671): 
> crypto_op=context_new ctx=0
> type=CWD msg=audit(1281013374.713:11671):  cwd="/root"
> type=PATH msg=audit(1281013374.713:11671): item=0 name="/dev/crypto" 
> inode=12498 dev=00:05 mode=020660 ouid=0 ogid=0 rdev=0a:3a 
> obj=system_u:object_r:device_t:s0
> type=CRYPTO_STORAGE_KEY msg=audit(1281013374.715:11672): key_size=16
> 
> 
> The netlink aproach, we only get the credentials that ride with the netlink 
> packet 
> 
> http://lxr.linux.no/#linux+v2.6.35/include/linux/netlink.h#L159
> 
> There really is no comparison between what can be recorded synchronously vs 
> async.
> 

Ok, so the $64 dollar question then: Do FIPS or Common Criteria require that you
log more than whats in the netlink packet?

> 
> > It sounds from previous emails that, generally speaking, you're worried that
> > you want the task struct that current points to in the recvmsg call be
> > guaranteeed to be the same as the task struct that current points to in the
> > sendmsg call (i.e. no children (re)using the same socket descriptor, etc). 
> 
> Not really, we are _hoping_ that the pid in the netlink credentials is the 
> same pid that sent the packet in the first place. From the time we reference 
> the pid out of the skb until we go hunting and locate the pid in the list of 
> tasks, it could have died and been replaced with another task with different 
> credentials. We can't take that risk.
> 
> 
> > Can this be handled by using the fact that netlink is actually syncronous
> > under the covers?
> 
> But its not or all the credentials would not be riding in the skb.
> 
Not true.  It not guaranteed to, as you can do anything you want when you
receive a netlink msg in the kernel.  But thats not to say that you can't
enforce synchronization, and in so doing obtain more information.

> 
> > Can you ennumerate here what FIPS and Common Criteria mandate be presented
> > in the audit logs?
> 
> Who did what to whom at what time and what was the outcome. In the case of 
> configuration changes we need the new and old values. However, we need extra 
> information to make the selective audit work right.
> 
Somehow I doubt that FIPS mandates that audit messages include "who did what to
whoom and what the result was" :).  Seriously, what do FIPS and common criteria
require in an audit message?  I assume this is a partial list:
* sending process id
* requested operation
* session id
* user id
* group id
* operation result

I see lots of other items in the above log message, but I'm not sure what else
is required.  Can you elaborate?

Neil

> -Steve
