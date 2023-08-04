Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3A7C00528
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 09:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjHDJmM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjHDJmK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 05:42:10 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B21330EB
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 02:42:09 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 0E78924002A
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 11:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1691142127; bh=Hg8+Ie5zk1+PShUsC8fZxv3X5pNkB2BeLLwMP1rWmCU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding:From;
        b=rOyCoJouUzqfpz1lQTwVMzRESTjBh5ZtloRWZTUOBM++GKBubjut+ihoPMF3VUhh/
         3Wo9oulQ/uVUmC/X3bgzSrGjXGLxN2u36kHRDi91WUZMMngngnm8u/YYguqd8wAT1N
         3rHl0oOoM3jm3xgCztFoebcbbsKGcy5oXH3GYBRK+JjGPC9QUvB7wH+e6oFikoAj4V
         3Ra9QvPGtGB72xfxp7hdFlGb6JhoFjF1cOXauMSESJtcY+vukmTYyk5YcCEdkAMD9j
         jn2/LOpwDNEiISj4yN5ihalN9E2zux4THVesyuI8C0/ZijoyOv3cz6k2apPg137ikO
         9TC8MbZVEU55Q==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4RHLMx1w9tz6twV;
        Fri,  4 Aug 2023 11:42:05 +0200 (CEST)
From:   Mark O'Donovan <shiftee@posteo.net>
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, ebiggers@google.com,
        herbert@gondor.apana.org.au, Mark O'Donovan <shiftee@posteo.net>
Subject: [PATCH RESEND] lib/mpi: avoid null pointer deref in mpi_cmp_ui()
Date:   Fri,  4 Aug 2023 09:32:18 +0000
Message-Id: <20230804093218.418276-1-shiftee@posteo.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

During NVMeTCP Authentication a controller can trigger a kernel
oops by specifying the 8192 bit Diffie Hellman group and passing
a correctly sized, but zeroed Diffie Hellamn value.
mpi_cmp_ui() was detecting this if the second parameter was 0,
but 1 is passed from dh_is_pubkey_valid(). This causes the null
pointer u->d to be dereferenced towards the end of mpi_cmp_ui()

Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
---
 lib/mpi/mpi-cmp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
index c4cfa3ff0581..0835b6213235 100644
--- a/lib/mpi/mpi-cmp.c
+++ b/lib/mpi/mpi-cmp.c
@@ -25,8 +25,12 @@ int mpi_cmp_ui(MPI u, unsigned long v)
 	mpi_limb_t limb = v;
 
 	mpi_normalize(u);
-	if (!u->nlimbs && !limb)
-		return 0;
+	if (u->nlimbs == 0) {
+		if (v == 0)
+			return 0;
+		else
+			return -1;
+	}
 	if (u->sign)
 		return -1;
 	if (u->nlimbs > 1)
-- 
2.39.2

