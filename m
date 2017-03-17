From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 0/7] LLVM: make x86_64 kernel build with clang.
Date: Fri, 17 Mar 2017 09:17:40 +0100
Message-ID: <CACT4Y+aeyXK5jwN4Nej-+u302zwC=uwQM4VkMBzesTCpQD4pLQ@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com>
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
        Matthias Kaehlcke <mka@chromium.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 17, 2017 at 1:15 AM, Michael Davidson <md@google.com> wrote:
> This patch set is sufficient to get the x86_64 kernel to build
> and boot correctly with clang-3.8 or greater.
>
> The resulting build still has about 300 warnings, very few of
> which appear to be significant. Most of them should be fixable
> with some minor code refactoring although a few of them, such
> as the complaints about implict conversions between enumerated
> types may be candidates for just being disabled.

Thanks, Michael!
This will help us a lot with KMSAN (uninit use detector) and code coverage.


> Michael Davidson (7):
>   Makefile, LLVM: add -no-integrated-as to KBUILD_[AC]FLAGS
>   Makefile, x86, LLVM: disable unsupported optimization flags
>   x86, LLVM: suppress clang warnings about unaligned accesses
>   x86, boot, LLVM: #undef memcpy etc in string.c
>   x86, boot, LLVM: Use regparm=0 for memcpy and memset
>   md/raid10, LLVM: get rid of variable length array
>   crypto, x86, LLVM: aesni - fix token pasting
>
>  Makefile                                |  4 ++++
>  arch/x86/Makefile                       |  7 +++++++
>  arch/x86/boot/copy.S                    | 15 +++++++++++++--
>  arch/x86/boot/string.c                  |  9 +++++++++
>  arch/x86/boot/string.h                  | 13 +++++++++++++
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  7 ++-----
>  drivers/md/raid10.c                     |  9 ++++-----
>  7 files changed, 52 insertions(+), 12 deletions(-)
>
> --
> 2.12.0.367.g23dc2f6d3c-goog
>
