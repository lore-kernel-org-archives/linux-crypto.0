Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFDF156678;
	Sat, 22 Nov 2025 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840564; cv=none; b=PhwUhBTQF+NcVSDypzQ5xZ030DX7WwVtSp6/F/Fu6MV44c806Gj5+T+/Q7+h8pgbE6cW/RwhJleDCbIdTTuFUhi4DShwHaLqVtdIk34RHG+Z4wY3KbevTo38G1DVYIpmU8ZfAfOhnVMTLBLf5sgNFTtUNe/OYsPpqZBrK9Win7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840564; c=relaxed/simple;
	bh=zDR3uEMg60fehYNLZZ/IJHvksey3rT5uWO5boMwJGuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MdHc+FSAFKZOg2ZCrKdb0oDPlotYprH7DvEV7ijT1bqR1bDcEZGzSn1jpmfVtEl8inSulQiFOVJecVpErJtihk9Y7wqVBsdaQ9Lv9f2pzfK+6z6wJ1WWDgEuCsjtsXmyfKJoPNicV98f0g4VRV4VphwNvHHNLv2wsVHoSKvlS+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESWo25rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESWo25rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFABC4CEF5;
	Sat, 22 Nov 2025 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840563;
	bh=zDR3uEMg60fehYNLZZ/IJHvksey3rT5uWO5boMwJGuQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ESWo25rqyiNt3jTMHPMnNqAIEgm3ccdPVAQY8RMHIrxkRicNjklvaU38k9Elvzyib
	 CVODSJI+sCu2zf+O8atAQ4MxxZOETcjypXbbcyP5vD667uqobY1eIfPSPTr7ozdRp8
	 P5ag2LISE+mYDw0se1p65NnEFHVPaMcVIaYQMzm2NY1OpVTPZFdyvpAfczZh9X+U5q
	 885jY8DSnC4R6MTt2pfsGYrweZwgoGj/J0jwyo7WqRSH1t7ekcGq11YADoLuRjKL1/
	 oUgFZcJxx1WG804XEozwTpfKFAng0ITzsQBMMurLthaqEyyaYNNBKpwoPgGw35oDAs
	 IMe7qsY4u7Eeg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/6] lib/crypto: More at_least decorations
Date: Sat, 22 Nov 2025 11:42:00 -0800
Message-ID: <20251122194206.31822-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series depends on the 'at_least' macro added by
https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
It can also be retrieved from

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of more of the crypto library functions.  This causes clang
to generate a warning if a too-small array of known size is passed.

Eric Biggers (6):
  lib/crypto: chacha: Add at_least decoration to fixed-size array params
  lib/crypto: curve25519: Add at_least decoration to fixed-size array
    params
  lib/crypto: md5: Add at_least decoration to fixed-size array params
  lib/crypto: poly1305: Add at_least decoration to fixed-size array
    params
  lib/crypto: sha1: Add at_least decoration to fixed-size array params
  lib/crypto: sha2: Add at_least decoration to fixed-size array params

 include/crypto/chacha.h     | 12 ++++-----
 include/crypto/curve25519.h | 24 ++++++++++-------
 include/crypto/md5.h        | 11 ++++----
 include/crypto/poly1305.h   |  2 +-
 include/crypto/sha1.h       | 12 +++++----
 include/crypto/sha2.h       | 53 ++++++++++++++++++++++---------------
 6 files changed, 65 insertions(+), 49 deletions(-)


base-commit: 86d930bb1c19ec798fd432c5b8f25912373c98b2
-- 
2.51.2

