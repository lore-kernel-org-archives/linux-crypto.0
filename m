From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Dead code in crypto/tcrypt.c
Date: Tue, 26 Sep 2006 13:05:41 +0200
Message-ID: <1159268741.5661.4.camel@alice>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:18874 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750811AbWIZLFp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Sep 2006 07:05:45 -0400
To: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

hi,

the following commit added some code in test_hash_cycles() which coverity flags as dead code.
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e9d41164e2fdd897fe4520c2079ea0000f6e0ec3

The culprit are the following lines:


	for (i = 0; i < 4; i++) {
- 		crypto_digest_init(tfm);
+ 		ret = crypto_hash_init(desc);
+ 		if (ret)
+ 			goto out;
		for (pcount = 0; pcount < blen; pcount += plen) {
			sg_set_buf(sg, p + pcount, plen);
- 			crypto_digest_update(tfm, sg, 1);
+ 			ret = crypto_hash_update(desc, sg, plen);
+ 			if (ret)
+ 				goto out;
		}
- 		crypto_digest_final(tfm, out);
+ 		crypto_hash_final(desc, out);
+ 		if (ret)
+ 			goto out;
	}

We check ret before the for loop, and inside it, and
there is no way it can change in between. Are we missing
to assign the return value of crypto_hash_final() to ret?

Greetings, Eric

