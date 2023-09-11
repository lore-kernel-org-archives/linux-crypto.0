Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E65BCA0EC7
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353621AbjIKVuw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbjIKN5h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 09:57:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A569FCD7;
        Mon, 11 Sep 2023 06:57:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DCBC433C7;
        Mon, 11 Sep 2023 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1694440653;
        bh=CU1g8Lrs6EaUNCYAPQHJ7zHQs/cwzFvskhy2PCvPc98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1YVtmnarCG1NzXEslc0QO12B4eWDiAycYzExvbrbPxKyFvPCCAgDkzl19UqGyjTZ
         ioVI+/Q03ulHEgj5lZm9pLsIsD1nRv6cYBQPB07OFx8uR6KdPYVDBXIr9tgDskC3nS
         77p3jjpI5betd/rMrMr4de6hAKZuPQ7GDclEBTm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, regressions@lists.linux.dev,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 110/739] crypto: af_alg - Fix missing initialisation affecting gcm-aes-s390
Date:   Mon, 11 Sep 2023 15:38:29 +0200
Message-ID: <20230911134654.173764504@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6a4b8aa0a916b39a39175584c07222434fa6c6ef ]

Fix af_alg_alloc_areq() to initialise areq->first_rsgl.sgl.sgt.sgl to point
to the scatterlist array in areq->first_rsgl.sgl.sgl.

Without this, the gcm-aes-s390 driver will oops when it tries to do
gcm_walk_start() on req->dst because req->dst is set to the value of
areq->first_rsgl.sgl.sgl by _aead_recvmsg() calling
aead_request_set_crypt().

The problem comes if an empty ciphertext is passed: the loop in
af_alg_get_rsgl() just passes straight out and doesn't set areq->first_rsgl
up.

This isn't a problem on x86_64 using gcmaes_crypt_by_sg() because, as far
as I can tell, that ignores req->dst and only uses req->src[*].

[*] Is this a bug in aesni-intel_glue.c?

The s390x oops looks something like:

 Unable to handle kernel pointer dereference in virtual kernel address space
 Failing address: 0000000a00000000 TEID: 0000000a00000803
 Fault in home space mode while using kernel ASCE.
 AS:00000000a43a0007 R3:0000000000000024
 Oops: 003b ilc:2 [#1] SMP
 ...
 Call Trace:
  [<000003ff7fc3d47e>] gcm_walk_start+0x16/0x28 [aes_s390]
  [<00000000a2a342f2>] crypto_aead_decrypt+0x9a/0xb8
  [<00000000a2a60888>] aead_recvmsg+0x478/0x698
  [<00000000a2e519a0>] sock_recvmsg+0x70/0xb0
  [<00000000a2e51a56>] sock_read_iter+0x76/0xa0
  [<00000000a273e066>] vfs_read+0x26e/0x2a8
  [<00000000a273e8c4>] ksys_read+0xbc/0x100
  [<00000000a311d808>] __do_syscall+0x1d0/0x1f8
  [<00000000a312ff30>] system_call+0x70/0x98
 Last Breaking-Event-Address:
  [<000003ff7fc3e6b4>] gcm_aes_crypt+0x104/0xa68 [aes_s390]

Fixes: c1abe6f570af ("crypto: af_alg: Use extract_iter_to_sg() to create scatterlists")
Reported-by: Ondrej Mosnáček <omosnacek@gmail.com>
Link: https://lore.kernel.org/r/CAAUqJDuRkHE8fPgZJGaKjUjd3QfGwzfumuJBmStPqBhubxyk_A@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Sven Schnelle <svens@linux.ibm.com>
cc: Harald Freudenberger <freude@linux.vnet.ibm.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-crypto@vger.kernel.org
cc: linux-s390@vger.kernel.org
cc: regressions@lists.linux.dev
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Ondrej Mosnáček <omosnacek@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 10efb56d8b481..ad02ca0a8cdde 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1192,6 +1192,7 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 
 	areq->areqlen = areqlen;
 	areq->sk = sk;
+	areq->first_rsgl.sgl.sgt.sgl = areq->first_rsgl.sgl.sgl;
 	areq->last_rsgl = NULL;
 	INIT_LIST_HEAD(&areq->rsgl_list);
 	areq->tsgl = NULL;
-- 
2.40.1



