From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Provide support to autoload CCP driver
Date: Mon, 6 Jul 2015 16:33:51 +0800
Message-ID: <20150706083351.GA20800@gondor.apana.org.au>
References: <20150630175714.17231.11110.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150630175714.17231.11110.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 30, 2015 at 12:57:14PM -0500, Tom Lendacky wrote:
> Add the necessary module device tables to the platform support to allow
> for autoloading of the CCP driver. This will allow for the CCP's hwrng
> support to be available without having to manually load the driver. The
> module device table entry for the pci support is already present.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
