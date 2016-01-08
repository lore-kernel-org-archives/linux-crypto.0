From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 0/2] crypto: sunxi-ss: fix 64-bit compilation
Date: Fri, 8 Jan 2016 11:15:05 +0000
Message-ID: <568F9A39.9030400@arm.com>
References: <1452182298-4653-1-git-send-email-andre.przywara@arm.com>
 <20160108095959.GC3472@gondor.apana.org.au>
Reply-To: andre.przywara-5wv7dgnIgG8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
   maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>,
   arnd-r2nGTMty4D4@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
   linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
   linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBDNZNK75ZIKRBYFUX22AKGQETKZPWYY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20160108095959.GC3472-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 08/01/16 09:59, Herbert Xu wrote:
> On Thu, Jan 07, 2016 at 03:58:16PM +0000, Andre Przywara wrote:
>> Hi,
>>
>> these two patches provide a different approach to an issue I tried
>> to fix lately [1].
>> Instead of casting everything I now promote local types to size_t, so
>> that the min3() arguments naturally match in type.
>> As size_t is defined as "unsigned int" on 32-bit architectures
>> anyway, that actually does not change anything there, but instead
>> provides a clean approach to get it compiled for arm64.
>>
>> I split this up because 1/2 seems much cleaner to me than 2/2, so we
>> can have a separate discussion/merge process on this.
> 
> If this is meant for the crypto tree it needs to go to the linux-crypto
> list.

Oh dear, I planned on adding the list, but eventually forgot it. Sorry
for that, I will resend it to linux-crypto.

Thanks for pointing this out!

Cheers,
Andre.
