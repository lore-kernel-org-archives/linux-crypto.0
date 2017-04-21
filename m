From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 1/7] Makefile, LLVM: add -no-integrated-as to KBUILD_[AC]FLAGS
Date: Fri, 21 Apr 2017 16:49:53 +0900
Message-ID: <CAK7LNAS0i=Qtoqk3hZMhAyQOXWf-8=fb0bSMh=gMJ3-bunQ_5Q@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-2-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, X86 ML <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-2-md@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Michael,


2017-03-17 9:15 GMT+09:00 Michael Davidson <md@google.com>:
> Add -no-integrated-as to KBUILD_AFLAGS and KBUILD_CFLAGS
> for clang.

>From the code-diff, it is apparent that
you added -no-integrated-as.

Rather, I'd like to see "why" in the git-log.

Obviously, clang needs this patch to build the kernel,
but can you describe the reason why the integrated assembler is bad?

With git-log reworded, I will pick up this shortly.

Thanks!



> Signed-off-by: Michael Davidson <md@google.com>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index b841fb36beb2..b21fd0ca2946 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -704,6 +704,8 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
>  # See modpost pattern 2
>  KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
>  KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
> +KBUILD_CFLAGS += $(call cc-option, -no-integrated-as)
> +KBUILD_AFLAGS += $(call cc-option, -no-integrated-as)
>  else
>
>  # These warnings generated too much noise in a regular build.







-- 
Best Regards
Masahiro Yamada
