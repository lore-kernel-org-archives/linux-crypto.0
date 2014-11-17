From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: [PATCH 2/2] kernel/kexec: free crypto_shash using crypto_free_shash
Date: Mon, 17 Nov 2014 18:14:26 +0400
Message-ID: <20141117151426.10739.86414.stgit@buzz>
References: <20141117151420.10739.16342.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Michal Marek <mmarek@suse.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eric Biederman <ebiederm@xmission.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17554 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaKQPO2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 10:14:28 -0500
In-reply-to: <20141117151420.10739.16342.stgit@buzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These objects have special freeing functions which cares about
proper destruction and reference counting.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2abf9f6..5a62311 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2286,7 +2286,7 @@ out_free_sha_regions:
 out_free_desc:
 	kfree(desc);
 out_free_tfm:
-	kfree(tfm);
+	crypto_free_shash(tfm);
 out:
 	return ret;
 }
