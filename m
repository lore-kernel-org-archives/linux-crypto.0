From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: linux-next: Tree for Jun 13 (crypto)
Date: Wed, 13 Jun 2012 22:14:58 +0300
Message-ID: <20120613221458.21085iwxklwljhwc@www.81.fi>
References: <20120613155440.14672516ffaf5b01f91bb0a2@canb.auug.org.au>
 <4FD8BB95.4000307@xenotime.net> <20120613200317.20733xjrnmv47y04@www.81.fi>
 <20120613190540.GY17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120613190540.GY17705@kronos.redsun>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> On Wed, Jun 13, 2012 at 08:03:17PM +0300, Jussi Kivilinna wrote:
>> >arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_xts_decrypt':
>> >(.text+0x856c): multiple definition of `serpent_xts_decrypt'
>> >arch/x86/crypto/serpent-sse2-x86_64.o:(.text+0xae8): first defined here
>>
>> Reverting commit e2f4d85d5b2049a90859aa10de914ed31a4f17a4, "crypto:
>> serpent - add common glue code for avx and sse2 implementation",
>> should help for most.
>>
>> >arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_dec_blk_8way':
>> >(.text+0x3d70): multiple definition of `serpent_dec_blk_8way'
>> >arch/x86/crypto/serpent-avx-x86_64.o: In function `__serpent_enc_blk_8way':
>> >(.text+0x0): multiple definition of `__serpent_enc_blk_8way'
>>
>> Attached patch should solve these (patch depends on above revert).
>
> I'm really sorry about this, it shouldn't have happened. The most easiest
> solution to this problem would be to make the choice between
> CRYPTO_SERPENT_SSE2_X86_64 and CRYPTO_SERPENT_AVX_X86_64 an  
> exclusive-or choice
> in crypto/Kconfig. I don't think there is an use-case, where somebody would
> want to link both implementations into the same kernel image or even  
> load both
> implementations as module. This would avoid duplicating the glue-code again.

I'd think that most common use-case is distro-kernel, where all and  
everything is enabled by default.

>
> Another possibility would be to add a serpent-common-x86_64 module, but this
> wouldn't be a trivial change and imo a little bit too much just to avoid
> duplicating this code.

I'm working on patch-set that takes common glue code from  
serpent-sse2, serpent-avx, twofish-3way, twofish-avx and  
camellia-x86_64, to shared ablk_helper and glue_helper modules.

-Jussi
