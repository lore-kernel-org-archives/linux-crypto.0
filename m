From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips mode
Date: Wed, 29 Apr 2009 08:38:45 -0400
Message-ID: <200904290838.45896.jarod@redhat.com>
References: <200904282111.52074.jarod@redhat.com> <20090429103623.GB7227@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbZD2Mjd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 08:39:33 -0400
In-Reply-To: <20090429103623.GB7227@hmsreliant.think-freely.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 29 April 2009 06:36:23 Neil Horman wrote:
> On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> > I think this might have already been posted by Neil Horman, and
> > we already have it in the Red Hat Enterprise Linux 5.x kernels,
> > but in fips mode, we need to panic on the base cipher self-tests
> > failing as well as the later tests.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> I did post it:
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02307.html
> looks like it somehow just never made it to Linus.  Thanks for noticing, Jarod.

That part got committed, this is an additional piece, as I believe that
wasn't quite complete. This patch adds another check for the rc of
alg_test_cipher() (vs. only the check for alg_test_descs[i].test()).

-- 
Jarod Wilson
jarod@redhat.com
