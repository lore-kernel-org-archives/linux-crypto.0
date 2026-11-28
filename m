Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840853;
	b=aNbdITYMoeW1hYWEDt8QjZSU3kxhRJ5+u8BnsjW70efG7Vtm0XoRDLygjHwZnk4ekBUV
	 23Tc7etv4UbIcpc3vZJCyTdW+ek35URsChoj55f4rYT2ZEFP/3DxdE5JNlsOnW+JVgTjF
	 JyZ8cGKl12DRZKPFgdVc7MAbxizVG+2BExbpVtqkBwEjd56Mlk9KEEUyAsHsp6z4d99sS
	 RYXLKCv2oVegkuxmYdQ3mG5nLP8UG4Qv7Ow1Eor7S0BwolRVPmnmOY9LtGqeHBf/MyOYP
	 GHmrLD2HThync42/JEwAS2t7d3ZX9hejHCLnBJzgxV0EsVj9ie5tAP4ZJpEM1r04/Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LdGZmQWmpmdHwSWO6lkYlpHZbQKn6tbj5FKdxpXXdtY=;
	b=OEYd6CCZ4BoY2OP02FpaFUSGU9XhFxG8KNtz44FSD758L4mF5MJu0eFGnvE08O8ZhPnV
	 hm+Dx4N4cnpgPENVtVTf79s/vWeAzzW8WaAWuOXCdoe609hcwCIi0d1oOuBdleIkmZV5s
	 KG8p8FSToKlWvWClmuR3N3P5Hdq+3MGCjU/CjJ7dcO8WSk8RdsvtEBJ7U3mhjoOqTzRvP
	 wzvKoNM/4Qdrx7bTaN1HOfApMcUMNx0eVeAQBnpqosV55S8pYk3EqzMjrWq9X2jUdbdR/
	 LfJCeqd5gSZIqGnGNkOVET0y0cBWOrbkPTTmRYchGCcVUDic7D6/JsNJ1t/sAHifuYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U1DhWB9i;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443D606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7443D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U1DhWB9i
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cde7e8abf9cso3301557a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840853; x=1796445653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LdGZmQWmpmdHwSWO6lkYlpHZbQKn6tbj5FKdxpXXdtY=;
        b=U1DhWB9iKFR4QaR9NRROyMOa5YpuJfQL/+PabJixgkWeq5trKKZETb+Ym/+DGi6hCp
         KIEbdvDnXG3dwLjmW8nBvvX6M6rfp7rTje23jA0Gn40WXGB7crlztova6wAiFBfne7B0
         E2PMN3J9JtoTUbaMndQxhpuA/xrLPPoSxUWP5Zmv/Rm/6ChHaLfRQshz2i1+ilRZBHVK
         JKUn/P6YxcAtg8gst+1LAtT1BstsHswmyA6rELqz3/Ep16qESjWa1tHtc5a/6tVjYh25
         lo7Ffqz5CXKdj1uwTxiD/wmg/xlti5W1KkCOv6FoumaJBDK0PZ+VZmgglY1dP4KPdFMX
         E2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840853; x=1796445653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LdGZmQWmpmdHwSWO6lkYlpHZbQKn6tbj5FKdxpXXdtY=;
        b=Mh+rR3laK9M3mWPhGwDaTCv1ZsBPeOuCSJmK1Bfjcfsq7vibUbYad2PDmNO4dqb2Xw
         LDgMig/MxTi1ojyGfYtglc3SYuzSBPYf6+HVqwhMaPJ2clUnHPA4f1gClPcnAZniy3FU
         HsnLYPgpFgICJPIUm7oLxkcSapwa0+cL0xDsVfnb7hwukEcOgYYKWtziMfY2+e3D+i72
         7A0teXIwdUxY2SzfCKKm16TUd0FqnzF1iaY/S8AGRpKzy6gM1DTBn9SOYtzs/8wfKHBW
         7Hw32q4vcebPLtiLqbwYYsP0VyX55xFa0cb8MJP4JQORL5mUeu7XjymfWm/7dnwAQ6I5
         sswQ==
X-Gm-Message-State: APuU4Z9msZYA87HCdpCEar2nZTWIDYfpfiTk6aW7vMVrlIXvX4spCGTU
	/FnlycR3KH38AmdS8cDCe3LWeMIhUZHEtybO13A7WKDb+XYyWpqYedZakbKxGA==
X-Gm-Gg: AZFdTZfL8Pe5v2rqwvQCJR771+fjccaxfPg8T5GtUwfBnupdwtCqBK5ZPp8QK97NttH
	b9zhX4CTpEv+N7oPK2ICKxBJGnscOIYH+XIdTG93f9i71LJiWFCXpkcmhiHQAXpQbMTugMd3xKC
	eQPovocS7CduruNcOAK+g0+66UhpwBu4VQkk7+aUBU0jlH5fT7kwUpmzon/D84q8jF/7OoLLfTb
	xBWLO3+LlnhBUCwG/BVGu54bCjwccZoWLl3ki2B+BcrRY3ea3mtThux2m6nHoYGCADR96gHckou
	6ZaYHqFMEL22Z7Z84KWHP1W0duAomDzeCf4F9eCLOh9N/9YcYBTuvCeYbV6b0jmgVy1EwAKGxGs
	ZLPXdkLqKLzR5uZCQN1fidPPICMH41fHauuom2KC7kOqh0NRnCO+c7iKiDMi5tBAT45UMmTJrDJ
	L03a8mgdoFkLS1Ubf8cX3zU/74sAWT0+fwguvicUYGd5KclJjiLW/7m8W9moQqbpf2vDM91Nwp6
	owuRzPHRUcq31vfJnXig74MdfwTfR8XL412ELBPFdH2c3FNfu4mH9mvDh4Xnlr5qS7YGB5nD+b0
	LxZLg8IYRqABkY/M+bXJTSLETtK4eFCRzrQfbmLDbMjNXdSHaiECzx/e6zQGypwmwHIEkPLWrDt
	Qx6uhC1gAI+bDInkUlJDiF6l99NldIrOa+N9wTThHHWttYPxjTMs7oNu71j9Glp5BN1HDM1iRqA
	y6kg==
X-Received: by 2002:a17:90b:3148:b0:3b3:cab4:5060 with SMTP id 98e67ed59e1d1-3b41c8ffa9fmr27250393a91.17.1795840852700;
        Fri, 27 Nov 2026 20:40:52 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:52 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 0/8] crypto: cesa - fixes for the Marvell CESA driver
Date: Fri, 27 Nov 2026 20:40:42 -0800
Message-ID: <20261128044050.722617-1-rosenp@gmail.com>
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

These fix bugs in the Marvell CESA driver, found while reviewing and
testing it on an Armada 385 (Linksys WRT3200ACM).

Patch 1 clears the IRQ affinity hint before devm frees the IRQs. Since
commit 8dc981ba2fad the hint is left set, and __free_irq() warns about
it on removal or when probe fails after the first engine's IRQ.

Patch 2 suppresses the bind attributes. Transforms only hold a reference
on the module, so unbinding the device through sysfs freed its state
under transforms that were still in use, and corrupted the reference
counts of the static algorithms for a later rebind.

Patches 3 and 4 fix hashes that the driver pads by hand: messages whose
total length does not fit the engine's 16-bit length field, and, for
HMAC, also any final operation with no data left (any update()/final()
over a block-aligned length, or an empty message). Patch 3 stops the
padding from overwriting the last SRAM-sized chunk of a message before
it is hashed. Patch 4 makes the padding count the HMAC ipad block and
finishes the HMAC outer hash in software, which the engine does not do
for such messages.

Patches 5 to 8 fix the path used by engines without TDMA (Orion). CBC
requests longer than the SRAM payload restarted from the request IV at
every step, and hashes were wrong whenever they took more than one
step: the hand-made padding landed in the wrong place, updates could
step an empty operation, and hashes of 64 KiB or more were never padded.

The hash algorithms are still disabled by commit e845d2399a00
("crypto: marvell/cesa - Disable hash algorithms"). The concurrent
failures that led to it come from a DMA pool double free, which commit
23073a888ba1 ("crypto: marvell/cesa - Fix DMA cache leaks on hash setup
errors") fixed as a side effect: reverting just its req->cache = NULL
brings back wrong digests within milliseconds under parallel load,
followed by a lockup. With that commit and this series, I will send a
patch to re-enable them separately, along with a few cleanups.

Testing was done on the WRT3200ACM with the driver from this series
built as an out-of-tree module for its OpenWrt 6.12 kernel. The kernel's
crypto self-tests are disabled there, so a test module compared every
result against the software implementations: up to 8 threads, random
lengths up to 140000 bytes, scatterlist splits, in-place and separate
buffers, update/final/finup/export/import sequences and random HMAC
keys. The non-TDMA path was tested by disabling TDMA in a test build.
Before the series, about 0.5% of HMACs were wrong single threaded, and
about 1 in 4000 hashes with lengths up to 140000 bytes; without TDMA,
77% of CBC results and most hashes over 1920 bytes were wrong, and a 4
thread run hung. With the series, about 750000 requests over both paths
gave no wrong result. With patch 2 the bind attributes are gone and the
module cannot be unloaded while a transform exists; unload/reload cycles
gave no warnings.

An AI coding assistant (Claude Code, Claude Opus 5.5) was used to review
the driver, find the bugs, write the fixes and the test module, run the
tests on the WRT3200ACM, and draft the commit messages and this cover
letter.

Rosen Penev (8):
  crypto: cesa - clear the IRQ affinity hint before freeing the IRQ
  crypto: cesa - do not allow unbinding the device
  crypto: cesa - hash the last full SRAM chunk before the padding
  crypto: cesa - finish the HMAC outer hash when padding by hand
  crypto: cesa - keep the chained IV on the non-TDMA cipher path
  crypto: cesa - put the non-TDMA hash padding behind the data
  crypto: cesa - do not step empty hash operations on the non-TDMA path
  crypto: cesa - finish long hashes on the non-TDMA path

 drivers/crypto/marvell/Kconfig       |   3 +
 drivers/crypto/marvell/cesa/cesa.c   |  19 ++-
 drivers/crypto/marvell/cesa/cesa.h   |  12 ++
 drivers/crypto/marvell/cesa/cipher.c |   8 +-
 drivers/crypto/marvell/cesa/hash.c   | 168 ++++++++++++++++++++++++---
 5 files changed, 190 insertions(+), 20 deletions(-)


base-commit: 9fb9278d13dca54ce7ecd3254c7df8839e59f03d
-- 
2.56.1

