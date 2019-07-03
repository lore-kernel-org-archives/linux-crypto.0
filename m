Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF27BC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 15:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAEFE2189E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 15:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVcuY49Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfGCPQx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 11:16:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34911 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfGCPQx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 11:16:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id c27so3296571wrb.2
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 08:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=UFlH5lvkEcMcBAhxQwWf4kMze5LOT4PqrG0ikyVqAsM=;
        b=FVcuY49Z1FsbRJbTtiTv+HvKHelepKB1WerbpgZwT7t3N3ZGN3117sjd6EkSgmVILG
         VtILQsBbYFoEr2U5kDEFt+QYPLz+BI6MzL9SBOKNvaAVUatXKsnTd7rCRc5cIpyXKhs+
         D+1DWGD3ZeRLPua4aItGUJ0MTQu+ZiUZo7aKwi4tZP1mdzHtPDVeKKAGfgbNBFOL00Ou
         ZToNZA1h5h0xCzgnfQmKQJfZlqb8xfTHvCWBzTrh6CN7PPyMG1USTpGonlENC+o4jRmH
         aF6aJOS1sz30ySC6zkaeB1ArrXR2eG4gJaPtc5Q7s1YPMYEtks/xZ9oJQGixCi8do51M
         mguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=UFlH5lvkEcMcBAhxQwWf4kMze5LOT4PqrG0ikyVqAsM=;
        b=dK0CPh5aAS5CjAKDY7V0wytSbkLMIX7e68KtJ3swLoIeAiIZuCcfRu4IE2704CDjx1
         tcK/0EOa/5lRPucTiZ5X7rjtTZCYpZY1pPSGSFguinYmCmfUoaj/6ggqQ/j92mBJlXlU
         1b+oiIrNpLMYochSQfdf3aRmzK2nWfHGocw9OswhfAL7lG0o/ffT2Sr0tUzkZvwOlfJx
         G2DHWV+EegZrrX5TQPRL4wxiXdTJLjvR0K9s/E1ZBfksxh5g2tF0otc6gSYOyyAJZeMi
         wQYPlUDFMxc2aWBig4RbFuuSbPgAD+3ZwKHqYTzhfHiHotrn6uVd80AC5QPdYRWo9yX0
         0MVg==
X-Gm-Message-State: APjAAAWpaZo+GWKwWEfx1SRiNg4c7nmg+jGwmRrm2w1DrcBThRsbGmnO
        ApWCUbbkjzIBSE82+fV6y7D/ywjoKcbSlCRlymw=
X-Google-Smtp-Source: APXvYqyQILd4j1TZQ9PIZXaQbkoOuZbmiLGxOO+aozw7BA4YuPTE4hSKwVTDyfbfwk5HCogpALk5CjFg49iFiNfqq0o=
X-Received: by 2002:adf:81c8:: with SMTP id 66mr28423052wra.261.1562167011897;
 Wed, 03 Jul 2019 08:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com> <20190617182256.GB92263@gmail.com>
In-Reply-To: <20190617182256.GB92263@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 3 Jul 2019 17:16:40 +0200
Message-ID: <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: multipart/mixed; boundary="000000000000d31830058cc85981"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--000000000000d31830058cc85981
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 17, 2019 at 8:23 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jun 17, 2019 at 11:06:21AM -0700, Nick Desaulniers wrote:
> > On Mon, Jun 17, 2019 at 6:35 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > while digging through a ClangBuiltLinux issue when linking with LLD
> > > linker on x86-64 I checked the settings for...
> > >
> > > .rodata.cst16 and .rodata.cst32
> > >
> > > ...in crypto tree and fell over this change in...
> > >
> > > commit "crypto: x86/crct10dif-pcl - cleanup and optimizations":
> > >
> > > -.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
> > > +.section .rodata.cst32.byteshift_table, "aM", @progbits, 32
> > > .align 16
> > >
> > > Is that a typo?
> > > I would have expected...
> > > .rodata.cst32.XXX -> .align 32
> > > or
> > > rodata.cst16.XXX -> .align 16
> > >
> > > But I might be wrong as I am no expert for crypto and x86/asm.
> > >
> > > Thanks in advance.
> > >
> > > Regards,
> > > - Sedat -
> > >
> > > [1] https://github.com/ClangBuiltLinux/linux/issues/431
> > > [2] https://bugs.llvm.org/show_bug.cgi?id=42289
> >
> > > [3] https://git.kernel.org/linus/0974037fc55c
> >
> > + Peter, Fangrui (who have looked at this, and started looking into
> > this from LLD's perspective)
> >
> > In fact, looking closer at that diff, the section in question
> > previously had 32b alignment.  Eric, was that change intentional?  It
> > seems funny to have a 32b entity size but a 16b alignment.
> >
> > PDF page 81 / printed page 67 of this doc:
> > https://web.eecs.umich.edu/~prabal/teaching/resources/eecs373/Assembler.pdf
> > says:
> >
> > "The linker may remove duplicates within sections with the
> > same name, same entity size and same flags. "
> >
> > So for us, LLD is NOT merging these sections due to differing
> > alignments, which is producing warnings when loading such kernel
> > modules that link against these object files.
> > --
> > Thanks,
> > ~Nick Desaulniers
>
> It was an intentional change since actually no alignment is required for this.
> It's an array of 32 bytes and the code loads 16 bytes starting from some byte
> offset in the range 1...16, so it has to use movdqu anyway.
>
> There's no problem with changing it back to 32, but I don't fully understand
> what's going on here.  Where is it documented how alignment specifiers interact
> with the section merging?  Also, there are already other mergeable sections in
> the x86 crypto code with alignment smaller than their entity size, e.g.
>
>         .rodata.cst16.aegis128_const
>         .rodata.cst16.aegis128l_const
>         .rodata.cst16.aegis256_const
>         .rodata.cst16.morus640_const
>         .rodata.cst256.K256
>
> Do those need to be changed too?
>

Hi Eric, Hi Nick,

I am building Linux v5.1.16 with a new llvm-toolchain including the fix for LLD:

"[ELF] Allow placing SHF_MERGE sections with different alignments into
the same MergeSyntheticSection"

[ Alignment=16 before my patch ]

$ cd arch/x86/crypto/
$ for o in $(ls *.o) ; do echo [ $o ] ; readelf -WS $o | grep
rodata\.cst32 ; done

[ crct10dif-pcl-asm_64.o ]
  [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
0004e0 000020 20  AM  0   0 16

[ crct10dif-pclmul.o ]
  [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
000b40 000020 20  AM  0   0 16

[ Alignment=32 after my patch ]

[ crct10dif-pcl-asm_64.o ]
  [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
0004e0 000020 20  AM  0   0 32

[ crct10dif-pclmul.o ]
  [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
000b40 000020 20  AM  0   0 32

I am still building the Linux-kernel but first checks in [3] looks good.

I can send out a separate patch if you like for the issue I have reported.

I can not say much to ...

>         .rodata.cst16.aegis128_const
>         .rodata.cst16.aegis128l_const
>         .rodata.cst16.aegis256_const
>         .rodata.cst16.morus640_const
>         .rodata.cst256.K256

... as I am not a Linker or Linux/x86/crypto specialist.

Thanks.

Regards,
- Sedat -

[1] https://bugs.llvm.org/show_bug.cgi?id=42289#c7
[2] https://reviews.llvm.org/D63432
[3] https://github.com/ClangBuiltLinux/linux/issues/431#issuecomment-508132852

--000000000000d31830058cc85981
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-crypto-x86-crct10dif-pcl-Fix-alignment-size-in-.roda.patch"
Content-Disposition: attachment; 
	filename="0001-crypto-x86-crct10dif-pcl-Fix-alignment-size-in-.roda.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxncl5u80>
X-Attachment-Id: f_jxncl5u80

RnJvbSAzZTZiOGZmOTNiMTAwYjhjMTQwYTBmNjkzYjNmMmY3N2RkN2U3NDBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAY3JlZGF0aXYuZGU+
CkRhdGU6IFR1ZSwgMTggSnVuIDIwMTkgMDk6MzI6MzggKzAyMDAKU3ViamVjdDogW1BBVENIXSBj
cnlwdG86IHg4Ni9jcmN0MTBkaWYtcGNsOiBGaXggYWxpZ25tZW50IHNpemUgaW4KIC5yb2RhdGEu
Y3N0MzIgc2VjdGlvbgoKLS0tCiBhcmNoL3g4Ni9jcnlwdG8vY3JjdDEwZGlmLXBjbC1hc21fNjQu
UyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2NyeXB0by9jcmN0MTBkaWYtcGNsLWFzbV82NC5TIGIvYXJj
aC94ODYvY3J5cHRvL2NyY3QxMGRpZi1wY2wtYXNtXzY0LlMKaW5kZXggM2Q4NzNlNjc3NDlkLi40
ODBmY2QwN2U5NzMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2NyeXB0by9jcmN0MTBkaWYtcGNsLWFz
bV82NC5TCisrKyBiL2FyY2gveDg2L2NyeXB0by9jcmN0MTBkaWYtcGNsLWFzbV82NC5TCkBAIC0z
MjIsNyArMzIyLDcgQEAgRU5EUFJPQyhjcmNfdDEwZGlmX3BjbCkKIAkub2N0YQkweDAwMDEwMjAz
MDQwNTA2MDcwODA5MEEwQjBDMEQwRTBGCiAKIC5zZWN0aW9uCS5yb2RhdGEuY3N0MzIuYnl0ZXNo
aWZ0X3RhYmxlLCAiYU0iLCBAcHJvZ2JpdHMsIDMyCi0uYWxpZ24gMTYKKy5hbGlnbiAzMgogIyBG
b3IgMSA8PSBsZW4gPD0gMTUsIHRoZSAxNi1ieXRlIHZlY3RvciBiZWdpbm5pbmcgYXQgJmJ5dGVz
aGlmdF90YWJsZVsxNiAtIGxlbl0KICMgaXMgdGhlIGluZGV4IHZlY3RvciB0byBzaGlmdCBsZWZ0
IGJ5ICdsZW4nIGJ5dGVzLCBhbmQgaXMgYWxzbyB7MHg4MCwgLi4uLAogIyAweDgwfSBYT1IgdGhl
IGluZGV4IHZlY3RvciB0byBzaGlmdCByaWdodCBieSAnMTYgLSBsZW4nIGJ5dGVzLgotLSAKMi4y
MC4xCgo=
--000000000000d31830058cc85981--
