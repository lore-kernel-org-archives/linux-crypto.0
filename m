From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 09:16:02 -0400
Message-ID: <20100320131602.GA30349@hmsreliant.think-freely.org>
References: <20100320010849.GA30654@gondor.apana.org.au>
 <20100320042103.GB5127@jenkins>
 <20100320042434.GA32294@gondor.apana.org.au>
 <20100319.222325.260105122.davem@davemloft.net>
 <20100320122959.GA1930@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, brandon@ifup.org,
	linux-crypto@vger.kernel.org, rusty@rustcorp.com.au
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43387 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0CTNQN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Mar 2010 09:16:13 -0400
Content-Disposition: inline
In-Reply-To: <20100320122959.GA1930@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Mar 20, 2010 at 08:29:59PM +0800, Herbert Xu wrote:
> On Fri, Mar 19, 2010 at 10:23:25PM -0700, David Miller wrote:
> >
> > I hear what you're saying Herbert, but thinking about this a bit I
> > really think we should make this situation work instead of fail.
> 
> I think the initial report perhaps painted this in a slight
> different fashion than what it really is.  The code that was
> looping in module.c is not trying to load libcrc32c, but rather
> it is trying to get a reference on the already-loaded libcrc32c
> module.
> 
> AFAICS the only way to make it "work" would be to reload the
> module in question when we can't get a reference on it.  But
> that would entail recursively loading a module during the process
> of loading another module.
> 
> Rusty can chime in on whether this is doable.
> 
> I think I have a good guess as to why this problem is occuring
> for Brandon.  It is probably the result of two near-simultaneous
> modprobes, one issued against libcrc32c and one against bnx2x.
> 
> The libcrc32c module is partially loaded to the point of invoking
> its init function, which then tries to modprobe crc32c.
> 
> However, before this starts the modprobe on bnx2x is already in
> progression.  When bnx2x's loading tries to acquire a reference
> on libcrc32c which it depends on, we hit the dead-lock.
> 
> So if Suse were doing some kind of parallel booting where multiple
> modules may be loaded together then this could occur.
> 
> The easiest solution again would be for modprobe(8) to block the
> loading of bnx2x because the module that it depends on libcrc32c
> hasn't yet finished loading.
> 
> I'm open to a kernel solution too if anyone has suggestions.
> 

FWIW, this sounds like a regression in modprobe to me.  A few years ago I fixed
a deadlock condition in the netfilter conntrack code that was tickled by
parallel rmmod's and modprobes.  modprobe would take file locks on modules, and
if the same module was getting rmmodded and modprobed in parallel we'd wind up
with a deadlock.  I fixed it by making the default modprobe -r behavior to be
non-blocking (which is the same as rmmod).  That commit is here:
http://git.kernel.org/?p=utils/kernel/module-init-tools/module-init-tools.git;a=commit;h=b45a24e9c89a14baf63bffe0a9ff04c1c1bffb29

Later, in late 2009, That behavior was reverted:
http://git.kernel.org/?p=utils/kernel/module-init-tools/module-init-tools.git;a=commit;h=b45a24e9c89a14baf63bffe0a9ff04c1c1bffb29

withuot consideration of the consequences, of which this sounds like one.

JCM I think is working on fixing the problem in a sane way.  I'd suggested that
he reapply the patch, but IIRC he told me that hes planning on trying to fix it
by removing the file locking on the modules in userspace entirely, which I think
is also reasonable.

As a test, you might try massaging my old patch above into the latest
module-init-tools to see if it makes the problem go away.  Note, the result of
this will be that either the modprobe or rmmod will fail and will need to be
retried, but its non-fatal, and a retry is usually successful, as it moves the
rmmod and modprobe further apart in time.

Regards
Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
