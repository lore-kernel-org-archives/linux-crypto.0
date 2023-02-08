Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2006C636CC
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 05:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBHFVQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 00:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHFVO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 00:21:14 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66DD2B60C
        for <linux-crypto@vger.kernel.org>; Tue,  7 Feb 2023 21:21:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPctA-008kZI-PQ; Wed, 08 Feb 2023 13:21:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Feb 2023 13:21:00 +0800
Date:   Wed, 8 Feb 2023 13:21:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jussi.kivilinna@iki.fi, elliott@hpe.com, peterz@infradead.org
Subject: Re: [PATCH v4 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI
 assembler implementation of aria cipher
Message-ID: <Y+MxPDj3dqYBx484@gondor.apana.org.au>
References: <20220916125736.23598-1-ap420073@gmail.com>
 <20220916125736.23598-3-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220916125736.23598-3-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 16, 2022 at 12:57:35PM +0000, Taehee Yoo wrote:
>
> +#define aria_ark_8way(x0, x1, x2, x3,			\
> +		      x4, x5, x6, x7,			\
> +		      t0, rk, idx, round)		\
> +	/* AddRoundKey */                               \
> +	vpbroadcastb ((round * 16) + idx + 3)(rk), t0;	\

This triggers an invalid OP code on CPUs that supports AVX but not
AVX2:

[   10.857327] invalid opcode: 0000 [#1] PREEMPT SMP
[   10.857935] CPU: 1 PID: 2816 Comm: cryptomgr_test Tainted: G        W          6.2.0-rc1+ #1
[   10.858783] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   10.859622] RIP: 0010:__aria_aesni_avx_crypt_16way+0x22d/0x6000 [aria_aesni_avx_x86_64]
[   10.860440] Code: c4 41 7a 7f 48 10 c4 41 7a 7f 50 20 c4 41 7a 7f 58 30 c4 41 7a 7f 60 40 c4 41 7a 7f 68 50 c4 41 7a 7f 70 60 c4 41 7a 7f 78 70 <c4> c2 79 78 41 0b c5 39 ef c0 c4 c2 79 78 41 0a c5 31 ef c8 c4 c2
[   10.862409] RSP: 0018:ffffc900002eb728 EFLAGS: 00010206
[   10.863011] RAX: ffff88800666b00f RBX: ffff88800666b00f RCX: ffffffffa0c02010
[   10.863754] RDX: ffff88800666b00f RSI: ffff88800666b00f RDI: ffff88800408a420
[   10.864500] RBP: ffffc900002eb728 R08: ffff88800666b08f R09: ffff88800408a420
[   10.865270] R10: ffff8880064de040 R11: 00000000fffffff0 R12: ffff88800408a420
[   10.866019] R13: 000000000000011b R14: ffff88800666b00f R15: ffff88800666b00f
[   10.866764] FS:  0000000000000000(0000) GS:ffff88801ed00000(0000) knlGS:0000000000000000
[   10.867587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.868230] CR2: 00007f8c80f160a4 CR3: 0000000001e0a002 CR4: 0000000000060ee0
[   10.868986] Call Trace:
[   10.869392]  <TASK>
[   10.869744]  aria_aesni_avx_encrypt_16way+0x77/0xf0 [aria_aesni_avx_x86_64]
[   10.870489]  ecb_do_encrypt.constprop.0+0x100/0x140 [aria_aesni_avx_x86_64]
[   10.871233]  aria_avx_ecb_encrypt+0xd/0x20 [aria_aesni_avx_x86_64]
[   10.871912]  crypto_skcipher_encrypt+0x3a/0x70 [skcipher]
[   10.872527]  simd_skcipher_encrypt+0x8f/0xd0 [crypto_simd]
[   10.873165]  crypto_skcipher_encrypt+0x3a/0x70 [skcipher]
[   10.873789]  test_skcipher_vec_cfg+0x286/0x6a0 [cryptomgr]
[   10.874432]  ? number+0x305/0x350
[   10.874900]  ? skcipher_walk_next+0x524/0x570 [skcipher]
[   10.875508]  ? string+0x5c/0xe0
[   10.875942]  ? vsnprintf+0x256/0x4e0
[   10.876412]  ? vsnprintf+0x385/0x4e0
[   10.876878]  ? scnprintf+0x46/0x70
[   10.877359]  ? valid_sg_divisions.constprop.0+0x8a/0xa0 [cryptomgr]
[   10.878058]  ? valid_testvec_config+0xb7/0xd0 [cryptomgr]
[   10.878699]  ? generate_random_testvec_config.constprop.0+0x166/0x370 [cryptomgr]
[   10.879496]  test_skcipher_vs_generic_impl+0x401/0x610 [cryptomgr]
[   10.880194]  alg_test_skcipher+0x19d/0x1b0 [cryptomgr]
[   10.880805]  alg_test.part.0+0x335/0x3b0 [cryptomgr]
[   10.881425]  ? __schedule+0x274/0xf90
[   10.881916]  ? ttwu_queue_wakelist+0xf4/0x100
[   10.882464]  ? _raw_spin_unlock_irqrestore+0xd/0x40
[   10.883041]  ? try_to_wake_up+0x1f6/0x2d0
[   10.883537]  ? __pfx_cryptomgr_test+0x10/0x10 [cryptomgr]
[   10.884145]  alg_test+0x18/0x50 [cryptomgr]
[   10.884662]  cryptomgr_test+0x24/0x50 [cryptomgr]
[   10.885240]  kthread+0xe9/0x110
[   10.885672]  ? __pfx_kthread+0x10/0x10
[   10.886144]  ret_from_fork+0x2c/0x50
[   10.886599]  </TASK>
[   10.886939] Modules linked in: aria_aesni_avx_x86_64(+) aria_generic aegis128 aegis128_aesni chacha20poly1305 cmac camellia_aesni_avx_x86_64 camellia_generic camellia_x86_64 lzo lzo_compress lzo_decompress cast6_avx_x86_64 cast6_generic cast5_avx_x86_64 cast5_generic cast_common deflate ccm serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic blowfish_generic blowfish_x86_64 blowfish_common twofish_avx_x86_64 twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common xcbc md5 des_generic libdes xt_CHECKSUM nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_tcpudp nft_compat bridge stp llc nf_tables libcrc32c nfnetlink intel_rapl_msr intel_rapl_common iosf_mbi kvm_intel kvm irqbypass crc32_generic crc32_pclmul polyval_clmulni polyval_generic ghash_clmulni_intel af_packet sha512_ssse3 sha512_generic xctr ghash_generic gf128mul gcm crypto_null xts ctr sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc_t10dif cts
[   10.886989]  crct10dif_generic sr_mod cdrom crct10dif_pclmul crc64 cbc crct10dif_common joydev sg mousedev ppdev bochs drm_vram_helper drm_ttm_helper aes_generic ttm drm_kms_helper ecb drm drm_panel_orientation_quirks snd_pcm cfbfillrect cfbimgblt cfbcopyarea syscopyarea snd_timer sysfillrect aesni_intel sysimgblt snd fb soundcore psmouse ata_generic virtio_net libaes evdev libcryptoutils crypto_simd pata_acpi input_leds fbdev cryptd rapl led_class net_failover failover backlight pcspkr serio_raw ata_piix floppy libata intel_agp i2c_piix4 intel_gtt scsi_mod agpgart rtc_cmos parport_pc i2c_core parport scsi_common tiny_power_button button qemu_fw_cfg ip_tables x_tables sha256_ssse3 sha256_generic libsha256 sha1_ssse3 sha1_generic hmac ipv6 autofs4 ext4 crc16 mbcache jbd2 dm_snapshot dm_bufio dm_mod virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio_blk virtio_ring virtio unix crc32c_generic crc32c_intel cryptomgr kpp crypto_acompress akcipher rng aead crypto_hash skcipher
[   10.895975]  crypto_algapi crypto
[   10.905842] ---[ end trace 0000000000000000 ]---

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
