From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] HIFN: make Kconfig option depend on PCI
Date: Mon, 12 Nov 2007 21:58:11 +0800
Message-ID: <20071112135811.GA23624@gondor.apana.org.au>
References: <1194874310.5656.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1586 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758685AbXKLN6O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 08:58:14 -0500
Content-Disposition: inline
In-Reply-To: <1194874310.5656.10.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 12, 2007 at 01:31:49PM +0000, Jan Glauber wrote:
> The HIFN driver is currently selectable on s390 but wont compile.
> Since it looks like HIFN needs PCI make the Kconfig dependent on PCI,
> which is not available on s390.

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
