Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D426153561;
	Fri, 28 Jun 2024 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591306; cv=none; b=XoA0Inj0e8sIHh/lORc+v3GGzbI9xDJSK4pNTXaSRdzAK7F4W7S1N0OrdI+5Zrod10VxKchVLwjJ8JQfwhQmBFaTnLR/azqxNHF+lVwRpf0fGkYv89XVZ+dRE+ezudtk2Z9KNR9/ksr4wBg5k7cB1TCMOdiI8i0OOkNNipeXhCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591306; c=relaxed/simple;
	bh=a1x9W1spyksKdWXtlAZQSfWEw/MHcs4YPBx796W16tA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+l3D3l2lS9P51C8BCDW/LGlfpWspI24dT05UFUz5OJZ/Y28l2MkOWccSr0fzZQ2PKOuOf4kB2I3qLhoypw30zm4+rf/mNMbI+DCp9BeNnDd1XkmwK6ces0Aatrhb604krIvdx/2Z431xiNXu8QyVWYPCrF68Pq97tfYmjGt5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57cf8880f95so1083586a12.3;
        Fri, 28 Jun 2024 09:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719591303; x=1720196103;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tZc3nLBFY+UI37vMSq6JBYuPNwzayvpRvMkZC4pHqGg=;
        b=D8x2M5kj8iNCa5Dot5BCjCkE9SqziYne1G0u8A9mQcSMNGvvJncNXAguxj1wTAVjed
         ULbNE0aECNRdjndp9zE4dI14yXpZxYUT7VMrHKsBbVCaKEJ9xsBop6GC1IbCtq/0JUYh
         qkXp2SwYB4a28W7WjEeTvmZzfFrOPieus4Pze5pZlBxEza4lfqnFyMbVHysRpNvVhGaA
         x0VLBfngI/scjSqsLlb/pqHFmZeKr6zh7+4CG8yHcK+9lqH212DkBmE5brozNvYCq0wH
         DRpe/RD+A4N4a9tsqxXa3peWG40oTX770MQTHWX+GzlivBRCQJVxR/dr6OYu3+J1DDkE
         pEsA==
X-Forwarded-Encrypted: i=1; AJvYcCUo4SeSPS5+XCKL1ItgwAmBM/XvxjPbASfCQluw9fUtAYUJ2eIJpN33t2qKMFZvpSIHJy6PeRAdKDLSNc6LRmxddMvo9RPR+3b+H/MR/T/j2iu7OpAIwGFlm0X0S6R25fWnOLXgrQ5RF1HYLcgEiCcZH4l2GokRE5zwsFqf9LBBa4QY
X-Gm-Message-State: AOJu0Yxr8Udmt8JjRqsu3oJF4Mm94/4ivI+GQUSQGq9UzHT/bKej4P1j
	1EGJOEb//Q4aJJyYhFQb48owVjSwtXqlBtDjXX6XrHYgmS9RZDpu
X-Google-Smtp-Source: AGHT+IHTcB3dvO6kE88T15CIWzxuuAJCSpiYNG6q/oWmBqFy8vZUyEbVC1cIFTLS08U/yDcoRYuETw==
X-Received: by 2002:a05:6402:13d1:b0:586:1518:799d with SMTP id 4fb4d7f45d1cf-586151879c7mr2465853a12.17.1719591302698;
        Fri, 28 Jun 2024 09:15:02 -0700 (PDT)
Received: from localhost (fwdproxy-lla-008.fbsv.net. [2a03:2880:30ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614d50e1asm1212136a12.78.2024.06.28.09.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:15:02 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: kuba@kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] crypto: caam: Unembed net_dev
Date: Fri, 28 Jun 2024 09:14:45 -0700
Message-ID: <20240628161450.2541367-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will un-embed the net_device struct from inside other struct, so we
can add flexible array into net_device.

This also enable COMPILE test for FSL_CAAM, as any config option that
depends on ARCH_LAYERSCAPE.

Changelog:
v2:
	* added a cover letter (Jakub)
	* dropped the patch that makes FSL_DPAA dependent of
	  COMPILE_TEST, since it exposes other problems.
v1:
	* https://lore.kernel.org/all/20240624162128.1665620-1-leitao@debian.org/


Breno Leitao (3):
  crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
  crypto: caam: Unembed net_dev structure from qi
  crypto: caam: Unembed net_dev structure in dpaa2

 drivers/crypto/caam/Kconfig       |  2 +-
 drivers/crypto/caam/caamalg_qi2.c | 28 +++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h |  2 +-
 drivers/crypto/caam/qi.c          | 43 +++++++++++++++++++++++++------
 4 files changed, 62 insertions(+), 13 deletions(-)

-- 
2.43.0

