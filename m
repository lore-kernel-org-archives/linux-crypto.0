From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Fixing opcode issue on vmx-crypto
Date: Mon, 24 Aug 2015 22:14:05 +0800
Message-ID: <20150824141405.GA31146@gondor.apana.org.au>
References: <20150821202740.GA25407@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-next@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150821202740.GA25407@bluepex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 21, 2015 at 05:27:43PM -0300, Leonidas S Barbosa wrote:
> 
> In build time vadduqm opcode  is not being mapped
> correctly.
> 
> Adding a new map in ppc-xlate to do this.
> 
> Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
