From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Thu, 22 Mar 2018 11:43:26 +0900
Message-ID: <20180322024326.GC3181@jagdpanzerIV>
References: <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcas5p2.samsung.com>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
 <20180321082628.GB2746@jagdpanzerIV>
 <1663C9A3-7DAC-4A11-894C-C99E07BEDAD2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Maninder Singh <maninder1.s@samsung.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        Kees Cook <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pankaj.m@samsung.com" <pankaj.m@samsung.com>,
        "a.sahrawat@samsung.com" <a.sahrawat@sams
To: Nick Terrell <terrelln@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1663C9A3-7DAC-4A11-894C-C99E07BEDAD2@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (03/21/18 19:56), Nick Terrell wrote:
[..]
> This seems like a reasonable extension to the algorithm, and it looks like
> LZ4_DYN is about a 5% improvement to compression ratio on your benchmark.
> The biggest question I have is if it is worthwhile to maintain a separate
> incompatible variant of LZ4 in the kernel without any upstream for a 5%
> gain? If we do want to go forward with this, we should perform more
> benchmarks.
> 
> I commented in the patch, but because the `dynOffset` variable isn't a
> compile time static in LZ4_decompress_generic(), I suspect that the patch
> causes a regression in decompression speed for both LZ4 and LZ4_DYN. You'll
> need to re-run the benchmarks to first show that LZ4 before the patch
> performs the same as LZ4 after the patch. Then re-run the LZ4 vs LZ4_DYN
> benchmarks.
> 
> I would also like to see a benchmark in user-space (with the code), so we
> can see the performance of LZ4 before and after the patch, as well as LZ4
> vs LZ4_DYN without anything else going on. I expect the extra branches in
> the decoding loop to have an impact on speed, and I would like to see how
> big the impact is without noise. 

Yes, I've been thinking about this. There are more branches now
("to dyn or not to dyn") in compression/decompression hot path but
we see less instructions and branches in perf output at the end.
And my guess is that we have a lot of noise from zram and zsmalloc.
The data is XXX bytes shorter with dyn enabled, so we use YYY less
moves and ZZZ less branches while we copy the data to zsmalloc and
from zsmalloc, and I may be that's the root cause of "performance
gain" that we see in zram-fio tests. So may be we need to run
benchmarks against lz4, not zram+lz4.

> CC-ing Yann Collet, the author of LZ4

Great, thanks.

	-ss
