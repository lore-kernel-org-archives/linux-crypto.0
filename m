Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7D310D;
	Fri,  1 Dec 2023 02:13:23 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90WN-005hnB-0B; Fri, 01 Dec 2023 18:13:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:13:28 +0800
Date: Fri, 1 Dec 2023 18:13:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, shenyang39@huawei.com
Subject: Re: [PATCH v2] crypto: hisilicon/zip - add zip comp high perf mode
 configuration
Message-ID: <ZWmxyFV1fILeQ3q0@gondor.apana.org.au>
References: <20231124054924.3964946-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124054924.3964946-1-huangchenghai2@huawei.com>

On Fri, Nov 24, 2023 at 01:49:24PM +0800, Chenghai Huang wrote:
> To meet specific application scenarios, the function of switching between
> the high performance mode and the high compression mode is added.
> 
> Use the perf_mode=0/1 configuration to set the compression high perf mode,
> 0(default, high compression mode), 1(high performance mode). These two
> modes only apply to the compression direction and are compatible with
> software algorithm in both directions.
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 65 +++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
