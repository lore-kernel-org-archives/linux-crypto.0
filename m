From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: GPF in ChaCha20 SSSE3 Implementation
Date: Thu, 21 Jan 2016 15:21:23 +0100
Message-ID: <CAHmME9r9QGqJE__dfzuypW87Kyy1g3i4BbWnZD+NPAchK_TmMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: martin@strongswan.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:57632 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759175AbcAUO2H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jan 2016 09:28:07 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 063ea41b
	for <linux-crypto@vger.kernel.org>;
	Thu, 21 Jan 2016 14:20:25 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 939b789d
	TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=YES
	for <linux-crypto@vger.kernel.org>;
	Thu, 21 Jan 2016 14:20:24 +0000 (UTC)
Received: by mail-wm0-f52.google.com with SMTP id u188so228392814wmu.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2016 06:21:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

I'm trying to use your ChaPoly implementation and I'm running into
quite a bit of trouble. Firstly, it appears that the routine
intermittently overwrites boundaries that it shouldn't, resulting in
panics, which I'm still looking into, and could be caused by error on
my part. But, more importantly, it looks like you're not aligning
things correctly, and this causes issues:

[   31.583522] general protection fault: 0000 [#1] PREEMPT SMP
[   31.583561] RIP: 0010:[<ffffffffa03461d7>]  [<ffffffffa03461d7>]
chacha20_4block_xor_ssse3+0x87/0x7c0 [chacha20_x86_64]
[   31.583563] RSP: 0018:ffff88003b2e7a88  EFLAGS: 00010286
[   31.583564] RAX: 0000000000000000 RBX: ffff88003be34970 RCX: 0000000000000100
[   31.583565] RDX: ffff88003be34870 RSI: ffff88003be34870 RDI: ffff88003b2e7c00
[   31.583566] RBP: ffff88003b2e7b50 R08: ffff88003b25d9a0 R09: 0000000000000790
[   31.583567] R10: 0000000000000790 R11: 00000000002413e4 R12: 0000000000000100
[   31.583567] R13: ffff88003be34970 R14: ffff88003be34970 R15: ffff88003b2e7c00
[   31.583569] FS:  0000000000000000(0000) GS:ffff88003d600000(0000)
knlGS:0000000000000000
[   31.583570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.583571] CR2: 00007ff1aa711a94 CR3: 0000000001809000 CR4: 00000000001406f0
[   31.583606] Stack:
[   31.583608]  ffff88003b093700 ffff88003d655700 ffff88003d655700
ffff88003b093700
[   31.583610]  ffff88003b2e7ab8 ffffffff81055ee3 ffff88003b2e7ac8
ffffffff8104d84d
[   31.583612]  ffffffffa03469ef 0000000000000100 ffff88003be34870
ffff88003b2e7b70
[   31.583613] Call Trace:
[   31.583642]  [<ffffffffa0346c66>] chacha20_simd.part.0+0x96/0x110
[chacha20_x86_64]
[   31.583644]  [<ffffffffa0346d16>] chacha20_simd+0x36/0x50 [chacha20_x86_64]

Disassembling chacha20_4block_xor_ssse3+0x87, we get these instructions:

# x0..3 on stack
movdqa %xmm0,0x00(%rsp)
movdqa %xmm1,0x10(%rsp)
movdqa %xmm2,0x20(%rsp)
movdqa %xmm3,0x30(%rsp)

It looks like the problem stems from RSP being ffff88003b2e7a88, which
isn't 16bit aligned. According to the Intel manual, trying to a load a
non-aligned address like this will result in GP, which is what's
happening here.

Is this a bug, or is this potentially related to my own API misuse?

Thanks,
Jason



==== The way I'm using the API, more or less ====

nonce = get_nonce_from_somewhere();
padding_len = calculate_padding_between_0_and_15(skb);
plaintext_len = skb->len + padding_len;

/* Expand data section to have room for padding and auth tag */
num_frags = skb_cow_data(skb, padding_len + POLY_AUTH_TAG_LEN, &trailer);

/* Set the padding to zeros, and make sure it and the auth tag are
part of the skb */
memset(skb_tail_pointer(trailer), 0, padding_len);
pskb_put(skb, trailer, padding_len + POLY_AUTH_TAG_LEN);

sg = kzalloc(num_frags * sizeof(struct scatterlist), GFP_ATOMIC);
/* Convert skb to sg list */
sg_init_table(sg, num_frags);
skb_to_sgvec(skb, ctx->sg, 0, plaintext_len + POLY_AUTH_TAG_LEN);

tfm = set_key_and_get_aead_tfm_blah("rfc7539(chacha20,poly1305)", bla, bla);
req = aead_request_alloc(tfm, GFP_ATOMIC);
aead_request_set_crypt(req, sg, sg, plaintext_len, nonce);
aead_request_set_ad(req, 0);
aead_request_set_callback(req, 0, callback_done, NULL);
crypto_aead_encrypt(req);
