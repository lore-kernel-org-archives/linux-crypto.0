From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: talitos: Delete an error message for a
 failed memory allocation in talitos_edesc_alloc()
Date: Fri, 23 Mar 2018 23:58:04 +0800
Message-ID: <20180323155804.GA2186@gondor.apana.org.au>
References: <ad256dc9-a064-37f9-fb8e-aea22ba40a2b@users.sourceforge.net>
 <13bfdc03-1dee-2f1c-da8d-1e452f10c850@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13bfdc03-1dee-2f1c-da8d-1e452f10c850@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 12, 2018 at 02:32:58PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 12 Mar 2018 14:18:23 +0100
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
