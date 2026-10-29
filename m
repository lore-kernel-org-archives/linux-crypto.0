Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281835;
	b=Uh3BOUKBzmxCdBW+/a1vKoVXqXaOoKR8enRhZN+ZB5D+1LLxRCuGjP3OOiHlhV+sLTSV
	 0D6Nb2yKuGO+7waZhXRtzVhFLHWerobMRrNnJU0q7MMlo4FNU7fo6Iut8f6Tn2CbwrsRl
	 IHKRyE+i6D57LK4XWETadTcRzFmU/0ki7yYVpUBLy4ygm/VuPnOT2dQkW7KpvgnJoaNkJ
	 mVgHjVrt/0bowccaj4UxY+mXgZzSXNHvS15ptJ6xp37v0SX1QeCbtTO6TCx5L2juYe0P0
	 LTfPczY3mj7NtoGjCNpaUmfCDHVqdex2a/hPsrlN2BWgq6A34wGOiMlHhnTt+EpaO9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=WZCcOUUIhCEQ9Fj14Fk6W+WsOHHcMABIP8ZRGfIzWVM=;
	b=HQqRfsO2+nwya6qJ8/ajjZZYj+pYXQR2R4ue7m5u7aRTm9LgH+PJEFjmGNPNhqE5US5b
	 GgXX6t3Ra6E9Kqz0iyON2qVGR+bYY4k2nWa9hpfIlnUszmZ8KcLo5IDVKkBELu1Wiz2Tt
	 qXi8vgK1zocSyaONc7u1gEMeZa4BYjROEa0zKqQntwShzlGrIzz+SKTWJ74Ne6BvMqcSv
	 2js7RH+svDK0jKoQphv5XjwHW+L2KhBzjGm22ZsMks5yYLxVH/guhVhhTPr2zuaYzSQek
	 u+VKM3LupRwIgKodEckvycmjz4Q48nG9QLjdn7jUew/8W5tRXM4SnxS102lxEgNzt4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IqAJaMq4;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7928F60A260D
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 13:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7928F60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IqAJaMq4
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e00f3929bso481435f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281834; x=1793886634; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WZCcOUUIhCEQ9Fj14Fk6W+WsOHHcMABIP8ZRGfIzWVM=;
        b=IqAJaMq4BV/Ll2fiQyMHuL2nK3v64E+DdyblAjWICx5rYZobrR9NQLIdooBP2V6bwC
         rFcOrJq5cDzofv/YEDzeNlZiPSNn+BeyvWRo0q6GJva3nU5/pahAsfIwy/02LIoFILao
         1IfraPy77kWM6gS2vVKPHa3XDif+Hs1FLghni6Mq1lIdVsXdcNDnfGCITqcXGfplmAa/
         Uf4uSdQ0N8hH+hasVomPX4Su+limB/IXN+TZ6vS1TYLZtPO1bnFuR/k29Vv6CFTU3Sxk
         WbHaS62sxVw00Z5TquImrGgzVlJMiTMVwwIEPYPcvHQeBrITPOqQWH5QYqlU+mgsERtH
         JjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281834; x=1793886634;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WZCcOUUIhCEQ9Fj14Fk6W+WsOHHcMABIP8ZRGfIzWVM=;
        b=AQ8eIf46bWCPyffr4AMjyuDLQdTnar/eT76UPGkzPFezxlDt7UvrkiQGtXqzq4ZJJ3
         S0YtDrM87dhWnLft269RAomf//puk16tVJ04a9DrKUpXzlqIcGVBdme8yXb5ctAGEfp0
         WAS/h1aasUEdS9I56+9IB0AwRF7MtXsjPRGixa0BXs617rT959cc1Y9QA9RKco08GE/+
         ZhvPD03YLi6m9BUsZgu+Ul783lCgdFIXwWL+gZ48BRG+OoJ6ac7SONHygQEQCbN0VESS
         s4r6ZABpBQbM/P7bCxpnROajIhx4siEAhBz3YyX5Nmqx2ZVj1ENj5dO+mV7fvnEnKwlQ
         Q9hQ==
X-Forwarded-Encrypted: i=1; AKwUvBx075YcFG/XQjqraF7h1TxYLByM3cn1MloM7Dr1q7A85BXqCypRYBWL61eDMLFq5wwvnYUc3maBzJ0kwbk=@vger.kernel.org
X-Gm-Message-State: AFq9FYJaJCmEFD7qywZAns0pN7+2FhHt/mfazV8t1DSkL05ag3dPahZR
	MWtFNOe0kQCW8tb+48B/kLlC/g2qpDqII+G/HA6a39lzRHvUemZFc1jv9BBTPDrd2NFxZGSSEA=
	=
X-Received: from wmcq2.prod.google.com ([2002:a05:600c:c102:b0:4a1:d8be:ba51])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:540f:b0:49e:65f2:db64
 with SMTP id 5b1f17b1804b1-4aa871e8bd4mr66653385e9.5.1793281833756; Thu, 29
 Oct 2026 06:50:33 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:50:21 +0100
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029135020.272082-7-ardb+git@google.com>
Subject: [PATCH 1/4] lib/crc: Don't include <linux/types.h> in NEON intrinsics code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The kernel's definitions of uint64_t and int64_t in <linux/types.h> are based
on [unsigned] long long, whereas the ones provided by <stdint.h>, which is
included by <arm_neon.h>, are based on [unsigned] long on arm64. On 32-bit ARM,
a similar mismatch exists for intptr_t.

Including both into the same compilation unit currently only works because
asm/neon-intrinsics.h overrides the predefined macros that the compiler's
freestanding <stdint.h> uses to define these types. In order to be able to get
rid of those overrides, stop including <linux/types.h> into the CRC64 NEON
intrinsics code.

Instead, use <stddef.h> for the definition of size_t, and rely on
<asm/neon-intrinsics.h> to provide the u8 and u64 types used in the prototype
of crc64_nvme_neon(), which is shared with code that does include
<linux/types.h>. Use uint64_t for the arrays of constants that are passed to
vld1q_u64(), so that they match its prototype regardless of how uint64_t is
defined.

No change in generated code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/crc64-neon.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
index 4753fb94a4be..1267df1310be 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -3,7 +3,7 @@
  * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
  */
 
-#include <linux/types.h>
+#include <stddef.h>
 #include <asm/neon-intrinsics.h>
 
 #include "crc64-neon.h"
@@ -11,11 +11,11 @@
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
 /* x^191 mod G, x^127 mod G */
-static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
-					0x21e9761e252621acULL };
+static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
+					     0x21e9761e252621acULL };
 /* floor(x^127 / G), (G - x^64) / x */
-static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
-				    0x34d926535897936aULL };
+static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
+					 0x34d926535897936aULL };
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 {
-- 
2.56.0.313.g2479322e68-goog

