From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Wed, 11 Aug 2010 08:09:10 -0400 (EDT)
Message-ID: <1017757280.204271281528550695.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1488103333.203081281527737237.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46994 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751208Ab0HKMJU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 08:09:20 -0400
In-Reply-To: <1488103333.203081281527737237.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> On Tue, Aug 10, 2010 at 10:06:05PM -0400, Miloslav Trmac wrote:
> > ----- "Neil Horman" <nhorman@redhat.com> wrote:
> > > Ok, well, I suppose we're just not going to agree on this.  I don't know how
> > > else to argue my case, you seem to be bent on re-inventing the wheel instead of
> > > using what we have.  Good luck. 
> > Well, I basically spent yesterday learning about netlink and looking
> how it can or can not be adapted.  I still see drawbacks that are not
> balanced by any benefits that are exclusive to netlink.
> > 
> > As a very unscientific benchmark, I modified a simple example
> program to add a simple non-blocking getmsg(..., MSG_PEEK) call on a
> netlink socket after each encryption operation; this is only a lower
> bound on the overhead because no copying of data between userspace and
> the skbuffer takes place and zero copy is still available.  With
> cbc(aes), encrypting 256 bytes per operation, the throughput dropped
> from 156 MB/s to 124 MB/s (-20%); even with 32 KB per operation there
> is still a decrease from 131 to 127 MB/s (-2.7%).
> > 
> > If I have to do a little more programming work to get a permanent
> 20% performance boost, why not?
> > 
> Because your test is misleading.  By my read, all you did was add an extra
> syscall to the work your already doing.  The best case result in such a
> test is equivalent performance if the additional syscall takes near-zero time.
> The test fails to take into account the change in programming model that you can
> use in the kernel when you make the operation asynchronous.  What happens to
> your test if you change the cipher your using to an asynchronous form
> (ablkcipher or ahash)?  When you do that, you no longer need to stall the send
> routine while the crypto operation completes.
User space won't be in practice able to use such a programming model.  In the vast majority of cases we do not have control over the fact that the caller is asking for one operation at a time, and does not expect the function call to return until the operation finishes.

> > How about this: The existing ioctl (1-syscall interface) remains,
> using a very minimal fixed header (probably just a handle and perhaps
> algorithm ID) and using the netlink struct nlattr for all other
> attributes (both input and output, although I don't expect many output
> attribute).
> > 
> > - This gives us exactly the same flexibility benefits as using netlink directly.
> > - It uses the 1-syscall, higher performance, interface.
> > - The crypto operations are run in process context, making it
> possible to implement zero-copy operations and reliable auditing.
> > - The existing netlink parsing routines (both in the kernel and in
> libnl) can be used; formatting routines will have to be rewritten, but
> that's the easier part.

> This would be better, but it really just seems like you're re-inventing the
> wheel at this point.  As noted above, I think your performance comparison fails
> to account for advantages that can be leveraged in an asynchronous model.
I have already previously argued that these advantages are not beneficial in the usual case, whereas the costs are paid always.  I'm trying to reuse as much as the wheel as is possible, without including the rectangular parts as well.

> The
> zero-copy argument is misleading, as both a single syscall and a multiple
> syscall are not zero copy, a copy_from_user and copy_to_user is required in
> both cases.
No, we can resolve user-space addresses into page pointers using get_user_pages() and build scatterlists without any copy_{from,to}_user.  See __get_userbuf() in patch 2/4.

> Also, now that I'm poking about in it, how do you intend to support the async
> interfaces?
The patch already uses ablkcipher/ahash, right now by simply blocking the calling process until the operation is complete.

> I assume that, in the kernel your cryptodev code,
> if it used the 1 syscall interface would setup a lock, and block until the
> operation was complete?
In the future "truly async interface", something like that would happen.

>  If thats the case, and the actual crypto operation were
> handled by an alternate task (see the cryptd module), wouldn't you be loosing
> soe modicum of audit information as well, just as you would using the netlink
> interface?
No, both the "init async" and "get async results" operations are implemented in kernel space by running in task context of the caller, so all audit information is reliably available in both cases.  Whether the operation is actually performed by the same thread, a different kernel thread, or a hardware accelerator is an internal implementation detail of the kernel that is not relevant for auditing.
    Mirek
