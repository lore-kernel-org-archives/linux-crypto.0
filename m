Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689D93F88B8
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791147739; cv=none; b=rqNoD/HfzHkpkS3AuF/8elTfnGXE7iFJZBktBS26ROmsXtEAI26a2W+hO/NdSVJGLpSF4Cj43G7PnDJ5MPlA2+3FOCD+LilV55S7KhNncC9xvnpQQJ746UY9g8SeMakcu6BBq7GSPBhzBekJ+pmaWuQVe5vhQXcXHk9Gh4GXsHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791147739; c=relaxed/simple;
	bh=9I0LUxXM+OZDNWz3rSenB7v3lSagut5j/DNlEoZLhmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YocUtEARKUytCIri8kNTNLbsjYiOSoBQmlO4O1I2jBG6s+nR9u0MFSm0Od1BKwz6jtJcw/fh/qxXNAqETgMOAXmPBYe7OVnypxMCDYNC+TdRokdsLXylUsNZP+zkapX4+UVnDj8ki8I4acDv3jdZohCS7uw1sUKKmE1EIZfUGaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=aDQsOZpZ; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="aDQsOZpZ"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7C10D3F223
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791147729;
	bh=pGZv3g6OHISibbeAlwlkebf07nb4vhiMpwCWgKmkqkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=aDQsOZpZgCtUACXcuQMpO1IxQ4CLEyf/8bi3yWwgio3i8HKMH/JLjin+utqZXjigV
	 dHHylRt9Ysk+zB1hA5rAEv9RaA0vcRVyfz3oA+yqFNbwusCHglZ9CNc0oxsmoaq/kA
	 OXvBG4F0RsjFOUf+PMJ54EJKp8Aes6ZCD7LPvFSoTDgjirS5XuLKTmiOTuupZHVsPf
	 NjHsEkq7RdD8hfjH5XggBzwtskimS+osOnaDDm41i90GcVzJI2hMCHfrEgf/rKwCUq
	 d9Exm8TPZd8Muhzf/A5prXOy6Dg4NI7gOEhavj8vSB6EHp1O/4foswvzXIwqTjnhaV
	 8cwWzfZk3Ezn0TCdQ9v+PvJdHvG//sG/BVlYxZE0/D/OO4+QWa3YN7JF5AEeC8ZEne
	 ZnFWvt3baP680oi5svA6a8yxeo3DI4B9eIIyUkSppJT1C5QE0Ip4TjGlfDrd1eH0yM
	 nb4k7vwwgCFQsBAl0a5rhkHtjJ9Ds9cGqN4LOjbrOBrzjM2M7wB80nJini+Yqb2AII
	 H/mTD4fC/RxGhFMcW4TVc3Inm+O8gbcPvgSyrgA1n4OtPXHSd/mdq/AwsqTpsvbJ2E
	 ATKgdY79NtDjjlU6oFqylimIRxsDDxnbKnE3JNiHnqdOsLO7iC5p0HTjPQ55h/j2eE
	 wOTq5FpsW9g14OyfOIVll9/Q=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso1097447a91.2
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 14:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791147727; x=1791752527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pGZv3g6OHISibbeAlwlkebf07nb4vhiMpwCWgKmkqkE=;
        b=Veu9TRF9NiRbVJFtVnvNEu5fS7vQAk00jxa9+51q5heU2wTbaAJpLjLlwjYG8EB/sz
         XjbWKRZ0upQBsF8fAR3vIfAYNG7SutaDOX2xT+bhFBLjFsls0wEnfK226hsH2VjrWC6F
         dGpYKTWQUo7VAhe51H59TtsCMZEyYPvhoBRRk5pVKGgqI6gVkI+804/rcwnVTFeiDPgO
         prhqrSzCgOSy2JVzbkbQ8WDgA1Abx9vJNGEV7lXpMyv/IYKFoGge/um+RrubieTt51ZU
         ZuzrHY4Y1dUAVj4mynijvsaY3xNNIF+FV9dXWV4db/LmkjNm3NFrfVf9M+cMgNUWc7Tp
         DHCg==
X-Forwarded-Encrypted: i=1; AKwUvBwNevJBYbS7BkAusYZuTf0Oqn+TKxzPQ4n1JF95LgcR83G2IlngUidYGhsLIh5i9CsFz5qs+RBAVig3zx0=@vger.kernel.org
X-Gm-Message-State: AFq9FYKevOtgQxdrYSVxPg6Q+q5eqdgt5kyvaPtQ186ie47u2DDXfvRv
	qwOWmIMcHIUYzhOLvBeoCtnRXxH7xLSZwPSvL7M+0e48Td5tV+ts6YjmXPCBK/beTBFvBNlTMad
	M5LVcjg+IWDoG7PRzKS1PdryWfKhUTjG987mRaQX5Pp2WfvMwwjUP+G7Jrv3p/k3JjMgsceXc9S
	57l5a2Dg==
X-Gm-Gg: AYBFou2t+Hen9O2Wu581kLCKEiOvpJjb45tUTaBlYFWHaHYMr6SIjrAB7bWUe5Tdma+
	U+OyJsmCjmairejyGqwXNIF04eaNGR7O6mJZl7LakBbpmLQ0tM/qRvAJvU5r/1oAxJSkOguuGMZ
	AsQCnys90AInghnvZmF3OdsGeJEpIwAUNKF8tKcBNql4lvJtXduh7waAxwBydQ94D6g5ZoBy61t
	vHwyqRUCumTzSrlZhGHzvPNrZE7aG16FGv0CsqXWhRwZIdSr1js/LGEWBaMq9EphOG0JdB/p0xF
	S5AJ9g4hlqKwpkQuuj1yC0nbOffJzia1DBta+Ca2uW8seM9DdaiijzAqXPYlwsIB027yKdZDjIo
	q5i2BMi1lgw==
X-Received: by 2002:a17:90b:3d8e:b0:3a4:d883:3edf with SMTP id 98e67ed59e1d1-3a798c79a69mr2989825a91.9.1791147727554;
        Sun, 04 Oct 2026 14:02:07 -0700 (PDT)
X-Received: by 2002:a17:90b:3d8e:b0:3a4:d883:3edf with SMTP id 98e67ed59e1d1-3a798c79a69mr2989806a91.9.1791147727210;
        Sun, 04 Oct 2026 14:02:07 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4664ebsm8313782a91.7.2026.10.04.14.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:02:06 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] crypto: caam - Fix RSA destination buffer handling
Date: Mon,  5 Oct 2026 08:01:58 +1100
Message-ID: <20261004210200.290119-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two issues in the rsa-caam driver.

Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
regardless of the key type.

Patch 2 adds a bounce buffer to handle unaligned RSA destination
buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
-EKEYREJECTED errors when loading signed kernel modules.

Changes since v1:
- Patch 1: Add Fixes: tag; pick up Reviewed-by from Sahil Malhotra.
- Patch 2: Move the !bounce_buf check out of do_rsa_bounce_buf() into
  the caller rsa_bounce_buf_done() so the helper is only entered when a
  bounce buffer actually exists; add Reported-by/Closes and Tested-by
  from Martin Kepplinger-Novakovic.

Link to v1:
https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/

Changwei Zou (2):
  crypto: caam - Fix wrong unmap operations
  crypto: caam - Use bounce buffer for unaligned RSA destination buffers

 drivers/crypto/caam/caampkc.c | 123 ++++++++++++++++++++++++++++++----
 drivers/crypto/caam/caampkc.h |   6 ++
 2 files changed, 116 insertions(+), 13 deletions(-)

-- 
2.43.0

