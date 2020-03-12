Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB1EC1975A
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 16:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B63722067C
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 16:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584031277;
	bh=s/sJ3YAgR5YkJwbOLGpa9jus9ezwXX24JkPT1Y1u6LE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=fIjnOMxrpClHU/jcXcFKLuMVI4555/fnKvgxuXnLyIoT8tRT9T/E2BzOnopFkXzrn
	 KJXuRFCYpbRrZOdAzmBdwDe879E3CgIwUHsa7Nf8Zp1RHeBWO96H7j4TlKkKWNyNWq
	 h5vjRB9n4lVKay+bP4LgfRgXouUXwLWjkXEV2RC8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725268AbgCLQlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 12:41:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35410 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCLQlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 12:41:16 -0400
Received: by mail-lf1-f66.google.com with SMTP id v8so4465306lfe.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2020 09:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2sz196/Cs27wxtfRE//dxsR1M4xyc6FsBDBBJltAxs=;
        b=cdQC2dv3JAgsVAdL4pkokh+yfj9tt9IkD9gkf373P1CN2QgninELU3Wvy4TJQIySWw
         hTxFfX7IX/VgILNHfG6vUbqBRg9TgBnfBG+bamXLeynfrIGZ2sAn4gmDJacfJ+zjzBjt
         PDw9j5myuoeR7hRy4P/P91cTtE9LDJ+lt3pvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2sz196/Cs27wxtfRE//dxsR1M4xyc6FsBDBBJltAxs=;
        b=GZwbzpZ5WGYCrWbdX7T/AR+OZbh9pCWomrzo0maiylY4+rA0xhMDjaCJ82vSt1/3CK
         i7tpPbsUz8jZzH9AyQogxl6+xzE/cxVNmtYHk4QTZGwqI+9PCMLEyc0ZHOPg+xju4mZ3
         t8CyXQ9CVaEyjC3RlJ+DDRKtHH7F6LH4I2VFDfbtitjBjM0dBENo9VcyQULdLa5rPTQi
         smAWaE/ieB2BTAAmzSAK7DNjbUaQ2c+YwJNw0t2L4Gl4Z3bofRmJ/BMQGWdX0y9iDwnZ
         k0gTup8TJycfM+10HxP021V2jfRzT4/2A2Hji6+083yBXMwDfjv8EmDemt3V5kTuxvXz
         8VJg==
X-Gm-Message-State: ANhLgQ0Tu0T/IX8tTxu2B1mLgSns/Vswe09su+qqyCOFgPDft10NLrdu
        6mlV4sonmIFH1uWrdNCUVHnizWhfE6I=
X-Google-Smtp-Source: ADFU+vsRCECKko9/gztCde1YouLbK0nlbBp+W5veVEFLvDbh+Ez2d4sZvzrAnB9tY3OT/DolyPjG2Q==
X-Received: by 2002:ac2:51c7:: with SMTP id u7mr5745647lfm.195.1584031272118;
        Thu, 12 Mar 2020 09:41:12 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id k4sm25003559ljk.12.2020.03.12.09.41.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 09:41:11 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id r7so7187100ljp.10
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2020 09:41:10 -0700 (PDT)
X-Received: by 2002:a05:651c:230:: with SMTP id z16mr5760125ljn.201.1584031269966;
 Thu, 12 Mar 2020 09:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190916084901.GA20338@gondor.apana.org.au> <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au> <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au> <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au> <20200312115714.GA21470@gondor.apana.org.au>
In-Reply-To: <20200312115714.GA21470@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 Mar 2020 09:40:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
Message-ID: <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 12, 2020 at 4:57 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a build problem with x86/curve25519.

Pulled.

I do have a comment, though: this fix matches the existing pattern of
checking for assembler support, but that existing pattern is
absolutely horrible.

Would some enterprising individual please look at making the
CONFIG_AS_xyz flags use the _real_ config subsystem rather than ad-hoc
Makefile rules?

IOW, instead of having

  adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
  ..
  adx_supported := $(call as-instr,adox %r10$(comma)%r10,yes,no)

in the makefiles, and silently changing how the Kconfig variables work
depending on those flags, make that DCONFIG_AS_ADX be a real config
variable:

   config AS_ADX
           def_bool $(success,$(srctree)/scripts/as-instr.sh "adox %r10,%r10")

or something like that?

And then we can make that CRYPTO_CURVE25519_X86 config variable simply have a

        depends on AS_ADX

in it, and the Kconfig system just takes care of these dependencies on its own.

Anyway, the crypto change isn't _wrong_, but it does point out an ugly
little horror in how the crypto layer silently basically changes the
configuration depending on other things.

For an example of why this is problematic: it means that if somebody
sends you their config file, the actual configuration you get may be
*completely* different from what they actually had, depending on
tools.

Added Masahiro to the cc, since he's used to the 'def_bool' model, and
also is familiar with our existing 'as-instr' Makefile macro.

So this is basically me throwing out a "I wish somebody would look at
this". Not meant as a criticism of the commit in question.

            Linus
