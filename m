From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Mon, 16 Apr 2018 13:01:18 -0700
Message-ID: <20180416200118.GA10051@gmail.com>
References: <20180329102613epcms5p6ffaa80d12115ded8f3c9ef01dd009744@epcms5p6>
 <20180329102046epcms5p8ecc9532b03bab4f47cbdbb2507171b86@epcms5p8>
 <20180323134319epcms5p62e6021aa33c941c46ecdb8b5364b614c@epcms5p6>
 <1663C9A3-7DAC-4A11-894C-C99E07BEDAD2@fb.com>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
 <20180321082628.GB2746@jagdpanzerIV>
 <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcms5p4>
 <20180416102138epcms5p429e04b68b94dcf80cd84f7008467ed68@epcms5p4>
 <74EB06AE-E1CA-4B06-9935-596DCFAC951C@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "maninder1.s@samsung.com" <maninder1.s@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>,
        Nick Terrell <terrelln@fb.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
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
To: Yann Collet <cyan@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <74EB06AE-E1CA-4B06-9935-596DCFAC951C@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 16, 2018 at 07:34:29PM +0000, Yann Collet wrote:
> Hi Singh
> 
> I don't have any strong opinion on this topic.
> 
> You made your case clear: 
> your variant trades a little bit of speed for a little bit more compression ratio.
> In the context of zram, it makes sense, and I would expect it to work, as advertised in your benchmark results.
> (disclaimer: I haven't reproduced these results, just, they look reasonable to me, I have no reason to doubt them).
> 
> So, the issue is less about performance, than about code complexity.
> 
> As mentioned, this is an incompatible variant.
> So, it requires its own entry point, and preferably its own code path
> (even if it's heavily duplicated,
> mixing it with regular lz4 source code, as proposed in the patch, will be bad for maintenance, 
> and can negatively impact regular lz4 usage, outside of zram).
> 
> So that's basically the "cost" of adding this option.
> 
> Is it worth it?
> Well, this is completely outside of my responsibility area, so I really can't tell.
> You'll have to convince people in charge that the gains are worth their complexity,
> since _they_ will inherit the duty to keep the system working through its future evolutions.
> At a minimum, you are targeting maintainers of zram and the crypto interface.
> For this topic, they are the right people to talk to.
> 
> 
> ﻿On 4/16/18, 04:09, "Maninder Singh" <maninder1.s@samsung.com> wrote:
> 
>     
>      Hello Nick/ Yann,
>     
>     Any inputs regarding LZ4 dyn results & lz4 dyn approach.
>     
>     >Hello Nick/Sergey,
>     > 
>     >Any suggestion or comments, so that we can change code and resend the patch?
>     > 
>     >> Hi Nick / Sergey,
>     >> 
>     >> 
>     >> We have compared LZ4 Dyn with Original LZ4 using some samples of realtime application data(4Kb)
>     >> compressed/decompressed by ZRAM. For comparison we have used lzbench (https://github.com/inikep/lzbench)
>     >> we have implemented dedicated LZ4 Dyn API & kept last literal length as 6 to avoid overhead 
>     >> of checks. It seems in average case there is a saving of 3~4% in compression ratio with almost same compression
>     >> speed and minor loss in decompression speed (~50MB/s) when compared with LZ4.
>     >> 
>     >> Comparison of Lz4 Dyn with LZO1x is also done as LZO1x is default compressor of ZRAM.
>     >> 

Unfortunately the track record of maintaining compression code in the Linux
kernel is not great.  zlib for example was forked from v1.2.3, which was
released in 2005, and hasn't been updated since besides some random drive-by
patches which have made it diverge even further from upstream.  There have even
been bugs assigned CVE numbers in upstream zlib, and I don't think anyone has
looked at whether the Linux kernel version has those bugs or not.

The story with LZ4 is a bit better as someone updated it to v1.7.3 last year.
But, it took a lot of rounds of review in which I had to point out some subtle
regressions like the hash table size being accidentally changed, and things not
being inlined that should be.  And of course now that version is outdated
already.

We also have LZO and Zstandard in the kernel to maintain too, as well as XZ
decompression.

And very problematically, *none* of these compression algorithms have a
maintainer listed in the MAINTAINERS file.

So in my opinion, as a prerequisite for this change, someone would need to
volunteer to actually maintain LZ4 in the kernel.

Thanks,

Eric
