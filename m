From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: tcrypt: do not exit on success in fips mode
Date: Wed, 13 May 2009 13:32:19 -0400
Message-ID: <20090513173219.GC16406@hmsreliant.think-freely.org>
References: <200905111006.32675.jarod@redhat.com> <200905130937.33449.jarod@redhat.com> <20090513140329.GA17863@gondor.apana.org.au> <200905131240.11615.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674AbZEMRcc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 13:32:32 -0400
Content-Disposition: inline
In-Reply-To: <200905131240.11615.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2009 at 12:40:10PM -0400, Jarod Wilson wrote:
> On Wednesday 13 May 2009 10:03:29 Herbert Xu wrote:
> > On Wed, May 13, 2009 at 09:37:32AM -0400, Jarod Wilson wrote:
> > > 
> > > The latter option is more or less what the patch at the start of this
> > > thread did, although via a param to tcrypt, not keying off the fips
> > > flag. If I were to modify the patch to drop the mod param usage, and
> > > instead key off the fips flag to not exit, would that be acceptable
> > > for committing until such time as the userspace interface is ready?
> > 
> > Yes that sounds like the way to go.
> 
> Okay, here it is.
> 
> At present, the tcrypt module always exits with an -EAGAIN upon
> successfully completing all the tests its been asked to run. In fips
> mode, integrity checking is done by running all self-tests from the
> initrd, and its much simpler to check the ret from modprobe for
> success than to scrape dmesg and/or /proc/crypto. Simply stay
> loaded, giving modprobe a retval of 0, if self-tests all pass and
> we're in fips mode.
> 
> A side-effect of tracking success/failure for fips mode is that in
> non-fips mode, self-test failures will return the actual failure
> return codes, rather than always returning -EAGAIN, which seems more
> correct anyway.
> 
> The tcrypt_test() portion of the patch is dependent on my earlier
> pair of patches that skip non-fips algs in fips mode, at least to
> achieve the fully intended behavior.
> 
> Nb: testing this patch against the cryptodev tree revealed a test
> failure for sha384, which I have yet to look into...
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
