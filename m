From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure
 handling in SPRINTFCAT macro
Date: Mon, 28 Apr 2014 18:24:41 +0800
Message-ID: <20140428102441.GA17037@gondor.apana.org.au>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
 <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 18, 2014 at 01:01:42PM +0300, Horia Geanta wrote:
> GFP_ATOMIC memory allocation could fail.
> In this case, avoid NULL pointer dereference and notify user.
> 
> Cc: <stable@vger.kernel.org> # 3.2+
> Cc: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied to the crypto tree.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
