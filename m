From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
Date: Thu, 10 Jan 2008 14:03:02 +1100
Message-ID: <20080110030302.GB4570@gondor.apana.org.au>
References: <47841152.8080705@web.de> <478550DF.3070908@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Torben Viets <viets@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4782 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbYAJDDM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jan 2008 22:03:12 -0500
Content-Disposition: inline
In-Reply-To: <478550DF.3070908@web.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 09, 2008 at 10:55:27PM +0000, Torben Viets wrote:
> 
> eneral protection fault: 0000 [#1]
> Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE 
> xt_tcpudp xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 
> iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc 
> aes_i586
> CPU:    0
> EIP:    0060:[<c035b828>]    Not tainted VLI
> EFLAGS: 00010292   (2.6.23.12 #7)
> EIP is at aes_crypt_copy+0x28/0x40
> eax: f7639ff0   ebx: f6c24050   ecx: 00000001   edx: f6c24030
> esi: f7e89dc8   edi: f7639ff0   ebp: 00010000   esp: f7e89dc8

Thanks for the report.  It would appear that your CPU goes one step
further than the other report and insists on having two blocks in the
destination too.

Please let me know whether this patch fixes the problem.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index a337b69..ed3ae47 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -433,7 +433,8 @@ static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
 		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
 
 	memcpy(tmp, in, AES_BLOCK_SIZE);
-	padlock_xcrypt(tmp, out, key, cword);
+	padlock_xcrypt(tmp, tmp, key, cword);
+	memcpy(out, tmp, AES_BLOCK_SIZE);
 }
 
 static inline void aes_crypt(const u8 *in, u8 *out, u32 *key,
