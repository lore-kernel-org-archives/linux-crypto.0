Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308ECC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57682076C
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1FAgTgc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbgLAOqX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgLAOqW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:46:22 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CC6C0613CF;
        Tue,  1 Dec 2020 06:45:36 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a6so3375260wmc.2;
        Tue, 01 Dec 2020 06:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mMlh9khZXCfriVq56d2yMrt6NqVcBzUXYtjyPsxf8aQ=;
        b=F1FAgTgceMlntDI7hbmR9gVj7lgoO4ZPecPAAlJD6nHEWzGLMIox07Pd3aQakfmu1Y
         qPzibaSrMbEikXwBPI38e6u8qymESHQBoH5TMNrtAK1GuTcE3XJWHmzrO80tI47fuD3c
         0NQAUuyVu/CfdwVlEVSA/B0X+O0g4ksCgVAWEk4i1ySzinfjBM3Gj9ZpukMrCzVeZuhB
         zEVPjIjdC00tiLgzCLxU1bv9jnwV0OhfelLa32jhgZiZxBPATyrFcN6NN4ppAp4ufBAj
         fYfUkguGX48/QfK1k9otwiiF0sP+NbuDpLMp6FIaizfMjhe5Vks6ZllTtR8vO7qxyP47
         BkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mMlh9khZXCfriVq56d2yMrt6NqVcBzUXYtjyPsxf8aQ=;
        b=PUGgjJKfPp7BkIDyp2OFwybwo3cjf1UZ/clE/g80S3zRdUZcEv+8bJAf8IjOExJwPi
         QXLk2HatN4XO654IP5Yheu25vsBvgYkvbl9k+MvZ2sgWqsfet+Ah6aX+iwgtah+zEL2S
         AAOVdlBgADvgkAlUyFjerMAE/LPgxm/Cr+86kZtKjzBjcsjkGwplAviOoM35XslAVH+H
         mLO8d6uNCAoW9cjBuHSwAZyi4S8nGbpy+sMGf8OO5x3xpyOoko6CvCaniK1MxR6nALnf
         KtMieOnbb2+Y+bLA1+n54UShen/doWyNpUEwJ+IkFPyGg1uAj2VGsBG9TehA73x6F7Vj
         NRCw==
X-Gm-Message-State: AOAM533y0xZYguhDYeXCXBGhLGVYSJWT+Fdhiab9uBRL/vQjtjxxqyIk
        iSWoaXqebe8vjpCPD5Mtlcw7MxZ6Hbk=
X-Google-Smtp-Source: ABdhPJwm9Y/3v88HFWHJocZbdDm1rDzJ9iPAdY4w3GtSuRILpS8fOmSIjZzsU41vXyIOVWE8i0yHNQ==
X-Received: by 2002:a1c:7909:: with SMTP id l9mr3086664wme.120.1606833934975;
        Tue, 01 Dec 2020 06:45:34 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b62sm62095wmh.41.2020.12.01.06.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 06:45:33 -0800 (PST)
Date:   Tue, 1 Dec 2020 15:45:29 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201201144529.GA6786@Red>
References: <20201201130102.GA23461@Red>
 <87ft4phcyx.fsf@nanos.tec.linutronix.de>
 <20201201135252.GA9584@Red>
 <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01, 2020 at 03:16:36PM +0100, Thomas Gleixner wrote:
> On Tue, Dec 01 2020 at 14:52, Corentin Labbe wrote:
> > On Tue, Dec 01, 2020 at 02:28:54PM +0100, Thomas Gleixner wrote:
> > The patch made the board too busy logging and fail to boot until the test.
> 
> Stupid me. Of course this wants to be conditional.
> 
> Thanks,
> 
>         tglx
> ---        
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b49364a306b8..178b126ab4f6 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -571,8 +571,10 @@ void kunmap_local_indexed(void *vaddr)
>  		 * PAGE_OFFSET. Warn for all other addresses which are in
>  		 * the user space part of the virtual address space.
>  		 */
> -		if (!kmap_high_unmap_local(addr))
> -			WARN_ON_ONCE(addr < PAGE_OFFSET);
> +		if (!kmap_high_unmap_local(addr)) {
> +			if (WARN_ON_ONCE(addr < PAGE_OFFSET))
> +				pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
> +		}
>  		return;
>  	}
>  

In fact the warn was a bit later so I added:
       preempt_disable();
        idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
-       WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
+       if (WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)))
+               pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
 
        arch_kmap_local_pre_unmap(addr);
        pte_clear(&init_mm, addr, kmap_pte - idx);

and this give kunmap_local: vaddr ffefe000

full dump:
+[  215.602507] ------------[ cut here ]------------
+[  215.602563] WARNING: CPU: 0 PID: 18429 at mm/highmem.c:584 kunmap_local_indexed+0x204/0x228
+[  215.602570] Modules linked in: sm4_generic authenc vmac xcbc hmac streebog_generic sm3_generic sha3_generic crct10dif_generic crct10dif_common seed rmd320 rmd256 rmd160 rmd128 cts lzo lzo_compress salsa20_generic camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate zlib_deflate sha512_generic cfb ofb serpent_generic lrw twofish_generic twofish_common blowfish_generic blowfish_common md4
+[  215.602767] CPU: 0 PID: 18429 Comm: cryptsetup Tainted: G        W         5.10.0-rc5-next-20201130-00059-gf7ecf0611042-dirty #247
+[  215.602772] Hardware name: Allwinner sun7i (A20) Family
+[  215.602805] [<c010d730>] (unwind_backtrace) from [<c010a218>] (show_stack+0x10/0x14)
+[  215.602821] [<c010a218>] (show_stack) from [<c08bbe2c>] (dump_stack+0x98/0xac)
+[  215.602834] [<c08bbe2c>] (dump_stack) from [<c08b940c>] (__warn+0xc0/0xd8)
+[  215.602846] [<c08b940c>] (__warn) from [<c08b9488>] (warn_slowpath_fmt+0x64/0xc0)
+[  215.602860] [<c08b9488>] (warn_slowpath_fmt) from [<c0201924>] (kunmap_local_indexed+0x204/0x228)
+[  215.602879] [<c0201924>] (kunmap_local_indexed) from [<c03e03e8>] (sg_miter_stop+0xb4/0x164)
+[  215.602895] [<c03e03e8>] (sg_miter_stop) from [<c03e0884>] (sg_miter_next+0xc/0xe4)
+[  215.602913] [<c03e0884>] (sg_miter_next) from [<c06b2d64>] (sun4i_ss_opti_poll+0x278/0x40c)
+[  215.602929] [<c06b2d64>] (sun4i_ss_opti_poll) from [<c06b33ec>] (sun4i_ss_cipher_poll+0x4f4/0x5e4)
+[  215.602944] [<c06b33ec>] (sun4i_ss_cipher_poll) from [<c039922c>] (crypto_skcipher_encrypt+0x38/0x5c)
+[  215.602958] [<c039922c>] (crypto_skcipher_encrypt) from [<c03aa9d8>] (xts_encrypt+0x8c/0xd4)
+[  215.602971] [<c03aa9d8>] (xts_encrypt) from [<c039922c>] (crypto_skcipher_encrypt+0x38/0x5c)
+[  215.602984] [<c039922c>] (crypto_skcipher_encrypt) from [<c03b3dec>] (skcipher_recvmsg+0x364/0x43c)
+[  215.602999] [<c03b3dec>] (skcipher_recvmsg) from [<c07196b0>] (sock_read_iter+0xa8/0xf8)
+[  215.603017] [<c07196b0>] (sock_read_iter) from [<c0239eec>] (vfs_read+0x2b8/0x2d8)
+[  215.603030] [<c0239eec>] (vfs_read) from [<c023a3ec>] (ksys_read+0xb0/0xe4)
+[  215.603042] [<c023a3ec>] (ksys_read) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
+[  215.603050] Exception stack(0xc4de9fa8 to 0xc4de9ff0)
+[  215.603061] 9fa0:                   00000006 b6fea4d0 00000006 b48ce000 00010000 00000000
+[  215.603073] 9fc0: 00000006 b6fea4d0 00010000 00000003 00000030 bebad9bc 00000010 bebad9fc
+[  215.603082] 9fe0: b6f1809c bebad958 b6daa504 b6daa51c
+[  215.603091] ---[ end trace d5a2f8d9794ce46d ]---
+[  215.603098] kunmap_local: vaddr ffefe000
+[  215.604643] 8<--- cut here ---
+[  215.604650] Unable to handle kernel paging request at virtual address ffefdf70
+[  215.604661] pgd = b4af32d8
+[  215.604667] [ffefdf70] *pgd=6ffce861, *pte=00000000, *ppte=00000000
+[  215.604692] Internal error: Oops: 837 [#1] SMP ARM
+[  215.609490] Modules linked in: sm4_generic authenc vmac xcbc hmac streebog_generic sm3_generic sha3_generic crct10dif_generic crct10dif_common seed rmd320 rmd256 rmd160 rmd128 cts lzo lzo_compress salsa20_generic camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate zlib_deflate sha512_generic cfb ofb serpent_generic lrw twofish_generic twofish_common blowfish_generic blowfish_common md4
+[  215.650069] CPU: 0 PID: 18429 Comm: cryptsetup Tainted: G        W         5.10.0-rc5-next-20201130-00059-gf7ecf0611042-dirty #247
+[  215.661789] Hardware name: Allwinner sun7i (A20) Family
+[  215.667017] PC is at __raw_readsl+0x30/0x100
+[  215.671282] LR is at 0x3a692a37
+[  215.674421] pc : [<c041d588>]    lr : [<3a692a37>]    psr: 20000093
+[  215.680679] sp : c4de9ca0  ip : c01ea23f  fp : 00000000
+[  215.685897] r10: c4de8000  r9 : c51ca640  r8 : 00000000
+[  215.691116] r7 : 00000fa0  r6 : c5068a40  r5 : 00000018  r4 : 4f0e2404
+[  215.697634] r3 : 3e034c16  r2 : 00000004  r1 : ffefdf70  r0 : f08ea204
+[  215.704155] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
+[  215.711368] Control: 10c5387d  Table: 44f3806a  DAC: 00000051
+[  215.717108] Process cryptsetup (pid: 18429, stack limit = 0xca52e1ce)
+[  215.723541] Stack: (0xc4de9ca0 to 0xc4dea000)
+[  215.727899] 9ca0: 0000000d c06b2de8 eff19c80 80000013 00000374 00000001 00000000 c5068b64
+[  215.736069] 9cc0: 60000013 00000000 ffefe374 00000000 00000000 00000000 00000000 00000000
+[  215.744239] 9ce0: 00000000 00000000 00000001 00001000 00000000 00000005 efed8240 ffefd000
+[  215.752409] 9d00: 00001000 00001000 c51ca4f8 00000000 00000001 00000001 00000000 00001000
+[  215.760580] 9d20: 00000003 d09453dc efed7e80 c0dd81c0 c4e394c0 c5068a40 00000000 c51ca640
+[  215.768750] 9d40: c51ca408 00000000 00000000 c06b33ec 7879265f c0201500 c4de9da8 ff98fca0
+[  215.776920] 9d60: c4de8000 00000000 00000001 00000000 c4de9da8 00000000 00000000 c039a040
+[  215.785090] 9d80: 68874dfe e29ea43a 0001fe9b 2581e6c9 c51ca5c0 c03aa070 00000000 c4de8000
+[  215.793261] 9da0: 00000001 00000000 ef867ee0 c4f77000 efed8240 ffefe000 c50b54f0 00001000
+[  215.801431] 9dc0: 00000000 c51ca4f8 00001000 00000000 c5ffbec0 c51ca5c0 00000000 00000000
+[  215.809602] 9de0: c4e7bcc0 d09453dc 00000010 c51ca640 c4e394c0 c0dd81c0 00010000 00000000
+[  215.817772] 9e00: c4de9ea0 c51ca5c0 00000000 c039922c c51ca5c0 c51ca600 00000000 00010000
+[  215.825943] 9e20: 00000000 c03aa9d8 c51ca5c0 c4e39700 c4d69080 c039922c c51ca400 c4e7bc90
+[  215.834113] 9e40: c4e7bc80 c4e39700 00000000 c03b3dec 00010000 c4de9e70 c15cfb00 c0de0e40
+[  215.842283] 9e60: c03945d0 c03b2140 c4e80400 c4de8000 00010000 d09453dc c12f1b40 c4de9f08
+[  215.850454] 9e80: c03b3a88 c4de8000 c12f1b40 c15cfb00 00000000 00000001 00000000 c07196b0
+[  215.858624] 9ea0: 00000000 00000000 00000004 00000000 00000000 c4de9f08 00000000 c071d634
+[  215.866794] 9ec0: 00000000 00000000 00000000 00000000 c4de9f20 d09453dc 00010000 c12f1b40
+[  215.874965] 9ee0: 00000000 00000000 c4de8000 c0239eec 00010000 00000020 c4d69080 c4e7bc80
+[  215.883135] 9f00: b48ce000 00010000 00000004 00000000 00010000 c4de9f00 00000001 c071d634
+[  215.891305] 9f20: c12f1b40 00000000 00000000 00000000 00000000 00000000 00000000 00000000
+[  215.899475] 9f40: 00000000 00000000 00000000 d09453dc 00000000 c12f1b40 c12f1b40 00010000
+[  215.907645] 9f60: 00000003 c4de8000 00010000 b48ce000 bebad9fc c023a3ec c4e7bd00 0000011c
+[  215.915816] 9f80: 00000030 d09453dc 00000006 b6fea4d0 00010000 00000003 c0100264 c4de8000
+[  215.923987] 9fa0: 00000003 c0100060 00000006 b6fea4d0 00000006 b48ce000 00010000 00000000
+[  215.932157] 9fc0: 00000006 b6fea4d0 00010000 00000003 00000030 bebad9bc 00000010 bebad9fc
+[  215.940327] 9fe0: b6f1809c bebad958 b6daa504 b6daa51c 80000010 00000006 00000000 00000000
+[  215.948501] Code: e5904000 e590c000 e590e000 e2522004 (e8a15018) 
+[  215.954592] ---[ end trace d5a2f8d9794ce46e ]---
+[  215.959208] note: cryptsetup[18429] exited with preempt_count 2
