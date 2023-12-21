Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7834416;
	Thu, 21 Dec 2023 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rG7vJ-00DG0a-Mf; Thu, 21 Dec 2023 09:32:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Dec 2023 09:32:40 +0800
Date: Thu, 21 Dec 2023 09:32:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+8ffb0839a24e9c6bfa76@syzkaller.appspotmail.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH next] crypto: fix oob Read in arc4_crypt
Message-ID: <ZYOVuAL4kymn8mnX@gondor.apana.org.au>
References: <000000000000d52e14060cc9c551@google.com>
 <tencent_656D589558EA3EED8ACF3C79166F202E010A@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_656D589558EA3EED8ACF3C79166F202E010A@qq.com>

On Wed, Dec 20, 2023 at 11:53:55PM +0800, Edward Adam Davis wrote:
> The space allocated to areq is not sufficient to access the member __ctx of 
> struct skcipher_request, as the space occupied by struct arc4_ctx for reading 
> is 1032 bytes, while the requested memory size in skcipher_recvmsg() is:
> sizeof(struct af_alg_async_req) + crypto_skcipher_reqsize(tfm) = 736 bytes,
> which does not include the memory required for __ctx of struct skcipher_request.
> 
> Reported-by: syzbot+8ffb0839a24e9c6bfa76@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  crypto/algif_skcipher.c            | 10 +++++++---
>  crypto/skcipher.c                  |  1 -
>  include/crypto/internal/skcipher.h |  1 +
>  3 files changed, 8 insertions(+), 4 deletions(-)

I see where the real bug is.  The statesize is not being passed
along by ecb so that's why we end up with no memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
