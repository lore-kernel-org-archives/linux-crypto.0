From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/7] Makefile, x86, LLVM: disable unsupported optimization
 flags
Date: Fri, 17 Mar 2017 14:32:10 -0700
Message-ID: <ad94b647-4ba0-4ae9-be8f-6fe7e9406def@zytor.com>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-3-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>, Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-3-md@google.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/16/17 17:15, Michael Davidson wrote:
> Unfortunately, while clang generates a warning about these flags
> being unsupported it still exits with a status of 0 so we have
> to explicitly disable them instead of just using a cc-option check.
> 
> Signed-off-by: Michael Davidson <md@google.com>
> ---
>  Makefile          | 2 ++
>  arch/x86/Makefile | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index b21fd0ca2946..5e97e5fc1eea 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -629,7 +629,9 @@ ARCH_AFLAGS :=
>  ARCH_CFLAGS :=
>  include arch/$(SRCARCH)/Makefile
>  
> +ifneq ($(cc-name),clang)
>  KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
> +endif
>  KBUILD_CFLAGS	+= $(call cc-disable-warning,frame-address,)
>  
>  ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 2d449337a360..894a8d18bf97 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -87,11 +87,13 @@ else
>          KBUILD_AFLAGS += -m64
>          KBUILD_CFLAGS += -m64
>  
> +ifneq ($(cc-name),clang)
>          # Align jump targets to 1 byte, not the default 16 bytes:
>          KBUILD_CFLAGS += -falign-jumps=1
>  
>          # Pack loops tightly as well:
>          KBUILD_CFLAGS += -falign-loops=1
> +endif
>  
>          # Don't autogenerate traditional x87 instructions
>          KBUILD_CFLAGS += $(call cc-option,-mno-80387)
> 

NAK.  Fix your compiler, or use a wrapper script or something.  It is
absolutely *not* acceptable to disable this since future versions of
clang *should* support that.

That being said, it might make sense to look for a key pattern like
"(un|not )supported" on stderr the try-run macro.  Is there really no
-Wno- or -Werror= option to turn off this craziness?

	-hpa

