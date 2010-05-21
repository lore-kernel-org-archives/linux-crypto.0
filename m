From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] des_s390: remove des3_ede128 mode
Date: Fri, 21 May 2010 22:05:03 +1000
Message-ID: <20100521120503.GA30788@gondor.apana.org.au>
References: <1274354351.15679.12.camel@hal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:39718 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753353Ab0EUMFK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 May 2010 08:05:10 -0400
Content-Disposition: inline
In-Reply-To: <1274354351.15679.12.camel@hal>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 20, 2010 at 01:19:11PM +0200, Jan Glauber wrote:
> des_s390 implements support for 3DES with a 128 bit key. This mode is probably
> not used anywhere, less secure than 3DES with a 192 bit key and not
> implemented in the generic des version. Removing this mode seems to be low risk
> and will ease maintenance of the code.
> 
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

Both patches applied.  Thanks Jan!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
