From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/2] zram: use crypto API to compress the page
Date: Thu, 13 Aug 2015 16:42:27 +0900
Message-ID: <20150813074227.GA14553@js1304-P5Q-DELUXE>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1439432654-23322-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813035113.GB17958@swordfish>
 <20150813071941.GB13352@js1304-P5Q-DELUXE>
 <20150813073233.GA21492@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150813073233.GA21492@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 13, 2015 at 03:32:33PM +0800, Herbert Xu wrote:
> On Thu, Aug 13, 2015 at 04:19:41PM +0900, Joonsoo Kim wrote:
> > 
> > If that optimization is really needed for the case that doesn't need
> > tfm except fetching function pointer, we can implement sharable tfm
> > in crypto subsystem.
> 
> I'm happy to consider changes to the crypto compression interface
> as long as it continues to support the existing algorithms and users.

Happy to hear that.
I will think how it can be improved.

Thanks.
