From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2 4/7] hwrng: st: Provide DT bindings for ST's Random
 Number Generator
Date: Fri, 18 Sep 2015 09:21:37 -0700
Message-ID: <55FC3A11.6080209@codeaurora.org>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <1442497557-9271-5-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org,
	festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442497557-9271-5-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 09/17/2015 06:45 AM, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/rng/st,rng.txt | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/st,rng.txt
>
> diff --git a/Documentation/devicetree/bindings/rng/st,rng.txt b/Documentation/devicetree/bindings/rng/st,rng.txt
> new file mode 100644
> index 0000000..dbc64e6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/st,rng.txt
> @@ -0,0 +1,15 @@
> +STMicroelectronics HW Random Number Generator
> +----------------------------------------------
> +
> +Required parameters:
> +compatible	: Should be "st,rng"
> +reg		: Base address and size of IP's register map.
> +clocks		: Phandle to device's clock (See: ../clocks/clock-bindings.txt)
> +
> +Example:
> +
> +rng@0xfee80000 {

Drop the 0x part please.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
