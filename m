Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795767071;
	b=5U1mHOTiJCbFkx+3nD9DHDHubA+aTJmCCVES4obpV+ZG7+hiHC4uuaTAk2xwtTMRXnoB
	 1gN/cG7JR0YIZ60If3iy2kx2YwFUA3uv7bF3O5GLEMuv5XWx9yenRZMzKG5RK8WfMvNZn
	 NYaMCluuFX+ZhmFa9ITOV8+D3JnqIhRnSWNaYqdkcOwxIkNruXCXhWPt02mbd8EptAaN4
	 b48rPmhvFCB0G3x4+b7UlM4PPKLcgK3duDiZgRKg7b5r3f1LjRV07I3XdVm8/Pc8tollZ
	 FnyUmvPXKwkIwMFBt+d7FGEuddNNkGj92hFvv5/cyQ4GUKbZw7li4Hgr3Grp0n3hcIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795767071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vJH/+bwAYrknt5ggzmxUwQOnnQMN1PCmldtA01IpSCc=;
	b=JOu+mvSkEVbP1hMCUx281Kc1ivZtKUWt9k4kt89QgdpwQfoh9WtBeb73WYabGT/umKs/
	 9F94GI2Am/28GN7CbmFxfEo9uc7w7IJtD+N8y1xuhrAe8f5uJAeqL/tnypeTkgPu9rts9
	 vOCsGd8vQUru2TGOeQHhtY037oav50RdLk5SkKFwXUwwK5tQ14c7mZCE88a6twlRwwXvO
	 XXAo/tGLbCwCiFIaIgg4MoA22oNaqQor5XoZiZ+KxmqKQyCG5vo22WIQJJuKqYOHXht/J
	 AgfwlMrh32L6vaWViH4yrLJKkEXh1m1AB9+V75jSwoOCg5upinrA9bsk3su3CmpK8XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rFxSjTVc;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126C606A329
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 08:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4126C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rFxSjTVc
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-38431138772so10139290eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 00:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795767070; x=1796371870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vJH/+bwAYrknt5ggzmxUwQOnnQMN1PCmldtA01IpSCc=;
        b=rFxSjTVcod12OYqSxSq7QF8z194ZntGPxmCYkbvFrH5o9bkYBXmtf7WiElTlbZPHZW
         AR2ItULjFzlrAq9ZbTzRNvdi/B+dfo8i0ZJ5LLFP8XL0cUS+WDwniwjpKMJKrcMvz4WQ
         GmkL3Im9e+ctjbRss9UAKMBaOJ4eIVuKsO6+RtWQwiKBxeaof3z5oGyLBM5TQ5CABISU
         U0Ywu8lCHqGxjBHqtiQt+3s+3Vnmtx79Gkf80DVL+UkBnawvsefRpAiig8xgmV/VnCMM
         /EmgHt+3X6o1lqLWfGTmTsDGzGzRyrhzxL/GF7YY0ezZW9KnNGrSraVLIgaWH8REy2gO
         cyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795767070; x=1796371870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vJH/+bwAYrknt5ggzmxUwQOnnQMN1PCmldtA01IpSCc=;
        b=iRpDTEiK4pYlwWtTZXGEcP6RKUxde09QjAzpSmJTu53aogJXulP9IV2Cp88zeF+l0A
         PJTw6tHs5Tmxh6hMZcGwzqbzUP+Pdc1P78wwPgQPUwzPun8AFCRqvppIfvZ+Mi2Ny9Uf
         8CoFpneWkEh5Xg/Ohoumcrs1krGXcFYnNK4z54H9b1T1nGsTsOi3TrS6ebfH7tRBj6/5
         mggTWL5vPUqH74pJe6cMjFurL8wxOM2TUIsMrzZnUPqLS97lO6QQMTdQMXqs3w0bzlXR
         +uWHIwCVywjihqJ8B954N6W4VKTD7X/RrFi6CjePIQ9TCMGY9sCqku+pRQbBFdQKQRdV
         uFcA==
X-Forwarded-Encrypted: i=1; AL+hErEotC8Sde83EtHcyl0No1cSdbRXor7KYJ0WB5moAIPBewDgq2PyfScajfgMt+9WmHpwVe11uXnMv3gAUEY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/e+JviH6sHvnOtlqIpFKRxcZqMMWQryA8wkD78Hc8cMo+CXu6u
	9mQmF891wwqNVL9PP4KlD4ZIqr6fWYAqqFmQh6kuF8MRwujCTSVtfZ9d
X-Gm-Gg: AZFdTZebzBZhBDOSrGpN3npAEmsCs4j1CiJV66YA7zE/kl0nbPMBzSpq4KIOON8kRRd
	OFwV00aLYIqWCdIrq/qWC8/14cWG6yV77Dq90YpyMvKuggZluNhGffo7mRjidShnG25Y9XKhE33
	FTbbnOd590eEua/BjAU2VWjZ03mKaKNeMyVnRn6SXH0ZTaWpr77UpkOkXljXwMQFhoX4/RcoPOW
	YiBe8uqHaNeJonpAsJhNqUi25Yz+Xz9N0JNuCjdBRsFNy4S0gIWPFRiAriiaqCDt5bze1GB6XS9
	nWN4sPaFQO7brGne3gmePcxLRTUSPqynYupvpdDSdixQmuYpGmrYp1WMICxvHQvfgJQ+S4hZXnK
	R8tSCYD6LPdd2dPaaH8SJODKkW8M208Rt2zwWo/ZbRmvaEi2jQKmtOvfjRSl+buImMOzQAImjJK
	OlyhUCtBep7C1L+sz2BNHxxKWHia0vJxKUv3tCbBZPjjZUqrX07VtfATThpVLDfNKbMsyag7mMY
	bViaSwYylPWTfY0Q923yA0UH+ZGx/bdbwKqYxyXu+JfaMNenA73UMaRRVkOF+0J90BDDuBw7oh1
	AQe8duwVYtW9ZkSMOVAIl0xQMKynqg==
X-Received: by 2002:a05:7300:ac82:b0:385:4b9:18f2 with SMTP id 5a478bee46e88-3857093f077mr35349467eec.21.1795767070240;
        Fri, 27 Nov 2026 00:11:10 -0800 (PST)
Received: from fedora ([2401:4900:8898:76e7:b41a:e5d0:b45:7cf9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aa203267sm39746815eec.0.2026.11.27.00.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:11:09 -0800 (PST)
From: Vedant Dave <vedantdave354@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vedant Dave <vedantdave354@gmail.com>
Subject: [PATCH] lib/crc: Fix kernel-doc for crc32init_le_generic
Date: Fri, 27 Nov 2026 13:40:01 +0530
Message-ID: <20261127081001.327898-1-vedantdave354@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kernel-doc -none -Wall lib/crc/gen_crc32table.c reports:

  function parameter 'polynomial' not described in 'crc32init_le_generic'
  function parameter 'tab' not described in 'crc32init_le_generic'
  expecting prototype for crc32init_le(). Prototype was for
  crc32init_le_generic() instead

The kernel-doc comment is named crc32init_le() but sits above
crc32init_le_generic(), and it does not describe the @polynomial and
@tab parameters. Rename the comment to match the function and
document both parameters.

Comment-only change with no functional difference. After the change,
kernel-doc reports no warnings for this file.

An AI coding assistant helped draft this change. I reviewed it and
understand it.

Signed-off-by: Vedant Dave <vedantdave354@gmail.com>
---
 lib/crc/gen_crc32table.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/crc/gen_crc32table.c b/lib/crc/gen_crc32table.c
index 9a7f31658..b9ec94a68 100644
--- a/lib/crc/gen_crc32table.c
+++ b/lib/crc/gen_crc32table.c
@@ -9,7 +9,9 @@ static uint32_t crc32table_be[256];
 static uint32_t crc32ctable_le[256];
 
 /**
- * crc32init_le() - allocate and initialize LE table data
+ * crc32init_le_generic() - allocate and initialize LE table data
+ * @polynomial: CRC polynomial to use
+ * @tab: 256-entry table to fill
  *
  * crc is the crc of the byte i; other entries are filled in based on the
  * fact that crctable[i^j] = crctable[i] ^ crctable[j].
-- 
2.56.1

