From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: initialize entry len for null input in crypto
 hash sg list walk
Date: Tue, 12 Aug 2014 20:00:00 +0800
Message-ID: <20140812120000.GA15066@gondor.apana.org.au>
References: <1405034288.2970.647.camel@schen9-DESK>
 <20140723130945.GA29178@gondor.apana.org.au>
 <1406131665.2970.820.camel@schen9-DESK>
 <20140801141816.GA14651@gondor.apana.org.au>
 <1407789120.2583.2.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53741 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaHLMAX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Aug 2014 08:00:23 -0400
Content-Disposition: inline
In-Reply-To: <1407789120.2583.2.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 11, 2014 at 01:32:00PM -0700, Tim Chen wrote:
>
> Thanks Herbert.  I was out on vacation for a while.  Wonder if
> you are planning to pick up the multi-buffer SHA1 series for 3.17
> kernel?

Sorry it's too late for that but I'm planning in on putting it
into cryptodev as soon as rc1 is released.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
