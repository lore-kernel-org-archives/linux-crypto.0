From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] arch/x86/crypto/camellia_glue.c: adjust code
 alignment
Date: Wed, 14 Aug 2013 20:41:22 +1000
Message-ID: <20130814104122.GA12970@gondor.apana.org.au>
References: <1376156077-6208-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376156077-6208-2-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376156077-6208-2-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 10, 2013 at 07:34:36PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Adjust alignment in automatically generated code.  If this code
> will not be regenerated in the future, it may as well look nice.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> This patch was generated from the result of the previous one, which
> replaced commas by semicolons.

Please fold this patch into the original one.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
