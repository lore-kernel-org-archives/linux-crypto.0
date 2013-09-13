From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] crypto: tegra: use kernel entropy instead of ad-hoc
Date: Sat, 14 Sep 2013 09:39:12 +1000
Message-ID: <20130913233912.GA16389@gondor.apana.org.au>
References: <1378712154-30602-1-git-send-email-linus.walleij@linaro.org>
 <522DF0FC.5080200@wwwdotorg.org>
 <20130913122318.GD8579@gondor.apana.org.au>
 <52333974.4040404@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52333974.4040404-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 13, 2013 at 10:12:36AM -0600, Stephen Warren wrote:
>
> I'm curious which kernel version it was merged for; it'd be nice to
> remove tegra_chip_uid() from the Tegra tree now since it's unused, but
> that obviously requires this patch in the history.

This is in cryptodev which will be pushed upstream for 3.13.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
