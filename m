From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: [1/1] HIFN 795x driver.
Date: Mon, 8 Oct 2007 11:19:26 +1000
Message-ID: <20071008011926.GD31206@securecomputing.com>
References: <20071001124822.GA16017@2ka.mipt.ru> <20071001202214.GA15421@Chamillionaire.breakpoint.cc> <20071002105431.GA28803@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:39712 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbXJHBR1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 21:17:27 -0400
Content-Disposition: inline
In-Reply-To: <20071002105431.GA28803@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Evgeniy Polyakov lays it down ...
...
> >   ACRYPTO_TYPE_AES_??? depending on ctx->current_key_len. Good.
> > - You need a software queue in case your HW queue is full and you receive
> >   a requests which you may not drop. Currently you don't consider
> >   CRYPTO_TFM_REQ_MAY_BACKLOG (it is fine if you can process all requests
> >   no mater what).
> 
> That is what I do not like, but will implement.

I have to agree, you cannot queue crypto forever (no drops),  it's too
slow.

There is a similar queue in OCF and unless you put a limit on it's size
you can easily run you system out of memory.  The Q needs a configurable
limit of some kind.  Flood ping an ipsec tunnel and the crypto is where
all the data will bank up.

If I understand what you are asking Evgeniy to do,  you will be
putting the logic for managing the Q into every driver.  Sounds like
something that needs to move up a level ?

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
