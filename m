Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6DC6AAD
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264296; cv=none; b=eNqvlqiYFJMaIr/xSzbqYUxYZYa3K0zRHnulCFf2+31X0uf04t6AibT7J9KlWAnMv+DEhAEpRh/I4u4krgiibCYYBLayNDc+Kt1XSxpOXL5nla5F9YF8imToktpgIHBu0wpQXXdYS75hYrYeQlwMFeSdfm5RQr+Ol7DyOZ7FBxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264296; c=relaxed/simple;
	bh=MW/IHp1E7rwSyNuBU2jVTzCs62qHX7IsBPgwGhUHeXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AU9OSQmjRJxA74VdeyryiZIIuvVDubCnI7nx0746Z5caJAVAR7H3Gnbt3+dP1uicWVcqfSzZo4PzCyE9gylb8sZ7/jkLoDHGzqJjehGSnJZfT3EFnnQdvt3/BuFFdhcG3YNkenmwCUTxugCBKn0wpmENBjohYN/VJ3EOaBiIlMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDWz19HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDWz19HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D12C4CEC5;
	Mon,  7 Oct 2024 01:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264295;
	bh=MW/IHp1E7rwSyNuBU2jVTzCs62qHX7IsBPgwGhUHeXw=;
	h=From:To:Cc:Subject:Date:From;
	b=gDWz19HFKp5h31gOsG4XQW9leqr0RqjhGHPiVvFXZVTZmAanf9D6heSYP2r1K5WhP
	 I/y6M2Z+8rNa4RX38n7s8gYLejeSpIK/UaQr6HdqwLh8c07dBdzog+W4t6DJ21HJZI
	 JUhmW+U995yqGZ6kKepbrQUIFwEdpqpEAUqN5rM4FUAURx0wYF+5+y7XPFOItqoy+x
	 RRcx+za7/bVcZfnXybfiWS1Hh+rcfwlCDncpapO9b6pOn4uWD2gnWI6PyrB8/Mt5TL
	 Z/eIzXXdP9BAQtsWUvzvVKQ6mGE+coQqECRhAz+xmZoZzccaEtTq8qXv2D62Xhi1zl
	 tYXxnZkUsNNSg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 00/10] AEGIS x86 assembly tuning
Date: Sun,  6 Oct 2024 18:24:20 -0700
Message-ID: <20241007012430.163606-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up the AES-NI optimized implementation of AEGIS-128.

Performance is improved by 1-5% depending on the input lengths.  Binary
code size is reduced by about 20% (measuring glue + assembly combined),
and source code length is reduced by about 150 lines.

The first patch also fixes a bug which could theoretically cause
incorrect behavior but was seemingly not being encountered in practice.

Note: future optimizations for AEGIS-128 could involve adding AVX512 /
AVX10 optimized assembly code.  However, unfortunately due to the way
that AEGIS-128 is specified, its level of parallelism is limited, and it
can't really take advantage of vector lengths greater than 128 bits.
So, probably this would provide only another modest improvement, mostly
coming from being able to use the ternary logic instructions.

Eric Biggers (10):
  crypto: x86/aegis128 - access 32-bit arguments as 32-bit
  crypto: x86/aegis128 - remove no-op init and exit functions
  crypto: x86/aegis128 - eliminate some indirect calls
  crypto: x86/aegis128 - don't bother with special code for aligned data
  crypto: x86/aegis128 - optimize length block preparation using SSE4.1
  crypto: x86/aegis128 - improve assembly function prototypes
  crypto: x86/aegis128 - optimize partial block handling using SSE4.1
  crypto: x86/aegis128 - take advantage of block-aligned len
  crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
  crypto: x86/aegis128 - remove unneeded RETs

 arch/x86/crypto/Kconfig               |   4 +-
 arch/x86/crypto/aegis128-aesni-asm.S  | 532 ++++++++++----------------
 arch/x86/crypto/aegis128-aesni-glue.c | 145 ++++---
 3 files changed, 261 insertions(+), 420 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.46.2

