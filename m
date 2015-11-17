From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 11/11] crypto: algif: Change some variable to size_t
Date: Tue, 17 Nov 2015 22:08:19 +0800
Message-ID: <20151117140819.GF9546@gondor.apana.org.au>
References: <1445602236-24130-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445602236-24130-12-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445602236-24130-12-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 23, 2015 at 02:10:36PM +0200, LABBE Corentin wrote:
> Some variable are set as int but store only positive values.
> Furthermore there are used in operation/function that wait for unsigned
> value.
> This patch set them as size_t.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
