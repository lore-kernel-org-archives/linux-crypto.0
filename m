Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8000CC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 13:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 635C660F56
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 13:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKDNdl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 09:33:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56544 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhKDNdk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 09:33:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1micpP-00045L-9M; Thu, 04 Nov 2021 21:30:51 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1micpI-0002Ef-4i; Thu, 04 Nov 2021 21:30:44 +0800
Date:   Thu, 4 Nov 2021 21:30:44 +0800
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
Message-ID: <20211104133044.GA8563@gondor.apana.org.au>
References: <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
 <20211104121612.GA8044@gondor.apana.org.au>
 <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 04, 2021 at 02:11:34PM +0100, Geert Uytterhoeven wrote:
>
> My config is nommu_k210_sdcard_defconfig with the changes below:

Could you send me the actual config? Just in case something weird
happened during the kconfig process and options got flipped from
their default values.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
