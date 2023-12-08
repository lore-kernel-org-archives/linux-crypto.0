Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00A81718
	for <linux-crypto@vger.kernel.org>; Thu,  7 Dec 2023 20:08:13 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBS9o-008Ijs-UI; Fri, 08 Dec 2023 12:08:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:08:18 +0800
Date: Fri, 8 Dec 2023 12:08:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yang Yingliang <yangyingliang@huaweicloud.com>
Cc: linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	gatien.chevallier@foss.st.com, yangyingliang@huawei.com
Subject: Re: [PATCH] hwrng: stm32 - add missing clk_disable_unprepare() in
 stm32_rng_init()
Message-ID: <ZXKWsq/+td8HUmVQ@gondor.apana.org.au>
References: <20231201082048.1975940-1-yangyingliang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201082048.1975940-1-yangyingliang@huaweicloud.com>

On Fri, Dec 01, 2023 at 04:20:48PM +0800, Yang Yingliang wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> Add clk_disable_unprepare() in the error path in stm32_rng_init().
> 
> Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/char/hw_random/stm32-rng.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
