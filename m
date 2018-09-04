From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] arm64: cpufeature: add feature for CRC32 instructions
Date: Tue, 4 Sep 2018 11:18:55 +0800
Message-ID: <20180904031855.mjpdndeh57lqziuk@gondor.apana.org.au>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
 <20180827110245.14812-3-ard.biesheuvel@linaro.org>
 <20180828170135.GC19825@arm.com>
 <CAKv+Gu-tM9aKZJ3ppt9yLVP_V5YA_yN8D1j_-NtM+qQCdnc6JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-tM9aKZJ3ppt9yLVP_V5YA_yN8D1j_-NtM+qQCdnc6JA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 28, 2018 at 08:43:35PM +0200, Ard Biesheuvel wrote:
> On 28 August 2018 at 19:01, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Aug 27, 2018 at 01:02:43PM +0200, Ard Biesheuvel wrote:
> >> Add a CRC32 feature bit and wire it up to the CPU id register so we
> >> will be able to use alternatives patching for CRC32 operations.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >>  arch/arm64/include/asm/cpucaps.h | 3 ++-
> >>  arch/arm64/kernel/cpufeature.c   | 9 +++++++++
> >>  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > Acked-by: Will Deacon <will.deacon@arm.com>
> >
> > With the minor caveat below...
> >
> >> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> >> index ae1f70450fb2..9932aca9704b 100644
> >> --- a/arch/arm64/include/asm/cpucaps.h
> >> +++ b/arch/arm64/include/asm/cpucaps.h
> >> @@ -51,7 +51,8 @@
> >>  #define ARM64_SSBD                           30
> >>  #define ARM64_MISMATCHED_CACHE_TYPE          31
> >>  #define ARM64_HAS_STAGE2_FWB                 32
> >> +#define ARM64_HAS_CRC32                              33
> >>
> >> -#define ARM64_NCAPS                          33
> >> +#define ARM64_NCAPS                          34
> >
> >
> > ... if this goes via crypto, you'll almost certainly get a (trivial)
> > conflict with arm64, since these numbers get bumped all the time.
> >
> 
> I think the first three patches should go through the arm64 tree. The
> last one just removes the now redundant crc32 SIMD driver, and Herbert
> could pick that up separately, i.e., it should be totally independent.

Yes let's do that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
