Return-Path: <SRS0=fE7s=RX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D45C10F05
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 18:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061FF21841
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 18:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553108245;
	bh=jU9CC7/cwUq1tn+oMCzXLh4scS18THRBZAue4BKsS7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DgkPwKh89GKBS2CXGEU0v9kkiuzx8/54YQtFG9zqStoY5Lu1zQGvzWDor7UbWzkRy
	 5riKCHoW92MKqBNvkIhnNlWJDwpcZZ+7QDTwOQNqRuzXYo7jMdv9iU/N6d+NvGxOOM
	 +XleLcyCP5gix+kBOKFT7JKZnhn641v0yFHnYDmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfCTS5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbfCTS5X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Mar 2019 14:57:23 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C52206BA;
        Wed, 20 Mar 2019 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553108242;
        bh=jU9CC7/cwUq1tn+oMCzXLh4scS18THRBZAue4BKsS7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWPdUEOCxrvBlwDE+7K2wdjzuuigEDqZTaAD+vsE1JIMwEnZkBxK0E6Tk8a7ZEGj6
         IUXiiFPhx9crVD9zlnZpaBDlDWvI4qPTJlGJtoYALy7RJlA2xgYpcDNV5NOkWAwmlm
         P1lYonc179XpoR+OPMvwkl92YibgKft0h7rTS7Ss=
Date:   Wed, 20 Mar 2019 11:57:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
Message-ID: <20190320185719.GB180195@gmail.com>
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
 <20190319170911.GB202956@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319170911.GB202956@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 19, 2019 at 10:09:13AM -0700, Eric Biggers wrote:
> On Tue, Mar 19, 2019 at 12:54:23PM +0100, Geert Uytterhoeven wrote:
> > When running the sha1-asm crypto selftest on arm with
> > CONFIG_HARDENED_USERCOPY_PAGESPAN=y:
> > 
> >     usercopy: Kernel memory overwrite attempt detected to spans
> > multiple pages (offset 0, size 42)!
> >     ------------[ cut here ]------------
> >     kernel BUG at mm/usercopy.c:102!
> >     Internal error: Oops - BUG: 0 [#1] SMP ARM
> >     Modules linked in:
> >     CPU: 0 PID: 35 Comm: cryptomgr_test Not tainted
> > 5.1.0-rc1-koelsch-01109-gbeb7d6376ecfbf07-dirty #397
> >     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> >     PC is at usercopy_abort+0x68/0x90
> >     LR is at usercopy_abort+0x68/0x90
> >     pc : [<c030fd60>]    lr : [<c030fd60>]    psr: 60000013
> >     sp : ea54bc60  ip : 00000010  fp : cccccccd
> >     r10: 00000000  r9 : c0e0ce04  r8 : ea54d009
> >     r7 : ea54d00a  r6 : 00000000  r5 : 0000002a  r4 : c09d1120
> >     r3 : dd6cd422  r2 : dd6cd422  r1 : 2abb4000  r0 : 0000005f
> >     Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> >     Control: 30c5387d  Table: 40003000  DAC: fffffffd
> >     Process cryptomgr_test (pid: 35, stack limit = 0x(ptrval))
> >     Stack: (0xea54bc60 to 0xea54c000)
> >     bc60: c09d1120 c09d1120 c09d1120 00000000 0000002a 0000002a
> > 00000000 c0310060
> >     bc80: 0000002a 00000000 000001c0 00000000 00000000 c0eb11e8
> > ea54cfe0 ea538c00
> >     bca0: 00000000 ea54cfe0 ebef73e0 0000002a ea538c20 ea54bd84
> > 0000003a c0427a30
> >     bcc0: ea54bdbc 00000000 00000000 c081cf70 eb074280 c081cf70
> > 0000002a c081cf80
> >     bce0: 0000000e c07da138 ea54bd0c 00000000 c084061c c04248e8
> > c0e0a408 eb074240
> >     bd00: eb074200 c04253c8 eb074280 ea550000 00000012 dd6cd422
> > ebef7480 eb074200
> >     bd20: ea54bd84 c081cf64 ea537200 00000002 00000000 00000014
> > c084061c c0428c38
> >     bd40: ea54bd84 ea54bdbc c081cd34 00000000 c0e4e4b4 ea538c40
> > 00000002 eabe4e80
> >     bd60: ea538c00 00000400 ea4f7a00 ea4f7a60 eb074240 00000060
> > 00000006 c09d544c
> >     bd80: 00000038 00000003 00000000 00000038 ea54bd7c 00000001
> > eb074200 00000000
> >     bda0: 00000000 dead4ead ffffffff ffffffff ea54bdb0 ea54bdb0
> > 00000000 c081cf70
> >     bdc0: c081ce68 c081ce78 ea4f7480 eb000780 00000dc0 eb000780
> > c0e4ee80 443e9884
> >     bde0: 6ed23b1c a14aaeba e52951f9 f17046e5 fefefefe fefefefe
> > fefefefe fefefefe
> >     be00: eb000780 c04292c4 c0e0a638 60000013 60000013 c0305298
> > ea4f7a00 c03062bc
> >     be20: eb000780 00000cc0 ea4f7a00 dd6cd422 00000cc0 ea538c00
> > 00000002 eabe4e40
> >     be40: ea537200 00000007 00000000 ea4f7a00 eb074200 c0429314
> > eb074200 ea538c00
> >     be60: ea4f7a00 0000000a eabe4e80 c084061c c08405fc 00000006
> > c04dace8 00000006
> >     be80: 00000000 c084065c ea537200 0000000e 00000400 eb04de08
> > ea4f71a8 c0429420
> >     bea0: 00000400 ea537200 0000000e ea537200 0000000e c0429374
> > 00000400 ffffffff
> >     bec0: 000000a2 c042a414 00000103 c0e0a408 00000000 c0e0a438
> > c0e5a2a0 c0e5a2a0
> >     bee0: 00000001 00000001 00000017 ffffe000 00000000 60000013
> > c0e5a2a0 c0269470
> >     bf00: c09c9ed0 ea54bf5c 00000103 00000000 00000000 c0e0a408
> > ea537280 0000000e
> >     bf20: 00000400 c0426500 00000000 eb04de08 ea4f71a8 c02694f4
> > c09c9ed0 ea54bf5c
> >     bf40: ea54bf28 c02699d0 ea54bf5c dd6cd422 ea537200 dd6cd422
> > c09c9ed0 ea537200
> >     bf60: ea4af1c0 ea54a000 ea537200 c0426500 00000000 eb04de08
> > ea4f71a8 c0426524
> >     bf80: ea4f7180 c023dcec ea54a000 ea4af1c0 c023dbb4 00000000
> > 00000000 00000000
> >     bfa0: 00000000 00000000 00000000 c02010d8 00000000 00000000
> > 00000000 00000000
> >     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> > 00000000 00000000
> >     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> > 00000000 00000000
> >     [<c030fd60>] (usercopy_abort) from [<c0310060>]
> > (__check_object_size+0x2d8/0x448)
> >     [<c0310060>] (__check_object_size) from [<c0427a30>]
> > (build_test_sglist+0x268/0x2d8)
> >     [<c0427a30>] (build_test_sglist) from [<c0428c38>]
> > (test_hash_vec_cfg+0x110/0x694)
> >     [<c0428c38>] (test_hash_vec_cfg) from [<c0429314>]
> > (__alg_test_hash+0x158/0x1b8)
> >     [<c0429314>] (__alg_test_hash) from [<c0429420>] (alg_test_hash+0xac/0xf4)
> >     [<c0429420>] (alg_test_hash) from [<c042a414>] (alg_test.part.4+0x264/0x2f8)
> >     [<c042a414>] (alg_test.part.4) from [<c0426524>] (cryptomgr_test+0x24/0x44)
> >     [<c0426524>] (cryptomgr_test) from [<c023dcec>] (kthread+0x138/0x150)
> >     [<c023dcec>] (kthread) from [<c02010d8>] (ret_from_fork+0x14/0x3c)
> >     Exception stack(0xea54bfb0 to 0xea54bff8)
> >     bfa0:                                     00000000 00000000
> > 00000000 00000000
> >     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> > 00000000 00000000
> >     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> >     Code: e58de000 e98d0012 e1a0100c ebfd6712 (e7f001f2)
> >     ---[ end trace 190b3cf48e720f78 ]---
> >     BUG: sleeping function called from invalid context at
> > include/linux/percpu-rwsem.h:34
> >     in_atomic(): 0, irqs_disabled(): 128, pid: 35, name: cryptomgr_test
> >     CPU: 0 PID: 35 Comm: cryptomgr_test Tainted: G      D
> > 5.1.0-rc1-koelsch-01109-gbeb7d6376ecfbf07-dirty #397
> >     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> >     [<c020ec74>] (unwind_backtrace) from [<c020ae58>] (show_stack+0x10/0x14)
> >     [<c020ae58>] (show_stack) from [<c07c3624>] (dump_stack+0x7c/0x9c)
> >     [<c07c3624>] (dump_stack) from [<c0242e14>] (___might_sleep+0xf4/0x158)
> >     [<c0242e14>] (___might_sleep) from [<c0230210>] (exit_signals+0x2c/0x258)
> >     [<c0230210>] (exit_signals) from [<c0223d6c>] (do_exit+0x114/0xa20)
> >     [<c0223d6c>] (do_exit) from [<c020b160>] (die+0x304/0x344)
> >     [<c020b160>] (die) from [<c020b388>] (do_undefinstr+0x80/0x190)
> >     [<c020b388>] (do_undefinstr) from [<c0201b24>] (__und_svc_finish+0x0/0x3c)
> >     Exception stack(0xea54bc10 to 0xea54bc58)
> >     bc00:                                     0000005f 2abb4000
> > dd6cd422 dd6cd422
> >     bc20: c09d1120 0000002a 00000000 ea54d00a ea54d009 c0e0ce04
> > 00000000 cccccccd
> >     bc40: 00000010 ea54bc60 c030fd60 c030fd60 60000013 ffffffff
> >     [<c0201b24>] (__und_svc_finish) from [<c030fd60>] (usercopy_abort+0x68/0x90)
> >     [<c030fd60>] (usercopy_abort) from [<c0310060>]
> > (__check_object_size+0x2d8/0x448)
> >     [<c0310060>] (__check_object_size) from [<c0427a30>]
> > (build_test_sglist+0x268/0x2d8)
> >     [<c0427a30>] (build_test_sglist) from [<c0428c38>]
> > (test_hash_vec_cfg+0x110/0x694)
> >     [<c0428c38>] (test_hash_vec_cfg) from [<c0429314>]
> > (__alg_test_hash+0x158/0x1b8)
> >     [<c0429314>] (__alg_test_hash) from [<c0429420>] (alg_test_hash+0xac/0xf4)
> >     [<c0429420>] (alg_test_hash) from [<c042a414>] (alg_test.part.4+0x264/0x2f8)
> >     [<c042a414>] (alg_test.part.4) from [<c0426524>] (cryptomgr_test+0x24/0x44)
> >     [<c0426524>] (cryptomgr_test) from [<c023dcec>] (kthread+0x138/0x150)
> >     [<c023dcec>] (kthread) from [<c02010d8>] (ret_from_fork+0x14/0x3c)
> >     Exception stack(0xea54bfb0 to 0xea54bff8)
> >     bfa0:                                     00000000 00000000
> > 00000000 00000000
> >     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> > 00000000 00000000
> >     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> > 
> 
> Well, this must happen with the new (in 5.1) crypto self-tests implementation
> for any crypto algorithm when CONFIG_HARDENED_USERCOPY_PAGESPAN=y.  I don't
> understand why hardened usercopy considers it a bug though, as there's no buffer
> overflow.  The crypto tests use copy_from_iter() to copy data into a 2-page
> buffer that was allocated with __get_free_pages():
> 
> 	__get_free_pages(GFP_KERNEL, 1)
> 
> ... where 1 means an order-1 allocation.
> 
> If it copies to offset=4064 len=42, for example, then hardened usercopy
> considers it a bug even though the buffer is 8192 bytes long.  Why?
> 
> It isn't actually copying anything to/from userspace, BTW; it's using iov_iter
> with ITER_KVEC.
> 
> - Eric

Kees, any thoughts on why hardened usercopy rejects copies spanning a page
boundary when they seem to be fine?

- Eric
