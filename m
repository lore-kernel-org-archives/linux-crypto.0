From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 2/7] Makefile, x86, LLVM: disable unsupported optimization flags
Date: Mon, 10 Apr 2017 23:54:57 +0900
Message-ID: <CAK7LNARuyveh5o9ypX56rDACyYW-EMb--TB5Uar-NT0Egc_jiw@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-3-md@google.com>
 <CAK7LNAR2efi4e3-st-hP3T7v=Hkb81beKibgYeKzxs3Q3kP0uA@mail.gmail.com>
 <20170405190130.GD145051@google.com> <CA+=D-XVbZfgaQ+ZrjctAF5Ek3kaF3XqTLsSu==hK9savDztKsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matthias Kaehlcke <mka@chromium.org>,
        Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, X86 ML <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
To: Michael Davidson <md@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+=D-XVbZfgaQ+ZrjctAF5Ek3kaF3XqTLsSu==hK9savDztKsw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.


2017-04-06 4:11 GMT+09:00 Michael Davidson <md@google.com>:
> It "works" for the cases that I currently care about but I have to say
> that I am uneasy about adding -Werror to the cc-option test in this
> way.
>
> Suppose that one of the *other* flags that is implicitly passed to the
> compiler by cc-option - eg something that was explicitly specified in
> $(KBUILD_CFLAGS) - triggers a warning. In that case all calls to
> cc-option will silently fail because of the -Werror and valid options
> will not be detected correctly.

Theoretically, options explicitly specified in KBUILD_CFLAGS
should be always valid.
Options that may not be supported in some cases
should be wrapped with $(call cc-option ).



> If everyone is OK with that because "it shouldn't normally ever
> happen" then that is fine, but if does result in a subtle change from
> existing behavior (and a trap that I almost immediately fell into
> after applying a similar patch).

There is a rare case where a particular combination fails
(such as the conflict between -pg and -ffunction-sections
as reported in https://patchwork.kernel.org/patch/9624573/).

In a such case, we may end up with swapping the order,
but this should not happen quite often.



> On Wed, Apr 5, 2017 at 12:01 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
>> Hi Masahiro,
>>
>> El Thu, Apr 06, 2017 at 03:08:26AM +0900 Masahiro Yamada ha dit:
>>
>>> 2017-03-17 9:15 GMT+09:00 Michael Davidson <md@google.com>:
>>> > Unfortunately, while clang generates a warning about these flags
>>> > being unsupported it still exits with a status of 0 so we have
>>> > to explicitly disable them instead of just using a cc-option check.
>>> >
>>> > Signed-off-by: Michael Davidson <md@google.com>
>>>
>>>
>>> Instead, does the following work for you?
>>> https://patchwork.kernel.org/patch/9657285/
>>
>> Thanks for the pointer, I was about to give this change (or rather its
>> ancestor) a rework myself :)
>>
>>> You need to use
>>> $(call cc-option, ...)
>>> for -falign-jumps=1 and -falign-loops=1
>>
>> I can confirm that this works.
>>
>> Thanks
>>
>> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Masahiro Yamada
