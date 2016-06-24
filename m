From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 14:25:50 +0800
Message-ID: <20160624062550.GA17033@gondor.apana.org.au>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
 <20160624062342.GA2506@sbenedet-virtual-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38026 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbcFXGZz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 02:25:55 -0400
Content-Disposition: inline
In-Reply-To: <20160624062342.GA2506@sbenedet-virtual-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 07:23:42AM +0100, Salvatore Benedetto wrote:
>
> We do use the symbol in question, and I'm pretty sure we use
> all of crypto/ecc.c. I was going to send a patch where
> I remove the net/bluetooth/ecc.c

I see.  In that case either rename the symbols in net/bluetooth/ecc.c
since it's going away or just do the bluetooth conversion.

Please send any new patches based on the current tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
