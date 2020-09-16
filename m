Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E88C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978B622225
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIPJjQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:39:16 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:58755 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgIPJjP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 05:39:15 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9F9994000C;
        Wed, 16 Sep 2020 09:39:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1599810399-14999-1-git-send-email-pvanleeuwen@rambus.com>
References: <1599810399-14999-1-git-send-email-pvanleeuwen@rambus.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        linux-crypto@vger.kernel.org
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH] crypto: inside-secure - Add support for EIP197 with output classifier
Message-ID: <160024914969.39497.4731533016684319800@kwain>
Date:   Wed, 16 Sep 2020 11:39:09 +0200
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

Quoting Pascal van Leeuwen (2020-09-11 09:46:39)
> This patch adds support for EIP197 instances that include the output
> classifier (OCE) option, as used by one of our biggest customers.
> The OCE normally requires initialization and dedicated firmware, but
> for the simple operations supported by this driver, we just bypass it
> completely for now (using what is formally a debug feature).
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c | 44 ++++++++++++++++++++++++++++++---
>  drivers/crypto/inside-secure/safexcel.h | 13 ++++++++++
>  2 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index fa7398e..eb241845 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -304,6 +304,11 @@ static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
>                 /* Enable access to all IFPP program memories */
>                 writel(EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN,
>                        EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
> +
> +               /* bypass the OCE, if present */
> +               if (priv->flags & EIP197_OCE)
> +                       writel(EIP197_DEBUG_OCE_BYPASS, EIP197_PE(priv) +
> +                                                       EIP197_PE_DEBUG(pe));
>         }
>  
>  }
> @@ -1495,6 +1500,9 @@ static int safexcel_probe_generic(void *pdev,
>         hwopt = readl(EIP197_GLOBAL(priv) + EIP197_OPTIONS);
>         hiaopt = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_OPTIONS);
>  
> +       priv->hwconfig.icever = 0;
> +       priv->hwconfig.ocever = 0;
> +       priv->hwconfig.psever = 0;
>         if (priv->flags & SAFEXCEL_HW_EIP197) {
>                 /* EIP197 */
>                 peopt = readl(EIP197_PE(priv) + EIP197_PE_OPTIONS(0));
> @@ -1513,8 +1521,37 @@ static int safexcel_probe_generic(void *pdev,
>                                             EIP197_N_RINGS_MASK;
>                 if (hiaopt & EIP197_HIA_OPT_HAS_PE_ARB)
>                         priv->flags |= EIP197_PE_ARB;
> -               if (EIP206_OPT_ICE_TYPE(peopt) == 1)
> +               if (EIP206_OPT_ICE_TYPE(peopt) == 1) {
>                         priv->flags |= EIP197_ICE;
> +                       /* Detect ICE EIP207 class. engine and version */
> +                       version = readl(EIP197_PE(priv) +
> +                                 EIP197_PE_ICE_VERSION(0));
> +                       if (EIP197_REG_LO16(version) != EIP207_VERSION_LE) {
> +                               dev_err(dev, "EIP%d: ICE EIP207 not detected.\n",
> +                                       peid);
> +                               return -ENODEV;
> +                       }
> +                       priv->hwconfig.icever = EIP197_VERSION_MASK(version);
> +               }
> +               if (EIP206_OPT_OCE_TYPE(peopt) == 1) {
> +                       priv->flags |= EIP197_OCE;
> +                       /* Detect EIP96PP packet stream editor and version */
> +                       version = readl(EIP197_PE(priv) + EIP197_PE_PSE_VERSION(0));
> +                       if (EIP197_REG_LO16(version) != EIP96_VERSION_LE) {
> +                               dev_err(dev, "EIP%d: EIP96PP not detected.\n", peid);
> +                               return -ENODEV;
> +                       }
> +                       priv->hwconfig.psever = EIP197_VERSION_MASK(version);
> +                       /* Detect OCE EIP207 class. engine and version */
> +                       version = readl(EIP197_PE(priv) +
> +                                 EIP197_PE_ICE_VERSION(0));
> +                       if (EIP197_REG_LO16(version) != EIP207_VERSION_LE) {
> +                               dev_err(dev, "EIP%d: OCE EIP207 not detected.\n",
> +                                       peid);
> +                               return -ENODEV;
> +                       }
> +                       priv->hwconfig.ocever = EIP197_VERSION_MASK(version);
> +               }
>                 /* If not a full TRC, then assume simple TRC */
>                 if (!(hwopt & EIP197_OPT_HAS_TRC))
>                         priv->flags |= EIP197_SIMPLE_TRC;
> @@ -1552,13 +1589,14 @@ static int safexcel_probe_generic(void *pdev,
>                                     EIP197_PE_EIP96_OPTIONS(0));
>  
>         /* Print single info line describing what we just detected */
> -       dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x/%x,alg:%08x\n",
> +       dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x/%x(alg:%08x)/%x/%x/%x\n",
>                  peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hwnumpes,
>                  priv->hwconfig.hwnumrings, priv->hwconfig.hwnumraic,
>                  priv->hwconfig.hiaver, priv->hwconfig.hwdataw,
>                  priv->hwconfig.hwcfsize, priv->hwconfig.hwrfsize,
>                  priv->hwconfig.ppver, priv->hwconfig.pever,
> -                priv->hwconfig.algo_flags);
> +                priv->hwconfig.algo_flags, priv->hwconfig.icever,
> +                priv->hwconfig.ocever, priv->hwconfig.psever);
>  
>         safexcel_configure(priv);
>  
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 7c5fe38..7054306 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -22,6 +22,7 @@
>  #define EIP96_VERSION_LE                       0x9f60
>  #define EIP201_VERSION_LE                      0x36c9
>  #define EIP206_VERSION_LE                      0x31ce
> +#define EIP207_VERSION_LE                      0x30cf
>  #define EIP197_REG_LO16(reg)                   (reg & 0xffff)
>  #define EIP197_REG_HI16(reg)                   ((reg >> 16) & 0xffff)
>  #define EIP197_VERSION_MASK(reg)               ((reg >> 16) & 0xfff)
> @@ -34,6 +35,7 @@
>  
>  /* EIP206 OPTIONS ENCODING */
>  #define EIP206_OPT_ICE_TYPE(n)                 ((n>>8)&3)
> +#define EIP206_OPT_OCE_TYPE(n)                 ((n>>10)&3)
>  
>  /* EIP197 OPTIONS ENCODING */
>  #define EIP197_OPT_HAS_TRC                     BIT(31)
> @@ -168,6 +170,7 @@
>  #define EIP197_PE_ICE_FPP_CTRL(n)              (0x0d80 + (0x2000 * (n)))
>  #define EIP197_PE_ICE_PPTF_CTRL(n)             (0x0e00 + (0x2000 * (n)))
>  #define EIP197_PE_ICE_RAM_CTRL(n)              (0x0ff0 + (0x2000 * (n)))
> +#define EIP197_PE_ICE_VERSION(n)               (0x0ffc + (0x2000 * (n)))
>  #define EIP197_PE_EIP96_TOKEN_CTRL(n)          (0x1000 + (0x2000 * (n)))
>  #define EIP197_PE_EIP96_FUNCTION_EN(n)         (0x1004 + (0x2000 * (n)))
>  #define EIP197_PE_EIP96_CONTEXT_CTRL(n)                (0x1008 + (0x2000 * (n)))
> @@ -176,8 +179,11 @@
>  #define EIP197_PE_EIP96_FUNCTION2_EN(n)                (0x1030 + (0x2000 * (n)))
>  #define EIP197_PE_EIP96_OPTIONS(n)             (0x13f8 + (0x2000 * (n)))
>  #define EIP197_PE_EIP96_VERSION(n)             (0x13fc + (0x2000 * (n)))
> +#define EIP197_PE_OCE_VERSION(n)               (0x1bfc + (0x2000 * (n)))
>  #define EIP197_PE_OUT_DBUF_THRES(n)            (0x1c00 + (0x2000 * (n)))
>  #define EIP197_PE_OUT_TBUF_THRES(n)            (0x1d00 + (0x2000 * (n)))
> +#define EIP197_PE_PSE_VERSION(n)               (0x1efc + (0x2000 * (n)))
> +#define EIP197_PE_DEBUG(n)                     (0x1ff4 + (0x2000 * (n)))
>  #define EIP197_PE_OPTIONS(n)                   (0x1ff8 + (0x2000 * (n)))
>  #define EIP197_PE_VERSION(n)                   (0x1ffc + (0x2000 * (n)))
>  #define EIP197_MST_CTRL                                0xfff4
> @@ -352,6 +358,9 @@
>  /* EIP197_PE_EIP96_TOKEN_CTRL2 */
>  #define EIP197_PE_EIP96_TOKEN_CTRL2_CTX_DONE   BIT(3)
>  
> +/* EIP197_PE_DEBUG */
> +#define EIP197_DEBUG_OCE_BYPASS                        BIT(1)
> +
>  /* EIP197_STRC_CONFIG */
>  #define EIP197_STRC_CONFIG_INIT                        BIT(31)
>  #define EIP197_STRC_CONFIG_LARGE_REC(s)                (s<<8)
> @@ -776,6 +785,7 @@ enum safexcel_flags {
>         EIP197_PE_ARB           = BIT(2),
>         EIP197_ICE              = BIT(3),
>         EIP197_SIMPLE_TRC       = BIT(4),
> +       EIP197_OCE              = BIT(5),
>  };
>  
>  struct safexcel_hwconfig {
> @@ -783,7 +793,10 @@ struct safexcel_hwconfig {
>         int hwver;
>         int hiaver;
>         int ppver;
> +       int icever;
>         int pever;
> +       int ocever;
> +       int psever;
>         int hwdataw;
>         int hwcfsize;
>         int hwrfsize;
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
