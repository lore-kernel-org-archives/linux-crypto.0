Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49672331202
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780237397; cv=none; b=Uan85O6MagtKrweeGvU0xjaobo8qIicg936CF2mqXiJ+ILqLikpcb4x945oAhKYkiaHuibMbYoyRfyxUv6GQvNwBxLSltdsW3zIZL2cUj/uCCfrVRJjst1EjRziKGO2LknD+KpmWx0ibMB2RMQaNnYJMwinhJMuhEFtmyhc5pUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780237397; c=relaxed/simple;
	bh=9z1lDO7WVRwOEqS8leOsAWQHA9GkNdjVjksm5OmCH2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JYg+l2kFSUCZgL9MwAyrmzV4d02q42zHb/Ie7vUyO+cpTNlnc+mpjxI14r61xIb2JIauN291rkzSnQGv7QOnzEOZf/0+j+J8qxMpeRxWTn6v1j+z2BqaWwreXWoyM4ZIv1lrFDMLkGArGH++2jTsSGyxR/eHM9wCe5nsuz3OwHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evm6D9YD; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evm6D9YD"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso36314886d6.2
        for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 07:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780237395; x=1780842195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qDDIR+RflfCxQnybr+lZETyzlWzPcM4iBOlWecmvA2w=;
        b=evm6D9YDcOxEMYOJT6+jJr9WxBaMYoXykx5xcHyzNYaau1b1F//f0CC4h3NPVVbD+C
         WBeCTD92tq1jwMVS7rrKbPpRWOSTCyMHY8c8HqyAe6B36YcKoK8R0pCHFMcofqEbwAhK
         kJOjtvybHQAPUNkAIj6y8TlI4X931twpv6SfaP5MeMx2isrdiOpJ0XVI6dw+zP7gL47J
         IB9K/tLaw2qA2r6YggCdATWoUSdGDT7zLqDVrhF+1m1Mdo3xdm8pFK9yT/vsKRhzaTxT
         66J09hbm/bPeOXgWn1ets7qzq1ptN9GDHSPg9VurW40Po6az0ItkxW6zVruuQR7iUa+R
         txyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780237395; x=1780842195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDDIR+RflfCxQnybr+lZETyzlWzPcM4iBOlWecmvA2w=;
        b=L5zJsoUlLxRAlNIdZz6OEjOJifw1sspygy6CWLnDmjagKWJb46Vx4B/nQAJ5y1SwnG
         l22ePUioWG3wO/fOIVt7MrvqIuMxcFXlsdxOBLOcl7BmcuPNkYrUK8NUV4lez22GHtb3
         OlfYX/AF873QdjEoqGgI11Yo41JLq3h3AoIHCSEZQ12K1aDEaaF9BtkIbGL9xPa6hpio
         tjjtRLa3Zyc6NfcKXGcaXa2SEahE7pYc2cFo8eQLJtmrvYGEkaUdm7pfKHDVcgki8VLi
         6YFR74cBKSFyg7uxSxQKGms/Hx7k16OPoGp8sJ/ieA7L28Xug7GGHKOisdqS58/mRxGf
         ncdA==
X-Forwarded-Encrypted: i=1; AFNElJ9gYAjaFP0TzZ6JHr+2uAZTqjnV5rCCqO+2vUVjpHIw85fvJm2XfxYHeUxVff/zSBdPnmKsOS3Hn/+Jsd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7P5ZaYLnrMV5fWEzeyG5I/4DpTXXSlgfY2+omA+9xD7yEsMDJ
	RmEXbtDnuT9/F06ZLUNFCHLK1bTcmXvedWR6TT7xX0CyCLSygQc+a/Vb
X-Gm-Gg: Acq92OEEHAWG1bTPwKl9L64PQfIQFwjcroIFPoJ2M5qB+IGqz8txNpYWYMRPctMIqVv
	AudUa4m98DGOzfhCw8kSvfmBNVLhRJUqu6VWsMc64BCVXVip+tPBwXzNdlf3eMnreIcoo3IDgRs
	kaxKLL6/osvfKYfGe0oG+Eg0kXhYvywtGpVeZNmHLbBT4k/3mYdkQJ1s6/Pz9OsoNNi0SHAUOdo
	W3gR7xKekjaXcuDJp57FHj6IwYVdUXxoier0o/iFI1o+m85mXfLRoYf7aJ7gxt1bGrMWXBJ6xJr
	x5N3WwVej5BAKSBC9Ic3LPMJawyVOmBwUdPaVWADON1ZCtLGgfLt0y79GQ+HWWno+6U96m5+xi/
	aD6PSZ5LtubCMoRi9OtRgemx+E/WwXf29ZjtXvoWBG0p9hnGxV0KdW/iquWEy2WE4L/4OND5/bg
	dvHI9FmATR8OT9MfZ2l1O5hfIkXQthJKuWd3kkjiKmxdqVWGiZnZF1N5ILxSH8PkwXMi7ht/BW7
	oOe1Yqoy5qGZiXKxNw/aJ+sF3j5QC8=
X-Received: by 2002:a05:620a:c4d:b0:910:db3a:7bdb with SMTP id af79cd13be357-9153d9fa2c3mr1132560685a.32.1780237395122;
        Sun, 31 May 2026 07:23:15 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153249370csm769221285a.19.2026.05.31.07.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 07:23:14 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] hwrng: virtio: clamp device-reported used.len at copy_data()
Date: Sun, 31 May 2026 10:22:51 -0400
Message-ID: <20260531142251.2792061-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

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

KASAN confirms the OOB on a 7.1-rc4 guest whose virtio-rng backend
has been patched to report used.len = 0x10000:

  BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
  Read of size 64 at addr ffff88800ae0ba20 by task hwrng/52
  Call Trace:
   __asan_memcpy+0x23/0x60
   virtio_read+0x394/0x5d0
   hwrng_fillfn+0xb2/0x470
   kthread+0x2cc/0x3a0
  Allocated by task 1:
   probe_common+0xa5/0x660
   virtio_dev_probe+0x549/0xbc0
  The buggy address belongs to the object at ffff88800ae0b800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 0 bytes to the right of
   allocated 544-byte region [ffff88800ae0b800, ffff88800ae0ba20)

Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
overflow in USB transport layer"), which hardened
usb9pfs_rx_complete() against unchecked device-reported length in
the USB 9p transport.

With the clamp at point of use and array_index_nospec() in place,
the same harness boots cleanly: copy_data() returns zero for the
bogus report, the device-supplied bytes after data_idx are
discarded, and the driver issues a fresh request.

Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
Cc: stable@vger.kernel.org
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-8
---
Changes in v3:
- No functional change from v2.  Reposting the v2 clamp after the v2
  thread went quiet on linux-crypto.  Michael S. Tsirkin reconfirmed
  off-list that clamping the device-reported used.len at
  sizeof(vi->data) addresses his earlier concern, so this resends that
  fix unchanged.
- Rebased onto v7.1-rc4.  copy_data() is unchanged since 2023, so the
  clamp applies as-is, and the KASAN reproduction above was re-run on
  v7.1-rc4 (stock splats, patched boots clean).

Changes in v2 (Michael S. Tsirkin review):
- move the bound check from random_recv_done() into copy_data(), so the
  clamp sits immediately next to the memcpy() it protects.
- clamp to sizeof(vi->data) rather than substituting len = 0, so a
  previously-working but buggy device that occasionally over-reports
  used.len does not start returning zero-length reads.
- add array_index_nospec() on vi->data_idx to defeat a speculative
  out-of-bounds read given the malicious-backend threat model.
- expand the commit message with the /dev/hwrng observation path and
  the hypervisor plus guest-root cooperation scenario.

v1: https://lore.kernel.org/all/20260418000020.1847122-1-michael.bommarito@gmail.com/
v2: https://lore.kernel.org/all/20260418150613.3522589-1-michael.bommarito@gmail.com/

 drivers/char/hw_random/virtio-rng.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 0ce02d7e5048e..5e83ffa105e41 100644
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

base-commit: a1f173eb51db0dc78536334729ef832c62d6c65a
-- 
2.53.0

