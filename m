From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH 02/11] crypto: sunxi-ss: prevent compilation
 on 64-bit
Date: Sat, 6 Feb 2016 15:46:17 +0800
Message-ID: <20160206074617.GB22220@gondor.apana.org.au>
References: <1454348370-3816-1-git-send-email-andre.przywara@arm.com>
 <1454348370-3816-3-git-send-email-andre.przywara@arm.com>
Reply-To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Return-path: <linux-sunxi+bncBDTY5EWUQMEBBWWJ222QKGQE2YE2DYA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454348370-3816-3-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 01, 2016 at 05:39:21PM +0000, Andre Przywara wrote:
> The driver for the sunxi-ss crypto engine is not entirely 64-bit safe,
> compilation on arm64 spits some warnings.
> The proper fix was deemed to involved [1], so since 64-bit SoCs won't
> have this IP block we just disable this driver for 64-bit.
> 
> [1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/399988.html
>      (and the reply)
> 
> Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>

Applied.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
