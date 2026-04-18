Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C9246768
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776524796; cv=none; b=gAT6CRIP4lHBzu7UilLdml3s7yUhu9B8aNLO7cqxSPgUakA5ixdZwNvDGqzq0HApWgJ7QThuRcXWcTzvFmA2WRMp1IrfiuB6ig3Gi+9OigWApZBDt0ZPOvKC8AsnuxSHJbIuspBHnv/HQxKDQe+PoSykn/wzrUzg5Y6vQ7MhVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776524796; c=relaxed/simple;
	bh=1V6cC50xQESnLX0KQm6PhvdXPiTmwapBJ75OKMWymPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXGQ0xvLoX9znAyXnBJZ2uHH9EMoVtacm4L1okRNQnAdMfBTrzFEB4EPv1I044b2+DGvw0neFe7zX8Dx2XFWcwx1hU32YF9eDODf9UqP6P+xeep0xVsJ2Zm4dO0rzgG7IVuHwS7qvypkhV3m48/17CFEfI38jbUgh4V7PRGYq/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKvSzXTh; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKvSzXTh"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a068db9989so24736296d6.0
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776524792; x=1777129592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yz+44MQRchfmC+0bOJjAntAmbV8iNZQ8sftK5LQnA8Y=;
        b=mKvSzXThf60Pd1YMFbXBVfwDhVw7akgqd8b3gewz0o6/2RvulpEFI2r0Iev7Jp+IbZ
         rrUlkqHQy32qUFv6N7mouMJWA3gtWRG8EuisRTeLnw3cQZiaD88kcaa0PUIYa6D9pN+C
         wn/ncTNQlEe3SLKLxiRpjYUHILsNbtvG9GgkrssZfjMXTuOe0NxijZo+5dA8PwwEii2q
         S3+Hm8ELdWP6d55kMOKvMiYhnH7LNUYwXkAIpxBCkqDeF1iZw71r0uYNQwPhNhne5whY
         rTJI0tv5ChqhnHP9vQtNJYKw0yAOkFqyjTpKQl6tMCXozBuVgCC/GbSZS7rK541qIG/Y
         7aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776524792; x=1777129592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yz+44MQRchfmC+0bOJjAntAmbV8iNZQ8sftK5LQnA8Y=;
        b=MZxnMrodCYXCfoAfCx0d0Rt23/AVhwOrke7SHHN6CKJLkyQkYYRVKrcghGC51zqHP6
         J6D5FL1GSLCi3A9DZymB23qL5SmsK6SuSrwsXojeB2OlTwMP3zjrKJ4fTwLlpPbs6LG+
         +n/AgExj+Td5izV/mwAp7+auVU2r+exVxEkZ+GDKhSvFZWtslUaQmSlXn8mGcS/Ni4aP
         SPykCeTjlOp+4kVuQD108F6P2O6zLnQNkpm43qu5gFAf1cJli3lKRBWG0B00N9gnTjRD
         nIzEydqj+HUeUkEwJipS4bHMMAoJaToQdltDDyWFof8XxQRWJnWnm8Q57nuAG435Nao3
         5Jpg==
X-Forwarded-Encrypted: i=1; AFNElJ9Fx4yUFpYeRJd8czU7OF4k7tszcX/vW4u2M1JmOfxwqnqh94zdVPPsGfZUTIcTraG/CMs0NDTCnFddh6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxykyqodIDngscncpQUE/3boBpGCJXqnvbbyJSkEHRZMDRfSieY
	oUiN5/nWZtELmqehaZotJglFsUUhAMiowhQjHQMJTNzdznmXgkCNcldm
X-Gm-Gg: AeBDietei9TjvDtHq9DqIWTYwqlBSTBZ+p6Clxqtmy5VwXO37pTx+8nc0CjUzku4a19
	BpyY7UMiz5f5zvto0Pb1Hj4jRNQaqEiXsd5owc/Bv6GbZ9xu+zM7pHAAsN0z2fnQJHCcu8OsjKv
	HTHbrFsuIUpg8xLHdWM4bkxcTtnYGYAgqYmcAsfFodig/mrh8W+B1Lb4ILIvjGrxEbukgbWVIPq
	7vu+59aMp3BPaB6twr0/8WXGTFRntyAq9F4pMuZjkdLA/WLjNMGXdwJXI7GIrblKk1xwEIIlN41
	CaXIi6KPnLFkH90mPTQfqnrwAm8FMpIKIFFuF6bKDQvcjYgGEKQN/3wD2pzS55KlYL1PXTTEK3l
	OpiY3UMeDoLwk5PfAsbhDp3ZFo+8LF+hTZ9kMOyRWZEYX7F8AakFG7O/W4WcKdij3cLc+7fZWhZ
	kibpwV5aX3guHD9t27cPgQvwqYu9hYm3to2JcLd/Hvur1AAejvH4e8woLhouo/kscwJgAPVSmdF
	+QnLZAu2tJCAZlB4ug/s2IM+OIkpcQ=
X-Received: by 2002:a05:6214:4993:b0:89c:869e:4972 with SMTP id 6a1803df08f44-8b028471514mr93381016d6.10.1776524792131;
        Sat, 18 Apr 2026 08:06:32 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae5c44esm34256396d6.27.2026.04.18.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 08:06:31 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] hwrng: virtio: clamp device-reported used.len at copy_data()
Date: Sat, 18 Apr 2026 11:06:13 -0400
Message-ID: <20260418150613.3522589-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418000020.1847122-1-michael.bommarito@gmail.com>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

random_recv_done() stores the device-reported used.len directly into
vi->data_avail.  copy_data() then indexes vi->data[] using
vi->data_idx (advanced by previous copy_data() calls) and issues a
memcpy() without re-validating either value against the posted
buffer size sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32
or 64).

A malicious or buggy virtio-rng backend can set used.len beyond
sizeof(vi->data), steering the memcpy() past the end of the inline
array into adjacent kmalloc-1k slab bytes.  hwrng_fillfn() mixes
those bytes into the guest RNG, and guest root can also observe
them directly via /dev/hwrng.

Concrete impact is inside the guest:

 - Memory-safety / hardening: any virtio-rng backend that
   over-reports used.len causes the driver to read past vi->data
   into unrelated slab contents.  hwrng_fillfn() is a kernel thread
   that runs as soon as the device is probed; no guest userspace
   interaction is required to first-trigger the OOB.

 - Cross-boundary leak (confidential-compute threat model): a
   malicious hypervisor cooperating with a malicious or compromised
   guest root userspace can use /dev/hwrng as a leak channel for
   guest-kernel heap data.  The host sets a large used.len, guest
   root reads /dev/hwrng, and the returned bytes contain guest
   kernel slab contents that were adjacent to vi->data.  In
   practice, confidential-compute guests (SEV-SNP, TDX) usually
   disable virtio-rng entirely, so this path is narrow, but the
   fix is still worth carrying because the underlying
   memory-safety bug contaminates the guest RNG on any host.

KASAN confirms the OOB on a guest booted under a QEMU 9.0 whose
virtio-rng backend has been patched to report used.len = 0x10000:

  BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
  Read of size 64 at addr ffff8880089c2220 by task hwrng/52
  Call Trace:
   __asan_memcpy
   virtio_read+0x394/0x5d0
   hwrng_fillfn+0xb2/0x470
   kthread
  Allocated by task 1:
   probe_common+0xa5/0x660
   virtio_dev_probe+0x549/0xbc0
  The buggy address belongs to the object at ffff8880089c2000
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 0 bytes to the right of
   allocated 544-byte region [ffff8880089c2000, ffff8880089c2220)

Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
overflow in USB transport layer"), which hardened
usb9pfs_rx_complete() against unchecked device-reported length in
the USB 9p transport.

With the clamp at point of use and array_index_nospec() in place,
the same harness boots cleanly: copy_data() returns zero for the
bogus report, the device-supplied bytes after data_idx are
discarded, and the driver issues a fresh request.

Changes in v2 (per Michael S. Tsirkin review):
- move the bound check from random_recv_done() into copy_data(),
  so the clamp sits immediately next to the memcpy it protects
- clamp to sizeof(vi->data) rather than substituting len = 0, so a
  previously-working but buggy device that occasionally over-reports
  used.len does not start returning zero-length reads
- add array_index_nospec() on vi->data_idx to defeat a speculative
  out-of-bounds read given the malicious-backend threat model
- expand the commit message to describe the /dev/hwrng observation
  path and the hypervisor + guest-root cooperation scenario

Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
Cc: stable@vger.kernel.org
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 drivers/char/hw_random/virtio-rng.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 0ce02d7e5048..5e83ffa105e4 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -7,6 +7,7 @@
 #include <asm/barrier.h>
 #include <linux/err.h>
 #include <linux/hw_random.h>
+#include <linux/nospec.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -69,8 +70,26 @@ static void request_entropy(struct virtrng_info *vi)
 static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 			      unsigned int size)
 {
-	size = min_t(unsigned int, size, vi->data_avail);
-	memcpy(buf, vi->data + vi->data_idx, size);
+	unsigned int idx, avail;
+
+	/*
+	 * vi->data_avail was set from the device-reported used.len and
+	 * vi->data_idx was advanced by previous copy_data() calls.  A
+	 * malicious or buggy virtio-rng backend can drive either past
+	 * sizeof(vi->data).  Clamp at point of use and harden the index
+	 * with array_index_nospec() so the memcpy() below cannot be
+	 * steered into adjacent slab memory, including under
+	 * speculation.
+	 */
+	avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
+	if (vi->data_idx >= avail) {
+		vi->data_avail = 0;
+		request_entropy(vi);
+		return 0;
+	}
+	size = min_t(unsigned int, size, avail - vi->data_idx);
+	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
+	memcpy(buf, vi->data + idx, size);
 	vi->data_idx += size;
 	vi->data_avail -= size;
 	if (vi->data_avail == 0)
-- 
2.53.0

