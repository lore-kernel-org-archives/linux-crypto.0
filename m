Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E4BC48BC2
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC58A61C2A
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhF1D16 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jun 2021 23:27:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51010 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhF1D16 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jun 2021 23:27:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lxhts-0001or-E8; Mon, 28 Jun 2021 11:25:32 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lxhti-00011F-BY; Mon, 28 Jun 2021 11:25:22 +0800
Date:   Mon, 28 Jun 2021 11:25:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
Message-ID: <20210628032522.GA1375@gondor.apana.org.au>
References: <20210618211411.1167726-1-sean.anderson@seco.com>
 <20210618211411.1167726-2-sean.anderson@seco.com>
 <20210624065644.GA7826@gondor.apana.org.au>
 <dfe6dc8d-8e26-643e-1e29-6bf05611e9db@seco.com>
 <20210625001640.GA23887@gondor.apana.org.au>
 <f3117c42-7918-3d32-059e-4e6c338a781a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3117c42-7918-3d32-059e-4e6c338a781a@seco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 25, 2021 at 10:49:08AM -0400, Sean Anderson wrote:
>
> What version of sparse are you using? With sparse 0.6.2, gcc 9.3.0, and
> with C=1 and W=2 I don't see this warning.

OK I've upgraded my sparse to the latest git tree, but it still
gives the same warning, because the two types are of different
sizes:

$ make C=1 W=1 O=build-compile drivers/crypto/
make[1]: Entering directory '/home/herbert/src/build/kernel/test/build-compile'
  GEN     Makefile
  CALL    ../scripts/checksyscalls.sh
  CALL    ../scripts/atomic/check-atomics.sh
  CC [M]  drivers/crypto/mxs-dcp.o
In file included from ../include/linux/kernel.h:15,
                 from ../arch/x86/include/asm/percpu.h:27,
                 from ../arch/x86/include/asm/current.h:6,
                 from ../include/linux/sched.h:12,
                 from ../include/linux/ratelimit.h:6,
                 from ../include/linux/dev_printk.h:16,
                 from ../include/linux/device.h:15,
                 from ../include/linux/dma-mapping.h:7,
                 from ../drivers/crypto/mxs-dcp.c:8:
../drivers/crypto/mxs-dcp.c: In function \u2018mxs_dcp_aes_block_crypt\u2019:
../include/linux/minmax.h:18:28: warning: comparison of distinct pointer types lacks a cast
  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                            ^~
../include/linux/minmax.h:32:4: note: in expansion of macro \u2018__typecheck\u2019
   (__typecheck(x, y) && __no_side_effects(x, y))
    ^~~~~~~~~~~
../include/linux/minmax.h:42:24: note: in expansion of macro \u2018__safe_cmp\u2019
  __builtin_choose_expr(__safe_cmp(x, y), \
                        ^~~~~~~~~~
../include/linux/minmax.h:51:19: note: in expansion of macro \u2018__careful_cmp\u2019
 #define min(x, y) __careful_cmp(x, y, <)
                   ^~~~~~~~~~~~~
../drivers/crypto/mxs-dcp.c:369:12: note: in expansion of macro \u2018min\u2019
      rem = min(dst_iter.length, actx->fill);
            ^~~
  CHECK   ../drivers/crypto/mxs-dcp.c
../drivers/crypto/mxs-dcp.c:369:47: error: incompatible types in comparison expression (different type sizes):
../drivers/crypto/mxs-dcp.c:369:47:    unsigned long *
../drivers/crypto/mxs-dcp.c:369:47:    unsigned int *
make[1]: Leaving directory '/home/herbert/src/build/kernel/test/build-compile'
$ 

In fact as you can see that gcc is warning too.  Perhaps you're
building on 32-bit?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
