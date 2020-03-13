Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87FCC10DCE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 05:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF2D8206E2
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 05:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584077303;
	bh=pHql+SpQj+MeG6rVjnuPXcHw2IQyb23EWIepG0+cruQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AwrJ1OPqChNbOBXZE2ckykXOmaqKB0K/NC9heT/VWk+lN9duovHH/3fHB6LkB1wyI
	 Nq3HKbN5iRl3ISmQaU/52xZruPNbvVZjQrZ8/ae7uzmKAjYPnbDLvCqzLJmc0GX9Dh
	 G9ThVrksgLA00wb7pe4QJqrDiGQOSHFyC5MM4044=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgCMF2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 01:28:23 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:22933 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgCMF2W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 01:28:22 -0400
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 02D5S6Tc009503;
        Fri, 13 Mar 2020 14:28:06 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 02D5S6Tc009503
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1584077287;
        bh=+fsxH5XCWbBHArJVq6PwCJOxwCgrqHwu1xWOKzYD9s4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WGcK+Ad+LcKCDBzc3BTnZ38CAE4grHKYXZAbUw4BvvrFkO4jlmXSkE7JTSyHufKBo
         891e8rtqCpTB4hS/ti8G9iKKoeCfLDVkdKnVxOh9ew4yxRVgpIU09BAXnD8ITRjd47
         taGFqz1c6MpipTafWreHKDH23/jpj+y5bnpEQJ5QVreGzH7MTdaIxyg4azrnseWTe+
         L6GQyR6pyWRlcvMygvIf8pptOKV4IfNuIPiXc5jjd+WaBU+QHBs/JnjIv1dH12BBXU
         6Cbok2qOe9h/R2EVCv59wIA4pTKjw+L/HKGAZdkxDYbXFw9rGi6wknaTHaifMRSUTX
         dbIbMGAYwywvA==
X-Nifty-SrcIP: [209.85.222.48]
Received: by mail-ua1-f48.google.com with SMTP id 8so3088994uar.3;
        Thu, 12 Mar 2020 22:28:06 -0700 (PDT)
X-Gm-Message-State: ANhLgQ172rQD9E8xGJR0PsV1J2JLxoxc/CI3jXHD8ckdy4gdSrRrhp+n
        0Q3FCnmRXsjH/ZwypXs6q0U4B6W6kXqHwoIj2WI=
X-Google-Smtp-Source: ADFU+vsZEBleM1Gp0y7XLL9hrFgCCN2x/Ky0AHliMll5vkmuNcXmF013bVP+YJVefVldqZItqYBJLw2pR+LYXJ1SDlQ=
X-Received: by 2002:a9f:2828:: with SMTP id c37mr7074803uac.25.1584077285731;
 Thu, 12 Mar 2020 22:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190916084901.GA20338@gondor.apana.org.au> <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au> <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au> <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au> <20200312115714.GA21470@gondor.apana.org.au>
 <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 13 Mar 2020 14:27:29 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS2Ev8h=W_6V9DJc7-1Hz3J6O79ADUULrnOG5vTMWfSpw@mail.gmail.com>
Message-ID: <CAK7LNAS2Ev8h=W_6V9DJc7-1Hz3J6O79ADUULrnOG5vTMWfSpw@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus,

On Fri, Mar 13, 2020 at 1:41 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Mar 12, 2020 at 4:57 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > This push fixes a build problem with x86/curve25519.
>
> Pulled.
>
> I do have a comment, though: this fix matches the existing pattern of
> checking for assembler support, but that existing pattern is
> absolutely horrible.
>
> Would some enterprising individual please look at making the
> CONFIG_AS_xyz flags use the _real_ config subsystem rather than ad-hoc
> Makefile rules?
>
> IOW, instead of having
>
>   adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
>   ..
>   adx_supported := $(call as-instr,adox %r10$(comma)%r10,yes,no)
>
> in the makefiles, and silently changing how the Kconfig variables work
> depending on those flags, make that DCONFIG_AS_ADX be a real config
> variable:
>
>    config AS_ADX
>            def_bool $(success,$(srctree)/scripts/as-instr.sh "adox %r10,%r10")
>
> or something like that?
>
> And then we can make that CRYPTO_CURVE25519_X86 config variable simply have a
>
>         depends on AS_ADX
>
> in it, and the Kconfig system just takes care of these dependencies on its own.
>
> Anyway, the crypto change isn't _wrong_, but it does point out an ugly
> little horror in how the crypto layer silently basically changes the
> configuration depending on other things.
>
> For an example of why this is problematic: it means that if somebody
> sends you their config file, the actual configuration you get may be
> *completely* different from what they actually had, depending on
> tools.
>
> Added Masahiro to the cc, since he's used to the 'def_bool' model, and
> also is familiar with our existing 'as-instr' Makefile macro.


Thanks for the heads-up.

In fact, as-instr is already used in Kconfig.
arch/arm64/Kconfig: line 1396


arm / arm64 are simple cases because
32, 64-bit is separated by directory.

There is one thing we need to be careful about.
The x86 GCC is usually biarch.
So, when evaluating 64-bit assembly code
with a default 32-bit compiler,
-m64 must be passed.

I will keep this conversion in my mind.

Thanks.

> So this is basically me throwing out a "I wish somebody would look at
> this". Not meant as a criticism of the commit in question.
>
>             Linus



-- 
Best Regards
Masahiro Yamada
