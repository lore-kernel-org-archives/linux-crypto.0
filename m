From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 9/9] Disable ccm and ccm4309 in fips mod
Date: Thu, 6 Nov 2014 23:03:26 +0800
Message-ID: <20141106150326.GC3300@gondor.apana.org.au>
References: <20141028175146.GA18467@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56991 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKFPDd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 10:03:33 -0500
Content-Disposition: inline
In-Reply-To: <20141028175146.GA18467@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 28, 2014 at 03:51:54PM -0200, Leonidas S. Barbosa wrote:
> NX CCM has not support to keys larger than 128 neither our hardware.
> In cases where a system is running in fips mode enabled a tcrypt test will
> crash the system in a kernel panic call.
> This patch disable, for now, CCM's algorithms in fips mode to avoid this.
> 
> Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>

For cases like this you should be using a software fallback rather
than just failing.  See padlock-sha for an example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
