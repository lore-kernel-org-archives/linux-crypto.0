Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87E6C43334
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jul 2022 17:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiGXRAt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 13:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGXRAt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 13:00:49 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCCAEE3F
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 10:00:45 -0700 (PDT)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C9D9A3F12C
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1658682043;
        bh=A2EBTwoVYX14a4fWbZ0vCjcrE9v4KPce0Km1BN1L64o=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=YBFKs6DViBnvsXi3Lrg3GTyzO9ksEgePL1bykhQtIv5aT0XVltYi3Twzu2n2G50rM
         fqqrxO9NxzQ2iBgvJVMt9Ha16pJmQykBIrxyiylNfWUl0dy/eoXiF0VxJcMk0G+rRd
         mbUYW1KgUzEUmTo8HFLq4++KMaOt6HWlgKv51Q4KBVwvC52mRVpYkjgQdsaukAFXYj
         qfEQnRHwc87Ttp5UFUbs/GKZTJ2OMvd+iMush6PJLmKzKQ89UoyhITprwxuiAp3UqU
         sz266xe4859RR7uwmMzNllMxiSrI7gWxj9/6vDofwK6Mf2TO0P9jZzeuFfygdicNAJ
         41nhvpjkH+f0w==
Received: by mail-lj1-f200.google.com with SMTP id b23-20020a2e8497000000b0025d4590922cso1682929ljh.7
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 10:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A2EBTwoVYX14a4fWbZ0vCjcrE9v4KPce0Km1BN1L64o=;
        b=8MaxOE/fcmeP2C/6pztZr5vN0tQ4NcZzz+SEGUZktr4CDsveyGV6L8PwgxBUS1VcBy
         Ofm81wRTVCQ+lI0mrEHKXYF+9Vqn/2sIRn4aSBfdtCuv0o5laiJd+d/kEA09s1EZOer+
         m4ScqutjgyYJr5kAxa1gDr7Y7F7txZnjY/dm3kpFgxX+LBzOo9DWFs5cM9BDZhm+NHMI
         P1OXDUOS/QjjqxNwE/rePdO/MGT2SEw5e37YEcV76mj/7ZfSl0do9Rvxa9ixoSp2yv+z
         iMJp5dk7mL/vssBAvQREkitTgcQxNCl0F2RuX9jEvmKQafclfEb/bsG07jhOtJZd4wS9
         VQqQ==
X-Gm-Message-State: AJIora9fY3bU6p4VISINVCVuYsWc5vUv/TKmsnDXM6J8wqdY4YOlJr65
        R+rTjf+vLHnIc0TlbCUyGp98YR2827k+c7doc5bVqfRwdtuZ0KGZnHBVoRIrcO/SrghIT8dWrBn
        Dizrg4/5iWf1w+iK6I5n9qxJi41Jr+RoDJ+kmJfh4yg==
X-Received: by 2002:a2e:aa0b:0:b0:25e:8fa:3c22 with SMTP id bf11-20020a2eaa0b000000b0025e08fa3c22mr153215ljb.149.1658682042956;
        Sun, 24 Jul 2022 10:00:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uLE7FYtkFXRRn9lB5ptQTIPDy2Dd7YigerXtjJDXWHgv3ONzaHYw2zgFn8N9LB7WKxCTQdmA==
X-Received: by 2002:a2e:aa0b:0:b0:25e:8fa:3c22 with SMTP id bf11-20020a2eaa0b000000b0025e08fa3c22mr153205ljb.149.1658682042547;
        Sun, 24 Jul 2022 10:00:42 -0700 (PDT)
Received: from [192.168.8.186] (87-49-44-169-mobile.dk.customer.tdc.net. [87.49.44.169])
        by smtp.gmail.com with ESMTPSA id a5-20020a056512390500b00477c5940bbasm693374lfu.265.2022.07.24.10.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jul 2022 10:00:41 -0700 (PDT)
Message-ID: <d731c9b8-cef8-5916-ab79-7edf5a3ede1e@canonical.com>
Date:   Sun, 24 Jul 2022 19:00:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] crypto: fix warnings from missing .note.GNU-stack
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>, Ben Dooks <ben-linux@fluff.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20220721204709.445216-1-ben-linux@fluff.org>
 <CAMj1kXHvf8vWTL=6HzQGcUMK3Qwd9-s5qKAhJzGuk_cEa=cZkQ@mail.gmail.com>
From:   Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <CAMj1kXHvf8vWTL=6HzQGcUMK3Qwd9-s5qKAhJzGuk_cEa=cZkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/23/22 12:37, Ard Biesheuvel wrote:
> On Thu, 21 Jul 2022 at 22:48, Ben Dooks <ben-linux@fluff.org> wrote:
>>
>> A lot of the assembly code in arch/arm/crypto is missing
>> a .note.GNU-stack section which is making a numbe of warnings
>> about implicit executable stack. This code does not look like
>> it does not need an executable stack, so silence the warnings
>> by adding a .section .note.GNU-stack to all these.
>>
>> Since this is an empty section, it should be backwards compatible
>> with older linkers.
>>
>> Fixes the following warnings:
>>
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/aes-cipher-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/aes-neonbs-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha1-armv4-large.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha1-armv7-neon.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha256-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha512-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/chacha-neon-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/aes-ce-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha1-ce-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/sha2-ce-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/ghash-ce-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>> arm-linux-gnueabihf-ld: warning: arch/arm/crypto/crc32-ce-core.o: missing .note.GNU-stack section implies executable stack
>> arm-linux-gnueabihf-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>>
>> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Hello Ben,
> 
> This annotation is pointless in the kernel, as we never load any code
> as ELF executables. We only load raw binaries or partially linked
> objects, which don't carry this annotation, and we never use an
> executable stack anyway.
> 
> So instead of adding these annotations, can we please just find a way
> to shut up the linker?

Passing -zexecstack to gcc silences the warning.

This is what we use in U-Boot for ELF files that are only used as 
intermediaries to create EFI binaries.

> 
> 
>> ---
>>   arch/arm/crypto/aes-ce-core.S        | 2 ++
>>   arch/arm/crypto/aes-cipher-core.S    | 2 ++
>>   arch/arm/crypto/aes-neonbs-core.S    | 3 +++
>>   arch/arm/crypto/chacha-neon-core.S   | 2 ++
>>   arch/arm/crypto/chacha-scalar-core.S | 2 ++
>>   arch/arm/crypto/crc32-ce-core.S      | 2 ++
>>   arch/arm/crypto/ghash-ce-core.S      | 2 ++
>>   arch/arm/crypto/sha1-armv4-large.S   | 1 +
>>   arch/arm/crypto/sha1-armv7-neon.S    | 2 ++
>>   arch/arm/crypto/sha1-ce-core.S       | 2 ++
>>   arch/arm/crypto/sha2-ce-core.S       | 2 ++
>>   arch/arm/crypto/sha256-armv4.pl      | 1 +
>>   arch/arm/crypto/sha512-armv4.pl      | 1 +
>>   13 files changed, 24 insertions(+)
>>
>> diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
>> index 312428d83eed..4e570c6df9bb 100644
>> --- a/arch/arm/crypto/aes-ce-core.S
>> +++ b/arch/arm/crypto/aes-ce-core.S
>> @@ -711,3 +711,5 @@ ENDPROC(ce_aes_invert)
>>          .byte            0x8,  0x9,  0xa,  0xb,  0xc,  0xd,  0xe,  0xf
>>          .byte           0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>>          .byte           0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
>> index 1da3f41359aa..11f10ee35487 100644
>> --- a/arch/arm/crypto/aes-cipher-core.S
>> +++ b/arch/arm/crypto/aes-cipher-core.S
>> @@ -199,3 +199,5 @@ ENDPROC(__aes_arm_encrypt)
>>   ENTRY(__aes_arm_decrypt)
>>          do_crypt        iround, crypto_it_tab, crypto_aes_inv_sbox, 0
>>   ENDPROC(__aes_arm_decrypt)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
>> index 7b61032f29fa..19197c0d635c 100644
>> --- a/arch/arm/crypto/aes-neonbs-core.S
>> +++ b/arch/arm/crypto/aes-neonbs-core.S
>> @@ -1041,3 +1041,6 @@ ENTRY(aesbs_xts_decrypt)
>>          ldr             ip, [sp, #8]            // reorder final tweak?
>>          __xts_crypt     aesbs_decrypt8, q0, q1, q6, q4, q2, q7, q3, q5
>>   ENDPROC(aesbs_xts_decrypt)
>> +
>> +.section .note.GNU-stack,"",%progbits

Would llvm-as understand this?

Best regards

Heinrich

>> +
>> diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/chacha-neon-core.S
>> index 13d12f672656..a90690d32ad8 100644
>> --- a/arch/arm/crypto/chacha-neon-core.S
>> +++ b/arch/arm/crypto/chacha-neon-core.S
>> @@ -641,3 +641,5 @@ ENDPROC(chacha_4block_xor_neon)
>>          .byte           0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
>>          .byte           0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
>>          .byte           0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/chacha-scalar-core.S b/arch/arm/crypto/chacha-scalar-core.S
>> index 083fe1ab96d0..81f94876f418 100644
>> --- a/arch/arm/crypto/chacha-scalar-core.S
>> +++ b/arch/arm/crypto/chacha-scalar-core.S
>> @@ -441,3 +441,5 @@ ENTRY(hchacha_block_arm)
>>   1:     _chacha_permute 12
>>          b               0b
>>   ENDPROC(hchacha_block_arm)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
>> index 3f13a76b9066..990c756c7487 100644
>> --- a/arch/arm/crypto/crc32-ce-core.S
>> +++ b/arch/arm/crypto/crc32-ce-core.S
>> @@ -304,3 +304,5 @@ ENDPROC(crc32_armv8_le)
>>   ENTRY(crc32c_armv8_le)
>>          __crc32         c
>>   ENDPROC(crc32c_armv8_le)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
>> index 9f51e3fa4526..2f712b9d8b2b 100644
>> --- a/arch/arm/crypto/ghash-ce-core.S
>> +++ b/arch/arm/crypto/ghash-ce-core.S
>> @@ -337,3 +337,5 @@ ENTRY(pmull_ghash_update_p8)
>>
>>          ghash_update    p8
>>   ENDPROC(pmull_ghash_update_p8)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/sha1-armv4-large.S b/arch/arm/crypto/sha1-armv4-large.S
>> index 1c8b685149f2..4e40132382b5 100644
>> --- a/arch/arm/crypto/sha1-armv4-large.S
>> +++ b/arch/arm/crypto/sha1-armv4-large.S
>> @@ -505,3 +505,4 @@ ENTRY(sha1_block_data_order)
>>   ENDPROC(sha1_block_data_order)
>>   .asciz "SHA1 block transform for ARMv4, CRYPTOGAMS by <appro@openssl.org>"
>>   .align 2
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/sha1-armv7-neon.S b/arch/arm/crypto/sha1-armv7-neon.S
>> index 28d816a6a530..a554b1bb4ceb 100644
>> --- a/arch/arm/crypto/sha1-armv7-neon.S
>> +++ b/arch/arm/crypto/sha1-armv7-neon.S
>> @@ -632,3 +632,5 @@ ENTRY(sha1_transform_neon)
>>   .Ldo_nothing:
>>     bx lr
>>   ENDPROC(sha1_transform_neon)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/sha1-ce-core.S b/arch/arm/crypto/sha1-ce-core.S
>> index 8a702e051738..73353804c33f 100644
>> --- a/arch/arm/crypto/sha1-ce-core.S
>> +++ b/arch/arm/crypto/sha1-ce-core.S
>> @@ -121,3 +121,5 @@ ENTRY(sha1_ce_transform)
>>          vstr            dgbs, [r0, #16]
>>          bx              lr
>>   ENDPROC(sha1_ce_transform)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/sha2-ce-core.S b/arch/arm/crypto/sha2-ce-core.S
>> index b6369d2440a1..b5f20ab96690 100644
>> --- a/arch/arm/crypto/sha2-ce-core.S
>> +++ b/arch/arm/crypto/sha2-ce-core.S
>> @@ -121,3 +121,5 @@ ENTRY(sha2_ce_transform)
>>          vst1.32         {dga-dgb}, [r0]
>>          bx              lr
>>   ENDPROC(sha2_ce_transform)
>> +
>> +.section .note.GNU-stack,"",%progbits
>> diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
>> index f3a2b54efd4e..c12edbd99531 100644
>> --- a/arch/arm/crypto/sha256-armv4.pl
>> +++ b/arch/arm/crypto/sha256-armv4.pl
>> @@ -677,6 +677,7 @@ $code.=<<___;
>>   #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
>>   .comm   OPENSSL_armcap_P,4,4
>>   #endif
>> +.section .note.GNU-stack,"",%progbits
>>   ___
>>
>>   open SELF,$0;
>> diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
>> index 2fc3516912fa..6411799b4d1d 100644
>> --- a/arch/arm/crypto/sha512-armv4.pl
>> +++ b/arch/arm/crypto/sha512-armv4.pl
>> @@ -639,6 +639,7 @@ $code.=<<___;
>>   #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
>>   .comm  OPENSSL_armcap_P,4,4
>>   #endif
>> +.section .note.GNU-stack,"",%progbits
>>   ___
>>
>>   $code =~ s/\`([^\`]*)\`/eval $1/gem;
>> --
>> 2.35.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
