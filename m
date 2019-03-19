Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3C7C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 17:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFD320872
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553015357;
	bh=wzEbZMaPHJ0EJCQgY/z/qbBTZS4/wt3ud+9O/xrf7v8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jajoorXgCoNB9edUBMTkTDjOjPk7ul847hoYJBVVfuaRvvtgyFlV2QN9wTjoqoPyN
	 LmSNYMWzZ+5NOCrUTGUvM6GL6mJdvXRSmNxqdsQaleI3TaFqEHtyf5YNB4ARkRaV0n
	 ALh85HXUsPlZHWTXHn0JSa/0OCW25khK8xQ9AXbo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfCSRJQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfCSRJQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 13:09:16 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A208F20863;
        Tue, 19 Mar 2019 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553015354;
        bh=wzEbZMaPHJ0EJCQgY/z/qbBTZS4/wt3ud+9O/xrf7v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xrd82BejhHnAlYw5QMtlI3TrJ5Ajmgi4oHMZH/kd5+IG8VjPXgaHpl1Rrs0kQnN5w
         2OnAJZAjiuWFsEUwRYpgfltwMn25XqivOqHMEjteSsqzJKb5kKCWT/TMe75YDiTkmB
         XAorZmW6ICNjFWhbBEn8byNIHQ8e+ltw5vhRgBqY=
Date:   Tue, 19 Mar 2019 10:09:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
Message-ID: <20190319170911.GB202956@gmail.com>
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 19, 2019 at 12:54:23PM +0100, Geert Uytterhoeven wrote:
> When running the sha1-asm crypto selftest on arm with
> CONFIG_HARDENED_USERCOPY_PAGESPAN=y:
> 
>     usercopy: Kernel memory overwrite attempt detected to spans
> multiple pages (offset 0, size 42)!
>     ------------[ cut here ]------------
>     kernel BUG at mm/usercopy.c:102!
>     Internal error: Oops - BUG: 0 [#1] SMP ARM
>     Modules linked in:
>     CPU: 0 PID: 35 Comm: cryptomgr_test Not tainted
> 5.1.0-rc1-koelsch-01109-gbeb7d6376ecfbf07-dirty #397
>     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
>     PC is at usercopy_abort+0x68/0x90
>     LR is at usercopy_abort+0x68/0x90
>     pc : [<c030fd60>]    lr : [<c030fd60>]    psr: 60000013
>     sp : ea54bc60  ip : 00000010  fp : cccccccd
>     r10: 00000000  r9 : c0e0ce04  r8 : ea54d009
>     r7 : ea54d00a  r6 : 00000000  r5 : 0000002a  r4 : c09d1120
>     r3 : dd6cd422  r2 : dd6cd422  r1 : 2abb4000  r0 : 0000005f
>     Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>     Control: 30c5387d  Table: 40003000  DAC: fffffffd
>     Process cryptomgr_test (pid: 35, stack limit = 0x(ptrval))
>     Stack: (0xea54bc60 to 0xea54c000)
>     bc60: c09d1120 c09d1120 c09d1120 00000000 0000002a 0000002a
> 00000000 c0310060
>     bc80: 0000002a 00000000 000001c0 00000000 00000000 c0eb11e8
> ea54cfe0 ea538c00
>     bca0: 00000000 ea54cfe0 ebef73e0 0000002a ea538c20 ea54bd84
> 0000003a c0427a30
>     bcc0: ea54bdbc 00000000 00000000 c081cf70 eb074280 c081cf70
> 0000002a c081cf80
>     bce0: 0000000e c07da138 ea54bd0c 00000000 c084061c c04248e8
> c0e0a408 eb074240
>     bd00: eb074200 c04253c8 eb074280 ea550000 00000012 dd6cd422
> ebef7480 eb074200
>     bd20: ea54bd84 c081cf64 ea537200 00000002 00000000 00000014
> c084061c c0428c38
>     bd40: ea54bd84 ea54bdbc c081cd34 00000000 c0e4e4b4 ea538c40
> 00000002 eabe4e80
>     bd60: ea538c00 00000400 ea4f7a00 ea4f7a60 eb074240 00000060
> 00000006 c09d544c
>     bd80: 00000038 00000003 00000000 00000038 ea54bd7c 00000001
> eb074200 00000000
>     bda0: 00000000 dead4ead ffffffff ffffffff ea54bdb0 ea54bdb0
> 00000000 c081cf70
>     bdc0: c081ce68 c081ce78 ea4f7480 eb000780 00000dc0 eb000780
> c0e4ee80 443e9884
>     bde0: 6ed23b1c a14aaeba e52951f9 f17046e5 fefefefe fefefefe
> fefefefe fefefefe
>     be00: eb000780 c04292c4 c0e0a638 60000013 60000013 c0305298
> ea4f7a00 c03062bc
>     be20: eb000780 00000cc0 ea4f7a00 dd6cd422 00000cc0 ea538c00
> 00000002 eabe4e40
>     be40: ea537200 00000007 00000000 ea4f7a00 eb074200 c0429314
> eb074200 ea538c00
>     be60: ea4f7a00 0000000a eabe4e80 c084061c c08405fc 00000006
> c04dace8 00000006
>     be80: 00000000 c084065c ea537200 0000000e 00000400 eb04de08
> ea4f71a8 c0429420
>     bea0: 00000400 ea537200 0000000e ea537200 0000000e c0429374
> 00000400 ffffffff
>     bec0: 000000a2 c042a414 00000103 c0e0a408 00000000 c0e0a438
> c0e5a2a0 c0e5a2a0
>     bee0: 00000001 00000001 00000017 ffffe000 00000000 60000013
> c0e5a2a0 c0269470
>     bf00: c09c9ed0 ea54bf5c 00000103 00000000 00000000 c0e0a408
> ea537280 0000000e
>     bf20: 00000400 c0426500 00000000 eb04de08 ea4f71a8 c02694f4
> c09c9ed0 ea54bf5c
>     bf40: ea54bf28 c02699d0 ea54bf5c dd6cd422 ea537200 dd6cd422
> c09c9ed0 ea537200
>     bf60: ea4af1c0 ea54a000 ea537200 c0426500 00000000 eb04de08
> ea4f71a8 c0426524
>     bf80: ea4f7180 c023dcec ea54a000 ea4af1c0 c023dbb4 00000000
> 00000000 00000000
>     bfa0: 00000000 00000000 00000000 c02010d8 00000000 00000000
> 00000000 00000000
>     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 00000000 00000000
>     [<c030fd60>] (usercopy_abort) from [<c0310060>]
> (__check_object_size+0x2d8/0x448)
>     [<c0310060>] (__check_object_size) from [<c0427a30>]
> (build_test_sglist+0x268/0x2d8)
>     [<c0427a30>] (build_test_sglist) from [<c0428c38>]
> (test_hash_vec_cfg+0x110/0x694)
>     [<c0428c38>] (test_hash_vec_cfg) from [<c0429314>]
> (__alg_test_hash+0x158/0x1b8)
>     [<c0429314>] (__alg_test_hash) from [<c0429420>] (alg_test_hash+0xac/0xf4)
>     [<c0429420>] (alg_test_hash) from [<c042a414>] (alg_test.part.4+0x264/0x2f8)
>     [<c042a414>] (alg_test.part.4) from [<c0426524>] (cryptomgr_test+0x24/0x44)
>     [<c0426524>] (cryptomgr_test) from [<c023dcec>] (kthread+0x138/0x150)
>     [<c023dcec>] (kthread) from [<c02010d8>] (ret_from_fork+0x14/0x3c)
>     Exception stack(0xea54bfb0 to 0xea54bff8)
>     bfa0:                                     00000000 00000000
> 00000000 00000000
>     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>     Code: e58de000 e98d0012 e1a0100c ebfd6712 (e7f001f2)
>     ---[ end trace 190b3cf48e720f78 ]---
>     BUG: sleeping function called from invalid context at
> include/linux/percpu-rwsem.h:34
>     in_atomic(): 0, irqs_disabled(): 128, pid: 35, name: cryptomgr_test
>     CPU: 0 PID: 35 Comm: cryptomgr_test Tainted: G      D
> 5.1.0-rc1-koelsch-01109-gbeb7d6376ecfbf07-dirty #397
>     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
>     [<c020ec74>] (unwind_backtrace) from [<c020ae58>] (show_stack+0x10/0x14)
>     [<c020ae58>] (show_stack) from [<c07c3624>] (dump_stack+0x7c/0x9c)
>     [<c07c3624>] (dump_stack) from [<c0242e14>] (___might_sleep+0xf4/0x158)
>     [<c0242e14>] (___might_sleep) from [<c0230210>] (exit_signals+0x2c/0x258)
>     [<c0230210>] (exit_signals) from [<c0223d6c>] (do_exit+0x114/0xa20)
>     [<c0223d6c>] (do_exit) from [<c020b160>] (die+0x304/0x344)
>     [<c020b160>] (die) from [<c020b388>] (do_undefinstr+0x80/0x190)
>     [<c020b388>] (do_undefinstr) from [<c0201b24>] (__und_svc_finish+0x0/0x3c)
>     Exception stack(0xea54bc10 to 0xea54bc58)
>     bc00:                                     0000005f 2abb4000
> dd6cd422 dd6cd422
>     bc20: c09d1120 0000002a 00000000 ea54d00a ea54d009 c0e0ce04
> 00000000 cccccccd
>     bc40: 00000010 ea54bc60 c030fd60 c030fd60 60000013 ffffffff
>     [<c0201b24>] (__und_svc_finish) from [<c030fd60>] (usercopy_abort+0x68/0x90)
>     [<c030fd60>] (usercopy_abort) from [<c0310060>]
> (__check_object_size+0x2d8/0x448)
>     [<c0310060>] (__check_object_size) from [<c0427a30>]
> (build_test_sglist+0x268/0x2d8)
>     [<c0427a30>] (build_test_sglist) from [<c0428c38>]
> (test_hash_vec_cfg+0x110/0x694)
>     [<c0428c38>] (test_hash_vec_cfg) from [<c0429314>]
> (__alg_test_hash+0x158/0x1b8)
>     [<c0429314>] (__alg_test_hash) from [<c0429420>] (alg_test_hash+0xac/0xf4)
>     [<c0429420>] (alg_test_hash) from [<c042a414>] (alg_test.part.4+0x264/0x2f8)
>     [<c042a414>] (alg_test.part.4) from [<c0426524>] (cryptomgr_test+0x24/0x44)
>     [<c0426524>] (cryptomgr_test) from [<c023dcec>] (kthread+0x138/0x150)
>     [<c023dcec>] (kthread) from [<c02010d8>] (ret_from_fork+0x14/0x3c)
>     Exception stack(0xea54bfb0 to 0xea54bff8)
>     bfa0:                                     00000000 00000000
> 00000000 00000000
>     bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>     bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> A similar trace is seen with sha1-ce on arm64:
> 
>     usercopy: Kernel memory overwrite attempt detected to spans
> multiple pages (offset 0, size 42)!
>     ------------[ cut here ]------------
>     kernel BUG at mm/usercopy.c:102!
>     Internal error: Oops - BUG: 0 [#1] SMP
>     Modules linked in:
>     CPU: 1 PID: 33 Comm: cryptomgr_test Not tainted
> 5.1.0-rc1-salvator-x-01109-gbeb7d6376ecfbf07-dirty #352
>     Hardware name: Renesas Salvator-X 2nd version board based on r8a77965 (DT)
>     pstate: 60400005 (nZCv daif +PAN -UAO)
>     pc : usercopy_abort+0x64/0x90
>     lr : usercopy_abort+0x64/0x90
>     sp : ffffff8011eb38d0
>     x29: ffffff8011eb38e0 x28: 6db6db6db6db6db7
>     x27: ffffffbf00000000 x26: 0000000000000038
>     x25: ffffffc0778fd009 x24: 0000000000000000
>     x23: ffffffc0778fd00a x22: ffffff8010d51000
>     x21: 0000000000000000 x20: 000000000000002a
>     x19: ffffffc0778fcfe0 x18: 000000000000000a
>     x17: 00000000526a1be5 x16: 0000000000000014
>     x15: 000000000009f6c2 x14: 0720072007200720
>     x13: 0720072007200720 x12: 0720072007200720
>     x11: 0720072007200720 x10: 0720072007200720
>     x9 : ffffff80110126c8 x8 : 0000000000000000
>     x7 : ffffff801015700c x6 : 0000000000000000
>     x5 : 0000000000000000 x4 : ffffff8011eb4000
>     x3 : 0000000000000080 x2 : a045404094166600
>     x1 : 0000000000000000 x0 : 000000000000005f
>     Process cryptomgr_test (pid: 33, stack limit = 0x(____ptrval____))
>     Call trace:
>      usercopy_abort+0x64/0x90
>      __check_object_size+0x64/0x464
>      build_test_sglist+0x238/0x2c8
>      test_hash_vec_cfg+0x130/0x660
>      __alg_test_hash+0x1b4/0x1f4
>      alg_test_hash+0x88/0x104
>      alg_test.part.6+0x2a8/0x330
>      alg_test+0x98/0xa0
>      cryptomgr_test+0x24/0x4c
>      kthread+0x120/0x130
>      ret_from_fork+0x10/0x18
>     Code: aa0003e3 b00053e0 91148000 97fc3bf2 (d4210000)
>     ---[ end trace d9f3261d50a7f84f ]---
>     BUG: sleeping function called from invalid context at
> include/linux/percpu-rwsem.h:34
>     in_atomic(): 0, irqs_disabled(): 128, pid: 33, name: cryptomgr_test
>     INFO: lockdep is turned off.
>     irq event stamp: 262
>     hardirqs last  enabled at (261): [<ffffff8010157050>]
> console_unlock+0x554/0x560
>     hardirqs last disabled at (262): [<ffffff8010081a28>]
> do_debug_exception+0x48/0x13c
>     softirqs last  enabled at (258): [<ffffff8010081ee4>]
> __do_softirq+0x18c/0x4a0
>     softirqs last disabled at (245): [<ffffff80100f3e10>] irq_exit+0xa4/0x100
>     CPU: 1 PID: 33 Comm: cryptomgr_test Tainted: G      D
> 5.1.0-rc1-salvator-x-01109-gbeb7d6376ecfbf07-dirty #352
>     Hardware name: Renesas Salvator-X 2nd version board based on r8a77965 (DT)
>     Call trace:
>      dump_backtrace+0x0/0x118
>      show_stack+0x14/0x1c
>      dump_stack+0xc8/0x118
>      ___might_sleep+0x24c/0x25c
>      __might_sleep+0x70/0x80
>      exit_signals+0x48/0x278
>      do_exit+0x10c/0xa30
>      die+0x1f4/0x208
>      bug_handler+0x4c/0x78
>      brk_handler+0x15c/0x188
>      do_debug_exception+0xd4/0x13c
>      el1_dbg+0x18/0xbc
>      usercopy_abort+0x64/0x90
>      __check_object_size+0x64/0x464
>      build_test_sglist+0x238/0x2c8
>      test_hash_vec_cfg+0x130/0x660
>      __alg_test_hash+0x1b4/0x1f4
>      alg_test_hash+0x88/0x104
>      alg_test.part.6+0x2a8/0x330
>      alg_test+0x98/0xa0
>      cryptomgr_test+0x24/0x4c
>      kthread+0x120/0x130
>      ret_from_fork+0x10/0x18
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

Well, this must happen with the new (in 5.1) crypto self-tests implementation
for any crypto algorithm when CONFIG_HARDENED_USERCOPY_PAGESPAN=y.  I don't
understand why hardened usercopy considers it a bug though, as there's no buffer
overflow.  The crypto tests use copy_from_iter() to copy data into a 2-page
buffer that was allocated with __get_free_pages():

	__get_free_pages(GFP_KERNEL, 1)

... where 1 means an order-1 allocation.

If it copies to offset=4064 len=42, for example, then hardened usercopy
considers it a bug even though the buffer is 8192 bytes long.  Why?

It isn't actually copying anything to/from userspace, BTW; it's using iov_iter
with ITER_KVEC.

- Eric
