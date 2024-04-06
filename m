Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807CA36B
	for <linux-crypto@vger.kernel.org>; Sat,  6 Apr 2024 00:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712363285; cv=none; b=p002GJDhsFD00e/60UVMwJQT8tXDjTg/O4QdH3JbvFoBOfsqQZ5dauwWGmMTANpfJwei14YrOeq36RtVWq2o6CjkJ9OsaovZ9oChlYZFzY5i/eo7MrhaKbOJAsHKI3cuNnuNBNnN2/cgEfgQMH5sAcitrFW5z84zfgBDqkpx7+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712363285; c=relaxed/simple;
	bh=2fuT2RmC/hJnbsRp44gaH+jZr/DqKcX7gPAeJfMqbpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NTkkL7NX2+OiKNW4Ip1yX/0Zob1aUjHKfCDuv+eVMo3HdUkk9uiy8F8HV8OJzkj5a3pXVoMeNQCDMwaiW5epi0pwoi/uZd3uucXnBTtCCFBMGWTVAPWSZrCrozE6FYD+tC5LNAZEgnBxits6nvzN4h/M7/u8CJhYqpA0iLq/AJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNs08Zwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNs08Zwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B90C433C7;
	Sat,  6 Apr 2024 00:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712363285;
	bh=2fuT2RmC/hJnbsRp44gaH+jZr/DqKcX7gPAeJfMqbpQ=;
	h=From:To:Cc:Subject:Date:From;
	b=pNs08ZwlDDd2WcpqkyNv3Wxfa5/77hInaYw2nvTYYJ7bZbboRi1mE6kFgOR79DCLH
	 W78CWihTaqaU3XPRvZOp+8tY4YNDeTsYSr2LseKVXgxyo+5YfnfVthVsf5tcBPAUgV
	 MNrKK8oIEMXBNyaHDi7fPsKad1DosegBgDO497BQyNUI1YaKZ59Q4jCJ9FNgvLwAD3
	 yIyeEfn9C/ic0PFFdVjPAYzs35KKTYX2AWtK8PYAF50WtbwyO5emu6U14Hg8t8ScBt
	 9LaqcEmKw0MIT6QopNTdXQuS9K2EV3Gvc0b62Mblqmbj5aoPqMSUfi5pSDN6tlFKsz
	 L/evmcYBcWHGw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/3] crypto: x86 - add missing vzeroupper instructions
Date: Fri,  5 Apr 2024 20:26:07 -0400
Message-ID: <20240406002610.37202-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds missing vzeroupper instructions before returning from
code that uses ymm registers.

Eric Biggers (3):
  crypto: x86/nh-avx2 - add missing vzeroupper
  crypto: x86/sha256-avx2 - add missing vzeroupper
  crypto: x86/sha512-avx2 - add missing vzeroupper

 arch/x86/crypto/nh-avx2-x86_64.S  | 1 +
 arch/x86/crypto/sha256-avx2-asm.S | 1 +
 arch/x86/crypto/sha512-avx2-asm.S | 1 +
 3 files changed, 3 insertions(+)


base-commit: 4ad27a8be9dbefd4820da0f60da879d512b2f659
-- 
2.44.0

