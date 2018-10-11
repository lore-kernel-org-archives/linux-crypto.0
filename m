From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 4.4.y 1/3] x86/fpu: Remove use_eager_fpu()
Date: Thu, 11 Oct 2018 17:10:52 +0200
Message-ID: <20181011151052.GB31502@kroah.com>
References: <1531270120-19068-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
 <1531270120-19068-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com,
        Ingo Molnar <mingo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gleb Natapov <
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531270120-19068-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 11, 2018 at 09:48:38AM +0900, Daniel Sangorrin wrote:
> From: Andy Lutomirski <luto@kernel.org>
> 
> commit c592b57347069abfc0dcad3b3a302cf882602597 upstream
> 
> This removes all the obvious code paths that depend on lazy FPU mode.
> It shouldn't change the generated code at all.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: pbonzini@redhat.com
> Link: http://lkml.kernel.org/r/1475627678-20788-5-git-send-email-riel@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
> ---
>  arch/x86/crypto/crc32c-intel_glue.c | 17 ++++-------------
>  arch/x86/include/asm/fpu/internal.h | 34 +--------------------------------
>  arch/x86/kernel/fpu/core.c          | 38 +++++--------------------------------
>  arch/x86/kernel/fpu/signal.c        |  8 +++-----
>  arch/x86/kvm/cpuid.c                |  4 +---
>  arch/x86/kvm/x86.c                  | 10 ----------
>  6 files changed, 14 insertions(+), 97 deletions(-)

This does not apply to the current 4.4.y tree.  Can you rebase this
series and resend it?

thanks,

greg k-h
