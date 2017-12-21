From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Thu, 21 Dec 2017 11:20:19 +0100
Message-ID: <CAK8P3a2b7+KxJ5kKYcnrAV8jDkNBiCR4gCg47iRsiZGdyPoGVg@mail.gmail.com>
References: <20171220205213.1025257-1-arnd@arndb.de> <20171220214648.GO2353@tucnak>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36422 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbdLUKUV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 05:20:21 -0500
In-Reply-To: <20171220214648.GO2353@tucnak>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 10:46 PM, Jakub Jelinek <jakub@redhat.com> wrote:
> On Wed, Dec 20, 2017 at 09:52:05PM +0100, Arnd Bergmann wrote:
>> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
>> index ca554d57d01e..35f973ba9878 100644
>> --- a/crypto/aes_generic.c
>> +++ b/crypto/aes_generic.c
>> @@ -1331,6 +1331,20 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>>       f_rl(bo, bi, 3, k);     \
>>  } while (0)
>>
>> +#if __GNUC__ >= 7
>> +/*
>> + * Newer compilers try to optimize integer arithmetic more aggressively,
>> + * which generally improves code quality a lot, but in this specific case
>> + * ends up hurting more than it helps, in some configurations drastically
>> + * so. This turns off two optimization steps that have been shown to
>> + * lead to rather badly optimized code with gcc-7.
>> + *
>> + * See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
>> + */
>> +#pragma GCC optimize("-fno-tree-pre")
>> +#pragma GCC optimize("-fno-tree-sra")
>
> So do it only when UBSAN is enabled?  GCC doesn't have a particular
> predefined macro for those (only for asan and tsan), but either the kernel
> does have something already, or could have something added in the
> corresponding Makefile.

My original interpretation of the resulting object code suggested that disabling
those two optimizations produced better results for this particular
file even without
UBSAN, on both gcc-7 and gcc-8 (but not gcc-6), so my patch might have
been better, but I did some measurements now as Ard suggested, showing
cycles/byte for AES256/CBC with 8KB blocks:


               default      ubsan         patched        patched+ubsan
gcc-4.3.6        14.9        ----           14.9         ----
gcc-4.6.4        15.0        ----           15.8         ----
gcc-4.9.4        15.5        20.7           15.9         20.9
gcc-5.5.0        15.6        47.3           86.4         48.8
gcc-6.3.1        14.6        49.4           94.3         50.9
gcc-7.1.1        13.5        54.6           15.2         52.0
gcc-7.2.1        16.8       124.7           92.0         52.2
gcc-8.0.0        15.0      no boot          15.3        no boot

I checked that there are actually three significant digits on the measurements,
detailed output is available at https://pastebin.com/eFsWYjQp

It seems that I was wrong about the interpretation that disabling
the optimization would be a win on gcc-7 and higher, it almost
always makes things worse even with UBSAN. Making that
check "#if __GNUC__ == 7 && IS_ENABLED(CONFIG_UBSAN_SANITIZE_ALL)"
would help here, or we could list the file as an exception for
UBSAN and never sanitize it.

Looking at the 'default' column, I wonder if anyone would be interested
in looking at why the throughput regressed with gcc-7.2 and gcc-8.

       Arnd
