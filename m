From: Matthijs van Duin <matthijsvanduin@gmail.com>
Subject: Re: [PATCH v3] crypto: omap-aes: Add support for GCM mode
Date: Sun, 20 Sep 2015 12:38:44 +0200
Message-ID: <CAALWOA_=hs+Xa2f+3=s=QaxA9HfVfHJnW0dzK6toRcFFiOvdTA@mail.gmail.com>
References: <1436283109-13318-7-git-send-email-lokeshvutla@ti.com> <1442323681-6538-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Tero Kristo <t-kristo@ti.com>, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442323681-6538-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 15 September 2015 at 15:28, Lokesh Vutla <lokeshvutla@ti.com> wrote:
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -293,6 +293,7 @@ config CRYPTO_DEV_OMAP_AES
>         depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
>         select CRYPTO_AES
>         select CRYPTO_BLKCIPHER
> +       select CRYPTO_AEAD

Is it appropriate that this also selects CRYPTO_AEAD on omap2/omap3,
even though they do not support GCM?



> +#define AES_REG_CTRL_GCM               GENMASK(17, 16)

Instead of adding these definitions one bit at a time, can't we get
the whole list over with at once? This thing supports:

ECB, CBC, and CFB-128 encryption
CTR and F8 encryption with 16/32/64/96/128-bit counter
XEX (disk encryption)
CBC-MAC authentication including the CMAC/OMAC/PMAC subflavors
F9 authentication
GCM and CCM aead
(and raw GHASH, if you happen to have a use for it)
