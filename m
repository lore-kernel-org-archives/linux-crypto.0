Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F872C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 07:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAFF46109F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 07:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKDIBJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 04:01:09 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:39616 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDIBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 04:01:08 -0400
Received: by mail-ua1-f41.google.com with SMTP id i6so9248819uae.6;
        Thu, 04 Nov 2021 00:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C0VeHDwd0st+efSBfafTGRGInECO+leW6YfH2krS5v8=;
        b=k2nTBMAfUmED23BJ5zx6DxU6ulYDdc2HG1EB48xkGJW+CGGb1GlVBI9a4CzpR8Cjqb
         TpuImGOXO4hsl0aGG2vxsMlJGvlP+GkZ/on/uCoDEHsvDaXPyyzu7iA1tYq1Mo6Q2zO7
         AC1rdLtGKB0tpxLB/IaknpsqlImQMi3Oo+i57INLn8Vjo79X/lq0t3lUQlzdmza4ZZ/o
         swzOc1In+0WrAidvFnV9igs+LiP0Vrb/nc7HwQlzmXYRbS6osUSjBN6a0qcKo67ApDPq
         IBZNGm28/+zmBv77lQCnw/KQNzU9E4Ihean2QNMTOJczWL9vc1HatL3X4IsRNv/YLIPG
         UK3A==
X-Gm-Message-State: AOAM532tXdVUyZ59KIc8EKMvXgFeJw2udxjnMDp/wcREc8DbSibkwUuT
        195Y4nxDJ5Pa6A/ZtI7xcLj5vw5FjhmTgA==
X-Google-Smtp-Source: ABdhPJyGF4VnVry4jSkBCOCLtfOZWAyBiEMhM5qdafXv5eZc5nMjm6DMuf/sCHNnd1YSoNfHjgMzQQ==
X-Received: by 2002:a05:6102:f08:: with SMTP id v8mr27167977vss.38.1636012708990;
        Thu, 04 Nov 2021 00:58:28 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id q8sm628059uae.10.2021.11.04.00.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 00:58:28 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id v20so9232485uaj.9;
        Thu, 04 Nov 2021 00:58:28 -0700 (PDT)
X-Received: by 2002:a05:6102:b13:: with SMTP id b19mr10910538vst.50.1636012707755;
 Thu, 04 Nov 2021 00:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210913071251.GA15235@gondor.apana.org.au> <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161> <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161> <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161> <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg> <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Nov 2021 08:58:16 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
Message-ID: <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: api - Do not create test larvals if manager is disabled
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Damien,

On Thu, Nov 4, 2021 at 8:29 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> On 2021/11/03 0:41, Geert Uytterhoeven wrote:
> > On Tue, 19 Oct 2021, Herbert Xu wrote:
> >> On Tue, Oct 05, 2021 at 07:33:28PM -0700, Nathan Chancellor wrote:
> >>> I assume this is the diff you mean? This does not resolve the issue. My
> >>> apologies if I am slow to respond, I am on vacation until the middle of
> >>> next week.
> >>
> >> Sorry for the delay.  The kernel robot figured out the problem
> >> for me.  It's the crypto_alg_tested call that causes api.c to
> >> depend on algapi.c.  This call is only invoked in the case where
> >> the crypto manager is turned off.  We could instead simply make
> >> test larvals disappear in that case.
> >>
> >> ---8<---
> >> The delayed boot-time testing patch created a dependency loop
> >> between api.c and algapi.c because it added a crypto_alg_tested
> >> call to the former when the crypto manager is disabled.
> >>
> >> We could instead avoid creating the test larvals if the crypto
> >> manager is disabled.  This avoids the dependency loop as well
> >> as saving some unnecessary work, albeit in a very unlikely case.
> >>
> >> Reported-by: Nathan Chancellor <nathan@kernel.org>
> >> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
> >> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > Thanks for your patch, which is now commit cad439fc040efe5f
> > ("crypto: api - Do not create test larvals if manager is disabled").
> >
> > I have bisected a failure to mount the root file system on k210 to this
> > commit.
> >
> > Dmesg before/after:
> >
> >       mmcblk0: mmc0:0000 SA04G 3.68 GiB
> >       random: fast init done
> >        mmcblk0: p1
> >      -EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: disabled.
> >      -VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
> >      +EXT4-fs (mmcblk0p1): Cannot load crc32c driver.
> >      +VFS: Cannot open root device "mmcblk0p1" or unknown-block(179,1): error -80
>
> p1 exist as the message 2 lines above shows. And since the mount error is -80
> (ELIBBAD), it is really all about crypto. Since the default k210 config compile
> everything in-kernel (no modules), it should work. Was crc32c compiled as a
> module ? If yes, then the k210 will need to be booted with U-Boot and use a real
> initrd, which likely will all end-up in a no memory situation. ext4 in itself
> will consume way too much memory...

Everything is built-in, including crc32c. It worked fine, until the commit
referenced.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
