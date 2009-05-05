From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in fips mode
Date: Tue, 5 May 2009 09:04:49 -0400
Message-ID: <200905050904.49945.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <49FFB644.5030201@redhat.com> <20090505052905.GA14477@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZEENFi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 09:05:38 -0400
In-Reply-To: <20090505052905.GA14477@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 05 May 2009 01:29:05 Herbert Xu wrote:
> On Mon, May 04, 2009 at 11:45:08PM -0400, Jarod Wilson wrote:
> >
> > Can't keep all the RFCs and SPs and whatnot straight in my head, and they
> > aren't in front of me, but I thought I read that the basic counter increment
> > routine wasn't mandated to be any specific way, the only mandate was to
> > ensure unique values. Suggestions for how to do so were made though.
> 
> It doesn't matter what is or isn't specified for CTR, the thing
> that we call "ctr" is the one that's used for RFC 3686, CCM, and
> GCM.  It is completely pinned down and can be tested.

There are two different "can be tested" contexts here. I completely
agree that ctr(aes) is testable within the tcrypt/testmgr context,
and sent a patch for such in this thread yesterday. The other
context is FIPS CAVS testing, which NIST is saying can't be done,
and I was attempting to understand why, which probably only served
to muddy the waters. We can definitely do self-tests for ctr(aes).

-- 
Jarod Wilson
jarod@redhat.com
