Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE936C05027
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 08:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjBNIoR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 03:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNIoQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 03:44:16 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25412EB5E
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 00:44:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRqv1-00AxwH-Jt; Tue, 14 Feb 2023 16:44:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Feb 2023 16:44:07 +0800
Date:   Tue, 14 Feb 2023 16:44:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-crypto@vger.kernel.org, peter@n8pjl.ca, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: Re: [PATCH 0/3] crypto: x86/twofish-3way - Cleanup and optimize asm
Message-ID: <Y+tJ1yRLXlfr/0dc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <cover.1675653010.git.peter@n8pjl.ca>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Peter Lafreniere <peter@n8pjl.ca> wrote:
> 1/3 removes the unused xor argument to encode functions. This argument
> is deadweight and its removal shaves off a both a few cycles per call as
> well as a small amount of lines.
> 
> 2/3 moves handling for cbc mode decryption to assembly in order to
> remove overhead, yielding a ~6% speedup on AMD Zen1.
> 
> 3/3 makes a minor readability change that doesn't fit well into 2/3.
> 
> Peter Lafreniere (3):
>  crypto: x86/twofish-3way - Remove unused encode parameter
>  crypto: x86/twofish-3way - Perform cbc xor in assembly
>  crypto: x86/twofish-3way - Remove unused macro argument
> 
> arch/x86/crypto/twofish-x86_64-asm_64-3way.S | 71 ++++++++++++--------
> arch/x86/crypto/twofish.h                    | 19 ++++--
> arch/x86/crypto/twofish_avx_glue.c           |  5 --
> arch/x86/crypto/twofish_glue_3way.c          | 22 +-----
> 4 files changed, 59 insertions(+), 58 deletions(-)

This fails the self-test on my machine:

[   91.709458] alg: skcipher: ecb-twofish-3way decryption test failed (wrong result) on test vector 3, cfg="in-place (one sglist)"
[   91.710358] alg: self-tests for ecb(twofish) using ecb-twofish-3way failed (rc=-22)
[   91.710370] ------------[ cut here ]------------
[   91.711228] alg: self-tests for ecb(twofish) using ecb-twofish-3way failed (rc=-22)
[   91.711288] WARNING: CPU: 1 PID: 3245 at crypto/testmgr.c:5858 alg_test.part.0.cold+0xea/0x128 [cryptomgr]
[   91.712672] Modules linked in: twofish_x86_64_3way(+) sm3_generic rmd160 ip_vti ip_tunnel af_key ah6 ah4 esp6 esp4 xfrm4_tunnel tunnel4 ipcomp ipcomp6 xfrm6_tunnel xfrm_ipcomp tunnel6 cfb sm4_generic sm4_aesni_avx_x86_64 sm4 sm3 poly1305_generic poly1305_x86_64 nhpoly1305_sse2 nhpoly1305 libpoly1305 des3_ede_x86_64 curve25519_x86_64 libcurve25519_generic chacha_generic chacha_x86_64 libchacha aria_aesni_avx_x86_64 aria_generic aegis128 aegis128_aesni chacha20poly1305 cmac camellia_aesni_avx_x86_64 camellia_generic camellia_x86_64 lzo lzo_compress lzo_decompress cast6_avx_x86_64 cast6_generic cast5_avx_x86_64 cast5_generic cast_common deflate ccm serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic blowfish_generic blowfish_x86_64 blowfish_common twofish_generic twofish_x86_64 twofish_common xcbc md5 des_generic libdes xt_CHECKSUM nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack xfrm_user xfrm_algo nf_defrag_ipv6 nf_defrag_ipv4 xt_tcpudp nft_compat bridge stp llc nf_tables libcrc32c
[   91.712714]  nfnetlink af_packet intel_rapl_msr intel_rapl_common iosf_mbi kvm_intel kvm irqbypass crc32_generic crc32_pclmul polyval_clmulni polyval_generic ghash_clmulni_intel sha512_ssse3 sha512_generic xctr ghash_generic gf128mul gcm crypto_null xts sd_mod t10_pi ctr crc64_rocksoft_generic crc64_rocksoft crc_t10dif cts crct10dif_generic crct10dif_pclmul crc64 cbc sr_mod crct10dif_common cdrom sg joydev mousedev ppdev aes_generic ecb aesni_intel snd_pcm bochs drm_vram_helper drm_ttm_helper snd_timer virtio_net libaes ttm snd libcryptoutils drm_kms_helper evdev input_leds ata_generic pata_acpi crypto_simd cryptd rapl net_failover failover psmouse drm soundcore led_class ata_piix drm_panel_orientation_quirks cfbfillrect cfbimgblt cfbcopyarea syscopyarea sysfillrect sysimgblt libata pcspkr serio_raw fb fbdev backlight floppy intel_agp rtc_cmos i2c_piix4 intel_gtt scsi_mod parport_pc agpgart i2c_core scsi_common parport tiny_power_button button qemu_fw_cfg ip_tables x_tables sha256_ssse3
[   91.719801]  sha256_generic libsha256 sha1_ssse3 sha1_generic hmac ipv6 autofs4 ext4 crc16 mbcache jbd2 dm_snapshot dm_bufio dm_mod virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio_blk virtio_ring virtio unix crc32c_generic crc32c_intel cryptomgr kpp crypto_acompress akcipher rng aead crypto_hash skcipher crypto_algapi crypto [last unloaded: twofish_x86_64_3way]
[   91.729585] CPU: 1 PID: 3245 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #4
[   91.730089] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   91.730727] RIP: 0010:alg_test.part.0.cold+0xea/0x128 [cryptomgr]
[   91.731154] Code: dd ea 46 e1 44 8b 85 54 ff ff ff 41 83 f8 fe 0f 84 61 9f ff ff 44 89 c1 4c 89 ea 4c 89 fe 48 c7 c7 30 82 2a a0 e8 b6 cd 46 e1 <0f> 0b 44 8b 85 54 ff ff ff e9 3e 9f ff ff 0f 0b 48 c7 c7 08 81 2a
[   91.732625] RSP: 0018:ffffc900001e3e18 EFLAGS: 00010296
[   91.732989] RAX: 0000000000000047 RBX: 0000000000000079 RCX: ffff88801ed1c4c8
[   91.733494] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff88801ed1c4c0
[   91.733996] RBP: ffffc900001e3ed8 R08: ffffffff81ea3dc8 R09: 0000000000000003
[   91.734516] R10: 00000000000001d3 R11: ffffffff81e8e9a8 R12: 000000000000007b
[   91.735028] R13: ffff888003334200 R14: 000000000000007b R15: ffff888003334280
[   91.735532] FS:  0000000000000000(0000) GS:ffff88801ed00000(0000) knlGS:0000000000000000
[   91.736113] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.736536] CR2: 00007f253884c060 CR3: 000000000393f003 CR4: 0000000000060ee0
[   91.737068] Call Trace:
[   91.737191]  <TASK>
[   91.737288]  ? __schedule+0x274/0xf90
[   91.737529]  ? _raw_spin_unlock_irqrestore+0xd/0x40
[   91.737860]  ? try_to_wake_up+0x18f/0x2d0
[   91.738126]  ? __pfx_cryptomgr_test+0x10/0x10 [cryptomgr]
[   91.738510]  alg_test+0x18/0x50 [cryptomgr]
[   91.739551]  cryptomgr_test+0x24/0x50 [cryptomgr]
[   91.740362]  kthread+0xe9/0x110
[   91.741011]  ? __pfx_kthread+0x10/0x10
[   91.741650]  ret_from_fork+0x2c/0x50
[   91.742272]  </TASK>
[   91.742799] ---[ end trace 0000000000000000 ]---

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
