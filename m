Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BC41DB125;
	Tue,  4 Mar 2025 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741125175; cv=none; b=LimzES2M05pRzMvauzyYOhCBG20CEswUUnJkp0auoB1i0eL7nIEiZ7T50Z6T24g+X12Ztz1JNHtjTM+nJJPh0xx9q4mnk4jdXBdW0SP9/wsKssM6H+73cH7kVF6yfkAoqdogFHXSnZIPjjIvJCNRpqhSwuND+ZAk1wi9DJdUP+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741125175; c=relaxed/simple;
	bh=ky/RX2jDTL4rFuAVxJO8stmYSrRCdXIUOD55plGiwSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWkKW0bL+y2Q2DURgcXMi78L//lG6tbKTZsNgX3CT4MxeoBv2s98SL7YOnwJeJwHoGBiubJ6A/azAo5ib0ZO6x3s4+548gdBu+Yy03gA3uLpyiT0ohDTtbmFDmtl399RMX2D34FO43HvvMJVsUFxrS6adFRDu63tXpz/QX8qU+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cF3rM1cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cF3rM1cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6278CC4CEE5;
	Tue,  4 Mar 2025 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741125174;
	bh=ky/RX2jDTL4rFuAVxJO8stmYSrRCdXIUOD55plGiwSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cF3rM1cBFoEMvjh5TL+Fl+KtQndXFNhsyL+OHetx0ROyNvpY9jFsFAv8pgNm/mpnF
	 3QYYay0r/FWbE849OUrYv3PhEi36KZDXgZZigSmfgmDDjip8A3n0apV/4wt6TzJKFn
	 7LgYvjOhPaF7NGAhUV6IHPaeJSnDvqxkf+9pHpVeRX5fWC051Bi1ME5Lmlb1aIJ6KE
	 UmyFcxCbX6sIcWOzKP1LIIEbKrtr7q/PhDRmTMQWjR779EqF9L4KRZfGf3iM1lRhY7
	 LRph+6mh9CJakKzGuR9+mvfteWQzX3+/+ZB/woVKmXYF3NeaeR8VuENcEKsApY3KFt
	 5a3Fqg5cW9sCg==
Date: Tue, 4 Mar 2025 13:52:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Bill Wendling <morbo@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
Message-ID: <20250304215252.GA15066@sol.localdomain>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
 <20250303201509.32f6f062@pumpkin>
 <CAGG=3QV1iDn2r39v5eroO+kCvpbmJNtSeqJS+fpwb4vBG67z=w@mail.gmail.com>
 <20250303224216.30431b1d@pumpkin>
 <7BC89461-A060-462A-9B42-7C0138AA0307@zytor.com>
 <CAGG=3QUnUQL2=YxN2ozwSba2A_x-S7sAEUP5oGhCWOzu4Q9SQA@mail.gmail.com>
 <20250304043223.68ed310f@pumpkin>
 <20250304205252.59a04955@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304205252.59a04955@pumpkin>

On Tue, Mar 04, 2025 at 08:52:52PM +0000, David Laight wrote:
> On Tue, 4 Mar 2025 04:32:23 +0000
> David Laight <david.laight.linux@gmail.com> wrote:
> 
> ....
> > > For reference, GCC does much better with code gen, but only with the builtin:
> > > 
> > > .L39:
> > >         crc32q  (%rax), %rbx    # MEM[(long unsigned int *)p_40], tmp120
> > >         addq    $8, %rax        #, p
> > >         cmpq    %rcx, %rax      # _37, p
> > >         jne     .L39    #,  
> > 
> > That looks reasonable, if Clang's 8 unrolled crc32q is faster per byte
> > then you either need to unroll once (no point doing any more) or use
> > the loop that does negative offsets from the end.
> 
> Thinking while properly awake the 1% difference isn't going to be a
> difference between the above and Clang's unrolled loop.
> Clang's loop will do 8 bytes every three clocks, if the above is slower
> it'll be doing 8 bytes in 4 clocks (ok, you can get 3.5 - but unlikely)
> which would be either 25% or 33% depending which way you measure it.
> 
> ...
> > I'll find the code loop I use - machine isn't powered on at the moment.
> 
> #include <linux/perf_event.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> 
> static int pmc_id;
> static void init_pmc(void)
> {
>         static struct perf_event_attr perf_attr = {
>                 .type = PERF_TYPE_HARDWARE,
>                 .config = PERF_COUNT_HW_CPU_CYCLES,
>                 .pinned = 1,
>         };
>         struct perf_event_mmap_page *pc;
> 
>         int perf_fd;
>         perf_fd = syscall(__NR_perf_event_open, &perf_attr, 0, -1, -1, 0);
>         if (perf_fd < 0) {
>                 fprintf(stderr, "perf_event_open failed: errno %d\n", errno);
>                 exit(1);
>         }
>         pc = mmap(NULL, 4096, PROT_READ, MAP_SHARED, perf_fd, 0);
>         if (pc == MAP_FAILED) {
>                 fprintf(stderr, "perf_event mmap() failed: errno %d\n", errno);
>                 exit(1);
>         }
>         pmc_id = pc->index - 1;
> }
> 
> static inline unsigned int rdpmc(id)
> {
>         unsigned int low, high;
> 
> // You need something to force the instruction pipeline to finish.
> // lfence might be enough.
> #ifndef NOFENCE
>         asm volatile("mfence");
> #endif
>         asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (id));
> #ifndef NOFENCE
>         asm volatile("mfence");
> #endif
> 
>         // return low bits, counter might to 32 or 40 bits wide.
>         return low;
> }
> 
> The test code is then something like:
> #define PASSES 10
>         unsigned int ticks[PASSES];
>         unsigned int tick;
>         unsigned int i;
> 
>         for (i = 0; i < PASSES; i++) {
>                 tick = rdpmc(pmc_id);
>                 test_fn(buf, len);
>                 ticks[i] = rdpmc(pmc_id) - tick;
>         }
> 
>         for (i = 0; i < PASSES; i++)
>                 printf(" %5d", ticks[i]);
> 
> Make sure the data is in the l1-cache (or that dominates).
> The values output for passes 2-10 are likely to be the same to within
> a clock or two.
> I probably tried to subtract an offset for an empty test_fn().
> But you can easily work out the 'clocks per loop iteration'
> (which is what you are trying to measure) by measuring two separate
> loop lengths.
> 
> I did find that sometimes running the program gave slow results.
> But it is usually very consistent.
> Needs to be run as root.
> Clearly a hardware interrupt will generate a very big number.
> But they don't happen.
> 
> The copy I found was used for measuring ip checksum algorithms.
> Seems to output:
> $ sudo ./ipcsum 
>                 0     0   160   160   160   160   160   160   160   160   160   160  overhead
>  3637b4f0b942c3c4  682f   316    25    26    26    26    26    26    26    26    26  csum_partial
>  3637b4f0b942c3c4  682f   124    79    43    25    25    25    24    26    25    24  csum_partial_1
>  3637b4f0b942c3c4  682f   166    43    25    25    24    24    24    24    24    24  csum_new adc pair
>  3637b4f0b942c3c4  682f   115    21    21    21    21    21    21    21    21    21  adc_dec_2
>  3637b4f0b942c3c4  682f    97    34    31    23    24    24    24    24    24    23  adc_dec_4
>  3637b4f0b942c3c4  682f    39    33    34    21    21    21    21    21    21    21  adc_dec_8
>  3637b4f0b942c3c4  682f    81    52    49    52    49    26    25    27    25    26  adc_jcxz_2
>  3637b4f0b942c3c4  682f    62    46    24    24    24    24    24    24    24    24  adc_jcxz_4
>  3637b4f0b942c3c4  682f   224    40    21    21    23    23    23    23    23    23  adc_2_pair
>  3637b4f0b942c3c4  682f    42    36    37    22    22    22    22    22    22    22  adc_4_pair_old
>  3637b4f0b942c3c4  682f    42    37    34    41    23    23    23    23    23    23  adc_4_pair
>  3637b4f0b942c3c4  682f   122    19    20    19    18    19    18    19    18    19  adcx_adox
>         bef7a78a9  682f   104    51    30    30    30    30    30    30    30    30  add_c_16
>         bef7a78a9  682f   143    50    50    27    27    27    27    27    27    27  add_c_32
>         6ef7a78ae  682f   103    91    45    34    34    34    35    34    34    34  add_c_high
> 
> I don't think the current one is in there - IIRC it is as fast as the adcx_adox one
> but more portable.

I guess this thread has turned into one where everyone has to weigh in :-)

Just to summarize my thoughts on the whole thread:

- IMO we should not use the crc32 intrinsics yet, as there are too many issues
  including no stability guarantee for the builtins (or else having to figure
  out how to include immintrin.h in the kernel to get the stable functions),
  having to set the crc32 target with the correct scope, dealing with old
  compiler versions that don't support crc32, and unhelpful loop unrolling.

- https://lore.kernel.org/r/20250210210741.471725-1-ebiggers@kernel.org already
  fixed the spilling to the stack with clang.  It does result in a separate mov
  from memory instead of taking advantage of the mem operand support.  But that
  should not make much of a difference.

- crc_kunit already includes a benchmark.  I recommend using that for
  benchmarking the kernel's CRC code.  Sure, one can do a more precise analysis
  with performance counters, but IMO it's generally unnecessary.

- The 4-2-1 step-down is a good idea, and in fact crc32c-3way.S (which handles
  lengths >= 512 bytes) already does exactly that for tail handling.  I sent out
  https://lore.kernel.org/r/20250304213216.108925-1-ebiggers@kernel.org which
  adds it to the C code (which handles lengths < 512 bytes) too.

- Moving all this to assembly is still attractive, especially considering that
  lengths >= 512 bytes are already handled in assembly in crc32c-3way.S, and
  essentially the exact code we want is already in that file (it's used to
  handle anything left over from the 3-way processing).  But, I think we'll keep
  the C (with inline asm for just the crc32 instructions) version too for now.
  It's a bit more approachable, and it's nice to avoid an extra function call to
  a .S file.
