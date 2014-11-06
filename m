From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/9] NX crypto driver fixes
Date: Thu, 6 Nov 2014 23:17:04 +0800
Message-ID: <20141106151704.GD4544@gondor.apana.org.au>
References: <20141028174006.GA15893@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141028174006.GA15893@bluepex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 28, 2014 at 03:40:09PM -0200, Leonidas S. Barbosa wrote:
> This patch set fixes the follow issues in  NX crypto driver:
> 
>   - Bound limit issue that causes a memory crash
>   - SHA concurrence issue
>   - IV vector fix with the correct bit order
>   - NX CCM does not support keys larger than 128 causing
>   crashes in fips mode.

All applied except the last patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
