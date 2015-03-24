From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 14:06:42 +0100
Message-ID: <CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
	<20150324122702.GJ14457@ns203013.ovh.net>
	<CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
	<20150324130511.GK14457@ns203013.ovh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sami Tolvanen <samitolvanen@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Polyakov <appro@openssl.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36202 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbCXNGm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 09:06:42 -0400
Received: by iedm5 with SMTP id m5so59590013ied.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2015 06:06:42 -0700 (PDT)
In-Reply-To: <20150324130511.GK14457@ns203013.ovh.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2015 at 14:05, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
>  >> +     '&eor   ($t0,$t0,$a,"ror#".($Sigma0[2]-$Sigma0[0]))',   # Sigma0(a)
>> >> +     '&add   ($h,$h,$t1)',                   # h+=Ch(e,f,g)
>> >> +     '&ldr   ($t1,sprintf "[sp,#%d]",4*(($j+1)&15))  if (($j&15)!=15);'.
>> >> +     '&ldr   ($t1,"[$Ktbl]")                         if ($j==15);'.
>> >> +     '&ldr   ($t1,"[sp,#64]")                        if ($j==31)',
>> >> +     '&and   ($t3,$t3,$t2)',                 # (b^c)&=(a^b)
>> >> +     '&add   ($d,$d,$h)',                    # d+=h
>> >> +     '&add   ($h,$h,$t0,"ror#$Sigma0[0]");'. # h+=Sigma0(a)
>> >> +     '&eor   ($t3,$t3,$b)',                  # Maj(a,b,c)
>> >> +     '$j++;  unshift(@V,pop(@V)); ($t2,$t3)=($t3,$t2);'
>> >> +     )
>> >> +}
>> >> +
>> >> +$code.=<<___;
>> >> +#if __ARM_MAX_ARCH__>=7
>> > this will be compile on armv4 but gcc will not allow it
>> >
>> > we need to drop the neon code for older non v7 build
>> >
>>
>> The .arch and .fpu declarations ensure that it can be built regardless
>> of the platform you are compiling for, unless you have a really old
>> toolchain.
> I known but does not work for me
>> The glue code ensures that the module can only be loaded if HWCAP_NEON is set.
>>
>> Did you get errors trying to build it?
>
> yes I do
>
> I use
>
> arm-none-linux-gnueabi-gcc (Sourcery CodeBench Lite 2014.05-29) 4.8.3 20140320
> (prerelease)
> Copyright (C) 2013 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> so it's not that old
>

Could you share the error log please?
