From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: GPF in scatterwalk_start
Date: Tue, 19 Jan 2016 21:23:57 +0800
Message-ID: <20160119132357.GA10447@gondor.apana.org.au>
References: <CACT4Y+bQGUjabQVkN=9C84tj716Ux8GprLwFYJSapWOLy-r50Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47511 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcASNYG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 08:24:06 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+bQGUjabQVkN=9C84tj716Ux8GprLwFYJSapWOLy-r50Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:30:40AM +0100, Dmitry Vyukov wrote:
> 
> The following program causes GPF in scatterwalk_start.
> 
> Herbert, I am on commit 5807fcaa9bf7dd87241df739161c119cf78a6bc4 with
> all your fixes applied, including the fix for out-of-bounds in
> skcipher_recvmsg.

OK this is an off-by-one bug in skcipher_sendmsg.

---8<---
Subject: crypto: algif_skcipher - sendmsg SG marking is off by one

We mark the end of the SG list in sendmsg and sendpage and unmark
it on the next send call.  Unfortunately the unmarking in sendmsg
is off-by-one, leading to an SG list that is too short.

Fixes: 0f477b655a52 ("crypto: algif - Mark sgl end at the end of data")
Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 76ecb40..38c1aa8 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -392,7 +392,8 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 		sg = sgl->sg;
-		sg_unmark_end(sg + sgl->cur);
+		if (sgl->cur)
+			sg_unmark_end(sg + sgl->cur - 1);
 		do {
 			i = sgl->cur;
 			plen = min_t(size_t, len, PAGE_SIZE);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
