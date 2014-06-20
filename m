From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add 2 missing __exit_p
Date: Sat, 21 Jun 2014 02:41:19 +0800
Message-ID: <20140620184119.GE3169@gondor.apana.org.au>
References: <20140529095435.72cb6b6e@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40693 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966182AbaFTSl0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:41:26 -0400
Content-Disposition: inline
In-Reply-To: <20140529095435.72cb6b6e@endymion.delvare>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 29, 2014 at 09:54:35AM +0200, Jean Delvare wrote:
> References to __exit functions must be wrapped with __exit_p.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
> Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
