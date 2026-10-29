Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281835;
	b=h6Pn11l/h6M0BR/GOWiAWptZOJJl2pdKRhRjnM7RtZaFJve5SLJOoBaVKe64/PR4WGdw
	 VAGdYcwIrgaaN9eynK7Fojhzx+orPUSfhk5AjZGZAUsJ6W+ZS9wlpkX0A2OzFnfHzJ37b
	 31hFQ/djOEa+MIEg8OP64UY28AS2njB2WW2YQouyNTB4cgvWLmn9/iZw6JUt/vuBOtvYe
	 irPthBzxgCgoy15tUxuQuomrHfBBeceXMCKh5eG6F6oE2LHW7noIpreymsXCiWhamt4aV
	 yK+18YKvOPlpI4bRql4HpKPSRzsBBhAGnHjXDtRPoCayX5/dHTfKmSE9Q5M3WfTir+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=L70Byn5v8ZFkrMF0OAudmvIVEZ2EuogOofsD9gsL04E=;
	b=k8wJdiixf98pZi3Sp+GXtV1rd93ZCOroEJRiz9E8/GdOm9xn2rJPbkUdWBCsSbf/zicR
	 D0chJ6ZgCPk5lnW0Of30PW5N6UQEpdlafmPVMnAn1lOmoaYvosp8QoTlRe33Ja4YMtVRw
	 VRlrXEyUNqFOmdTCTBhvRI6KMlf02zeuoqhrHBFXgqhghTKPVwprf6BSQb9iAt8pcDPGn
	 7iCRgIpyozATzD5dYadTHl9qBmdIJIxe8k43jJ13lMAUBPdzFjh/7ci3Mz/rc+Z2Z6wgv
	 shVGu8GOA/IhM3m4ohNzxj8O3U0Ir6ORIRiMpP/6SJVA93ZgvMx3pkVjgwu4/u8P1HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zuqno8QW;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86EF606A33F
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 13:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C86EF606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zuqno8QW
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a2001e85c8so15919225e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281833; x=1793886633; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L70Byn5v8ZFkrMF0OAudmvIVEZ2EuogOofsD9gsL04E=;
        b=Zuqno8QWGdM4HcfmTqzXaTvYRoQXFk8DU6M/7++6ldWU6V7snx6jc/xDwcJkDo0Z59
         FOYwOzLbPkjIHCmOEy2dM3SH0J4vMM97Q7IPAltISCQninP84XnasYbk/IfFEG4/7ynq
         AY2U3/HPYg3qzb6pMIQrLZs71UUvuu8o8U2pVfXTtYnCfYp6rRE49IkAB0WcEQaQZ9IS
         Z8sceOO4WjdOngdWsJ7yKk0RBA2fjYa5tF+W3f4IAzWPUzzXTjiPbXXiwx3vG8qh125D
         wVkSBrwwdiVzZkspQKlsUzPlk2Zj3XdGjFkOD/MDi7egwMdTG/SxOEnFOi+5YJKTJoPK
         uurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281833; x=1793886633;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L70Byn5v8ZFkrMF0OAudmvIVEZ2EuogOofsD9gsL04E=;
        b=WOi2QBtGpCv9+DBcQEGZOEc2WZKJhAcB4lJAwmf3XPxhGH640QEgymQkjoPHwhxe3/
         XbooHfjHSpGR80IpXA+BnkF8ejoCOjcqspt+DH33FNv0ki+vJ31SNtvuX9fvVs6/zpjN
         EY4HPQX+ZazZKxEJ/hMtpC3uLt+OjRJHPSuv5+eoAZF9zBby0IxJfmina24qXWVAnwZ7
         qcsi3mCAXGyq0Up/v25crPsc1uLV2LJszciMBaU8JecepnLzDjj1a4Xl/qbSsTt0k98+
         S/ml7TXZdHH7q+M0Dt1IjNffbHGIURE74kMsIIQA219sAl0fx4pvoGntfmpL5D0d2aDk
         2KvA==
X-Forwarded-Encrypted: i=1; AKwUvByGqyFjad4CXC8v9J4WhHxba3607DrvHKhUQmaZcdMQnMvmO7As9hUeyeb6hSHrXqF9RPd3c6ML/68PWO0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJsWnb+QxGyzzXskhF4+fmd9sN7cK2ryI3xOJZ38ihYsHbtzDcy
	pDpmRlkOnifPmCxfo4HFojxISNMsfA57FSxdTZfZ2cLrbP+LzTDC+59/oATF0beO14kalvd9ZA=
	=
X-Received: from wmdd24.prod.google.com ([2002:a05:600c:a218:b0:4a1:e51d:9268])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:e493:b0:4aa:2339:a375
 with SMTP id 5b1f17b1804b1-4aa2339a4a1mr77860825e9.13.1793281832038; Thu, 29
 Oct 2026 06:50:32 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:50:20 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029135020.272082-6-ardb+git@google.com>
Subject: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Recent Clang has become more finicky when it comes to overriding the
type macros that the freestanding stdint.h consumes when defining the
uintXX_t types, and so it is time to finally get rid of this entirely.

So instead of making stdint.h (which comes from the compiler when
-ffreestanding is set on the command line) agree with the kernel's
linux/types.h header, avoid the latter entirely in the compilation units
that actually use the NEON intrinsics (which are always leaf functions
that are not tightly coupled to kernel APIs).

Note that the disagreements are about long vs. long long on arm64, and
long vs. int on 32-bit ARM, so never about types that actually have
conflicting representations.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>

Ard Biesheuvel (4):
  lib/crc: Don't include <linux/types.h> in NEON intrinsics code
  xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
  arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
  ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h

 Documentation/arch/arm/kernel_mode_neon.rst | 10 +++--
 arch/arm/include/asm/neon-intrinsics.h      | 43 +++-----------------
 arch/arm64/include/asm/neon-intrinsics.h    | 24 +++--------
 lib/crc/crc64-neon.c                        | 10 ++---
 lib/raid/xor/arm/xor-neon-glue.c            |  3 ++
 lib/raid/xor/arm/xor-neon.h                 | 16 +++++++-
 lib/raid/xor/arm64/xor-eor3.c               | 15 ++-----
 lib/raid/xor/arm64/xor-neon-glue.c          |  5 +++
 lib/raid/xor/arm64/xor-neon.h               | 31 ++++++++++++--
 lib/raid/xor/xor-neon.c                     | 16 ++------
 10 files changed, 78 insertions(+), 95 deletions(-)

-- 
2.56.0.313.g2479322e68-goog

