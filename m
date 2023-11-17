Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AD7B3;
	Fri, 17 Nov 2023 03:20:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wti-000dDK-Nx; Fri, 17 Nov 2023 19:20:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:20:38 +0800
Date: Fri, 17 Nov 2023 19:20:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sagar Vashnav <sagarvashnav72427@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto/aesgcm.c:add kernel docs for aesgcm_mac
Message-ID: <ZVdMhiilu/Xj3LdP@gondor.apana.org.au>
References: <20231025125708.20645-1-sagarvashnav72427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025125708.20645-1-sagarvashnav72427@gmail.com>

On Wed, Oct 25, 2023 at 08:57:07AM -0400, Sagar Vashnav wrote:
> Add kernel documentation for the aesgcm_mac.
> This function generates the authentication tag using the AES-GCM algorithm.
> 
> Signed-off-by: Sagar Vashnav <sagarvashnav72427@gmail.com>
> ---
>  lib/crypto/aesgcm.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
