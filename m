Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40C51AD;
	Fri, 17 Nov 2023 03:26:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wzB-000dRK-UX; Fri, 17 Nov 2023 19:26:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:26:17 +0800
Date: Fri, 17 Nov 2023 19:26:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Kaiser <martin@kaiser.cx>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - remove #ifdef guards for PM functions
Message-ID: <ZVdN2agqgh+FHIFx@gondor.apana.org.au>
References: <20231112165241.176095-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112165241.176095-1-martin@kaiser.cx>

On Sun, Nov 12, 2023 at 05:52:41PM +0100, Martin Kaiser wrote:
> Use pm_sleep_ptr for the freeze and restore functions instead of putting
> them under #ifdef CONFIG_PM_SLEEP. The resulting code is slightly simpler.
> 
> pm_sleep_ptr lets the compiler see the functions but also allows removing
> them as unused code if !CONFIG_PM_SLEEP.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
> compile-tested only, I do not have this hardware
> 
>  drivers/char/hw_random/virtio-rng.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
