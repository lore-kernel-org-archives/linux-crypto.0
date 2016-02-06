From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Don't assume export/import areas are
 aligned
Date: Sat, 6 Feb 2016 15:47:17 +0800
Message-ID: <20160206074717.GE22220@gondor.apana.org.au>
References: <20160202173821.9736.99927.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160202173821.9736.99927.stgit@tlendack-t1.amdoffice.net>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 02, 2016 at 11:38:21AM -0600, Tom Lendacky wrote:
> Use a local variable for the exported and imported state so that
> alignment is not an issue. On export, set a local variable from the
> request context and then memcpy the contents of the local variable to
> the export memory area. On import, memcpy the import memory area into
> a local variable and then use the local variable to set the request
> context.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
