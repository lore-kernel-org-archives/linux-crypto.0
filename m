From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH 1/7] Makefile, LLVM: add -no-integrated-as to
 KBUILD_[AC]FLAGS
Date: Mon, 3 Apr 2017 15:49:02 -0700
Message-ID: <20170403224902.GE13986@google.com>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-2-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170317001520.85223-2-md@google.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

El Thu, Mar 16, 2017 at 05:15:14PM -0700 Michael Davidson ha dit:

> Add -no-integrated-as to KBUILD_AFLAGS and KBUILD_CFLAGS
> for clang.
> 
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

Ping, any feedback on this patch?

Cheers

Matthias
