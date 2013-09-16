From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH] crypto: tegra: use kernel entropy instead of ad-hoc
Date: Mon, 16 Sep 2013 09:28:22 -0600
Message-ID: <52372396.8030707@wwwdotorg.org>
References: <1378712154-30602-1-git-send-email-linus.walleij@linaro.org> <522DF0FC.5080200@wwwdotorg.org> <20130913122318.GD8579@gondor.apana.org.au> <52333974.4040404@wwwdotorg.org> <20130913233912.GA16389@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130913233912.GA16389-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 09/13/2013 05:39 PM, Herbert Xu wrote:
> On Fri, Sep 13, 2013 at 10:12:36AM -0600, Stephen Warren wrote:
>>
>> I'm curious which kernel version it was merged for; it'd be nice to
>> remove tegra_chip_uid() from the Tegra tree now since it's unused, but
>> that obviously requires this patch in the history.
> 
> This is in cryptodev which will be pushed upstream for 3.13.

OK, I guess I'll send you the follow-on cleanup patch then. While it
does touch arch/arm/mach-tegra code, I hope it won't conflict with
anything else going through the Tegra tree, so should be safe.
