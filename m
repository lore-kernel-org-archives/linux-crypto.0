From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-image-2.6.24-1-686: airo hang when loading because of aes
Date: Tue, 2 Jun 2009 15:12:34 +1000
Message-ID: <20090602051234.GA24468@gondor.apana.org.au>
References: <1243821770.14399.190.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 478166@bugs.debian.org, linux-crypto@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60542 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752745AbZFBFMj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 01:12:39 -0400
Content-Disposition: inline
In-Reply-To: <1243821770.14399.190.camel@deadeye>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ben Hutchings <ben@decadent.org.uk> wrote:
> 
> I believe geode_aes can be fixed by either (1) removing the MODULE_ALIAS
> declaration or (2) making the module initialisation function fail if the
> device is not present.  The latter behaviour is generally wrong for PCI
> drivers, but this device presumably cannot be hotplugged.

I was going to remove this alias but found that it was already
removed two years ago.  Please revise your theory based on this
new discovery :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
