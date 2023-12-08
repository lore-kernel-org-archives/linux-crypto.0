Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C86C1712;
	Thu,  7 Dec 2023 20:09:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBSB2-008IlK-4b; Fri, 08 Dec 2023 12:09:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:09:34 +0800
Date: Fri, 8 Dec 2023 12:09:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc: atenart@kernel.org, n.zhandarovich@fintech.ru, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: safexcel - Add error handling for
 dma_map_sg() calls
Message-ID: <ZXKW/lVRTeAAPe31@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201124929.12448-1-n.zhandarovich@fintech.ru>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Nikita Zhandarovich <n.zhandarovich@fintech.ru> wrote:
> Macro dma_map_sg() may return 0 on error. This patch enables
> checks in case of the macro failure and ensures unmapping of
> previously mapped buffers with dma_unmap_sg().
> 
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
> 
> Fixes: 49186a7d9e46 ("crypto: inside_secure - Avoid dma map if size is zero")
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> ---
> v2: remove extra level of parentheses and
> change return error code from -ENOMEM to EIO
> per Antoine Tenart's <atenart@kernel.org> suggestion
> 
> drivers/crypto/inside-secure/safexcel_cipher.c | 19 +++++++++++--------
> 1 file changed, 11 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
