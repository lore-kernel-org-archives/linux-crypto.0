From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Thu, 18 Feb 2016 09:17:04 +0100
Message-ID: <4580306.arupsYiYbb@positron.chronox.de>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu> <56C50725.6080408@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Thomas D." <whissi@whissi.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C50725.6080408@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 18. Februar 2016, 00:49:57 schrieb Thomas D.:

Hi Thomas,

> Hi
> 
> Willy Tarreau wrote:
> >> Is there a dependency I missed in 4.1? I don't really see anything that
> >> could have gone wrong there.
> > 
> > Or maybe Thomas can run a bisect ?
> 
> I cannot follow. I did a bisect between 4.1.7 and 4.1.8 as I have written
> 
> in my first mail. The bad commit was:

That breakage was expected and forcasted by Milan Broz a couple of days ago on 
this mailing list. The referenced patch covered a bug that must have been 
fixed but introduced a regression for backwards compatibility. Since then, 
this regression was fixed.



> > commit 0571ba52a19e18a1c20469454231eef681cb1310
> > Author: Herbert Xu
> > Date:   Wed Dec 30 11:47:53 2015 +0800
> > 
> >     crypto: af_alg - Disallow bind/setkey/... after accept(2)
> >     
> >     [ Upstream commit c840ac6af3f8713a71b4d2363419145760bd6044 ]
> >     
> >     Each af_alg parent socket obtained by socket(2) corresponds to a
> >     tfm object once bind(2) has succeeded.  An accept(2) call on that
> >     parent socket creates a context which then uses the tfm object.
> >     
> >     Therefore as long as any child sockets created by accept(2) exist
> >     the parent socket must not be modified or freed.
> >     
> >     This patch guarantees this by using locks and a reference count
> >     on the parent socket.  Any attempt to modify the parent socket will
> >     fail with EBUSY.
> 
> bisect log:
> > Bisecting: 114 revisions left to test after this (roughly 7 steps)
> > [3a1e81ad84e4d880b00ecf7ad8d03b9b772ddfa7] crypto: algif_hash - Fix race
> > condition in hash_check_key Bisecting: 56 revisions left to test after
> > this (roughly 6 steps)
> > [d6341753c418d3699948290d8c0b9d9dc78bd209] udf: Prevent buffer overrun
> > with multi-byte characters Bisecting: 28 revisions left to test after
> > this (roughly 5 steps)
> > [13aedd784b84cb7d8a3bb835941d80e99f5c796e] dmaengine: dw: fix cyclic
> > transfer setup Bisecting: 14 revisions left to test after this (roughly 4
> > steps)
> > [664ecf4f243bac17065cd9878790d40a592e2f3d] zram/zcomp: use GFP_NOIO to
> > allocate streams Bisecting: 7 revisions left to test after this (roughly
> > 3 steps)
> > [0571ba52a19e18a1c20469454231eef681cb1310] crypto: af_alg - Disallow
> > bind/setkey/... after accept(2) Bisecting: 3 revisions left to test after
> > this (roughly 2 steps)
> > [2c641f5b0c8e87d43235ce39890bcc4d0c7cd2fb] memcg: only free spare array
> > when readers are done Bisecting: 1 revision left to test after this
> > (roughly 1 step)
> > [0e19e24c3fe0abde8e2c5f4543616a251ccea6bf] kernel/panic.c: turn off locks
> > debug before releasing console lock Bisecting: 0 revisions left to test
> > after this (roughly 0 steps)
> > [bc24ac15b0746172a8f603171352aa54abcf7c78] printk: do cond_resched()
> > between lines while outputting to consoles
> > 0571ba52a19e18a1c20469454231eef681cb1310 is the first bad commit
> 
> -Thomas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
