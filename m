Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDF8E7490C
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 20:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbjJBUZc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 16:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjJBUZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 16:25:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B6B8
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 13:25:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A08C433C8;
        Mon,  2 Oct 2023 20:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696278324;
        bh=p0G49h7uQbvTfmyK7WVWJxxpd20F/G8wt70WhkQu8cI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyzqN0vD1K4jCiQYaq5vK5qWW8UMVzsD4OepcaCfshtffuuvbsfjkxcCBJhhrJTpn
         vQtjwOMMSx/9O4PwwClu6nZsjBGvDeVWuyG6BpA49JKCOHIMrTsddR9IiyG23Y+SNH
         Nfbc+7YXB14Bf57YuK5DMRROLbTXSc259Wto2kEeq39N/pSFzl3RLj6h5dgIA1wmx6
         //ScpxihIzdYREDOmTy9JVs7exNedewN8nqMDrreR8mJTzvOul8AvqqV/223/QLOVj
         g28UcAB2zfXYloMEKuA3+eKIlyUsI0ZOaAaVs1eFLR9RGDcfkj8iXSZ3vfk/Y86VIa
         SIeoPo5jg6grA==
Date:   Mon, 2 Oct 2023 13:25:22 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 8/8] crypto: cbc - Convert from skcipher to lskcipher
Message-ID: <20231002202522.GA4130583@dev-arch.thelio-3990X>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-9-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914082828.895403-9-herbert@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Sep 14, 2023 at 04:28:28PM +0800, Herbert Xu wrote:
> Replace the existing skcipher CBC template with an lskcipher version.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I am noticing a failure to get to user space when booting OpenSUSE's
armv7hl configuration [1] in QEMU after this change as commit
705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher"). I can
reproduce it with GCC 13.2.0 from kernel.org [2] and QEMU 8.1.1, in case
either of those versions matter.  The rootfs is available at [3] in case
it is relevant.

$ curl -LSso .config https://github.com/openSUSE/kernel-source/raw/master/config/armv7hl/default

$ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- olddefconfig bzImage

$ qemu-system-arm \
    -display none \
    -nodefaults \
    -no-reboot \
    -machine virt \
    -append 'console=ttyAMA0 earlycon' \
    -kernel arch/arm/boot/zImage \
    -initrd arm-rootfs.cpio \
    -m 512m \
    -serial mon:stdio
...
[    0.000000][    T0] Linux version 6.6.0-rc1-default+ (nathan@dev-arch.thelio-3990X) (arm-linux-gnueabi-gcc (GCC) 13.2.0, GNU ld (GNU Binutils) 2.41) #1 SMP Mon Oct  2 13:12:40 MST 2023
...
[    0.743773][    T1] ------------[ cut here ]------------
[    0.743980][    T1] WARNING: CPU: 0 PID: 1 at crypto/algapi.c:506 crypto_unregister_alg+0x124/0x12c
[    0.744693][    T1] Modules linked in:
[    0.745078][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc1-default+ #1 906712a81ca49f79575cf3062af84575f391802d
[    0.745453][    T1] Hardware name: Generic DT based system
[    0.745700][    T1] Backtrace:
[    0.745901][    T1]  dump_backtrace from show_stack+0x20/0x24
[    0.746181][    T1]  r7:c077851c r6:00000009 r5:00000053 r4:c1595a60
[    0.746373][    T1]  show_stack from dump_stack_lvl+0x48/0x54
[    0.746530][    T1]  dump_stack_lvl from dump_stack+0x18/0x1c
[    0.746703][    T1]  r5:000001fa r4:c1589f2c
[    0.746811][    T1]  dump_stack from __warn+0x88/0x120
[    0.746954][    T1]  __warn from warn_slowpath_fmt+0xb8/0x188
[    0.747115][    T1]  r8:0000012a r7:c077851c r6:c1589f2c r5:00000000 r4:c1e825f0
[    0.747288][    T1]  warn_slowpath_fmt from crypto_unregister_alg+0x124/0x12c
[    0.747475][    T1]  r7:c214e414 r6:00000001 r5:c214e428 r4:c2d590c0
[    0.747628][    T1]  crypto_unregister_alg from crypto_unregister_skcipher+0x1c/0x20
[    0.747824][    T1]  r4:c2d59000
[    0.747911][    T1]  crypto_unregister_skcipher from simd_skcipher_free+0x20/0x2c
[    0.748100][    T1]  simd_skcipher_free from aes_exit+0x30/0x4c
[    0.748264][    T1]  r5:c214e428 r4:c214e418
[    0.748375][    T1]  aes_exit from aes_init+0x88/0xa8
[    0.748521][    T1]  r5:fffffffe r4:c1f12740
[    0.748637][    T1]  aes_init from do_one_initcall+0x44/0x25c
[    0.748803][    T1]  r9:c1dd3d5c r8:c1689880 r7:00000000 r6:c2570000 r5:00000019 r4:c1d0c618
[    0.749008][    T1]  do_one_initcall from kernel_init_freeable+0x23c/0x298
[    0.749187][    T1]  r8:c1689880 r7:00000007 r6:c1dd3d38 r5:00000019 r4:c25f0640
[    0.749364][    T1]  kernel_init_freeable from kernel_init+0x28/0x14c
[    0.749540][    T1]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0fae978
[    0.749744][    T1]  r4:c1f0b040
[    0.749832][    T1]  kernel_init from ret_from_fork+0x14/0x30
[    0.750033][    T1] Exception stack(0xe080dfb0 to 0xe080dff8)
[    0.750315][    T1] dfa0:                                     00000000 00000000 00000000 00000000
[    0.750546][    T1] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    0.750760][    T1] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.750967][    T1]  r5:c0fae978 r4:00000000
[    0.751214][    T1] ---[ end trace 0000000000000000 ]---
[    0.751519][    T1] ------------[ cut here ]------------
[    0.751650][    T1] WARNING: CPU: 0 PID: 1 at crypto/algapi.c:506 crypto_unregister_alg+0x124/0x12c
[    0.751873][    T1] Modules linked in:
[    0.752037][    T1] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.6.0-rc1-default+ #1 906712a81ca49f79575cf3062af84575f391802d
[    0.752331][    T1] Hardware name: Generic DT based system
[    0.752464][    T1] Backtrace:
[    0.752551][    T1]  dump_backtrace from show_stack+0x20/0x24
[    0.752702][    T1]  r7:c077851c r6:00000009 r5:00000053 r4:c1595a60
[    0.752853][    T1]  show_stack from dump_stack_lvl+0x48/0x54
[    0.753001][    T1]  dump_stack_lvl from dump_stack+0x18/0x1c
[    0.753151][    T1]  r5:000001fa r4:c1589f2c
[    0.753258][    T1]  dump_stack from __warn+0x88/0x120
[    0.753417][    T1]  __warn from warn_slowpath_fmt+0xb8/0x188
[    0.753572][    T1]  r8:0000012a r7:c077851c r6:c1589f2c r5:00000000 r4:c1e825f0
[    0.753750][    T1]  warn_slowpath_fmt from crypto_unregister_alg+0x124/0x12c
[    0.753938][    T1]  r7:c214e414 r6:00000001 r5:00000002 r4:c1f12bc0
[    0.754096][    T1]  crypto_unregister_alg from crypto_unregister_skciphers+0x30/0x40
[    0.754291][    T1]  r4:c1f12bc0
[    0.754378][    T1]  crypto_unregister_skciphers from aes_exit+0x48/0x4c
[    0.754556][    T1]  r5:c214e428 r4:c214e428
[    0.754666][    T1]  aes_exit from aes_init+0x88/0xa8
[    0.754804][    T1]  r5:fffffffe r4:c1f12740
[    0.754913][    T1]  aes_init from do_one_initcall+0x44/0x25c
[    0.755070][    T1]  r9:c1dd3d5c r8:c1689880 r7:00000000 r6:c2570000 r5:00000019 r4:c1d0c618
[    0.755274][    T1]  do_one_initcall from kernel_init_freeable+0x23c/0x298
[    0.755462][    T1]  r8:c1689880 r7:00000007 r6:c1dd3d38 r5:00000019 r4:c25f0640
[    0.755636][    T1]  kernel_init_freeable from kernel_init+0x28/0x14c
[    0.755807][    T1]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0fae978
[    0.756007][    T1]  r4:c1f0b040
[    0.756095][    T1]  kernel_init from ret_from_fork+0x14/0x30
[    0.756243][    T1] Exception stack(0xe080dfb0 to 0xe080dff8)
[    0.756390][    T1] dfa0:                                     00000000 00000000 00000000 00000000
[    0.756610][    T1] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    0.756828][    T1] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.757001][    T1]  r5:c0fae978 r4:00000000
[    0.757178][    T1] ---[ end trace 0000000000000000 ]---
...
[    0.982740][    T1] trusted_key: encrypted_key: failed to alloc_cipher (-2)
...
[    0.993923][   T80] alg: No test for  ()
[    0.994049][   T80] alg: Unexpected test result for : 0

If there is any additional information I can provide or patches I can
test, I am more than happy to do so.

[1]: https://github.com/openSUSE/kernel-source/raw/master/config/armv7hl/default
[2]: https://mirrors.edge.kernel.org/pub/tools/crosstool/
[3]: https://github.com/ClangBuiltLinux/boot-utils/releases

Cheers,
Nathan

# bad: [df964ce9ef9fea10cf131bf6bad8658fde7956f6] Add linux-next specific files for 20230929
# good: [9ed22ae6be817d7a3f5c15ca22cbc9d3963b481d] Merge tag 'spi-fix-v6.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect start 'df964ce9ef9fea10cf131bf6bad8658fde7956f6' '9ed22ae6be817d7a3f5c15ca22cbc9d3963b481d'
# good: [2afef4020a647c2034c72a5ab765ad06338024c1] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
git bisect good 2afef4020a647c2034c72a5ab765ad06338024c1
# bad: [621abed2c5eb145b5c8f25aa08f4eaac3a4880df] Merge branch 'drm-next' of https://gitlab.freedesktop.org/agd5f/linux
git bisect bad 621abed2c5eb145b5c8f25aa08f4eaac3a4880df
# good: [fcdecb00fb04c2db761851b194547d291ba532c5] Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect good fcdecb00fb04c2db761851b194547d291ba532c5
# bad: [62edfd0bd4ac7b7c6b5eff0ea290261ff5ab6d1c] Merge branch 'drm-next' of git://git.freedesktop.org/git/drm/drm.git
git bisect bad 62edfd0bd4ac7b7c6b5eff0ea290261ff5ab6d1c
# good: [9896f0608f9fe0b49badd2fd6ae76ec761c70624] Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
git bisect good 9896f0608f9fe0b49badd2fd6ae76ec761c70624
# good: [d856c84b8cbc2f5bc6e906deebf3fa912bb6c1c3] Merge branch 'spi-nor/next' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
git bisect good d856c84b8cbc2f5bc6e906deebf3fa912bb6c1c3
# good: [39e0b96d61b6f5ad880d9953dc2b4c5b3ee145b3] drm/bridge/analogix/anx78xx: Drop ID table
git bisect good 39e0b96d61b6f5ad880d9953dc2b4c5b3ee145b3
# good: [3102bbcdcd3c945ef0bcea498d3a0c6384536d6c] crypto: qat - refactor deprecated strncpy
git bisect good 3102bbcdcd3c945ef0bcea498d3a0c6384536d6c
# bad: [bb4277c7e617e8b271eb7ad75d5bdb6b8a249613] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git bisect bad bb4277c7e617e8b271eb7ad75d5bdb6b8a249613
# bad: [aa3f80500382ca864b7cfcff4e5ca2fa6a0e977d] crypto: hisilicon/zip - support deflate algorithm
git bisect bad aa3f80500382ca864b7cfcff4e5ca2fa6a0e977d
# good: [b64d143b752932ef483d0ed8d00958f1832dd6bc] crypto: hash - Hide CRYPTO_ALG_TYPE_AHASH_MASK
git bisect good b64d143b752932ef483d0ed8d00958f1832dd6bc
# good: [3dfe8786b11a4a3f9ced2eb89c6c5d73eba84700] crypto: testmgr - Add support for lskcipher algorithms
git bisect good 3dfe8786b11a4a3f9ced2eb89c6c5d73eba84700
# bad: [705b52fef3c73655701d9c8868e744f1fa03e942] crypto: cbc - Convert from skcipher to lskcipher
git bisect bad 705b52fef3c73655701d9c8868e744f1fa03e942
# good: [32a8dc4afcfb098ef4e8b465c90db17d22d90107] crypto: ecb - Convert from skcipher to lskcipher
git bisect good 32a8dc4afcfb098ef4e8b465c90db17d22d90107
# first bad commit: [705b52fef3c73655701d9c8868e744f1fa03e942] crypto: cbc - Convert from skcipher to lskcipher
