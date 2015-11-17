From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 7/9] crypto: constify pci_error_handlers structures
Date: Tue, 17 Nov 2015 22:09:54 +0800
Message-ID: <20151117140953.GI9546@gondor.apana.org.au>
References: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
 <1447495621-9161-8-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447495621-9161-8-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 14, 2015 at 11:06:59AM +0100, Julia Lawall wrote:
> This pci_error_handlers structure is never modified, like all the other
> pci_error_handlers structures, so declare it as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
