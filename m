From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tegra: use kernel entropy instead of ad-hoc
Date: Fri, 13 Sep 2013 22:23:18 +1000
Message-ID: <20130913122318.GD8579@gondor.apana.org.au>
References: <1378712154-30602-1-git-send-email-linus.walleij@linaro.org>
 <522DF0FC.5080200@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Varun Wadekar <vwadekar@nvidia.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-tegra@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44004 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755311Ab3IMMXi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 08:23:38 -0400
Content-Disposition: inline
In-Reply-To: <522DF0FC.5080200@wwwdotorg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 09, 2013 at 10:02:04AM -0600, Stephen Warren wrote:
> On 09/09/2013 01:35 AM, Linus Walleij wrote:
> > The way I read the Tegra AES RNG is that it has a homebrew
> > algorithm for initializing the 128bit RNG using timespec and
> > the unique chip ID. This looks like reinventing the (square)
> > wheel, instead just grab 128bits from the kernel entropy pool
> > where the time and (after another patch) chip unique ID is
> > already mixed in.
> > 
> > Incidentally this also gets rid of a rather ugly
> > cross-dependence on the machine using an extern declaration.
> 
> This sounds reasonable to me, although I know little about the driver.
> Varun, can you please comment?
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
