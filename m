From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Sat, 10 Aug 2013 16:17:56 +1000
Message-ID: <20130810061756.GA8036@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
 <20130806141612.GB364@oc8526070481.ibm.com>
 <20130808050139.GA9636@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55514@NASANEXD02C.na.qualcomm.com>
 <20130810012128.GB6549@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55E11@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58897 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576Ab3HJGSL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Aug 2013 02:18:11 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23D55E11@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 10, 2013 at 02:15:10AM +0000, Hsieh, Che-Min wrote:
>
> >> .  IOW we don't currently provide a kill mechanism to the user.
> 
> Good. Tcrypt.c and Testmgr is only a bad example?

Right, they can't really do anything other than waiting so they're
not a realistic example.

For a good example, check out the IPsec implementation in
net/ipv4/esp4.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
