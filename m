Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D91D4E;
	Fri, 17 Nov 2023 03:20:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wts-000dDR-1P; Fri, 17 Nov 2023 19:20:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:20:47 +0800
Date: Fri, 17 Nov 2023 19:20:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rob Herring <robh@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: ingenic: Replace of_device.h with explicit of.h
 include
Message-ID: <ZVdMj7b8xjC+1iUe@gondor.apana.org.au>
References: <20231025162034.380152-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025162034.380152-1-robh@kernel.org>

On Wed, Oct 25, 2023 at 11:20:34AM -0500, Rob Herring wrote:
> The DT of_device.h and of_platform.h date back to the separate
> of_platform_bus_type before it as merged into the regular platform bus.
> As part of that merge prepping Arm DT support 13 years ago, they
> "temporarily" include each other and pull in various other headers. In
> preparation to fix this, adjust the includes for what is actually needed.
> 
> of_device.h isn't needed, but of.h is and was implicitly included by it.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/char/hw_random/ingenic-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
