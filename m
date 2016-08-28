From: Sergei Shtylyov <sergei.shtylyov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 3/4] hw_random: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Sun, 28 Aug 2016 13:33:32 +0300
Message-ID: <7a3874e2-069e-7bdf-2289-3364ec2c8cc4@cogentembedded.com>
References: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
 <1472321697-3094-4-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        mark.rutland-5wv7dgnIgG8@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
        harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org, prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org, narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org,
        linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472321697-3094-4-git-send-email-prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello.

On 8/27/2016 9:14 PM, PrasannaKumar Muralidharan wrote:

> This patch adds RNG node to jz4780.dtsi.
>
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> index b868b42..f11d139 100644
> --- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> @@ -36,7 +36,7 @@
>
>  	cgu: jz4780-cgu@10000000 {
>  		compatible = "ingenic,jz4780-cgu";
> -		reg = <0x10000000 0x100>;
> +		reg = <0x10000000 0xD8>;

    I think lower case is preferred here.

>
>  		clocks = <&ext>, <&rtc>;
>  		clock-names = "ext", "rtc";
> @@ -44,6 +44,11 @@
>  		#clock-cells = <1>;
>  	};
>
> +	rng: jz4780-rng@100000D8 {

    All in lower case, please.

> +		compatible = "ingenic,jz4780-rng";
> +		reg = <0x100000D8 0x8>;

    Likewise.

[...]

MBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
