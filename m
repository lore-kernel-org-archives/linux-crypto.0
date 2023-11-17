Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499A126;
	Thu, 16 Nov 2023 19:58:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3pzK-000WgD-Dw; Fri, 17 Nov 2023 11:57:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 11:57:58 +0800
Date: Fri, 17 Nov 2023 11:57:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: starfive - Pad adata with zeroes
Message-ID: <ZVbkxgAgSner0jWJ@gondor.apana.org.au>
References: <20231116021752.420680-1-jiajie.ho@starfivetech.com>
 <ZVWcLJOoLdElVsDd@gondor.apana.org.au>
 <2905f518-95a9-88d4-031c-291ef0373391@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2905f518-95a9-88d4-031c-291ef0373391@starfivetech.com>

On Thu, Nov 16, 2023 at 01:39:57PM +0800, Jia Jie Ho wrote:
>
> I'll update the v2 commit message if you're good with this implementation.
> Thanks for reviewing this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
