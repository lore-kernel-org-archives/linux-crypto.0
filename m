From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Remove unnecessary KERN_ERR in bfin_crc.c
Date: Mon, 5 Jan 2015 21:37:31 +1100
Message-ID: <20150105103730.GD25200@gondor.apana.org.au>
References: <1420170046-10269-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com
To: Masanari Iida <standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420170046-10269-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 02, 2015 at 12:40:46PM +0900, Masanari Iida wrote:
> This patch removes unnecessary KERN_ERR from bfin_crypto_crc_mod_init().
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
