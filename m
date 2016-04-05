From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] hwrng: exynos - Runtime suspend device after init
Date: Tue, 5 Apr 2016 20:44:29 +0800
Message-ID: <20160405124429.GC13048@gondor.apana.org.au>
References: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Kukjin Kim <kgene@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 14, 2016 at 09:07:12AM +0900, Krzysztof Kozlowski wrote:
> The driver uses pm_runtime_put_noidle() after initialization so the
> device might remain in active state if the core does not read from it
> (the read callback contains regular runtime put). The put_noidle() was
> chosen probably to avoid unneeded suspend and resume cycle after the
> initialization.
> 
> However for this purpose autosuspend is enabled so it is safe to runtime
> put just after the initialization.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
