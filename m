From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for
 nx842
Date: Tue, 22 Sep 2015 22:42:19 +0800
Message-ID: <20150922144219.GA12943@gondor.apana.org.au>
References: <1442707362.6178.11.camel@hbabu-laptop>
 <20150921142607.GA2405@gondor.apana.org.au>
 <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
 <20150922122117.GA11522@gondor.apana.org.au>
 <CALZtONBYYTnRE6FyQKVL8kyAAb8BuXJzyGA5mYNHiXtSNcDv9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41427 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbbIVOma (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 10:42:30 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONBYYTnRE6FyQKVL8kyAAb8BuXJzyGA5mYNHiXtSNcDv9Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 22, 2015 at 10:39:53AM -0400, Dan Streetman wrote:
>
> hmm, that's true, and that would simplify the code a lot!  No need for
> the header anymore.  But, since the sw driver is sooo much slower, it
> would be important to be able to communicate the alignment and size
> limits to the caller of the crypto compression api, via cra_alignmask
> and cra_blocksize (for minimum size), as well as new fields for max
> size (maybe cra_maxsize) and buffer length multiple - i.e. the buffer
> length must be a multiple of N (maybe cra_blockmult or cra_blockmodulo
> or something).  Otherwise callers would get unexpectedly slow
> performance if they use the wrong alignment or size.

Right.  So who actually uses this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
