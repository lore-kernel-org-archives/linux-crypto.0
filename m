From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: ccp - minor code fixes
Date: Tue, 25 Feb 2014 20:19:11 +0800
Message-ID: <20140225121911.GJ12216@gondor.apana.org.au>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 24, 2014 at 08:41:56AM -0600, Tom Lendacky wrote:
> The following series implements some fixes to some code paths executed
> during crypto API request processing.  These fixes address processing of
> requests when the CCP driver returns -EBUSY and freeing memory in error
> paths.
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
