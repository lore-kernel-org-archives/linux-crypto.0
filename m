From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in
	fips mode
Date: Tue, 5 May 2009 13:29:05 +0800
Message-ID: <20090505052905.GA14477@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au> <200905041456.59427.jarod@redhat.com> <20090505010847.GA13071@gondor.apana.org.au> <49FFB644.5030201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48586 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750994AbZEEF3K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 01:29:10 -0400
Content-Disposition: inline
In-Reply-To: <49FFB644.5030201@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2009 at 11:45:08PM -0400, Jarod Wilson wrote:
>
> Can't keep all the RFCs and SPs and whatnot straight in my head, and they
> aren't in front of me, but I thought I read that the basic counter increment
> routine wasn't mandated to be any specific way, the only mandate was to
> ensure unique values. Suggestions for how to do so were made though.

It doesn't matter what is or isn't specified for CTR, the thing
that we call "ctr" is the one that's used for RFC 3686, CCM, and
GCM.  It is completely pinned down and can be tested.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
