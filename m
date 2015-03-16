From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v6 3/4] MAINTAINERS: Add myself as maintainer of
 Allwinner Security System
Date: Mon, 16 Mar 2015 12:06:20 -0700
Message-ID: <1426532780.23897.30.camel@perches.com>
References: <1426532482-28830-1-git-send-email-clabbe.montjoie@gmail.com>
	 <1426532482-28830-4-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	arnd@arndb.de, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1426532482-28830-4-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2015-03-16 at 20:01 +0100, LABBE Corentin wrote:
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -10923,6 +10923,12 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	mm/zswap.c
>  
> +ALLWINNER SECURITY SYSTEM
> +M:	Corentin Labbe <clabbe.montjoie@gmail.com>
> +L:	linux-crypto@vger.kernel.org
> +S:	Maintained
> +F:	drivers/crypto/sunxi-ss/

Use alphabetic ordering for new sections please.

Please place this section between:

ALI1563 I2C DRIVER
and
ALPHA PORT


