From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] drivers: crypto: move nx build to driver/crypto
 Makefile
Date: Wed, 27 Jun 2012 14:49:00 +0800
Message-ID: <20120627064859.GB22920@gondor.apana.org.au>
References: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Kent Yoder <key@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:44003 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850Ab2F0GtW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 02:49:22 -0400
Content-Disposition: inline
In-Reply-To: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 13, 2012 at 01:22:42PM -0500, Seth Jennings wrote:
> When the nx driver was pulled, the Makefile that actually
> builds it is arch/powerpc/Makefile. This is unnatural.
> 
> This patch moves the line that builds the nx driver from
> arch/powerpc/Makefile to drivers/crypto/Makefile where it
> belongs.
> 
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Both patches applied.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
