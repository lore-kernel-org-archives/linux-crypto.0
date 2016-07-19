From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Automatically load the vmx_crypto module if supported
Date: Tue, 19 Jul 2016 11:59:39 +0800
Message-ID: <20160719035939.GA20847@gondor.apana.org.au>
References: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
 <20160718102253.GA13780@gondor.apana.org.au>
 <87fur6phj0.fsf@@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alastair@au1.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
	davem@davemloft.net, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39846 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbcGSEA2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jul 2016 00:00:28 -0400
Content-Disposition: inline
In-Reply-To: <87fur6phj0.fsf@@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 19, 2016 at 11:01:55AM +1000, Michael Ellerman wrote:
>
> Can you please ask for an ack before merging arch patches?
> 
> That's a 70 line powerpc patch and a 6 line crypto patch. It has no
> reviews and no acks. I would have preferred it if we could take it via
> the powerpc tree.

Sorry, I'll delete them from the crypto tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
