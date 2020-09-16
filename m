Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9E8C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 07:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D687206A4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 07:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=agner.ch header.i=@agner.ch header.b="IIQup0wB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIPHpc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 03:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgIPHpb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 03:45:31 -0400
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Sep 2020 00:45:29 PDT
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FAFC06174A
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 00:45:29 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 190E05C18D9;
        Wed, 16 Sep 2020 09:35:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1600241740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jn3SW9Ma2DI9wQ0f4YbqotwKjivqOg+8m+LV1CAtLCM=;
        b=IIQup0wBXX14zLxSfWaYmePbKf7TcO6b0SzBYn833xEC+GQsaNRVkPubecx0+pklBl5Iky
        QAvxANSFz5NMj+e/kKqxIQCzVH7hHnHBwpiqKBxk1nKmilbGlzQxaGGtUZXEDxoXVa3hoy
        QUQ5AdSVRl6wVnt7R4168bq5z0+lwKQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Sep 2020 09:35:40 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Smith <Peter.Smith@arm.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
In-Reply-To: <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
References: <20200915094619.32548-1-ardb@kernel.org>
 <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
 <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <b97cf037b2ca28a75125a31ef020ec86@agner.ch>
X-Sender: stefan@agner.ch
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-09-15 23:31, Ard Biesheuvel wrote:
> On Tue, 15 Sep 2020 at 21:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
>>
>> On Tue, Sep 15, 2020 at 2:46 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>> >
>> > The ADRL pseudo instruction is not an architectural construct, but a
>> > convenience macro that was supported by the ARM proprietary assembler
>> > and adopted by binutils GAS as well, but only when assembling in 32-bit
>> > ARM mode. Therefore, it can only be used in assembler code that is known
>> > to assemble in ARM mode only, but as it turns out, the Clang assembler
>> > does not implement ADRL at all, and so it is better to get rid of it
>> > entirely.
>> >
>> > So replace the ADRL instruction with a ADR instruction that refers to
>> > a nearer symbol, and apply the delta explicitly using an additional
>> > instruction.
>> >
>> > Cc: Nick Desaulniers <ndesaulniers@google.com>
>> > Cc: Stefan Agner <stefan@agner.ch>
>> > Cc: Peter Smith <Peter.Smith@arm.com>
>> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> > ---
>> > I will leave it to the Clang folks to decide whether this needs to be
>> > backported and how far, but a Cc stable seems reasonable here.
>> >
>> >  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
>> >  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
>> >  2 files changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
>> > index 9f96ff48e4a8..8aeb2e82f915 100644
>> > --- a/arch/arm/crypto/sha256-armv4.pl
>> > +++ b/arch/arm/crypto/sha256-armv4.pl
>> > @@ -175,7 +175,6 @@ $code=<<___;
>> >  #else
>> >  .syntax unified
>> >  # ifdef __thumb2__
>> > -#  define adrl adr
>> >  .thumb
>> >  # else
>> >  .code   32
>> > @@ -471,7 +470,8 @@ sha256_block_data_order_neon:
>> >         stmdb   sp!,{r4-r12,lr}
>> >
>> >         sub     $H,sp,#16*4+16
>> > -       adrl    $Ktbl,K256
>> > +       adr     $Ktbl,.Lsha256_block_data_order
>> > +       add     $Ktbl,$Ktbl,#K256-.Lsha256_block_data_order
>> >         bic     $H,$H,#15               @ align for 128-bit stores
>> >         mov     $t2,sp
>> >         mov     sp,$H                   @ alloca
>> > diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
>> > index ea04b2ab0c33..1861c4e8a5ba 100644
>> > --- a/arch/arm/crypto/sha256-core.S_shipped
>> > +++ b/arch/arm/crypto/sha256-core.S_shipped
>> > @@ -56,7 +56,6 @@
>> >  #else
>> >  .syntax unified
>> >  # ifdef __thumb2__
>> > -#  define adrl adr
>> >  .thumb
>> >  # else
>> >  .code   32
>> > @@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
>> >         stmdb   sp!,{r4-r12,lr}
>> >
>> >         sub     r11,sp,#16*4+16
>> > -       adrl    r14,K256
>> > +       adr     r14,.Lsha256_block_data_order
>> > +       add     r14,r14,#K256-.Lsha256_block_data_order
>>
>> Hi Ard,
>> Thanks for the patch.  With this patch applied:
>>
>> $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1
>> -j71 defconfig
>> $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
>> ...
>> arch/arm/crypto/sha256-core.S:2038:2: error: out of range immediate fixup value
>>  add r14,r14,#K256-.Lsha256_block_data_order
>>  ^
>>
>> :(
>>
> 
> Strange. Could you change it to
> 
> sub r14,r14,#.Lsha256_block_data_order-K256
> 
> and try again?
> 
> If that does work, it means the Clang assembler does not update the
> instruction type for negative addends (add to sub in this case), which
> would be unfortunate, since it would be another functionality gap.

Hm interesting, I did not come across another instance where this was a
problem.

In this particular case, is it guaranteed to be a subtraction? I guess
then using sub for now would be fine...?

FWIW, we discussed possible solution also in this issue
(mach-omap2/sleep34xx.S case is handled already):
https://github.com/ClangBuiltLinux/linux/issues/430

--
Stefan

> 
> 
> 
>> Would the adr_l macro you wrote in
>> https://lore.kernel.org/linux-arm-kernel/nycvar.YSQ.7.78.906.2009141003360.4095746@knanqh.ubzr/T/#t
>> be helpful here?
>>
>> >         bic     r11,r11,#15             @ align for 128-bit stores
>> >         mov     r12,sp
>> >         mov     sp,r11                  @ alloca
>> > --
>> > 2.17.1
>> >
>>
>>
>> --
>> Thanks,
>> ~Nick Desaulniers
