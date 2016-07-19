From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: vmx - Adding asm subroutines for XTS
Date: Tue, 19 Jul 2016 15:40:07 +0800
Message-ID: <20160719074007.GA22394@gondor.apana.org.au>
References: <1468855586-848-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:IBM Power VMX Cryptographic instructions"
	<linux-crypto@vger.kernel.org>,
	"open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)"
	<linuxppc-dev@lists.ozlabs.org>
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35063 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbcGSHkg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jul 2016 03:40:36 -0400
Content-Disposition: inline
In-Reply-To: <1468855586-848-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 18, 2016 at 12:26:25PM -0300, Paulo Flabiano Smorigo wrote:
> This patch add XTS subroutines using VMX-crypto driver.
> 
> It gives a boost of 20 times using XTS.
> 
> These code has been adopted from OpenSSL project in collaboration
> with the original author (Andy Polyakov <appro@openssl.org>).
> 
> Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
> Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
