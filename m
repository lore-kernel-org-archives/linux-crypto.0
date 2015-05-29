From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Fri, 29 May 2015 12:09:35 +0200
Message-ID: <2444206.rbm5Z3UBF9@tachyon.chronox.de>
References: <20150527092441.GA27913@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58347 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbbE2KJn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 06:09:43 -0400
In-Reply-To: <20150527092441.GA27913@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Mai 2015, 17:24:41 schrieb Herbert Xu:

Hi Herbert,

after testing of the new algif_aead interface, I am wondering about the 
following changes which seem to alter the way how the tag is supposed to be 
handled:

> -	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ? 0 : as)));
> +	return ctx->used >= ctx->aead_assoclen + as;

This change requires that the buffer handed in by user space always has room 
for the tag, regardless whether it is needed or not. Is that intended?

> -		/* add the size needed for the auth tag to be created */
> -		outlen += as;
> -	} else {
> -		/* output data size is input without the authentication tag */
> -		outlen = used - as;

The removal of these make me wonder: with those missing, the output of the 
cipher operation does not have CT || tag (in case of encryption) or PT (in 
case of encryption.

Note, I have updated my user space code to require space for the AD in the 
output buffer. When reverting those changes with the following patch, the code 
works nicely. If I do not apply the patch, the beginning of the CT or PT is as 
expected, but the end is bogus. Also, the tag would be missing.

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 38a6cab..b6af158 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -72,7 +72,7 @@ static inline bool aead_sufficient_data(struct aead_ctx 
*ctx)
 {
        unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx-
>aead_req));
 
-       return ctx->used >= ctx->aead_assoclen + as;
+       return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
 static void aead_put_sgl(struct sock *sk)
@@ -403,13 +403,19 @@ static int aead_recvmsg(struct socket *sock, struct 
msghdr *msg, size_t ignored,
        if (!aead_sufficient_data(ctx))
                goto unlock;
 
-       outlen = used;
+       if (ctx->enc) {
+               /* add the size needed for the auth tag to be created */
+               outlen = used + as;
+       } else {
+               /* output data size is input without the authentication tag */
+               outlen = used - as;
+       }
 
        /*
         * The cipher operation input data is reduced by the associated data
         * length as this data is processed separately later on.
         */
-       used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
+       used -= ctx->aead_assoclen;
 
        /* convert iovecs of output buffers into scatterlists */
        while (iov_iter_count(&msg->msg_iter)) {



However, when use those changes and I perform the test of libkcapi/test/kcapi 
-y -s, I get the following strange crash which i have no idea where to look 
for the cause (normal sendmsg and vmsplice tests with libkcapi/test/kcapi -y 
and libkcapi/test/kcapi -y -v work flawless)

[  177.112195] Modules linked in: crypto_user ccm algif_aead(E) af_alg 
nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT 
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute 
bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security 
ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security 
iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel 
aesni_intel aes_x86_64 glue_helper ablk_helper microcode joydev pcspkr 
serio_raw virtio_balloon i2c_piix4 acpi_cpufreq qxl virtio_blk virtio_net 
drm_kms_helper ttm drm virtio_pci virtio_ring virtio [last unloaded: 
algif_aead]
[  177.112306] CPU: 1 PID: 2012 Comm: kcapi Tainted: G            E   4.0.0+ 
#228
[  177.112312] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.7.5-20140709_153950- 04/01/2014
[  177.112319] task: ffff88007aaa3300 ti: ffff88007c0a4000 task.ti: 
ffff88007c0a4000
[  177.112324] RIP: 0010:[<ffffffff8118fb6a>]  [<ffffffff8118fb6a>] 
ksize+0x4a/0xf0
[  177.112337] RSP: 0018:ffff88007c0a7d98  EFLAGS: 00010286
[  177.112344] RAX: 00000188000680c0 RBX: ffffeb88000680c0 RCX: 
0000000000000000
[  177.112350] RDX: 0000000000000010 RSI: ffffea0001a033c2 RDI: 
000077ff80000000
[  177.112356] RBP: ffff88007c0a7da8 R08: ffffea0001efa2e0 R09: 
0000000000000007
[  177.112361] R10: ffff880079419bb0 R11: ffff88007aac8b10 R12: 
0000000000000010
[  177.112367] R13: 0000000000000010 R14: ffff88007d0bc920 R15: 
ffff8800796acc00
[  177.112375] FS:  00007f2e2fd8a700(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[  177.112381] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  177.112386] CR2: ffffeb88000680c0 CR3: 000000007c044000 CR4: 
00000000000407e0
[  177.112402] Stack:
[  177.112407]  ffff88007c0a7db8 ffffea0001a033c2 ffff88007c0a7dc8 
ffffffff811636bc
[  177.112418]  ffff88007c0a7de8 ffff88007c278800 ffff88007c0a7de8 
ffffffff81563ddf
[  177.112428]  ffff88007c278800 ffff88007a404000 ffff88007c0a7e18 
ffffffffa028f694
[  177.112438] Call Trace:
[  177.112452]  [<ffffffff811636bc>] kzfree+0x1c/0x40
[  177.112478]  [<ffffffff81563ddf>] sock_kzfree_s+0x1f/0x60
[  177.112486]  [<ffffffffa028f694>] aead_sock_destruct+0x54/0xa0 [algif_aead]
[  177.112492]  [<ffffffff815653b3>] __sk_free+0x23/0x140
[  177.112497]  [<ffffffff815654e9>] sk_free+0x19/0x20
[  177.112504]  [<ffffffffa02812f9>] af_alg_release+0x29/0x30 [af_alg]
[  177.112511]  [<ffffffff8156065f>] sock_release+0x1f/0x90
[  177.112517]  [<ffffffff815606e2>] sock_close+0x12/0x20
[  177.112524]  [<ffffffff811ab51c>] __fput+0xdc/0x1f0
[  177.112531]  [<ffffffff811ab67e>] ____fput+0xe/0x10
[  177.112539]  [<ffffffff8106f187>] task_work_run+0xb7/0xf0
[  177.112545]  [<ffffffff81002c31>] do_notify_resume+0x51/0x70
[  177.112553]  [<ffffffff816879bc>] int_signal+0x12/0x17
[  177.112557] Code: 00 ea ff ff 48 83 ec 08 48 01 f8 48 bf 00 00 00 80 ff 77 
00 00 48 0f 42 3d b4 d4 a7 00 48 01 f8 48 c1 e8 0c 48 c1 e0 06 48 01 c3 <48> 
8b 03 f6 c4 80 75 56 48 8b 03 a8 80 74 57 48 8b 43 30 48 8b 
[  177.112630] RIP  [<ffffffff8118fb6a>] ksize+0x4a/0xf0
[  177.112638]  RSP <ffff88007c0a7d98>
[  177.112641] CR2: ffffeb88000680c0
[  177.112646] ---[ end trace 300af93a757958e4 ]---

-- 
Ciao
Stephan
