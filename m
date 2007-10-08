From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN 795x driver.
Date: Mon, 8 Oct 2007 10:57:05 +0800
Message-ID: <20071008025705.GA31959@gondor.apana.org.au>
References: <20071001124822.GA16017@2ka.mipt.ru> <20071001202214.GA15421@Chamillionaire.breakpoint.cc> <20071002105431.GA28803@2ka.mipt.ru> <20071008011926.GD31206@securecomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
To: David McCullough <David_Mccullough@securecomputing.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1454 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbXJHC5P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 22:57:15 -0400
Content-Disposition: inline
In-Reply-To: <20071008011926.GD31206@securecomputing.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 08, 2007 at 11:19:26AM +1000, David McCullough wrote:
> 
> I have to agree, you cannot queue crypto forever (no drops),  it's too
> slow.

This is not what the backlog does.  The backlog guarantees that
each tfm can queue at least one request if necessary.  This is
needed for users such as dm-crypt.

> There is a similar queue in OCF and unless you put a limit on it's size
> you can easily run you system out of memory.  The Q needs a configurable
> limit of some kind.  Flood ping an ipsec tunnel and the crypto is where
> all the data will bank up.

This is how it works here too.  A queue with a configurable limit
plus the backlog which is bounded by the number of tfm objects.

> If I understand what you are asking Evgeniy to do,  you will be
> putting the logic for managing the Q into every driver.  Sounds like
> something that needs to move up a level ?

No the logic is in the helpers.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
