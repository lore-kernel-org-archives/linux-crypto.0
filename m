From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: constify ccp_actions structure
Date: Tue, 3 May 2016 16:17:35 +0800
Message-ID: <20160503081735.GF17166@gondor.apana.org.au>
References: <1462103575-21705-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	kernel-janitors@vger.kernel.org, Gary Hook <gary.hook@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462103575-21705-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, May 01, 2016 at 01:52:55PM +0200, Julia Lawall wrote:
> The ccp_actions structure is never modified, so declare it as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
