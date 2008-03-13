From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Link order of the AES-module(s)
Date: Thu, 13 Mar 2008 19:39:49 +0800
Message-ID: <20080313113949.GB8393@gondor.apana.org.au>
References: <20080122222012.GA6920@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52659 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbYCMLjw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 07:39:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1JZlmo-0007nU-7k
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2008 22:39:50 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1JZlmn-0002Eu-00
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2008 19:39:49 +0800
Content-Disposition: inline
In-Reply-To: <20080122222012.GA6920@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 22, 2008 at 11:20:12PM +0100, Sebastian Siewior wrote:
> Hello Herbert,
> 
> this is just for the protocol. If you build the two aes modules into
> the kernel (1x asm + 1x generic) than the asm module is initialized
> before the generic one and even before the crypto API itself. This was
> allready the case before I started to dig around :)
> This is currently not a problem because the module itself isn't used at
> that time and the init code doesn't do much.

Right as long as the data structures for registering algorithms
do not require initialisations this is OK.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
