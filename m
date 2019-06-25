Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C615C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 07:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42CF920665
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 07:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfFYHQk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 03:16:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:55120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfFYHQj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 03:16:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3A3CAD43;
        Tue, 25 Jun 2019 07:16:36 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-crypto@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>, chetjain@in.ibm.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: algapi - guard against uninitialized spawn list in crypto_remove_spawns
Date:   Tue, 25 Jun 2019 09:16:24 +0200
Message-Id: <20190625071624.27039-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reportedly on Linux 4.12 the LTP testsuite crashes at pcrypt_aead01 infrequently.

To get it reproduce more frequently I tried

n=0 ; while true ; do /opt/ltp/testcases/bin/pcrypt_aead01 >& /dev/null ; n=$(expr $n + 1) ; echo -ne $n\\r ; done

but this is quite stable. However, holding ^C in the terminal where the loop is running tends to trigger the crash.

The backtrace is:

[  100.615804] Unable to handle kernel paging request for data at address 0x00000000
[  100.615876] Faulting instruction address: 0xc000000000520e7c
[  100.615943] Oops: Kernel access of bad area, sig: 11 [#1]
[  100.616001] SMP NR_CPUS=2048 
[  100.616002] NUMA 
[  100.616030] pSeries
[  100.616054] Modules linked in: authenc pcrypt crypto_user kvm_pr kvm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter devlink ip_tables x_tables af_packet rtc_generic vmx_crypto ibmveth(X) gf128mul btrfs xor raid6_pq sd_mod ibmvscsi(X) scsi_transport_srp crc32c_vpmsum sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod autofs4
[  100.616478] Supported: Yes, External
[  100.616509] CPU: 5 PID: 6270 Comm: pcrypt_aead01 Tainted: G                   4.12.14-150.22-default #1 SLE15
[  100.616632] task: c000000595084d80 task.stack: c0000005be6dc000
[  100.616708] NIP: c000000000520e7c LR: c000000000521e3c CTR: c000000000521de0
[  100.616801] REGS: c0000005be6df620 TRAP: 0300   Tainted: G                    (4.12.14-150.22-default)
[  100.616906] MSR: 8000000000009033 <SF,EE,ME,IR,DR,RI,LE>
[  100.616912]   CR: 24002844  XER: 20040000
[  100.617003] CFAR: c000000000008860 DAR: 0000000000000000 DSISR: 40000000 SOFTE: 1 
               GPR00: c0000005a331f810 c0000005be6df8a0 c00000000119aa00 c0000005a331f800 
               GPR04: c0000005be6df930 c0000005be6df8c0 c0000005be6df8d0 0000000000000000 
               GPR08: 7269632929290000 c0000005a331f800 0000000000000000 0000000000000000 
               GPR12: c000000000521de0 c000000007a33700 00000001271a0ee0 00007fffcb9e7bb8 
               GPR16: 00000001271c2d80 00000001271c2d88 00007fffcb9e7a50 00007fffcb9e7a44 
               GPR20: 00007fffcb9e7a98 00007fffcb9e7a60 0000000000000010 0000000000000010 
               GPR24: 0000000000000000 0000000000000000 fffffffffffff000 c0000005be6dfaf0 
               GPR28: c0000005b9929d00 0000000000000c93 c0000005be6df930 c0000005be6df8e0 
[  100.617774] NIP [c000000000520e7c] crypto_remove_spawns+0x6c/0x2e0
[  100.617816] LR [c000000000521e3c] crypto_unregister_instance+0x5c/0xa0
[  100.617881] Call Trace:
[  100.617903] [c0000005be6df8a0] [c0000005b9929d00] 0xc0000005b9929d00 (unreliable)
[  100.617971] [c0000005be6df910] [0000000000000000]           (null)
[  100.618021] [c0000005be6df960] [d0000000098d0894] crypto_del_alg+0xdc/0x110 [crypto_user]
[  100.618119] [c0000005be6df990] [d0000000098d0b58] crypto_user_rcv_msg+0xe0/0x260 [crypto_user]
[  100.618222] [c0000005be6dfa30] [c00000000086d678] netlink_rcv_skb+0x78/0x170
[  100.618309] [c0000005be6dfaa0] [d0000000098d0064] crypto_netlink_rcv+0x4c/0x80 [crypto_user]
[  100.618407] [c0000005be6dfad0] [c00000000086cb98] netlink_unicast+0x208/0x2f0
[  100.618488] [c0000005be6dfb40] [c00000000086d170] netlink_sendmsg+0x380/0x440
[  100.618582] [c0000005be6dfbd0] [c0000000007e9ba4] sock_sendmsg+0x64/0x90
[  100.618650] [c0000005be6dfc00] [c0000000007eb94c] ___sys_sendmsg+0x2cc/0x330
[  100.618710] [c0000005be6dfd90] [c0000000007ed02c] __sys_sendmsg+0x5c/0xc0
[  100.618766] [c0000005be6dfe30] [c00000000000b188] system_call+0x3c/0x130
[  100.618822] Instruction dump:
[  100.618839] e9430010 83a90020 38a10020 fbe10040 fbe10048 f8c10030 f8c10038 f8a10020 
[  100.618902] f8a10028 38030010 7fa05040 7d475378 <e90a0000> 419e0064 60000000 60000000 
[  100.618980] ---[ end trace 60475621348ca387 ]---

The code looks like this:

   0xc000000000520e10 <+0>:     c8 00 4c 3c     addis   r2,r12,200
   0xc000000000520e14 <+4>:     f0 9b 42 38     addi    r2,r2,-25616
   0xc000000000520e18 <+8>:     a6 02 08 7c     mflr    r0
   0xc000000000520e1c <+12>:    00 00 00 60     nop
   0xc000000000520e20 <+16>:    79 2b ab 7c     mr.     r11,r5
   0xc000000000520e24 <+20>:    f0 ff c1 fb     std     r30,-16(r1)
   0xc000000000520e28 <+24>:    e8 ff a1 fb     std     r29,-24(r1)
   0xc000000000520e2c <+28>:    f8 ff e1 fb     std     r31,-8(r1)
   0xc000000000520e30 <+32>:    91 ff 21 f8     stdu    r1,-112(r1)
   0xc000000000520e34 <+36>:    78 1b 69 7c     mr      r9,r3
   0xc000000000520e38 <+40>:    78 23 9e 7c     mr      r30,r4
   0xc000000000520e3c <+44>:    08 00 82 41     beq     0xc000000000520e44 <crypto_remove_spawns+52>
   0xc000000000520e40 <+48>:    78 5b 69 7d     mr      r9,r11
   0xc000000000520e44 <+52>:    40 00 e1 3b     addi    r31,r1,64
   0xc000000000520e48 <+56>:    30 00 c1 38     addi    r6,r1,48
 # 0xc000000000520e4c <+60>:    10 00 43 e9     ld      r10,16(r3)
   0xc000000000520e50 <+64>:    20 00 a9 83     lwz     r29,32(r9)
   0xc000000000520e54 <+68>:    20 00 a1 38     addi    r5,r1,32
   0xc000000000520e58 <+72>:    40 00 e1 fb     std     r31,64(r1)
   0xc000000000520e5c <+76>:    48 00 e1 fb     std     r31,72(r1)
   0xc000000000520e60 <+80>:    30 00 c1 f8     std     r6,48(r1)
   0xc000000000520e64 <+84>:    38 00 c1 f8     std     r6,56(r1)
   0xc000000000520e68 <+88>:    20 00 a1 f8     std     r5,32(r1)
   0xc000000000520e6c <+92>:    28 00 a1 f8     std     r5,40(r1)
   0xc000000000520e70 <+96>:    10 00 03 38     addi    r0,r3,16
 & 0xc000000000520e74 <+100>:   40 50 a0 7f     cmpld   cr7,r0,r10
   0xc000000000520e78 <+104>:   78 53 47 7d     mr      r7,r10
 * 0xc000000000520e7c <+108>:   00 00 0a e9     ld      r8,0(r10)
   0xc000000000520e80 <+112>:   64 00 9e 41     beq     cr7,0xc000000000520ee4 <crypto_remove_spawns+212>

 #) This looks like alg->cra_users.next is loaded to r10
 &) This looks like r10 is compared with &alg->cra_users calculated on the line
    above to terminate the loop
 *) This looks like *alg->cra_users.next loaded into r8 which causes the null
    pointer dereference

So the fixup needs to be applied to the first dereference of
alg->cra_users.next as well to prevent crash.

Fixes: 9a00674213a3 ("crypto: algapi - fix NULL dereference in crypto_remove_spawns()")

Reported-by: chetjain@in.ibm.com
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
I cannot really test if this fix is effective because the crash is some
heisenbug that heavily depends on timing. When the bug is not triggered it does
not really mean anything. It is also qestionable if we should be getting these
algs with uninitialized spawns.

 crypto/algapi.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 313a7682cef1..82125b82ffba 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -151,6 +151,18 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 	LIST_HEAD(top);
 
 	spawns = &alg->cra_users;
+
+	/*
+	 * We may encounter an unregistered instance here, since an instance's
+	 * spawns are set up prior to the instance being registered.
+	 * An unregistered instance will have NULL ->cra_users.next, since
+	 * ->cra_users isn't properly initialized until registration.  But an
+	 * unregistered instance cannot have any users, so treat it the same as
+	 * ->cra_users being empty.
+	 */
+	if (spawns->next == NULL)
+		return;
+
 	list_for_each_entry_safe(spawn, n, spawns, list) {
 		if ((spawn->alg->cra_flags ^ new_type) & spawn->mask)
 			continue;
@@ -177,15 +189,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			spawn->alg = NULL;
 			spawns = &inst->alg.cra_users;
 
-			/*
-			 * We may encounter an unregistered instance here, since
-			 * an instance's spawns are set up prior to the instance
-			 * being registered.  An unregistered instance will have
-			 * NULL ->cra_users.next, since ->cra_users isn't
-			 * properly initialized until registration.  But an
-			 * unregistered instance cannot have any users, so treat
-			 * it the same as ->cra_users being empty.
-			 */
+			/* Guard against unregistered instance */
 			if (spawns->next == NULL)
 				break;
 		}
-- 
2.21.0

