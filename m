From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH] crypto: tegra: use kernel entropy instead of ad-hoc
Date: Fri, 13 Sep 2013 10:12:36 -0600
Message-ID: <52333974.4040404@wwwdotorg.org>
References: <1378712154-30602-1-git-send-email-linus.walleij@linaro.org> <522DF0FC.5080200@wwwdotorg.org> <20130913122318.GD8579@gondor.apana.org.au>
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
In-Reply-To: <20130913122318.GD8579-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 09/13/2013 06:23 AM, Herbert Xu wrote:
> On Mon, Sep 09, 2013 at 10:02:04AM -0600, Stephen Warren wrote:
>> On 09/09/2013 01:35 AM, Linus Walleij wrote:
>>> The way I read the Tegra AES RNG is that it has a homebrew
>>> algorithm for initializing the 128bit RNG using timespec and
>>> the unique chip ID. This looks like reinventing the (square)
>>> wheel, instead just grab 128bits from the kernel entropy pool
>>> where the time and (after another patch) chip unique ID is
>>> already mixed in.
>>>
>>> Incidentally this also gets rid of a rather ugly
>>> cross-dependence on the machine using an extern declaration.
>>
>> This sounds reasonable to me, although I know little about the driver.
>> Varun, can you please comment?
>>
>> Acked-by: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> Patch applied.  Thanks.

I'm curious which kernel version it was merged for; it'd be nice to
remove tegra_chip_uid() from the Tegra tree now since it's unused, but
that obviously requires this patch in the history.
