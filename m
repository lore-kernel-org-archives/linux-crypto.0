From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/4] arm64: cpufeature: add feature for CRC32 instructions
Date: Mon, 10 Sep 2018 16:45:33 +0100
Message-ID: <20180910154533.3yxh7iooqbbsp7nc@armageddon.cambridge.arm.com>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
 <20180827110245.14812-3-ard.biesheuvel@linaro.org>
 <20180828170135.GC19825@arm.com>
 <CAKv+Gu-tM9aKZJ3ppt9yLVP_V5YA_yN8D1j_-NtM+qQCdnc6JA@mail.gmail.com>
 <20180904031855.mjpdndeh57lqziuk@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904031855.mjpdndeh57lqziuk@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 04, 2018 at 11:18:55AM +0800, Herbert Xu wrote:
> On Tue, Aug 28, 2018 at 08:43:35PM +0200, Ard Biesheuvel wrote:
> > On 28 August 2018 at 19:01, Will Deacon <will.deacon@arm.com> wrote:
> > > On Mon, Aug 27, 2018 at 01:02:43PM +0200, Ard Biesheuvel wrote:
> > >> Add a CRC32 feature bit and wire it up to the CPU id register so we
> > >> will be able to use alternatives patching for CRC32 operations.
> > >>
> > >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >> ---
> > >>  arch/arm64/include/asm/cpucaps.h | 3 ++-
> > >>  arch/arm64/kernel/cpufeature.c   | 9 +++++++++
> > >>  2 files changed, 11 insertions(+), 1 deletion(-)
> > >
> > > Acked-by: Will Deacon <will.deacon@arm.com>
> > >
> > > With the minor caveat below...
> > >
> > >> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> > >> index ae1f70450fb2..9932aca9704b 100644
> > >> --- a/arch/arm64/include/asm/cpucaps.h
> > >> +++ b/arch/arm64/include/asm/cpucaps.h
> > >> @@ -51,7 +51,8 @@
> > >>  #define ARM64_SSBD                           30
> > >>  #define ARM64_MISMATCHED_CACHE_TYPE          31
> > >>  #define ARM64_HAS_STAGE2_FWB                 32
> > >> +#define ARM64_HAS_CRC32                              33
> > >>
> > >> -#define ARM64_NCAPS                          33
> > >> +#define ARM64_NCAPS                          34
> > >
> > >
> > > ... if this goes via crypto, you'll almost certainly get a (trivial)
> > > conflict with arm64, since these numbers get bumped all the time.
> > >
> > 
> > I think the first three patches should go through the arm64 tree. The
> > last one just removes the now redundant crc32 SIMD driver, and Herbert
> > could pick that up separately, i.e., it should be totally independent.
> 
> Yes let's do that.

I queued the first 3 patches for 4.19. Thanks.

-- 
Catalin
