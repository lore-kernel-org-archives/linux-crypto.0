From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp: terminate ccp_support array with empty
 element
Date: Mon, 26 Jan 2015 13:56:10 +1100
Message-ID: <20150126025610.GF19796@gondor.apana.org.au>
References: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
 <54C264B1.5090508@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"open list:AMD CRYPTOGRAPHIC..." <linux-crypto@vger.kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54C264B1.5090508@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 23, 2015 at 09:11:45AM -0600, Tom Lendacky wrote:
> On 01/21/2015 09:06 AM, Andrey Ryabinin wrote:
> >x86_match_cpu() expects array of x86_cpu_ids terminated
> >with empty element.
> >
> >Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
