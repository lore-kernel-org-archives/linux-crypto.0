From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for Mar 11 (powerpc build failure due to vmx
 crypto code)
Date: Thu, 12 Mar 2015 12:27:32 -0300
Message-ID: <20150312152732.GA8966@bluepex.com>
References: <20150311163558.6a09cfcc@canb.auug.org.au>
 <20150311154717.GA22169@roeck-us.net>
 <20150312012315.GA12660@gondor.apana.org.au>
 <5500FD4A.7050408@roeck-us.net>
 <20150312032829.GA13737@gondor.apana.org.au>
 <55010D44.7030900@roeck-us.net>
 <20150312035327.GA14659@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Guenter Roeck <linux@roeck-us.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43340 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbbCLP1k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 11:27:40 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Thu, 12 Mar 2015 12:27:36 -0300
Content-Disposition: inline
In-Reply-To: <20150312035327.GA14659@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


A little bit later, but thank you guys for fix it.

The issue seems happens just in BE machines, and  using _GLOBAL instead
.globl seems fix it so build the correct vmx-crypto.ko. On LE it does
not happens.




On Thu, Mar 12, 2015 at 02:53:27PM +1100, Herbert Xu wrote:
> On Wed, Mar 11, 2015 at 08:51:32PM -0700, Guenter Roeck wrote:
> >
> > Yes, this helps.
> > 
> > Feel free to add
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Thanks for testing and the quick feedback.
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
