From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function
 pointers
Date: Fri, 5 Oct 2018 15:57:28 +0200
Message-ID: <20181005135728.GR19272@hirez.programming.kicks-ass.net>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
 <20181005081333.15018-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rich
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181005081333.15018-2-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 05, 2018 at 10:13:25AM +0200, Ard Biesheuvel wrote:
> Add a function pointer abstraction that can be implemented by the arch
> in a manner that avoids the downsides of function pointers, i.e., the
> fact that they are typically located in a writable data section, and
> their vulnerability to Spectre like defects.
> 
> The FFP (or fast function pointer) is callable as a function, since
> the generic incarnation is simply that. However, due to the fact that
> C does not distinguish between functions and function pointers at the
> call site, the architecture can instead emit it as a patchable sequence
> of instructions consisting of ordinary branches.

This is basically a static_key, except for indirection function calls?
So why not call the thing static_func or static_call or something like
that?
