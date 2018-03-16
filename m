From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][next] crypto: x86/des3_ede: make array
 des3_ede_skciphers static
Date: Fri, 16 Mar 2018 23:35:38 +0800
Message-ID: <20180316153538.GA6781@gondor.apana.org.au>
References: <20180305131800.26647-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180305131800.26647-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 05, 2018 at 02:18:00PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The array des3_ede_skciphers is local to the source and does not need
> to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> arch/x86/crypto/des3_ede_glue.c:407:21: warning: symbol
> 'des3_ede_skciphers' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This patch no longer applies because it's already been merged
from someone else.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
