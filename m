From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Fri, 18 Sep 2015 22:07:56 +0800
Message-ID: <20150918140756.GK9249@gondor.apana.org.au>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org, festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 17, 2015 at 02:45:50PM +0100, Lee Jones wrote:
> v1 => v2:
>  - New patch: Also fixing /dev/hw_random => /dev/hwrng in Kconfig
>  - Fix 2099 => 2009 typo in commit log
>  - Fix 'number of random numbers sourced' return value
>  - Treat devm_clk_get()'s return value correctly
>  - Check return value of clk_prepare_enable()
>  - Use sysfs_streq() instead of manually stripping '\n' from sysfs

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
