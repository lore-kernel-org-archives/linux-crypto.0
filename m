Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408559;
	b=LxaHklH/zwH+/o6ZdpkGXGvZl3u9XTNo5c5XC5escNYY2RD8jVX9t4TFVFqsJh2HvK55
	 JqqTpIKkqByMx9COCJnokYrVfOAXeA9nVawwYXVJu3U3OLrQI9aWYMQazmKV6vAMXxzym
	 qcOtaAKUZOR5y70ZTyaidVDW4k6QCPxHVV7I2+QLa6mrGIiYWCcYG5IlQIIf7jjILtl/a
	 GcHfn1OSpXUwLtTWgntfhse9Sf8mfDKzDQyLtxB3utgzpsaZEumECEwTAiNkcxwrZ9q40
	 J8tsVF/fB9r+g1ssoWAEHs4FF2+wPuhx8ZYYh2txIdekCG61zo1r/7c8ypt08q+Syfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408559;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2DmAwvnqOJjoNtG2lpJ3xMDgLKyQyC//xlOdEPBXwno=;
	b=W8ykZ0rCi/lUKFKxmDzAvJSG5kc3cDeSeYh5vshP2Nj1gcPq4pqM/fQPxzPIjxqUMf1o
	 OyH21OOL6k7nUx4M3gXZeO+NUT1bEduEzyIg6Y67QSRulMMC23i0nl5Jf93AV7A+mewA9
	 nigfRtwLX10eLvLtC2SQo7rQFR8BM434GpjoL4b1MpQXL24TP+IzMIBpwB2xKkeEDgfwe
	 P9/UpIymPRm8/9GFOzabJIKCAZyf5LEZY0B6dgxS3dseTeDQg5Tz3t+RD+tpRX/g7i1wF
	 AgwaWAumKVHd0To3+HSi4oITT+szGJCwQpdQzj8pFIzQSn0qZOYR2+Pp+sRb8xDum4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KiQnJy24;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D8606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2026 01:02:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C67D8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KiQnJy24
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35c76e9614aso1884452eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 18:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793408558; x=1794013358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2DmAwvnqOJjoNtG2lpJ3xMDgLKyQyC//xlOdEPBXwno=;
        b=KiQnJy244oaL2gVFYKbKJSJ7o5NXI0yK4KsAVEJ2H9J1GndYKtuD6FVEK2TrjWkUFa
         l/Qqj8xEWGpAtL/3jkob+iAjOzSk6+JEClxi/bei0fxYEyt+t+CDG23k3ViFJoQYY1F4
         WjC9c0z+QTaMnjPmIaNoiHpYgR8+yIvjo4xactSqGBO4FSwje4V6+7Ket4ZFaBn764LS
         cDFCy6sNVCYoyeCrXwqDq+BNO2nMoGCa/8ypftm5O5Wummg3+bRKOrL3q1ZeMOg9s1IL
         qW6XD78b8i8NNsY64Gy8ae2yNYAwbaoIUJ3Sxjxc/zP43nNcNwIRVkNv1OG0z2YLqSyI
         c8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793408558; x=1794013358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2DmAwvnqOJjoNtG2lpJ3xMDgLKyQyC//xlOdEPBXwno=;
        b=YN3IVTcReGykYcrsWG3IDzR0Ig6CbPp7ICgj6VZv44bXE+1jJ+/CdwZGbuhYvBftu1
         uoVkNHC//J2i7z+47o1rGKecVEZkMC57WSVIYXimtQgDOTRI+ZhzaGwFl8Tku5QX+OmX
         YSxSlyylz4y/YubQeUFEWPJgVCKWfpKne7M7qZnHE1fm40TC9g9WlOiBMy87huhRNkyb
         ZY0VxuZSMfLhhphxZkzOEbl837ekavav51lkanZtyJvuaLBErQhBH2LGODJrUuZDlePf
         QAxsslPpCBRGmH7nU8KoRyshakraLkO7V8tIMk00FNp7qeZcxZZRKKRlNh8RFi0vTth7
         4ZVQ==
X-Forwarded-Encrypted: i=1; AKwUvByua0eLuBRYdKDgHcysW2fNNNzyz4OwG0QsRaOKroEJp5494NHQgmdy7OREh2fpQimVJ/V80tOFBhD4x9I=@vger.kernel.org
X-Gm-Message-State: AFq9FYI37vFqdanTtbUag/UmwNy85UHiC4UR+Cua5xvLq1xoe/JrB2l+
	97x5uAoucem2+5RxAHjPxG4MMy2Qs+ToM5xjG7X42BgXP0wolKu4L6Bk
X-Gm-Gg: AYBFou0OSpvhVkA8svObemUQZWIIi9nrq8FVPztlQrmVODWzoiNso2TJDhtr/fNAnJ7
	pduUNVeS5VLSE0y0MUHDSzGlwwbCag10BOAnkCXTr5MbLVi3c90+2a10I5HAtJY3JM6A6Nhv/d/
	nygiryru3W8m2pJH2Q8Oppk16O3UgvkShJo+JVGurDQs8DqKGEBn/Ecl9FRrHGQpoDMsrw+Uidb
	xJ5mu2xllQKtp4rdX5hvtAiDS1G4etrn1Vno0GxFDKj3LJf4wfjdayZdXABH+fKki1Lt2f242wI
	0Cz0feVpPjJPzs4Gk/IG5fqHzSMr+Xba7NYt3BH9mDHLX9NdBKq2uBImpG4qD9+sqi1Iu50NJjQ
	i8sXfYZAyF7saaB2rVewumy3GBIRgPLJrH/afBgNySeWYMov0GBf/gP9ffkFKwmflLrFctFPSFW
	I8nB7MwvpNwoXwbbALfBuUzgtjmFgu7MG1VplF69w5ra7ZWS1QMsD1IHSh9ciNIuPHBeoP6vXfb
	vc3fwJDrGiItCDWSr4DgpIcMK/aE+rn2Eaa2rZzgBsrAY7Fuaq4YHPWGHnuOPeKYxl/ouU2Hr0E
	otf7t+F4AqQRfeRwFQ5RVYPBDcFaKQvdPUdNLPNJd1TBSQH6jIdbpSB5P+5U5y9g7Sag9tC0b47
	IbFoM1hVuX1LA7cV0aDAi9cIQ0aLG3BddYL/oGxDsz+KxSiJ6pjbrjDWJSL3tLTA2eRayKdHq3I
	CY4RK1ngRpRDgSn2Q=
X-Received: by 2002:a05:693c:69cd:b0:34d:96cb:d75e with SMTP id 5a478bee46e88-36a423bed39mr5898672eec.27.1793408557929;
        Fri, 30 Oct 2026 18:02:37 -0700 (PDT)
Received: from brev-9gdpyq8lp.ap-south-1.compute.internal (ec2-3-110-210-194.ap-south-1.compute.amazonaws.com. [3.110.210.194])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42662f23sm13129484eec.2.2026.10.30.18.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 18:02:37 -0700 (PDT)
From: Samarth Narang <samarth.colleges@gmail.com>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>
Cc: Samarth Narang <samarth.colleges@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] crypto: starfive - DMA left running after timeout while buffers are unmapped
Date: Sat, 31 Oct 2026 01:02:32 +0000
Message-Id: <20261031010232.3361085-1-samarth.colleges@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Hi,

I found two DMA cleanup issues in the StarFive JH7110 AES and hash
drivers. On timeout, or when preparation of a subsequent descriptor
fails, the drivers can return an error and unmap their scatterlists
without terminating previously issued DMA descriptors.

Line numbers refer to mainline at 83f32c773255. I could not find any
dmaengine_terminate_*() calls under drivers/crypto/starfive/.

1. AES (jh7110-aes.c)

starfive_aes_dma_xfer() submits and issues out_desc on cryp->rx (lines
471-472), followed by in_desc on cryp->tx (lines 481-482). It then waits
up to one second for the RX descriptor's completion callback (line 484).

If the wait times out, the function clears alg_cr and returns
-ETIMEDOUT. The caller, starfive_aes_map_sg(), subsequently unmaps the
source and destination scatterlists (lines 520, 540-541) and propagates
the error.

Nothing in this error path explicitly terminates either DMA channel. The
descriptors may therefore retain the ability to access their mappings
after those mappings have been released.

There is also a descriptor-preparation failure path. If
dmaengine_prep_slave_sg() fails for in_desc (line 474), the function
returns -EINVAL even though out_desc has already been issued on
cryp->rx. The destination scatterlist is subsequently unmapped at line
541.

Since the RX descriptor transfers data from the device to memory, any
later execution of that descriptor could write to storage whose DMA
mapping has already been released.

2. Hash (jh7110-hash.c)

starfive_hash_dma_xfer() submits and issues in_desc on cryp->tx (lines
150-151), then waits up to one second for completion (line 153).

On timeout, the function clears alg_cr and returns an error.
starfive_hash_one_request() subsequently unmaps the source scatterlist
at line 235.

The TX descriptor has not been explicitly terminated before the unmap,
so it may retain access to the old source mapping.

DMA provider and possible consequences

On JH7110, the AES and hash DMA channels use the sdma controller,
associated with the PL080 DMAengine implementation through jh7110.dtsi.

The transfers are flow-controlled by the crypto hardware. I could not
establish from the driver source whether clearing alg_cr fully
suppresses further DMA requests, drains requests already accepted by the
DMA controller, or retires the corresponding descriptors.

Even if clearing the register prevents immediate further transfers, that
does not by itself establish that the DMAengine descriptor has been
retired. If the controller can resume the outstanding descriptor when
requests become available again, a later crypto operation could cause
accesses using the previous request's mapping.

Depending on the DMA mapping configuration and subsequent memory reuse,
such accesses could read from or write to storage belonging to another
operation.

Proposed fix

I think the error paths should explicitly terminate the outstanding DMA
operations before returning control to the callers that unmap the
scatterlists.

Specifically:

In starfive_aes_dma_xfer(), synchronously terminate both RX and TX
channels after a timeout, and terminate the already-issued RX channel if
preparation or submission of the TX descriptor fails.

In starfive_hash_dma_xfer(), synchronously terminate the TX channel on
timeout.

Both functions execute in the crypto engine worker context and already
use wait_for_completion_timeout(), so a synchronous termination call
appears appropriate. The cleanup would need to preserve the original
error and account for the outcome of termination.

Would dmaengine_terminate_sync() be the preferred approach here, or is
there a crypto-controller-specific shutdown sequence that must precede
DMA termination?

I can prepare and compile-test a patch if this direction is acceptable.

These cases were identified by a research static analyzer for DMA
lifecycle ordering and subsequently reviewed against the source. I have
not reproduced a timeout or late DMA access on JH7110 hardware. The
reported issue is the absence of established DMA retirement before
unmapping, rather than an experimentally demonstrated memory corruption.

Thanks,
Samarth
