From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha-mb - Add avx2_supported check.
Date: Mon, 5 Jan 2015 21:36:44 +1100
Message-ID: <20150105103643.GA25200@gondor.apana.org.au>
References: <1419898842-9447-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Vinson Lee <vlee@twitter.com>
To: Vinson Lee <vlee@twopensource.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1419898842-9447-1-git-send-email-vlee@twopensource.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 29, 2014 at 04:20:39PM -0800, Vinson Lee wrote:
> From: Vinson Lee <vlee@twitter.com>
> 
> This patch fixes this allyesconfig target build error with older
> binutils.
> 
>   LD      arch/x86/crypto/built-in.o
> ld: arch/x86/crypto/sha-mb/built-in.o: No such file: No such file or directory
> 
> Cc: stable@vger.kernel.org # 3.18+
> Signed-off-by: Vinson Lee <vlee@twitter.com>

Patch applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
