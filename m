From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: [RESEND PATCH 0/2] crypto: sunxi-ss: fix 64-bit compilation
Date: Fri,  8 Jan 2016 11:24:07 +0000
Message-ID: <1452252249-12040-1-git-send-email-andre.przywara@arm.com>
Reply-To: andre.przywara-5wv7dgnIgG8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-sunxi+bncBDNZNK75ZIKRB4FYX22AKGQEK7Y4S6Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

(resending to add linux-crypto, patches unchanged)

Hi,

these two patches provide a different approach to an issue I tried
to fix lately [1].
Instead of casting everything I now promote local types to size_t, so
that the min3() arguments naturally match in type.
As size_t is defined as "unsigned int" on 32-bit architectures
anyway, that actually does not change anything there, but instead
provides a clean approach to get it compiled for arm64.

I split this up because 1/2 seems much cleaner to me than 2/2, so we
can have a separate discussion/merge process on this.

Cheers,
Andre.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-December/395689.html

Andre Przywara (2):
  crypto: sunxi-ss-cipher: promote variables to match types in min3()
    calls
  crypto: sunxi-ss-hash: promote variables to match types in min3()
    calls

 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 20 ++++++++++----------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 12 ++++++------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.6.4
