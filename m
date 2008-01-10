From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
Date: Fri, 11 Jan 2008 07:48:31 +1100
Message-ID: <E1JD4KF-0004T4-00@gondolin.me.apana.org.au>
References: <285479690@web.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Viets@web.de (Torben Viets)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1414 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbYAJUsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 15:48:33 -0500
In-Reply-To: <285479690@web.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Torben Viets <Viets@web.de> wrote:
> 
> After rebuilding the kernel, I tried: cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/raid/test
> 
> It does the same as before, dmesg says:
> 
> general protection fault: 0000 [#1] 
> Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE xt_tcpudp pppoe pppox xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables af_packet ppp_generic slhc aes_i586 dm_crypt dm_mod
> 
> Pid: 4409, comm: kcryptd Not tainted (2.6.24-rc7 #2)
> EIP: 0060:[<c03599cc>] EFLAGS: 00010282 CPU: 0
> EIP is at aes_crypt_copy+0x2c/0x50
> EAX: f62e1ff0 EBX: f60ab850 ECX: 00000001 EDX: f60ab830
> ESI: f620dda8 EDI: f620dda8 EBP: f62e1ff0 ESP: f620dda8

Oh I see.  I misdiagnosed the problem.  The problem is that for some
reason gcc cannot guarantee 16-byte alignment for variables on the
stack in the kernel.  As you can see from ESI/EDI above the temporary
buffer is unaligned.

Please try this patch instead.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index a337b69..5f7e718 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -429,8 +429,8 @@ static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
 
 static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
 {
-	u8 tmp[AES_BLOCK_SIZE * 2]
-		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
+	u8 buf[AES_BLOCK_SIZE * 2 + PADLOCK_ALIGNMENT - 1];
+	u8 *tmp = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 
 	memcpy(tmp, in, AES_BLOCK_SIZE);
 	padlock_xcrypt(tmp, out, key, cword);
