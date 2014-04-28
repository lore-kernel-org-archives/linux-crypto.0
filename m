From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Cleanup ressource leaks in test_aead_speed()
Date: Mon, 28 Apr 2014 18:25:58 +0800
Message-ID: <20140428102558.GC17037@gondor.apana.org.au>
References: <20140421204439.7999f1c6@spike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140421204439.7999f1c6@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 21, 2014 at 08:44:39PM +0200, Christian Engelmayer wrote:
> This is a cleanup of Coverity ressource leak findings for the quick & dirty
> crypto testing module crypto/tcrypt.c.
> 
> All 3 changesets address function test_aead_speed() that was introduced in
> 53f52d7a (crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in
> tcrypt test suite)

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
