From: Jorgen Lundman <lundman@lundman.net>
Subject: Crypto causes panic in scatterwalk_done with large/multiple buffers
Date: Thu, 15 Nov 2012 18:03:42 +0900
Message-ID: <50A4AFEE.9030206@lundman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lundman.net ([210.157.1.114]:51730 "EHLO mail.lundman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab2KOJDq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Nov 2012 04:03:46 -0500
Received: from localhost (solaris11 [127.0.0.1])
	by mail.lundman.net (Postfix) with ESMTP id C089F6AF6C
	for <linux-crypto@vger.kernel.org>; Thu, 15 Nov 2012 18:03:44 +0900 (JST)
Received: from mail.lundman.net ([127.0.0.1])
	by localhost (mail.lundman.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OJldOJMLmSaR for <linux-crypto@vger.kernel.org>;
	Thu, 15 Nov 2012 18:03:44 +0900 (JST)
Received: from shinken.interq.or.jp (shinken.interq.or.jp [210.172.146.228])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.lundman.net (Postfix) with ESMTPSA id CBD276AF64
	for <linux-crypto@vger.kernel.org>; Thu, 15 Nov 2012 18:03:43 +0900 (JST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


I have a situation where I setup scatterlists as:

 input scatterlist of 1, address ffffc90003627000 len 0x20000.

output scatterlist of 2, address 0 ffffc90002d45000 len 0x20000
                         address 1 ffff88003b079d98 len 0x000c

When I call crypto_aead_encrypt(req); it will die with:

kernel: [  925.151113] BUG: unable to handle kernel paging request at
ffffeb04000b5140
kernel: [  925.151253] IP: [<ffffffff812f4880>] scatterwalk_done+0x50/0x60
kernel: [  925.151325] PGD 0
kernel: [  925.151381] Oops: 0000 [#1] SMP
kernel: [  925.151442] CPU 1
kernel: [  925.154255]  [<ffffffff812f7640>] blkcipher_walk_done+0xb0/0x230
kernel: [  925.154255]  [<ffffffffa02e9169>] crypto_ctr_crypt+0x129/0x2b0 [ctr]
kernel: [  925.154255]  [<ffffffff812fe580>] ? crypto_aes_set_key+0x40/0x40
kernel: [  925.154255]  [<ffffffff812f6cbd>] async_encrypt+0x3d/0x40
kernel: [  925.154255]  [<ffffffffa0149326>] crypto_ccm_encrypt+0x246/0x290
[ccm]
kernel: [  925.154255]  [<ffffffffa01633bd>] crypto_encrypt+0x26d/0x2d0



What is interesting about that is, if I allocate a linear buffer instead:

  dst = kmalloc(cryptlen, GFP_KERNEL); // 0x20000 + 0x000c
  sg_init_table(sg, 1 );
  sg_set_buf(&sg[0], dst, cryptlen);

  crypto_aead_encrypt(req);

will no longer panic. However, when I try to copy the linear buffer back to
scatterlist;


  scatterwalk_map_and_copy(dst, sg, 0, cryptlen, 1);


then it will panic there instead.


However, if I replace it with the call:

    sg_copy_from_buffer(sg, sg_nents(sg),
                        dst, cryptlen);

everything works! <-

So, what am I doing wrong that makes scatterwalk_map_and_copy() fail, and
sg_copy_from_buffer() work fine? It would be nice if I could fix it, so I
did not need to copy to a temporary buffer.

Lund

-- 
Jorgen Lundman       | <lundman@lundman.net>
Unix Administrator   | +81 (0)3 -5456-2687 ext 1017 (work)
Shibuya-ku, Tokyo    | +81 (0)90-5578-8500          (cell)
Japan                | +81 (0)3 -3375-1767          (home)
