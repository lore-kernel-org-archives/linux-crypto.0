Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2749F33AD88
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781455223; cv=none; b=JpLQRAVySsQTJs7UXYKg/ivgIFEAsQwJ8xfDkL1CnusSOmNuqlCRa1Jk8FXeOSZJvsUdDUmQX9tYLGo0pzKrEJYsolYDsskzM1CEnpWV+VEuhMYzsuc6Fkt/fmS/hvuxgnCz8L8rUdMbyP9GC098wtppLRskmDLiuptCM4VRYis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781455223; c=relaxed/simple;
	bh=Fl17u2X0k2HvhstQYApk5Vd2HHVjRBxN1PcydW4xlWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kKBIPJRPYAg5Bw1FZjT3JlySSuXXFKPUQfJqy8hnxNiivo1ZWx0iZKmHMafA73SQE1AYDsVOzL1AGxgkEAIJKv9YTdCi7thkAOXeIeYRi7aC8fL33SRIUgt/QS5KQeR64hC+4mbwt3ofnNbZ1qZlPIocbt+VQM4+sPBgGcuJK7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGtnGZWB; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGtnGZWB"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-91562bf6c12so308705685a.2
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 09:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781455220; x=1782060020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zBJHi5Hr1M/eo0hWqSi34rs7l71h5awOF/MLLNcZ4ic=;
        b=PGtnGZWBylMpEq0pzM9nvnQf9AtZRY7ncMk15RVDaISATkdYtNoPjBpjFea2NDWCOt
         Ahm94pGW/AuBemFpWofRbG65b0uHr+fKQ+pfqFp+8X2gQccjp33jekQrn/I1AcZFFFuJ
         TVMjFO226irF4Dh6gVYnfJSlE8OIZYC0XHbI/nEdKBWei3K1n7O5X0q5EwraOHtFOo0A
         09DWeSqEoTIl/ARCQl90uy0cYrrPc90TEutTCeKe1wcU1ieoyfQ941M491CKjhdxQvSZ
         78QDO6scT1T5sDLG3OU/7Ll6fku03xhjWrE630IuyVMbWRnWunN+LCYClmTiO+MmMkA5
         Z7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781455220; x=1782060020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBJHi5Hr1M/eo0hWqSi34rs7l71h5awOF/MLLNcZ4ic=;
        b=j1j6YVhZ4nCSJWG3k8oYkt4yo64G+zFVm8ppR/ZLsD5BLyFt9PhxkInEQbNcLTjjKk
         Gld5OGb34z6TzHzB8YdAauVTWKkd4ZAo2CgxMtJarLc4BYfl7Q9e7XryYdlivOyfyMVH
         T4PPa3IhHRvpBIEVDnHA8y7eREeLajLusnNLYLBv873CK9akdbz6sj84+foYK9JiGe4x
         wQRDlMOHDamc6/UoFz6AUZm1YWeJinqGF4NPXxweS43Dg98iaIYms8zsILSzHyMa4SqM
         A7ojBiEk3gWMU/2bc8QKMFt66l9EQJL0S5nXqg/pUaHlg4NBnoPXTEvL3j7zjtP5UZfh
         QwpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/KNzVkOL5hyhTBDYpO9ff7880QujJ6C6xfYIDx/zT4R6iBPD78hMldxXUpp2YPhb9A6CFuhFuNchxZ6tU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMKhUI9mHC9E5zMA7RO0XUXt5Sx1HsYnA3GT+3hjo+QR5lBsJz
	f8v3tp75rDxjc2Nz8A/yeyciIhs9X3OHPGus3Hn92xWBuPCin9pyFy5y
X-Gm-Gg: Acq92OG1Fii2wNCcHeu8pAFfyWnMrG+h5jRqsLy5lYEU1yED4uiUmkdkGuUO1qptoT4
	BH/qJin6hKhotJnyStzSDeZv8ujXPKIemJ5D/jihpJ4ioISh96uMAASzUK3t+501vj2/qAehSqV
	17uPs2mkDy8RQlaNvxn1Kjh1akJhY20mbMveT0p2iZjvjy3CSV/EZlx4cD+BpA8WcZH8EH4IzIa
	TvGYyeQpNbO8fyYhz820sqGU0iABdhkjekF84gfESUSWc6xKMnBGowUV2uO3cvxglArrq+YSSnd
	vv8aV7sxetYW11anvSIJ8U9Th275KoE4V8IZJsv1lGefHppUz6TR1KM9NdXp4pijK64tzYifxbD
	GGegXgGsGrdiA3Nxwi0QE38gfYN941YTv6yYdNbXYH/1ELmnWjY0g7buynGRvb1k6+fI6VDd0mB
	WvEI9LlqKp9Xi8oV5OI/sZ6VmqahctWIH3c/JZFIyNyG8DSWkakHDg6pAU8ejskh2upqMEUTVqy
	4RIP9WFNxGPbJ13map8oRcIIDJ03Rd5KfvMgad2np0=
X-Received: by 2002:a05:620a:390c:b0:915:cf88:1e3b with SMTP id af79cd13be357-9161bf722a8mr1707654585a.47.1781455220006;
        Sun, 14 Jun 2026 09:40:20 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f1c851sm805290585a.16.2026.06.14.09.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 09:40:19 -0700 (PDT)
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
Subject: [PATCH v4] hwrng: virtio: clamp device-reported used.len at copy_data()
Date: Sun, 14 Jun 2026 12:40:00 -0400
Message-ID: <20260614164000.3343777-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

copy_data() trusts the device-reported used.len stored in vi->data_avail
and memcpy()s that many bytes out of the inline vi->data buffer without
bounding it against sizeof(vi->data) (SMP_CACHE_BYTES, typically 32 or
64).  A malicious or buggy virtio-rng backend can report a used.len past
the buffer and steer the memcpy() into adjacent slab memory;
hwrng_fillfn() then mixes those bytes into the guest RNG and guest root
can read them back via /dev/hwrng.  No guest userspace action is required
to first trigger the read.

Clamp data_avail to sizeof(vi->data) at point of use and bail if the
running index has already reached the clamped bound.  Same class as
commit c04db81cd028 ("net/9p: Fix buffer overflow in USB transport
layer").

Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
Cc: stable@vger.kernel.org
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-8
---
KASAN on a v7.1-rc4 guest whose backend reports used.len = 0x10000:

  BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
  Read of size 64 at addr ffff88800ae0ba20 by task hwrng/52
   __asan_memcpy+0x23/0x60
   virtio_read+0x394/0x5d0
   hwrng_fillfn+0xb2/0x470
  located 0 bytes to the right of the 544-byte kmalloc-1k region.

With the clamp the same harness boots clean: copy_data() returns 0 for
the bogus report and the driver reissues the request.

Confidential-compute angle: a malicious hypervisor plus compromised guest
root could use /dev/hwrng as a guest-kernel heap leak channel, though
SEV-SNP/TDX guests usually disable virtio-rng.  The memory-safety fix is
worth carrying regardless.

Changes in v4:
- Drop array_index_nospec() on vi->data_idx (and linux/nospec.h) per
  Herbert Xu and Michael S. Tsirkin: data_idx is driver-maintained and
  already bounded by the check above, with no demonstrated speculation
  gadget.  Clamp unchanged; KASAN repro re-run (stock splats, patched
  clean).

Changes in v3: repost of v2 after the thread went quiet, rebased onto
v7.1-rc4.

Changes in v2 (Michael S. Tsirkin): move the check into copy_data() next
to the memcpy(); clamp to sizeof(vi->data) instead of forcing len = 0 so
an occasionally-over-reporting device does not start returning
zero-length reads.

v1: https://lore.kernel.org/all/20260418000020.1847122-1-michael.bommarito@gmail.com/
v2: https://lore.kernel.org/all/20260418150613.3522589-1-michael.bommarito@gmail.com/
v3: https://lore.kernel.org/all/20260531142251.2792061-1-michael.bommarito@gmail.com/
---
 drivers/char/hw_random/virtio-rng.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 0ce02d7e5048e..7413d24a67a9d 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -69,7 +69,22 @@ static void request_entropy(struct virtrng_info *vi)
 static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 			      unsigned int size)
 {
-	size = min_t(unsigned int, size, vi->data_avail);
+	unsigned int avail;
+
+	/*
+	 * vi->data_avail was set from the device-reported used.len and
+	 * vi->data_idx was advanced by previous copy_data() calls.  A
+	 * malicious or buggy virtio-rng backend can drive data_avail past
+	 * sizeof(vi->data), so clamp it at point of use before the memcpy()
+	 * below can be steered into adjacent slab memory.
+	 */
+	avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
+	if (vi->data_idx >= avail) {
+		vi->data_avail = 0;
+		request_entropy(vi);
+		return 0;
+	}
+	size = min_t(unsigned int, size, avail - vi->data_idx);
 	memcpy(buf, vi->data + vi->data_idx, size);
 	vi->data_idx += size;
 	vi->data_avail -= size;

base-commit: a1f173eb51db0dc78536334729ef832c62d6c65a
-- 
2.53.0

