From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 2/7] Makefile, x86, LLVM: disable unsupported optimization flags
Date: Thu, 6 Apr 2017 03:08:26 +0900
Message-ID: <CAK7LNAR2efi4e3-st-hP3T7v=Hkb81beKibgYeKzxs3Q3kP0uA@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-3-md@google.com>
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
In-Reply-To: <20170317001520.85223-3-md@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Michael,

2017-03-17 9:15 GMT+09:00 Michael Davidson <md@google.com>:
> Unfortunately, while clang generates a warning about these flags
> being unsupported it still exits with a status of 0 so we have
> to explicitly disable them instead of just using a cc-option check.
>
> Signed-off-by: Michael Davidson <md@google.com>


Instead, does the following work for you?
https://patchwork.kernel.org/patch/9657285/


You need to use
$(call cc-option, ...)
for -falign-jumps=1 and -falign-loops=1



-- 
Best Regards
Masahiro Yamada
