Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC5367B93
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 21:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483234; cv=none; b=It9xCWvUfHVj/BTx2PVG6dfrUyFI1wVwTL1EOuxn94lfCFMrma45Ymfe5XbIV/jMhFovK6upmsKIh4JZUZaK45P6wRdglnpFJT4bDOV5ZSvkvQAqsR963KiWk2Xh4tOChUwUHuV3Z9P6HEZg3WcfHvOd/ifrLqb5hhpP1+tvDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483234; c=relaxed/simple;
	bh=Ozv0qxakKBL0f7dmZSPxqJM5oFsARFE1Z75CSPTlKuc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DhcwGh0R1JIfGBDUVyY0LCmusBF44Qu1K+0xPIiukO812KdOHL75BNkvgR0tDfgro5/YJ3McJpyhS3cl5Sw2JoTqAy1gKjLUfRWi4TZUe9bZYGximjAGYJ05iHDOEYMKjRxZSPtSZRbfMmEy9aUXjXWHNDS0S+A9xQswPgo94qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSZmr2Ag; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSZmr2Ag"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d049069377so3875275ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 14:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786483232; x=1787088032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=70B88WFd3AQAm4VRQxLFNxtmaoLLrMV/Ems9Q7BZkrk=;
        b=GSZmr2Agksw+OKnIWXnmZAaXK+/UWn5/GjgqaEJSPADE2UGU/oJU0yKEdrlEDMN/YZ
         U2xevDhHltM7uH7wFZDjXSY4LCpBt3xpRU+tUKaGqaRu5XCWmeyyxFNb2FWKbyS/R9yD
         WlqQpDS20PyWalBipJPvf/yba8d8QUdfq8t9wC5waZxeJMc4/zWR7Mh+grIkH0dh89Tt
         96fgmGERljfxopk8uU/KTvylhXkU9t4gN7oXHq1NAaxy3JWp9aA9InUoMyJ3O+zxL336
         QkqmhLKFkxkpa5TgotT/0jPJAb8cTKzOw9SUVVJeKZQPnK+AHz35JpvR/9jm5beuZ/SU
         TX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483232; x=1787088032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70B88WFd3AQAm4VRQxLFNxtmaoLLrMV/Ems9Q7BZkrk=;
        b=LlDlk78yWRXM6Xb+LKPINqyh3mbU++HucybVMGhAsOS2qK5iUxD9QcUStSjaKKAoS9
         USqIwGAq0pUvEgMc4SCGE9AbuGvgjhrziWRUWdFipkUbGP/SEGtJP+fjYY19vdFDzRys
         Xc6At2tHczPvpObhYa8yy1owKpDgPE7Zjt7ne2G4mGORKtx9qXFSO2FA/jiNehtq2P6y
         HrTLkhfCfS8SjwjWVmm4qL3DjR0Uevt3GBF2Z/QkHcaaSY88/dyCQLnlXc07owEJvIRe
         hiDKTGsPyCtJo/5XoD9tO8Ww81IKjMokdBRWgTfMxQgpKuA1wa3/TnOF9sqvk6sb76Z6
         eHkw==
X-Gm-Message-State: AOJu0YwxdhA+DWoaNfxy9DmmixWD5Pmsa2Qf6HQO8ze91mkl7SdqsE31
	lU6bRsnxTo+Fq2jKnYzjcEzGDlL2J76YoeR8d9QFhoP526Tx+f4vBBt8G99R3A==
X-Gm-Gg: AR+sD13wJRSZG6d1gCzHhXfbSDjBruHXL2BslPQnvJO7+GPouInFIf1yrCXJyfKeoxk
	bKO1i+YjKowaTukW920ZVJvd+LVACz0WaW337KfngyNjsLAVEK0eiymgJHL4FBv7LU5PipJG/1R
	WwPSa+3MgeV5fNXTIGn0qmUsdibcc4Urdhp8gjEoVgOaFOokDZKRepyfAgIhvkAqwFpQ8QHfPT/
	n4DbjTNzkqH3qfn1U262R1xVvthdL1qNTpFuqr9WlQCur6FBURm4H9kW6MqiAgtDzQfd1PhgSim
	AvCiamy3pwXICyRRcheFcKBcSFIVgzYfALmfwReJ8WP9LC50Uv4iM90Ak8vMnhYV8rlW6lnQeHW
	wNb7Cl0d/szTfibQr3n0G1qvJvatk4rBeMDUE3JBve7KkSamHiOvMHzlg7Cy6pvXvfSB0QIeMgj
	0JMHqkRdZrk3bb4FFlgyFjSQorjykyIPSEOpD+jc0QZyPXShUIokpt846eqPof6rpkVN5aVAf7q
	NatdtmzOE7Tff++DaNEWZJ8kDa6K7MpP1bRAQdQS0bqIrhYVQipThWLMGsw7/qZ4q+x83hTkv6C
	dMmSZR77YmnmVttapIdcVwIfextutQznNEju+g==
X-Received: by 2002:a17:903:4b4c:b0:2ca:bf8e:35fe with SMTP id d9443c01a7336-2d3455b83d2mr5603775ad.16.1786483232100;
        Tue, 11 Aug 2026 14:20:32 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f2e10dsm12605465ad.23.2026.08.11.14.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:20:31 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/2] crypto: img-hash: clean up probe
Date: Tue, 11 Aug 2026 14:20:28 -0700
Message-ID: <20260811212030.20057-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move some devm calls early in order to avoid goto and return directly.
Also use non devm request_irq so that free_irq can be called at the right
time.

Rosen Penev (2):
  crypto: img-hash: fetch resources into locals before probe body
  crypto: img-hash: fix IRQ teardown ordering and fetch clocks early

 drivers/crypto/img-hash.c | 75 +++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

-- 
2.55.0

