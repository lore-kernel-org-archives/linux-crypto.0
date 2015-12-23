From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 2/5] crypto: sunxi-ss: fix min3() call
 to match types
Date: Wed, 23 Dec 2015 00:07:41 +0000
Message-ID: <5679E5CD.2070103@arm.com>
References: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
 <1450787267-26836-3-git-send-email-andre.przywara@arm.com>
 <201512222306.58681.arnd@arndb.de>
Reply-To: andre.przywara-5wv7dgnIgG8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
   Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
   marc.zyngier-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org,
   linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
   Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
   "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <linux-sunxi+bncBDNZNK75ZIKRB6OL46ZQKGQE7BQIB2A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <201512222306.58681.arnd-r2nGTMty4D4@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Arnd,
On 12/22/15 22:06, Arnd Bergmann wrote:
> On Tuesday 22 December 2015, Andre Przywara wrote:
>> The min3() macro expects all arguments to be of the same type (or
>> size at least). While two arguments are ints or u32s, one is size_t,
>> which does not match on 64-bit architectures.
>> Cast the size_t to u32 to make min3() happy. In this context here the
>> length should never exceed 32 bits anyway.
>>
>> Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
> 
> Looks correct, but a bit ugly. Could we avoid the casts by using
> temporary variables to keep the size_t based data?

I guess this gets even uglier, but I found a better solution by
promoting the other involved variables to size_t in this function. This
works nicely for most of the cases, I just need two size_t casts now.
Will send an updated version soon.

Cheers,
Andre.
