From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 16:08:55 -0400
Message-ID: <201008101608.56349.sgrubb@redhat.com>
References: <20100810164045.GH3390@hmsreliant.think-freely.org> <201008101510.12638.sgrubb@redhat.com> <20100810191757.GD9789@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Miloslav Trmac <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0HJUJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 16:09:13 -0400
In-Reply-To: <20100810191757.GD9789@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, August 10, 2010 03:17:57 pm Neil Horman wrote:
> > There really is no comparison between what can be recorded synchronously
> > vs async.
> 
> Ok, so the $64 dollar question then: Do FIPS or Common Criteria require
> that you log more than whats in the netlink packet?

The TSF shall be able to include or exclude auditable events from the set
of audited events based on the following attributes:
a) object identity,
b) user identity,
c) host identity,
d) event type,
e) success of auditable security events, and
f) failure of auditable security events.

We need the ability to selectively audit based on uid for example. The netlink 
credentials doesn't have that. In many cases its the same as the loginuid, but 
its not in the skb.

There is also a table of additional requirements. Take the case of logging in. 
It says:   

Origin of the attempt (e.g., terminal identifier, source IP address). 

So, when someone changes their password and a hash function is called, we need 
the origin information.


 
> > > It sounds from previous emails that, generally speaking, you're worried
> > > that you want the task struct that current points to in the recvmsg
> > > call be guaranteeed to be the same as the task struct that current
> > > points to in the sendmsg call (i.e. no children (re)using the same
> > > socket descriptor, etc).
> > 
> > Not really, we are _hoping_ that the pid in the netlink credentials is
> > the same pid that sent the packet in the first place. From the time we
> > reference the pid out of the skb until we go hunting and locate the pid
> > in the list of tasks, it could have died and been replaced with another
> > task with different credentials. We can't take that risk.
> > 
> > > Can this be handled by using the fact that netlink is actually
> > > syncronous under the covers?
> > 
> > But its not or all the credentials would not be riding in the skb.
> 
> Not true.  It not guaranteed to, as you can do anything you want when you
> receive a netlink msg in the kernel.  But thats not to say that you can't
> enforce synchronization, and in so doing obtain more information.

Racy. 

 
> > > Can you ennumerate here what FIPS and Common Criteria mandate be
> > > presented in the audit logs?
> > 
> > Who did what to whom at what time and what was the outcome. In the case
> > of configuration changes we need the new and old values. However, we
> > need extra information to make the selective audit work right.
> 
> Somehow I doubt that FIPS mandates that audit messages include "who did
> what to whoom and what the result was" :).  Seriously, what do FIPS and
> common criteria require in an audit message?  I assume this is a partial
> list:

The TSF shall record within each audit record at least the following 
information:

a) Date and time of the event, type of event, subject identity (if 
applicable), and the outcome (success or failure) of the event; and
additional data as required. (Usually the object)

There are other implicit requirement such as selective audit that causes more 
information to be needed as well as the additional requirements clause.

-Steve
