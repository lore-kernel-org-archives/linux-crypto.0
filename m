Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:37052 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfAGXov (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 18:44:51 -0500
Received: by mail-it1-f193.google.com with SMTP id b5so3681741iti.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Jan 2019 15:44:50 -0800 (PST)
MIME-Version: 1.0
From: David Tolnay <dtolnay@gmail.com>
Date: Mon, 7 Jan 2019 15:44:38 -0800
Message-ID: <CAJN_sMh5v5YKJ1f0BdSjLAoBfkiYddxi7a-75SbRWT-BwGeLsQ@mail.gmail.com>
Subject: [PATCH] virtio-rng: Avoid repeated init of completion
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: David Tolnay <dtolnay@gmail.com>
Date: Mon, 7 Jan 2019 14:36:11 -0800
Subject: [PATCH] virtio-rng: Avoid repeated init of completion

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
---
 drivers/char/hw_random/virtio-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c
b/drivers/char/hw_random/virtio-rng.c
index b89df66ea1ae..7abd604e938c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -73,7 +73,7 @@ static int virtio_read(struct hwrng *rng, void *buf,
size_t size, bool wait)

     if (!vi->busy) {
         vi->busy = true;
-        init_completion(&vi->have_data);
+        reinit_completion(&vi->have_data);
         register_buffer(vi, buf, size);
     }

-- 
2.20.1.97.g81188d93c3-goog
