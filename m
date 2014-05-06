From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH resend 01/15] asm-generic: allow generic unaligned access
 if the arch supports it
Date: Tue, 6 May 2014 16:34:23 +0200
Message-ID: <CAKv+Gu_YAd=0gsB=XG0syR+aEJerunvr_SQKtMopMPr5WOQ66w@mail.gmail.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
	<1398959381-8126-2-git-send-email-ard.biesheuvel@linaro.org>
	<20140506143120.GD23957@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:39921 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaEFOeZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 10:34:25 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so1664805lbg.4
        for <linux-crypto@vger.kernel.org>; Tue, 06 May 2014 07:34:24 -0700 (PDT)
In-Reply-To: <20140506143120.GD23957@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6 May 2014 16:31, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, May 01, 2014 at 04:49:33PM +0100, Ard Biesheuvel wrote:
>> Switch the default unaligned access method to 'hardware implemented'
>> if HAVE_EFFICIENT_UNALIGNED_ACCESS is set.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  include/asm-generic/unaligned.h | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> I'm happy to take this patch via the arm64 tree. But arm is affected as
> well, so it would be good to know if Russell has any objections (cc'ed).
>
> Patch below for reference. Thanks.
>

Russell has already replied to that:
http://marc.info/?l=linux-arm-kernel&m=139696976302889&w=2

Regards,
Ard.


>> diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
>> index 03cf5936bad6..1ac097279db1 100644
>> --- a/include/asm-generic/unaligned.h
>> +++ b/include/asm-generic/unaligned.h
>> @@ -4,22 +4,27 @@
>>  /*
>>   * This is the most generic implementation of unaligned accesses
>>   * and should work almost anywhere.
>> - *
>> - * If an architecture can handle unaligned accesses in hardware,
>> - * it may want to use the linux/unaligned/access_ok.h implementation
>> - * instead.
>>   */
>>  #include <asm/byteorder.h>
>>
>> +/* Set by the arch if it can handle unaligned accesses in hardware. */
>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +# include <linux/unaligned/access_ok.h>
>> +#endif
>> +
>>  #if defined(__LITTLE_ENDIAN)
>> -# include <linux/unaligned/le_struct.h>
>> -# include <linux/unaligned/be_byteshift.h>
>> +# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +#  include <linux/unaligned/le_struct.h>
>> +#  include <linux/unaligned/be_byteshift.h>
>> +# endif
>>  # include <linux/unaligned/generic.h>
>>  # define get_unaligned       __get_unaligned_le
>>  # define put_unaligned       __put_unaligned_le
>>  #elif defined(__BIG_ENDIAN)
>> -# include <linux/unaligned/be_struct.h>
>> -# include <linux/unaligned/le_byteshift.h>
>> +# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +#  include <linux/unaligned/be_struct.h>
>> +#  include <linux/unaligned/le_byteshift.h>
>> +# endif
>>  # include <linux/unaligned/generic.h>
>>  # define get_unaligned       __get_unaligned_be
>>  # define put_unaligned       __put_unaligned_be
>> --
>> 1.8.3.2
