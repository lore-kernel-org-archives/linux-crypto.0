From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple
 buffers
Date: Sat, 17 Nov 2012 02:42:20 +0200
Message-ID: <20121117024220.12381ph1ph0fu3q8@www.dalek.fi>
References: <50A4AFEE.9030206@lundman.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_1mu6qmiecf34"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Jorgen Lundman <lundman@lundman.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:42500 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2KQAmY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2012 19:42:24 -0500
In-Reply-To: <50A4AFEE.9030206@lundman.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This message is in MIME format.

--=_1mu6qmiecf34
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hello,

I managed to reproduce something similiar with small buffers...

Does attached patch help in your case?

-Jussi

Quoting Jorgen Lundman <lundman@lundman.net>:

>
> I have a situation where I setup scatterlists as:
>
>  input scatterlist of 1, address ffffc90003627000 len 0x20000.
>
> output scatterlist of 2, address 0 ffffc90002d45000 len 0x20000
>                          address 1 ffff88003b079d98 len 0x000c
>
> When I call crypto_aead_encrypt(req); it will die with:
>
> kernel: [  925.151113] BUG: unable to handle kernel paging request at
> ffffeb04000b5140
> kernel: [  925.151253] IP: [<ffffffff812f4880>] scatterwalk_done+0x50/0x60
> kernel: [  925.151325] PGD 0
> kernel: [  925.151381] Oops: 0000 [#1] SMP
> kernel: [  925.151442] CPU 1
> kernel: [  925.154255]  [<ffffffff812f7640>] blkcipher_walk_done+0xb0/0x230
> kernel: [  925.154255]  [<ffffffffa02e9169>]  
> crypto_ctr_crypt+0x129/0x2b0 [ctr]
> kernel: [  925.154255]  [<ffffffff812fe580>] ? crypto_aes_set_key+0x40/0x40
> kernel: [  925.154255]  [<ffffffff812f6cbd>] async_encrypt+0x3d/0x40
> kernel: [  925.154255]  [<ffffffffa0149326>] crypto_ccm_encrypt+0x246/0x290
> [ccm]
> kernel: [  925.154255]  [<ffffffffa01633bd>] crypto_encrypt+0x26d/0x2d0
>
>
>
> What is interesting about that is, if I allocate a linear buffer instead:
>
>   dst = kmalloc(cryptlen, GFP_KERNEL); // 0x20000 + 0x000c
>   sg_init_table(sg, 1 );
>   sg_set_buf(&sg[0], dst, cryptlen);
>
>   crypto_aead_encrypt(req);
>
> will no longer panic. However, when I try to copy the linear buffer back to
> scatterlist;
>
>
>   scatterwalk_map_and_copy(dst, sg, 0, cryptlen, 1);
>
>
> then it will panic there instead.
>
>
> However, if I replace it with the call:
>
>     sg_copy_from_buffer(sg, sg_nents(sg),
>                         dst, cryptlen);
>
> everything works! <-
>
> So, what am I doing wrong that makes scatterwalk_map_and_copy() fail, and
> sg_copy_from_buffer() work fine? It would be nice if I could fix it, so I
> did not need to copy to a temporary buffer.
>
> Lund
>
> --
> Jorgen Lundman       | <lundman@lundman.net>
> Unix Administrator   | +81 (0)3 -5456-2687 ext 1017 (work)
> Shibuya-ku, Tokyo    | +81 (0)90-5578-8500          (cell)
> Japan                | +81 (0)3 -3375-1767          (home)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



--=_1mu6qmiecf34
Content-Type: text/x-patch;
 charset=ISO-8859-1;
 name="05-fix-broken-scatterwalk_sg_chain.patch"
Content-Disposition: attachment;
 filename="05-fix-broken-scatterwalk_sg_chain.patch"
Content-Transfer-Encoding: 7bit

crypto: scatterwalk - fix broken scatterlist manipulation

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

scatterlist_sg_chain() manipulates scatterlist structures directly in wrong
way, chaining without marking 'chain' bit 0x01. This can in some cases lead
to problems, such as triggering BUG_ON(!sg->length) in scatterwalk_start().

So instead of reinventing wheel, change scatterwalk to use existing functions
from scatterlist API.
---
 include/crypto/scatterwalk.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 3744d2a..d31870c 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -34,16 +34,12 @@ static inline void crypto_yield(u32 flags)
 static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 					struct scatterlist *sg2)
 {
-	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
-	sg1[num - 1].page_link &= ~0x02;
+	sg_chain(sg1, num, sg2);
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
-	if (sg_is_last(sg))
-		return NULL;
-
-	return (++sg)->length ? sg : (void *)sg_page(sg);
+	return sg_next(sg);
 }
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,

--=_1mu6qmiecf34--
