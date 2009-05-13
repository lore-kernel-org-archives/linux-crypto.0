From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 21:38:19 +1000
Message-ID: <20090513113819.GA15662@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <200905121602.45960.jarod@redhat.com> <20090513003727.GA12788@localhost.localdomain> <20090513013050.GA6545@gondor.apana.org.au> <20090513110826.GA16406@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42250 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbZEMLiX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 07:38:23 -0400
Content-Disposition: inline
In-Reply-To: <20090513110826.GA16406@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2009 at 07:08:26AM -0400, Neil Horman wrote:
>
> Not really sure I agree with the logic here.  I agree that its pretty clear that
> its major value is for quickly testing all the algorithms in a system, but
> universally failing the loading of the module simply to save a few milliseconds
> seems like a poor choice.  In so doing you create an alias effect, as jarod
> noted between a non-existent module and a module that failed to load.  The
> aliasing can be resolved, if you want to parse dmesg, but if speed is the issue
> at hand, that parsing is a significant impact.  If you allow the module to load
> properly, then for the cost of an rmmod, you can tell simply from the exit code
> of modprobe:
> 1) If the module was found 
> 2) If the tests passed

As I said, tcrypt should no longer be used to test algorithms.
Algorithms are tested as they load, with the result available
in /proc/crypto.  tcrypt is just a relic that will be going away.

Do not rely on it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
