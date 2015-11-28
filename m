From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] crypto: akcipher: add akcipher declarations
 needed by templates.
Date: Sat, 28 Nov 2015 15:10:35 +0800
Message-ID: <20151128071035.GA4474@gondor.apana.org.au>
References: <1448574808-11320-1-git-send-email-andrew.zaborowski@intel.com>
 <20151127131213.GA29590@gondor.apana.org.au>
 <CAOq732K-A3-ypsLavOJrT_ENuSM=zuriJo0F5bS1dNuhbeRTDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48755 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbK1HKl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Nov 2015 02:10:41 -0500
Content-Disposition: inline
In-Reply-To: <CAOq732K-A3-ypsLavOJrT_ENuSM=zuriJo0F5bS1dNuhbeRTDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 27, 2015 at 04:10:41PM +0100, Andrzej Zaborowski wrote:
>
> You're right there aren't any users that need this now but again is
> there any reason you prefer the inst->free approach?

Because this method is type-safe while the old way is not.

> BTW note the lines that assign inst->free in crypto/gcm.c end with
> commas which could lead to confusion.

Please send a patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
