From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] avoid excessive use of socket buffer in skcipher
Date: Mon, 25 Aug 2014 11:49:53 +0200
Message-ID: <1408960194-11726-1-git-send-email-okozina@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, herbert@gondor.apana.org.au,
	gmazyland@gmail.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaHYJuG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 05:50:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

I found this bug when I ran cryptsetup testsuite on ppc64 arch. I don't have deep
insight into networking, but it seemed to me the MAX_SGL_ENTS define doesn't have
to be tied to PAGE_SIZE. Please take this patch as base for discussion, if it's
fundamentally wrong.

The 'easy' way is to increase net.core.optmem_max, but this way we would blow up
the memory overhead for every socket in kernel. Not to mention that for user space,
without not insignificant debugging effort, it's not clear what really happened.

Kind regards
Ondrej

Ondrej Kozina (1):
  avoid excessive use of socket buffer in skcipher

 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.9.3
