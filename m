Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C7218B;
	Fri, 17 Nov 2023 02:35:42 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wBy-000cFS-4p; Fri, 17 Nov 2023 18:35:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 18:35:26 +0800
Date: Fri, 17 Nov 2023 18:35:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: LeoLiu-oc <LeoLiu-oc@zhaoxin.com>
Cc: olivia@selenic.com, martin@kaiser.cx, jiajie.ho@starfivetech.com,
	jenny.zhang@starfivetech.com, mmyangfl@gmail.com, robh@kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	CobeChen@zhaoxin.com, TonyWWang@zhaoxin.com, YunShen@zhaoxin.com,
	LeoLiu@zhaoxin.com
Subject: Re: [PATCH v2] hwrng: add Zhaoxin rng driver base on rep_xstore
 instruction
Message-ID: <ZVdB7ZyjLay61mLp@gondor.apana.org.au>
References: <20231107070900.496827-1-LeoLiu-oc@zhaoxin.com>
 <20231108073454.521726-1-LeoLiu-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108073454.521726-1-LeoLiu-oc@zhaoxin.com>

On Wed, Nov 08, 2023 at 03:34:54PM +0800, LeoLiu-oc wrote:
> From: LeoLiuoc <LeoLiu-oc@zhaoxin.com>
> 
> Add support for Zhaoxin hardware random number generator.
> This driver base on rep_xstore instruction and uses the same
> X86_FEATURE_XSTORE as via-rng driver. Therefore, modify the x86_cpu_id
> array in the via-rng driver, so that the corresponding driver can be
> correctly loader on respective platforms.
> 
> ---
> 
> v1 -> v2:
> 1. Fix assembler code errors
> 2. Remove redundant CPU model check codes
> 
> Signed-off-by: LeoLiuoc <LeoLiu-oc@zhaoxin.com>
> ---
>  drivers/char/hw_random/Kconfig       | 13 ++++
>  drivers/char/hw_random/Makefile      |  1 +
>  drivers/char/hw_random/via-rng.c     | 23 +++----
>  drivers/char/hw_random/zhaoxin-rng.c | 95 ++++++++++++++++++++++++++++
>  4 files changed, 119 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/char/hw_random/zhaoxin-rng.c

Please cc x86@vger.kernel.org as the same comments to the other
zhaoxin driver seems to be applicable here.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
