From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH 0/3] crypto: x86/sha1 - regression and other fixes
Date: Tue, 25 Mar 2014 08:55:41 +0100
Message-ID: <CA+rthh9c5wVEtXnC3-0AiQgdWPvSmhABDoGb_ZCqfJ0APG2Qqg@mail.gmail.com>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
	<1395682173.2367.66.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Marek Vasut <marex@denx.de>
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36932 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaCYHzm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Mar 2014 03:55:42 -0400
Received: by mail-lb0-f175.google.com with SMTP id w7so67827lbi.34
        for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2014 00:55:41 -0700 (PDT)
In-Reply-To: <1395682173.2367.66.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2014 18:29, chandramouli narayanan <mouli@linux.intel.com> wrote:
> On Mon, 2014-03-24 at 17:10 +0100, Mathias Krause wrote:
>> The recent addition of the AVX2 variant of the SHA1 hash function wrongly
>> disabled the AVX variant by introducing a flaw in the feature test. Fixed
>> in patch 1.
>>
>> The alignment calculations of the AVX2 assembler implementation are
>> questionable, too. Especially the page alignment of the stack pointer is
>> broken in multiple ways. Fixed in patch 2. In patch 3 another issue for
>> code alignment is fixed.
>>
>> Please apply!
>>
>> Mathias Krause (3):
>>   crypto: x86/sha1 - re-enable the AVX variant
>>   crypto: x86/sha1 - fix stack alignment of AVX2 variant
>>   crypto: x86/sha1 - reduce size of the AVX2 asm implementation
>>
>>  arch/x86/crypto/sha1_avx2_x86_64_asm.S |    8 ++------
>>  arch/x86/crypto/sha1_ssse3_glue.c      |   26 ++++++++++++++++----------
>>  2 files changed, 18 insertions(+), 16 deletions(-)
>>
> Your fixes are the right on mark. I went through your patches and tested
> them and found to be correct.

Thanks for double-checking!

> Sorry for causing regression and missing alignment issues in the patches
> I submitted.

No problem with that. But as I'm not subscribed to the linux-crypto
mailing list I haven't seen your earlier submissions. Otherwise I
would have objected earlier. ;)

Thanks,
Mathias
