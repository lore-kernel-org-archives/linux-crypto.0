From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: Tree for Mar 11 (powerpc build failure due to vmx
 crypto code)
Date: Thu, 12 Mar 2015 14:53:27 +1100
Message-ID: <20150312035327.GA14659@gondor.apana.org.au>
References: <20150311163558.6a09cfcc@canb.auug.org.au>
 <20150311154717.GA22169@roeck-us.net>
 <20150312012315.GA12660@gondor.apana.org.au>
 <5500FD4A.7050408@roeck-us.net>
 <20150312032829.GA13737@gondor.apana.org.au>
 <55010D44.7030900@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59163 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbCLDxe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 23:53:34 -0400
Content-Disposition: inline
In-Reply-To: <55010D44.7030900@roeck-us.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 08:51:32PM -0700, Guenter Roeck wrote:
>
> Yes, this helps.
> 
> Feel free to add
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing and the quick feedback.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
