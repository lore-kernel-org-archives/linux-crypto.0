From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 14:45:06 +0800
Message-ID: <20160624064506.GA17229@gondor.apana.org.au>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
 <20160624062316.GA16985@gondor.apana.org.au>
 <20160624063644.GA21443@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com,
	linux-bluetooth@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50088 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcFXGpN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 02:45:13 -0400
Content-Disposition: inline
In-Reply-To: <20160624063644.GA21443@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 07:36:44AM +0100, Salvatore Benedetto wrote:
>
> 
> The patch was based on the current tree. I just pulled.
> There is not point in moving to lib because bluetooth is
> about to be converted to kpp. 
> That patch I believe will go up the bluetooth tree, so
> my suggestion is to simply accept that I fail to properly
> name that symbol.
> 
> Renaming the symbol in net/bluetooth/ecc which I think will conflict
> with the patch where I remove it completely which, again, I believe
> will go up the BT tree.

OK I will have no option but to revert your patches then.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
