From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: atmel-sha: Removed unused variable "err"
Date: Thu, 17 Dec 2015 16:46:09 +0800
Message-ID: <20151217084609.GB9239@gondor.apana.org.au>
References: <20151214084411.GA8727@visteon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "Pathak, Rahul (R.)" <rpathak@visteon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151214084411.GA8727@visteon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 14, 2015 at 08:44:19AM +0000, Pathak, Rahul (R.) wrote:
> From: Rahul Pathak <rpathak@visteon.com>
> 
> Removed unused variable "err" and directly return "0"
> 
> Reported by coccicheck -
> ./drivers/crypto/atmel-sha.c:758:5-8: Unneeded variable: "err". Return "0" on line 766
> 
> Signed-off-by: Rahul Pathak <rpathak@visteon.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
