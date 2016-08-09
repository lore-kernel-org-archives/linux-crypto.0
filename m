From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: FIPS mode: modprobe: ERROR: could not insert 'drbg'
Date: Tue, 9 Aug 2016 16:34:59 +0000
Message-ID: <D3CF7065.28F3%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-elk-01.trustwave.com ([204.13.202.188]:14518 "EHLO
	seg-node-elk-01.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694AbcHIQfE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 12:35:04 -0400
Content-Language: en-US
Content-ID: <C81D20106A24464E8492F6371310C1DD@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Following up from the other thread:

While trying to boot in FIPS mode, kernel panics with the following
message. So far, I don¹t have success to get more information about which
module or symbol is causing this. I haven¹t found any errors or warnings
in kernel compilation. It boots fine in a non-fips mode.

I am also pasting the CRYPTO related configs that I have enabled (See
below).

-Tapas

/boot/vmlinuz-4.7.0-1.tos2_5: OK
modprobe: ERROR: could not insert 'drbg': Unknown symbol in module, or
unknown parameter (see dmesg)
[    1.330798] dracut: FATAL: FIPS integrity test failed
[    1.331534] dracut: Refusing to continue


[    1.333491] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000100
[    1.333491]
[    1.334768] CPU: 0 PID: 1 Comm: init Not tainted 4.7.0-1.tos2_5 #1
[    1.335632] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.8.2-20150714_191134- 04/01/2014
[    1.336114]  0000000000000000 ffff88003e1dfbc8 ffffffff812ae299
0000000000000001
[    1.336114]  0000000000000001 ffffffff81716b00 ffff88003e210000
ffff88003e1dfc48
[    1.336114]  ffffffff81104fd4 0000000000000010 ffff88003e1dfc58
ffff88003e1dfbf8
[    1.336114] Call Trace:
[    1.336114]  [<ffffffff812ae299>] dump_stack+0x51/0x78
[    1.336114]  [<ffffffff81104fd4>] panic+0xc1/0x211
[    1.336114]  [<ffffffff81058781>] forget_original_parent+0x411/0x420
[    1.336114]  [<ffffffff810f4a12>] ? perf_pin_task_context+0x12/0x40
[    1.336114]  [<ffffffff810fcd52>] ? perf_event_exit_task+0x3b2/0x470
[    1.336114]  [<ffffffff81058cb6>] exit_notify+0x36/0x1e0
[    1.336114]  [<ffffffff810d4b61>] ? cgroup_exit+0x71/0xc0
[    1.336114]  [<ffffffff81070fdf>] ? task_work_run+0x5f/0x90
[    1.336114]  [<ffffffff8105a4ff>] do_exit+0x31f/0x640
[    1.336114]  [<ffffffff811726d9>] ? ____fput+0x9/0x10
[    1.336114]  [<ffffffff81070fdf>] ? task_work_run+0x5f/0x90
[    1.336114]  [<ffffffff81046d0e>] ? __do_page_fault+0x17e/0x450
[    1.336114]  [<ffffffff8105a869>] do_group_exit+0x49/0xb0
[    1.336114]  [<ffffffff8105a8e2>] SyS_exit_group+0x12/0x20
[    1.336114]  [<ffffffff8154dd9b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[    1.336114] Kernel Offset: disabled
[    1.336114] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x00000100
[    1.336114]



# Enabled CRYPTO configs
[root@localhost ~]# egrep 'CRYPTO.*=y|CRYPTO.*=m'
/boot/config-4.7.0-1.tos2_5
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=m
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_MCRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA1_MB=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=m
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG=m
CONFIG_CRYPTO_JITTERENTROPY=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m




________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
