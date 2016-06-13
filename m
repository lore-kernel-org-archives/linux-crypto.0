From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] hw_random: Add Amlogic Meson SoCs Random
 Generator driver
Date: Mon, 13 Jun 2016 20:31:09 +0800
Message-ID: <20160613123109.GA8674@gondor.apana.org.au>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Neil Armstrong <narmstrong@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 10, 2016 at 10:21:52AM +0200, Neil Armstrong wrote:
> Add support for the Amlogic Meson SoCs Hardware Random generator as a hw_random char driver.
> The generator is a single 32bit wide register.
> Also adds the Meson GXBB SoC DTSI node and corresponding DT bindings.
> 
> Changes since v1 at http://lkml.kernel.org/r/1464943621-18278-1-git-send-email-narmstrong@baylibre.com :
> - change to depend on ARCH_MESON || COMPILE_TEST
> - check buffer max size in read
> 
> Neil Armstrong (3):
>   char: hw_random: Add Amlogic Meson Hardware Random Generator
>   dt-bindings: hwrng: Add Amlogic Meson Hardware Random Generator
>     bindings
>   ARM64: dts: meson-gxbb: Add Hardware Random Generator node

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
