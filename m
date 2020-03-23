Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D50C43331
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 22:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B4C20753
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585001072;
	bh=mUDxCrCIVFUi1cXQXpTp5QzjQ5KGrUdk1lH1SYe0K7M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hKFgss24/oZN7YR4qcG4RlJ1Hwugd//YAHDKZlDRGMMGs/v9ukAA77iuYEsxYauxV
	 4EmtPckdAvuB1fjKAn4GpDz2WW8RwtGHZV9MsG7NsH3jSH5YJlXBm2cylFBYGX9rni
	 8yu9OVNxkBbMPo1jsdm/rFptxYxd8Ot8gjr7QzVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgCWWEb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 18:04:31 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:45673 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCWWEb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 18:04:31 -0400
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 02NM4RO3022840;
        Tue, 24 Mar 2020 07:04:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 02NM4RO3022840
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585001067;
        bh=h6nm2Hiq/kZPXDtve+y+JyahA5CoO2EzrLNaMh8pB0U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0NvQzc9vpf3i4w59OBql2bUA3fFv02GNg4qxwWwcd9IH33rrIsUo08Z3wwnqVWojs
         qTM2YaSHnKx5QmVLvDHW7wHshy511sa2W37eg8hjTC+XH/mA6Nnw8Ab//L20qZX7kv
         Is0J5qix6D04C7G6B5Fp46SjOrayLGPZW9qNtAfWhSQ1Nhjz5ukCtsEB21lY1spOrq
         bgcoKo0AB9CY9jXfZwVhqAchWtqq67aGINp+lg0IsRdbByJnGosJZkStVrmIBRuiNe
         cfsjbzUZDvNRw3D9UPLnSlNxD2CbDAYoOv4WlrYzV6OcxSjuxWq+h1iksn2oeaPqfk
         UHaI+ssapgr2w==
X-Nifty-SrcIP: [209.85.217.41]
Received: by mail-vs1-f41.google.com with SMTP id o3so9897821vsd.4;
        Mon, 23 Mar 2020 15:04:27 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3VVysrzTdO4zJlR1dX2vFmRsl7kjBL85RNgPVwrYKm4tTs3IbY
        QGOrY5ncEXFhoYgsGM6H0fXVjZnvNrJoFxlh+Vk=
X-Google-Smtp-Source: ADFU+vtPNIJCULsC2ckgQesaum0yAU1a8tkGRLL3Tmcwq7vScG0ATcz09kWyiVeYSrqPbj0n0fZXgJPCEyMKTqIqwsg=
X-Received: by 2002:a67:3201:: with SMTP id y1mr17991619vsy.54.1585001066297;
 Mon, 23 Mar 2020 15:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
 <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com> <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
In-Reply-To: <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 24 Mar 2020 07:03:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQgKgKgOpQ2bgHrB5h=LTffs2khbYRrBhrxFM44gS88KQ@mail.gmail.com>
Message-ID: <CAK7LNAQgKgKgOpQ2bgHrB5h=LTffs2khbYRrBhrxFM44gS88KQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On Mon, Mar 23, 2020 at 3:53 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Mon, Mar 23, 2020 at 12:36 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > Hi Jason,
> >
> > On Mon, Mar 23, 2020 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > Hi again,
> > >
> > > I've consolidated your patches and rebased mine on top, and
> > > incorporated your useful binutils comments. The result lives here:
> > >
> > > https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
> > >
> > > I can submit all of those to the list, if you want, or maybe you can
> > > just pull them out of there, include them in your v2, and put them in
> > > your tree for 5.7? However you want is fine with me.
> >
> >
> > Your series does not work correctly.
> >
> > I will comment why later.
>
> Bummer, okay. Looking forward to learning what's up. Also, if some
> parts of it are useful (like the resorting and organizing of
> arch/x86/crypto/Makefile), feel free to cannibalize it, keeping what's
> useful and discarding what's not.
>


The answer is mostly in my previous reply to Linus:
https://lkml.org/lkml/2020/3/13/27


I think this problem would happen
for CONFIG_AS_CFI and CONFIG_AS_ADX
since the register in instruction code
is machine-bit dependent.

The former is OK wince we are planning to
remove it.

We need to handle -m64 for the latter.
Otherwise, a problem like commit
3a7c733165a4799fa1 would happen.


So, I think we should merge this
https://lore.kernel.org/patchwork/patch/1214332/
then, fix-up CONFIG_AS_ADX on top of it.

(Or, if we do not need to rush,
we can delete CONFIG_AS_ADX entirely after
we bump the binutils version to 2.23)

Thanks.

-- 
Best Regards
Masahiro Yamada
