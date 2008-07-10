From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware accelerated CRC32c algorithm.]
Date: Thu, 10 Jul 2008 20:52:36 +0800
Message-ID: <20080710125236.GA25895@gondor.apana.org.au>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com> <1215512754.2906.23.camel@localhost.localdomain> <20080709074153.GA11927@gondor.apana.org.au> <1215689169.5257.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: johnpol@2ka.mipt.ru, davem@davemloft.net, chaapala@cisco.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	arjan@linux.intel.com
To: austin zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34113 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbYGJMwy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 08:52:54 -0400
Content-Disposition: inline
In-Reply-To: <1215689169.5257.7.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 10, 2008 at 07:26:09AM -0400, austin zhang wrote:
>
> > So my plan is to convert them and then remove the libcrc32c
> > interface completely.
> Because libcrc32c can be a module in original implemetation, so for
> those other routine which call crc32c_le directly, this may not work for
> them?  

I've looked at them all (there are only three users of crc32c
in the tree) and they can all be converted across.  I'll wait
for ahash to hit Linus's tree before starting the conversion.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
