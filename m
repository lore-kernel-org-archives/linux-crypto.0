From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 09:12:46 -0400
Message-ID: <200905130912.46965.jarod@redhat.com>
References: <200905111006.32675.jarod@redhat.com> <20090513110826.GA16406@hmsreliant.think-freely.org> <20090513113819.GA15662@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZEMNNi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 09:13:38 -0400
In-Reply-To: <20090513113819.GA15662@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2009 07:38:19 Herbert Xu wrote:
> On Wed, May 13, 2009 at 07:08:26AM -0400, Neil Horman wrote:
> >
> > Not really sure I agree with the logic here.  I agree that its pretty clear that
> > its major value is for quickly testing all the algorithms in a system, but
> > universally failing the loading of the module simply to save a few milliseconds
> > seems like a poor choice.  In so doing you create an alias effect, as jarod
> > noted between a non-existent module and a module that failed to load.  The
> > aliasing can be resolved, if you want to parse dmesg, but if speed is the issue
> > at hand, that parsing is a significant impact.  If you allow the module to load
> > properly, then for the cost of an rmmod, you can tell simply from the exit code
> > of modprobe:
> > 1) If the module was found 
> > 2) If the tests passed
> 
> As I said, tcrypt should no longer be used to test algorithms.
> Algorithms are tested as they load, with the result available
> in /proc/crypto.  tcrypt is just a relic that will be going away.
> 
> Do not rely on it.

Hm... FIPS has the requirement that we test all algs before we use any
algs, self-tests on demand before first use for each alg is
insufficient. At first blush, I'm not seeing how we ensure this
happens. How can we trigger a cbc(des3_ede) self-test from userspace?
I see that modprobe'ing des.ko runs the base des and des3_ede
self-tests, but modprobe'ing cbc.ko doesn't lead to any self-tests
being run.

-- 
Jarod Wilson
jarod@redhat.com
