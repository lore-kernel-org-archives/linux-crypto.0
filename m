From: Kieran Bingham <kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/7] Documentation: hw_random: Fix device node name
 reference /dev/hw_random => /dev/hwrng
Date: Fri, 18 Sep 2015 11:18:51 +0100
Message-ID: <CAB3z_RrhD9wx+P_BTd8ULPUDoFHLE5h=fPZDxZWTUoHpF2_w=g@mail.gmail.com>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
	<1442497557-9271-2-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org,
	festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442497557-9271-2-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 17 September 2015 at 14:45, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> In April 2009, commit d405640 ("Driver Core: misc: add node name support
> for misc devices.") inadvertently changed the device node name from
> /dev/hw_random to /dev/hwrng.  Since 6 years has passed since the change
> it seems unpractical to change it back, as this node name is probably
> considered ABI by now.  So instead, we'll just change the documentation
> to match the current situation.
>
> NB: It looks like rng-tools have already been updated.
>
> Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

I see the KConfig change went into a separate patch.
That's fine by me:

Acked-by: Kieran Bingham <kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  Documentation/hw_random.txt | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/hw_random.txt b/Documentation/hw_random.txt
> index 026e237..fce1634 100644
> --- a/Documentation/hw_random.txt
> +++ b/Documentation/hw_random.txt
> @@ -3,7 +3,7 @@ Introduction:
>         The hw_random framework is software that makes use of a
>         special hardware feature on your CPU or motherboard,
>         a Random Number Generator (RNG).  The software has two parts:
> -       a core providing the /dev/hw_random character device and its
> +       a core providing the /dev/hwrng character device and its
>         sysfs support, plus a hardware-specific driver that plugs
>         into that core.
>
> @@ -14,7 +14,7 @@ Introduction:
>
>                 http://sourceforge.net/projects/gkernel/
>
> -       Those tools use /dev/hw_random to fill the kernel entropy pool,
> +       Those tools use /dev/hwrng to fill the kernel entropy pool,
>         which is used internally and exported by the /dev/urandom and
>         /dev/random special files.
>
> @@ -32,13 +32,13 @@ Theory of operation:
>         The rng-tools package uses such tests in "rngd", and lets you
>         run them by hand with a "rngtest" utility.
>
> -       /dev/hw_random is char device major 10, minor 183.
> +       /dev/hwrng is char device major 10, minor 183.
>
>         CLASS DEVICE.  There is a /sys/class/misc/hw_random node with
>         two unique attributes, "rng_available" and "rng_current".  The
>         "rng_available" attribute lists the hardware-specific drivers
>         available, while "rng_current" lists the one which is currently
> -       connected to /dev/hw_random.  If your system has more than one
> +       connected to /dev/hwrng.  If your system has more than one
>         RNG available, you may change the one used by writing a name from
>         the list in "rng_available" into "rng_current".
>
> --
> 1.9.1
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
