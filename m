Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110401BC41;
	Sun, 11 Aug 2024 06:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723357707; cv=none; b=OIIitLTXHg16tCPUVYToh+D4uPot32Hhw2qY29rw/Ysr/xfrAMEITVtTYWw2s1fYfSVjcYKDeo9EUvdfc2u3jNHZ0gfCctwfRKdlxU2hne1rTOWttwqsQhbzUs9pvaT3lramML1Nq6Vwzcz7zfsGvjkGfL9lZ/hsJHvpz1TEDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723357707; c=relaxed/simple;
	bh=ITlBrNk/nnNYFawhBXPmlXS015YrTn0oyia8RryqSnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bCVFFsxTUvysPJQYWNymL+8SFGzqgpKP2oW4DGUwdDbxf7H27E9oP2OWo/Lxgd2GbwAuu/2BXzj10kA04JuOOVC4k9ofSHqL0QtVH222z4POzqrfwfA4PcMqm4ldUO20F2SSwnTuWFHhFOyt9SrjVbSTMlJ/MY9B325O2qbCIyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIuG11Qv; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIuG11Qv"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7c2595f5c35so547421a12.1;
        Sat, 10 Aug 2024 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723357705; x=1723962505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/DMcAaFP8TtynypPN0f9sbeN3Vgz8QTUBmxZp6aEgJE=;
        b=kIuG11Qvd/MZYLN53ZOm7EXjeSgDaUpsduJQuikIxmfvHFx+L9jDAs96J5c97yLqku
         UokrfIK1wrxXqZRGdf+uW0VyhB1ZpPcbGl86U+T6oa/1pOrRAMVfltjDjPdyGVPtwJ+t
         +COrvFOjETNx4MNKJ6uML2cbcIiA1HFLZx7WLFUXzCxKnKAQhffgs9I3oDFZjwMsL18i
         LNm+be9VpsGvBTVpNEtqhtoilBCywAigtVKvsqtR9YuNefOMoTI/jNtp+rgApVeEYI8J
         4VA60zVeWSqADG0Ihj30L7OLAKFULrAbQOEZv0242UekEAEv9EocZ0vYCYTbr5XOUc8u
         jDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723357705; x=1723962505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DMcAaFP8TtynypPN0f9sbeN3Vgz8QTUBmxZp6aEgJE=;
        b=ewwTP9BFcvzDaztEwb0xafF3KIKPTezSVbhI77PCyAaa5VNiQfxKBpTF84+WsJeTmi
         XwYBuSfNONHNpvhigYDQrYz1Z6Nh1MX0Hrf2rLBVmhi+lkgNgxgFsOUlVzuf6fWGv4lS
         Ao0HiWLu2JT/1kFKiLaQNLs/eFpLfWlhaV2bqjURykGDDq2ynGYEezSwIQ4kEDEvWGhA
         hlL4Gy8hzendXcyxiTEfcDDx6VAbqMPgT6ynFtR/X6gePBiNwGyNnrwTMLXOvkINa4o1
         lvagmdBhacueOohEiR6fIcGHVYH2EPpR0rXtaH5eOrFLm4mshXFYBpqIxdcXxcHRsSKy
         j1Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUJYsiYXaJQMjnFz/JtzQowQeD/4Qi1Nn2Jt6j9f/ujWtjMa6x+OiIQBJD9CAl+NaFDJricUDZ/XfAktTTQ@vger.kernel.org, AJvYcCV5elIC2+QJHOvckVYCwbIOdKRxoFHK0KcsIgf72dqCfQaoUN5n7kVBTPx2J95qF9kGyMe3hABAgznTZ/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiC1RDpv96scMPekqjfk+4J72uoip0e12bWpTb7F3909eWeOnt
	ykt63ILpl8USuOLTAzmilaBaOTjfDUxFrCBZ9k2aA5oxBcLQa2/H
X-Google-Smtp-Source: AGHT+IER3XajM5bBFvxQnnjDkNDUhSDbah17k73U0KUx8IyAlBH0JwbLi+zdu0VJ+kWqdFtqTyDWCQ==
X-Received: by 2002:a17:902:ec8a:b0:1f7:2046:a8ae with SMTP id d9443c01a7336-200ae25aa5amr47643885ad.0.1723357705138;
        Sat, 10 Aug 2024 23:28:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9038fesm18836795ad.114.2024.08.10.23.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 23:28:24 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jserv@ccns.ncku.edu.tw,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 0/2] crypto: marvell - Remove custom swap function in favor of built-in sort swap
Date: Sun, 11 Aug 2024 14:28:15 +0800
Message-Id: <20240811062817.210527-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom swap function used in octeontx/octeontx2 driver do not
perform any special operations and can be replaced with the built-in
swap function of sort. This change not only reduces code size but also
improves efficiency, especially in scenarios where CONFIG_RETPOLINE is
enabled, as it makes indirect function calls more expensive.

By using the built-in swap, we avoid these costly indirect function
calls, leading to better performance.

Kuan-Wei Chiu (2):
  crypto: octeontx - Remove custom swap function in favor of built-in
    sort swap
  crypto: octeontx2 - Remove custom swap functions in favor of built-in
    sort swap

 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 12 ++----------
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 10 +---------
 2 files changed, 3 insertions(+), 19 deletions(-)

-- 
2.34.1

