Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EF2C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 12:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922EC61183
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 12:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhKDMTY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 08:19:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56542 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231563AbhKDMTW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 08:19:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mibfR-0002ie-Nn; Thu, 04 Nov 2021 20:16:29 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mibfA-00026K-MG; Thu, 04 Nov 2021 20:16:12 +0800
Date:   Thu, 4 Nov 2021 20:16:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Message-ID: <20211104121612.GA8044@gondor.apana.org.au>
References: <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 04, 2021 at 08:58:16AM +0100, Geert Uytterhoeven wrote:
> Hi Damien,
> 
> On Thu, Nov 4, 2021 at 8:29 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> > On 2021/11/03 0:41, Geert Uytterhoeven wrote:
>
> > > Thanks for your patch, which is now commit cad439fc040efe5f
> > > ("crypto: api - Do not create test larvals if manager is disabled").
> > >
> > > I have bisected a failure to mount the root file system on k210 to this
> > > commit.
> > >
> > > Dmesg before/after:
> > >
> > >       mmcblk0: mmc0:0000 SA04G 3.68 GiB
> > >       random: fast init done
> > >        mmcblk0: p1
> > >      -EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: disabled.
> > >      -VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
> > >      +EXT4-fs (mmcblk0p1): Cannot load crc32c driver.
> > >      +VFS: Cannot open root device "mmcblk0p1" or unknown-block(179,1): error -80
> >
> > p1 exist as the message 2 lines above shows. And since the mount error is -80
> > (ELIBBAD), it is really all about crypto. Since the default k210 config compile
> > everything in-kernel (no modules), it should work. Was crc32c compiled as a
> > module ? If yes, then the k210 will need to be booted with U-Boot and use a real
> > initrd, which likely will all end-up in a no memory situation. ext4 in itself
> > will consume way too much memory...
> 
> Everything is built-in, including crc32c. It worked fine, until the commit
> referenced.

Can someone please send me the Kconfig used in this case?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
