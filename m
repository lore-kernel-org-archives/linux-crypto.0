From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: n2: set array of const as const
Date: Thu, 15 Oct 2015 21:19:53 +0800
Message-ID: <20151015131953.GE3981@gondor.apana.org.au>
References: <1444850114-17194-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444850114-17194-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 14, 2015 at 09:15:13PM +0200, LABBE Corentin wrote:
> Some array of const char are not set as const.
> This patch fix that.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
