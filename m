Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24ECC10F00
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82FD1206C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714200;
	bh=C+m6dDbr8RtFbwiDPqHtgWLlpOXUXxJZlReMOk2cRm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=znrirX8XjCvFSIMZxAMY/gm8ZkpNovVYfsSMEBOQYIc1A7sPDMfjm0pltpgMkjfMR
	 mpwpgjMO3mbP8VOLFmXpn30tFm9hy55S8oDFWV0mtQ0A06AOAr5nnFYabmWglT6BHC
	 24keqZvuflkJf/6xft6YXo3y7rVWfJRDnm1AjM8Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbfC0TQ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388492AbfC0SJF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 14:09:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28264217F5;
        Wed, 27 Mar 2019 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710144;
        bh=C+m6dDbr8RtFbwiDPqHtgWLlpOXUXxJZlReMOk2cRm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PncUpHO6W+29BM1e2K5+O/Cd7cmQeqguHxXqJph9gG4S2oDF0uoZoifdysISfLNtf
         bwjsVK8/d6xGDmspX3GtsjWMrb9EVWGUHMENP0eyg1NeKbzVcY6JY2UGvX2Nan752p
         wONwPCXrDZl+9Qt+ML5s/1zsSeCrfNXsYGqqYXCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Tolnay <dtolnay@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 216/262] hwrng: virtio - Avoid repeated init of completion
Date:   Wed, 27 Mar 2019 14:01:11 -0400
Message-Id: <20190327180158.10245-216-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: David Tolnay <dtolnay@gmail.com>

[ Upstream commit aef027db48da56b6f25d0e54c07c8401ada6ce21 ]

The virtio-rng driver uses a completion called have_data to wait for a
virtio read to be fulfilled by the hypervisor. The completion is reset
before placing a buffer on the virtio queue and completed by the virtio
callback once data has been written into the buffer.

Prior to this commit, the driver called init_completion on this
completion both during probe as well as when registering virtio buffers
as part of a hwrng read operation. The second of these init_completion
calls should instead be reinit_completion because the have_data
completion has already been inited by probe. As described in
Documentation/scheduler/completion.txt, "Calling init_completion() twice
on the same completion object is most likely a bug".

This bug was present in the initial implementation of virtio-rng in
f7f510ec1957 ("virtio: An entropy device, as suggested by hpa"). Back
then the have_data completion was a single static completion rather than
a member of one of potentially multiple virtrng_info structs as
implemented later by 08e53fbdb85c ("virtio-rng: support multiple
virtio-rng devices"). The original driver incorrectly used
init_completion rather than INIT_COMPLETION to reset have_data during
read.

Tested by running `head -c48 /dev/random | hexdump` within crosvm, the
Chrome OS virtual machine monitor, and confirming that the virtio-rng
driver successfully produces random bytes from the host.

Signed-off-by: David Tolnay <dtolnay@gmail.com>
Tested-by: David Tolnay <dtolnay@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index b89df66ea1ae..7abd604e938c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -73,7 +73,7 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 
 	if (!vi->busy) {
 		vi->busy = true;
-		init_completion(&vi->have_data);
+		reinit_completion(&vi->have_data);
 		register_buffer(vi, buf, size);
 	}
 
-- 
2.19.1

