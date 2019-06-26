Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5EBC4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 03:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37846208CB
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 03:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561519907;
	bh=mIc7zASrw/S5VCKYRC4T+Vc/+ctawgBF53nIboBSqDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SY7zP/zxkn0LKXnveMu++/K7oER1i+t9SdvPQGqzG97eyhUuA8sdQxqeWZ+zit2sS
	 K1tpd0sDgkAeLs1mKGnYxxsRyXeZ/JxH4kqD8hFR+bb8KMqciY6ngC7fTa+tGadtf6
	 sAGIatmaNuIAbWbe7hwYNz2mfx09lGGQ865KzUnI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFZDbq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 23:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfFZDbq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 23:31:46 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0B4D204FD;
        Wed, 26 Jun 2019 03:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561519904;
        bh=mIc7zASrw/S5VCKYRC4T+Vc/+ctawgBF53nIboBSqDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BhniTulSfHvVNE4QvTC2VDUpCfHLcMOhX5bi1wjcSs7WD6yJz+aTZXnDtJPoP3HU0
         bvKj7LkU1rHOmoEhVFAOD1HE/i2fAoNcY9Fh5wxMJSdwKcp5r1CLzH2PgBvFGmD2EU
         MqMjGdTCUwc2xhqMJvG5tCj8iELfFWU1PH4o7q/E=
Date:   Tue, 25 Jun 2019 20:31:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC PATCH 00/30] crypto: DES/3DES cleanup
Message-ID: <20190626033142.GA745@sol.localdomain>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 22, 2019 at 02:30:42AM +0200, Ard Biesheuvel wrote:
> In my effort to remove crypto_alloc_cipher() invocations from non-crypto
> code, i ran into a DES call in the CIFS driver. This is addressed in
> patch #30.
> 
> The other patches are cleanups for the quirky DES interface, and lots
> of duplication of the weak key checks etc.
> 
> Patch #1 adds new helpers to verify DES keys to crypto/internal.des.h
> 
> The next 23 patches move all existing users of DES routines to the
> new interface.
> 
> Patch #25 and #26 are preparatory patches for the new DES library
> introduced in patch #27, which replaces the various DES related
> functions exported to other drivers with a sane library interface.
> 
> Patch #28 switches the x86 asm code to the new librar interface.
> 
> Patch #29 removes code that is no longer used at this point.
> 
> Ard Biesheuvel (30):
>   crypto: des/3des_ede - add new helpers to verify key length
>   crypto: s390/des - switch to new verification routines
>   crypto: sparc/des - switch to new verification routines
>   crypto: atmel/des - switch to new verification routines
>   crypto: bcm/des - switch to new verification routines
>   crypto: caam/des - switch to new verification routines
>   crypto: cpt/des - switch to new verification routines
>   crypto: nitrox/des - switch to new verification routines
>   crypto: ccp/des - switch to new verification routines
>   crypto: ccree/des - switch to new verification routines
>   crypto: hifn/des - switch to new verification routines
>   crypto: hisilicon/des - switch to new verification routines
>   crypto: safexcel/des - switch to new verification routines
>   crypto: ixp4xx/des - switch to new verification routines
>   crypto: cesa/des - switch to new verification routines
>   crypto: n2/des - switch to new verification routines
>   crypto: omap/des - switch to new verification routines
>   crypto: picoxcell/des - switch to new verification routines
>   crypto: qce/des - switch to new verification routines
>   crypto: rk3288/des - switch to new verification routines
>   crypto: stm32/des - switch to new verification routines
>   crypto: sun4i/des - switch to new verification routines
>   crypto: talitos/des - switch to new verification routines
>   crypto: ux500/des - switch to new verification routines
>   crypto: 3des - move verification out of exported routine
>   crypto: des - remove unused function
>   crypto: des - split off DES library from generic DES cipher driver
>   crypto: x86/des - switch to library interface
>   crypto: des - remove now unused __des3_ede_setkey()
>   fs: cifs: move from the crypto cipher API to the new DES library
>     interface

I got the following on boot with this patchset applied:

alg: cipher: des-generic setkey failed on test vector 5; expected_error=-22, actual_error=-126, flags=0x100100
==================================================================
BUG: KASAN: global-out-of-bounds in des3_ede_expand_key+0x1a4/0x1b0 lib/crypto/des.c:829
Read of size 24 at addr ffffffff82b74a50 by task cryptomgr_test/114
CPU: 0 PID: 114 Comm: cryptomgr_test Not tainted 5.2.0-rc1-00155-g94bc260c0580 #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x86/0xca lib/dump_stack.c:113
 print_address_description.cold.2+0xe1/0x1f0 mm/kasan/report.c:188
 __kasan_report.cold.3+0x7d/0x95 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:142
 des3_ede_expand_key+0x1a4/0x1b0 lib/crypto/des.c:829
 des3_ede_setkey+0x28/0x100 crypto/des_generic.c:72
 setkey+0x149/0x290 crypto/cipher.c:61
 crypto_cipher_setkey include/linux/crypto.h:1741 [inline]
 test_cipher+0x2cb/0x690 crypto/testmgr.c:2373
 alg_test_cipher crypto/testmgr.c:3226 [inline]
 alg_test.part.6+0x531/0x8b0 crypto/testmgr.c:5198
 alg_test+0x33/0x70 crypto/testmgr.c:5177
 cryptomgr_test+0x56/0x80 crypto/algboss.c:223
 kthread+0x324/0x3e0 kernel/kthread.c:254
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
The buggy address belongs to the variable:
 des3_ede_cbc_tv_template+0xb0/0x500
Memory state around the buggy address:
 ffffffff82b74900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 fa
 ffffffff82b74980: fa fa fa fa 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffff82b74a00: 00 00 00 00 fa fa fa fa 00 00 00 01 fa fa fa fa
                                                    ^
 ffffffff82b74a80: 00 01 fa fa fa fa fa fa 00 01 fa fa fa fa fa fa
 ffffffff82b74b00: 00 00 00 01 fa fa fa fa 00 01 fa fa fa fa fa fa
==================================================================
