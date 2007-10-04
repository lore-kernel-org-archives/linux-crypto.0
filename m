From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 18:00:34 +0800
Message-ID: <20071004100034.GA24517@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <20071004084818.GB23890@gondor.apana.org.au> <200710041131.56625.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2764 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754604AbXJDKAi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 06:00:38 -0400
Content-Disposition: inline
In-Reply-To: <200710041131.56625.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 04, 2007 at 11:31:56AM +0200, Andi Kleen wrote:
>
> I also think it is a bad idea to install the generic function by default -- it 
> increases the risk the user ends up with a unnecessary slow implementation

With Sebastian's change this won't be possible at all since
modprobe will load all aliases.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
