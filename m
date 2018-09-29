From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Sat, 29 Sep 2018 08:16:25 +0200
Message-ID: <CAKv+Gu9FoFQymp2-=rUeh14CkUKON389OCE7stYCOFwKZpaCrg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu8knzzmK4_KouFQWKzMdHFgEsk-CtBrcuAvk0bYkDFO=w@mail.gmail.com> <CAHmME9qtN8kiKnMHTa76r9a_5Ou_s3WhAMT_HnH7-1FeoHUOZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9qtN8kiKnMHTa76r9a_5Ou_s3WhAMT_HnH7-1FeoHUOZg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 29 September 2018 at 04:20, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Fri, Sep 28, 2018 at 6:02 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> Please put comments like this below the ---
>
> git-notes is nice for this indeed.
>
>> Are these CONFIG_ symbols defined anywhere at this point?
>
> Yes, they're introduced in the first zinc commit. There's no git-blame
> on git.kernel.org, presumably because it's expensive to compute, but
> there is on my personal instance, so this might help:
> https://git.zx2c4.com/linux-dev/blame/lib/zinc/Kconfig?h=jd/wireguard
>
>> In any case, I don't think these is a reason for these, at least not
>> on ARM/arm64. The 64-bitness is implied in both cases
>
> You mean to say that since these nobs are def_bool y and are
> essentially "depends on ARM", then I should just straight up use
> CONFIG_ARM? I had thought about this, but figured this would make it
> easier to later make these optional or have other options block them
> need be, or even if the dependencies and requirements for having them
> changes (for example, with UML on x86). I think doing it this way
> gives us some flexibility later on. So if that's a compelling enough
> reason, I'd like to keep those.
>

Sure. But probably better to be consistent then, and stop using
CONFIG_ARM directly in your code.

>> and the
>> dependency on !CPU_32v3 you introduce (looking at the version of
>> Kconfig at the end of the series) seems spurious to me. Was that added
>> because of some kbuild robot report? (we don't support ARMv3 in the
>> kernel but ARCH_RPC is built in v3 mode because of historical reasons
>> while the actual core is a v4)
>
> I added the !CPU_32v3 in my development tree after posting v6, so good
> to hear you're just looking straight at the updated tree. If you see
> things jump out in there prior to me posting v7, don't hesitate to let
> me know.
>
> The reason it was added was indeed because of:
> https://lists.01.org/pipermail/kbuild-all/2018-September/053114.html
> -- exactly what you suspected, ARCH_RPC. Have a better suggestion than
> !CPU_32v3?

Yes, you could just add

asflags-$(CONFIG_CPU_32v3) += -march=armv4

with a comment stating that we don't actually support ARMv3 but only
use it as a code generation target for reasons unrelated to the ISA

> It seems to me like so long as the kernel has CPU_32v3 as a
> thing in any form, I should mark Zinc as not supporting it, since
> we'll certainly be at least v4 and up. (Do you guys have any old Acorn
> ARM610 boxes sitting around for old time's sake at LinaroHQ? ;-)
>

AFAIK we only support the StrongARM flavor of RiscPC which is ARMv4.
But yes, some people do care deeply about these antiquated platforms,
including Russell, and there is no particular to leave this one
behind.

>> > +#endif
>> > +
>>
>> No need to make asmlinkage declarations conditional
>
> Yep, addressed in the IS_ENABLED cleanup.
>
>>
>> if (IS_ENABLED())
>
> Sorted.
>
>>
>> """
>> if (!IS_ENABLED(CONFIG_ARM))
>>    return false;
>>
>> hchacha20_arm(x, derived_key);
>> return true;
>> """
>>
>> and drop the #ifdefs
>
> Also sorted.
>
> Regards,
> Jason
