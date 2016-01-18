From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RESEND PATCH 0/2] crypto: sunxi-ss: fix 64-bit compilation
Date: Mon, 18 Jan 2016 10:01:55 +0000
Message-ID: <569CB813.5050607@arm.com>
References: <1452252249-12040-1-git-send-email-andre.przywara@arm.com>
 <569AA8ED.7050404@gmail.com>
Reply-To: andre.przywara-5wv7dgnIgG8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
   "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
   linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
   linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
To: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
   Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
   Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-sunxi+bncBDNZNK75ZIKRBWXQ6K2AKGQENX4WFRA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <569AA8ED.7050404-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

(CC:ing Boris for the x86 parts)

thanks for looking at this and your answer.

On 16/01/16 20:32, Corentin LABBE wrote:
> Le 08/01/2016 12:24, Andre Przywara a =C3=A9crit :
>> (resending to add linux-crypto, patches unchanged)
>>
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
>>
>> Cheers,
>> Andre.
>>
>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-December/=
395689.html
>>
>> Andre Przywara (2):
>>   crypto: sunxi-ss-cipher: promote variables to match types in min3()
>>     calls
>>   crypto: sunxi-ss-hash: promote variables to match types in min3()
>>     calls
>>
>>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 20 ++++++++++----------
>>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 12 ++++++------
>>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
>>  3 files changed, 17 insertions(+), 17 deletions(-)
>>
>=20
> Hello
>=20
> Sorry for this late answer.
>=20
> I am in trouble with those patch, so we have with Andre a long conversati=
on about it.
> Basically, sun4i-ss will never be available on 64bits platform. (A64 will=
 have a totally new crypto engine).
> So letting it to compile under 64bit arch is only useful when goal is to =
add COMPILE_TEST for it.

OK, but actually I don't see the strict requirement for having
COMPILE_TEST here. Usually those warnings point to portability issues in
the code and should be fixed, regardless of it being usable for a
particular architecture or not. Since it got enabled with ARCH_SUNXI on
arm64 without further ado, I took this as a sufficient reason to fix
those issues.

But I see your point in it being useless outside of arm(32) (unless
Allwinner comes up with a ARMv8 SoC using the "old" crypto engine ;-)

> But COMPILE_TEST cannot simply be added with those patch since some arche=
s (x86/x86_64 at least) does not have writesl/readsl available.

So for the records (and interested x86 readers):
The sunxi-ss driver uses writesl/readsl, which _are_ defined in
include/asm-generic/io.h. But x86 does not include this header (probably
for historic reasons). So I added the #include in
arch/x86/include/asm/io.h, this required to dummy define a lot of
implemented functions, like:
#define readb readb
basically for all MMIO and IO port accessors. After that it worked, I
could use COMPILE_TEST on the driver and found the same issues as with
arm64 (which were fixed by my patch).

Now adding a number of hideous #defines to a core header in an unrelated
architecture to enable COMPILE_TEST for a single driver seems a bit of a
stretch to me, so I refrain from sending this out - unless people ask
for it.

Boris, do you recall any discussions about asm-generic/io.h on x86 in
the past?

> The conclusion is that it is simpler to block 64bit build for sun4i-ss.

OK, I am fine with just adding "&& !64BIT" to the Kconfig entry.
Actually that was my first impulse on finding this issue, but then I
felt it a bit cowardly to paper over the problem instead of fixing it.

So if no-one disagrees, I will include the !64bit dependency in the A64
enablement series I plan to send out later this week.

Cheers,
Andre.

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
