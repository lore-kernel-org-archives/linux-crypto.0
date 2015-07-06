From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] drivers/nx-842: reduce verbosity of logging
Date: Mon, 6 Jul 2015 16:34:11 +0800
Message-ID: <20150706083411.GB20800@gondor.apana.org.au>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35112 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbGFIeR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 04:34:17 -0400
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 03:38:00PM -0700, Nishanth Aravamudan wrote:
> Currently, on a LPAR with the nx-842 device disabled, the following
> messages are emitted:

Patches 1-3 applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
