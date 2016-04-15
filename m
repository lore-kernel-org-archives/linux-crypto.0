From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH resend] crypto: get rid of superfluous __GFP_REPEAT
Date: Fri, 15 Apr 2016 22:37:24 +0800
Message-ID: <20160415143724.GI733@gondor.apana.org.au>
References: <1460372892-8157-19-git-send-email-mhocko@kernel.org>
 <1460623902-7109-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1460623902-7109-1-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 14, 2016 at 10:51:42AM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> __GFP_REPEAT has a rather weak semantic but since it has been introduced
> around 2.6.12 it has been ignored for low order allocations.
> 
> lzo_init uses __GFP_REPEAT to allocate LZO1X_MEM_COMPRESS 16K. This is
> order 3 allocation request and __GFP_REPEAT is ignored for this size
> as well as all <= PAGE_ALLOC_COSTLY requests.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
