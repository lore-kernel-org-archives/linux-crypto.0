From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/nx-842-{powerpc,pseries}: reduce chattiness of
 platform drivers
Date: Tue, 7 Jul 2015 22:01:37 +0800
Message-ID: <20150707140137.GA3351@gondor.apana.org.au>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224049.GE1712@linux.vnet.ibm.com>
 <1435887032.3665.1.camel@ellerman.id.au>
 <20150706170621.GA3578@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Dan Streetman <ddstreet@us.ibm.com>,
	linux-crypto@vger.kernel.org, gustavold@linux.vnet.ibm.com,
	linuxppc-dev@lists.ozlabs.org,
	"David S. Miller" <davem@davemloft.net>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52989 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbbGGOBr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 10:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20150706170621.GA3578@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 06, 2015 at 10:06:21AM -0700, Nishanth Aravamudan wrote:
>
> v2:
>   Rather than not loading, just reduce the verbosity

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
