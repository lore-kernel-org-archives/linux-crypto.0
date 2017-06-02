From: David Gstir <david@sigma-star.at>
Subject: [RFC PATCH 0/2] crypto: caam - fix cts(cbc(aes)) with CAAM driver
Date: Fri,  2 Jun 2017 14:24:44 +0200
Message-ID: <20170602122446.2427-1-david@sigma-star.at>
Cc: richard@sigma-star.at, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gstir <david@sigma-star.at>
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdFBMZD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 08:25:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

While testing fscrypt's filename encryption, I noticed that the implementation
of cts(cbc(aes)) is broken when the CAAM hardware crypto driver is enabled.
Some digging showed that the refactoring of crypto/cts.c in v4.8 
(commit 0605c41cc53ca) exposed some problems with CAAM's aes-cbc
implementation. This can be tested quite easily by loading the tcrypt
module with mode=38. Looks like the cts mode is not used very often
and this went unnoticed since 4.8...

This patch series is an attempt to fix that and get cts(cbc(aes)) working
properly again when the CAAM driver is enabled.

Specifically, the issues are:

1) The cts implementation assumes ->info of ablkcipher_request (or ->iv of
   skcipher_request respectively) to be set to the last ciphertext block when
   the aes-cbc encryption is finished. Meaning that ->info is changed by the
   aes-cbc code. The CAAM driver does not do that and leaves ->info as-is.

   It is not fully clear to me yet if this is a requirement of the crypto API,
   or if this is just a side effect that is exploited by the cts implementation?

   For now, I assumed it is a requirement of the crypto API since I've seen
   other crypto drivers (e.g. AMD's CCP) do that. So the patch fixes the CAAM
   crypto driver accordingly.

   Also, the aead code in the CAAM driver, more specifically the gcm mode code
   seems to have the same flaw, so it'll need a similar fix in case.


2) The cts implementation uses aes-cbc twice to perform its job. The second
   time, it is called from within the callback of the first call to aes-cbc.
   This usage is not properly handled in the CAAM driver which triggers the
   BUG below.

   My current proposal is to use in_interrupt() to detect such cases and set
   the k*alloc flags accordingly. However, since using in_interrupt() is not
   really nice, I'm wondering if there is a better way to handle this?


Thanks,
David

<snip>
[  126.252543] BUG: sleeping function called from invalid context at mm/slab.h:432
[  126.260099] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
[  126.266837] no locks held by swapper/0/0.
[  126.270969] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.12.0-rc3-00052-g0ddec680d395 #287
[  126.279226] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  126.285821] Backtrace:
[  126.288406] [<c010c3e4>] (dump_backtrace) from [<c010c690>] (show_stack+0x18/0x1c)
[  126.296057]  r7:00000000 r6:60000113 r5:00000000 r4:c102ab48
[  126.301798] [<c010c678>] (show_stack) from [<c0427060>] (dump_stack+0xb4/0xe8)
[  126.309106] [<c0426fac>] (dump_stack) from [<c014f020>] (___might_sleep+0x17c/0x2a0)
[  126.316929]  r9:00000000 r8:c0a016dc r7:c101ee3e r6:000001b0 r5:c0c12fac r4:ffffe000
[  126.324751] [<c014eea4>] (___might_sleep) from [<c014f1a8>] (__might_sleep+0x64/0xa4)
[  126.332655]  r7:014080c1 r6:00000000 r5:000001b0 r4:c0c12fac
[  126.338397] [<c014f144>] (__might_sleep) from [<c0224a20>] (__kmalloc+0x130/0x1b8)
[  126.346039]  r6:c071a8ec r5:014080c1 r4:eec01e00
[  126.350742] [<c02248f0>] (__kmalloc) from [<c071a8ec>] (ablkcipher_edesc_alloc.constprop.1+0x200/0x900)
[  126.360213]  r10:00000000 r9:00000000 r8:c0a016dc r7:c0a016dc r6:ee05ac10 r5:edfdaec0
[  126.368109]  r4:00000001 r3:00000020
[  126.371765] [<c071a6ec>] (ablkcipher_edesc_alloc.constprop.1) from [<c071b010>] (ablkcipher_encrypt+0x24/0x9c)
[  126.381843]  r10:00000000 r9:00000020 r8:00000001 r7:ee05ac10 r6:ed597000 r5:edfdaec0
[  126.389738]  r4:ed475d08
[  126.392354] [<c071afec>] (ablkcipher_encrypt) from [<c03d6f20>] (skcipher_encrypt_ablkcipher+0x68/0x6c)
[  126.401822]  r7:ed475d08 r6:ed597000 r5:00000400 r4:ed475d08
[  126.407566] [<c03d6eb8>] (skcipher_encrypt_ablkcipher) from [<c03e8a70>] (cts_cbc_encrypt+0x118/0x124)
[  126.416947]  r7:ed475d08 r6:c1001cc0 r5:00000010 r4:edfdae00
[  126.422686] [<c03e8958>] (cts_cbc_encrypt) from [<c03e8b88>] (crypto_cts_encrypt_done+0x20/0x54)
[  126.431548]  r10:00000000 r9:ee05ac10 r8:00000000 r7:00000010 r6:edc8e6c0 r5:edc8e6d8
[  126.439443]  r4:edfdae00
[  126.442056] [<c03e8b68>] (crypto_cts_encrypt_done) from [<c07195a0>] (ablkcipher_encrypt_done+0x88/0x9c)
[  126.445180] fec 2188000.ethernet eth0: MDIO read timeout
[  126.456948]  r5:edc8e6d8 r4:edfdaec0
[  126.460604] [<c0719518>] (ablkcipher_encrypt_done) from [<c0715ca0>] (caam_jr_dequeue+0x214/0x2d4)
[  126.469639]  r9:00000001 r8:ee088010 r7:000001ff r6:00000001 r5:00000000 r4:edfdaec0
[  126.477467] [<c0715a8c>] (caam_jr_dequeue) from [<c012b3f0>] (tasklet_action+0x98/0x154)
[  126.485160] fec 2188000.ethernet eth0: MDIO read timeout
[  126.490975]  r10:c1080b80 r9:c1008b84 r8:00000000 r7:c1000000 r6:00000000 r5:ee088028
[  126.498870]  r4:ee088024
[  126.501484] [<c012b358>] (tasklet_action) from [<c012b60c>] (__do_softirq+0xf0/0x2a4)
[  126.509390]  r10:40000006 r9:c1002080 r8:00000101 r7:c1002098 r6:c1000000 r5:00000006
[  126.517285]  r4:00000000
[  126.519896] [<c012b51c>] (__do_softirq) from [<c012bb90>] (irq_exit+0xec/0x168)
[  126.525127] fec 2188000.ethernet eth0: MDIO write timeout
[  126.532709]  r10:c1008cf0 r9:eec08400 r8:00000001 r7:00000000 r6:c1008b84 r5:00000000
[  126.540603]  r4:c0fd940c
[  126.543222] [<c012baa4>] (irq_exit) from [<c017ff24>] (__handle_domain_irq+0x74/0xe8)
[  126.551135] [<c017feb0>] (__handle_domain_irq) from [<c01015fc>] (gic_handle_irq+0x58/0xbc)
[  126.559564]  r9:f4000100 r8:c102af80 r7:c1001ea8 r6:000003ff r5:000003eb r4:f400010c
[  126.567384] [<c01015a4>] (gic_handle_irq) from [<c010d2f0>] (__irq_svc+0x70/0x98)
[  126.574937] Exception stack(0xc1001ea8 to 0xc1001ef0)
[  126.580065] 1ea0:                   00000001 2e39a000 00000000 c100c080 00000000 ef374698
[  126.588320] 1ec0: 653b20b1 0000001d 653afed6 0000001d 00000000 c1001f24 c1001ec8 c1001ef8
[  126.596568] 1ee0: c016fcf4 c06f1fbc 20000013 ffffffff
[  126.601696]  r10:00000000 r9:c1000000 r8:653afed6 r7:c1001edc r6:ffffffff r5:20000013
[  126.609591]  r4:c06f1fbc
[  126.612210] [<c06f1e34>] (cpuidle_enter_state) from [<c06f2120>] (cpuidle_enter+0x1c/0x20)
[  126.620551]  r10:c100f8c0 r9:ef374698 r8:c1008b84 r7:c0fda690 r6:c10089ec r5:c1008a38
[  126.628448]  r4:c1000000 r3:ef374698
[  126.632114] [<c06f2104>] (cpuidle_enter) from [<c0167330>] (call_cpuidle+0x28/0x44)
[  126.639859] [<c0167308>] (call_cpuidle) from [<c0167608>] (do_idle+0x1ac/0x220)
[  126.647249] [<c016745c>] (do_idle) from [<c0167a20>] (cpu_startup_entry+0x20/0x24)
[  126.654895]  r10:c0e60a50 r9:efffc940 r8:c1080000 r7:c10089c0 r6:c1080000 r5:00000002
[  126.662793]  r4:000000bd r3:c0e733c4
[  126.666457] [<c0167a00>] (cpu_startup_entry) from [<c09cfbd4>] (rest_init+0x154/0x198)
[  126.674463] [<c09cfa80>] (rest_init) from [<c0e00cf0>] (start_kernel+0x344/0x3b8)
[  126.682015]  r5:ffffffff r4:c108004c
[  126.685668] [<c0e009ac>] (start_kernel) from [<1000807c>] (0x1000807c)
</snip>

  crypto: caam - properly set IV after {en,de}crypt
  crypto: caam - fix k*alloc if called from own cipher callback

 drivers/crypto/caam/caamalg.c | 55 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 10 deletions(-)

-- 
2.12.0
