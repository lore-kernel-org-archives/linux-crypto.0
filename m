From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: vmx - comply with ABIs that specify vrsave as
 reserved.
Date: Tue, 10 May 2016 17:53:17 +0800
Message-ID: <20160510095317.GA15908@gondor.apana.org.au>
References: <20160503081345.GA17118@gondor.apana.org.au>
 <1462457367-15445-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:IBM Power VMX Cryptographic instructions"
	<linux-crypto@vger.kernel.org>
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462457367-15445-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 05, 2016 at 11:09:27AM -0300, Paulo Flabiano Smorigo wrote:
> It gives significant improvements ( ~+15%) on some modes.
> 
> These code has been adopted from OpenSSL project in collaboration
> with the original author (Andy Polyakov <appro@openssl.org>).
> 
> Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
