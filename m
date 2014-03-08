From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106 - fixed whitespace
Date: Fri, 07 Mar 2014 17:52:48 -0800
Message-ID: <1394243568.27116.151.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
	 <1394239315.27116.142.camel@schen9-DESK>
	 <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973760@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaCHBxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Mar 2014 20:53:13 -0500
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973760@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-03-07 at 19:40 -0600, McCaffrey, Timothy M wrote:
> You need to set the key length in the aes_key_expanded structure either explicitly or use the aesni_set_key function.
> 
> The asm code expects only valid values in the structure (16, 24 or 32).
> 
> If the encrypt/decrypt is called without setting the key, you get garbage (and an error in this case).  Perhaps the glue code needs to double check the keysize before calling the asm code?
> 
> 	- Tim
> 

Right, your new function actually will look for the keylen which was not
needed before.  

I think it will be a good idea to double check the keysize has valid
value before calling the asm code or in the asm code itself. 

Tim
