Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6816EC19;
	Thu, 23 Jan 2025 21:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667986; cv=none; b=cqkA0TDo3MsEhkaxvZ0W+zXVK/rW4MFf3xmur8AU+vjRVLzfWURRXY0lr/V4nH/CnI51gnBSffb9geOlEUe9mhwZNZQxHETpuN4EzeLC1EVb7u6Fi935eNfktRjGxW/fWZ27CDz4BlY9tgo9mT8YmtPHDqeZuopxMlW/tU1bfGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667986; c=relaxed/simple;
	bh=nnh2CElsv9KOTCThJIMNHaeFom2j9CqO6RMKaLMU3Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DofRW2mSQHhuUQ4/npIxrvUhpG5VAmnk7HTaHzGkRwy8mC3O/QAtdG6nG87vZHMyjPDRbsuyC36uOCrDf1fp4kXiMLw1IRtx0lkTDZ0qQHP12TJmRMKROzPn7KkFitZDEeCTBU2NtvHXTq3vtyDmogmuUWx1273ldgOc0jYYwzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doVcpmwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doVcpmwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9111C4CED3;
	Thu, 23 Jan 2025 21:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737667986;
	bh=nnh2CElsv9KOTCThJIMNHaeFom2j9CqO6RMKaLMU3Lk=;
	h=From:To:Cc:Subject:Date:From;
	b=doVcpmwQicKBZgm3WDUd8B/yoaVnz2PQRt3TiXPLqpyvE6PKpQunjsw598fwirFpJ
	 B1ALwpby2hLSIA3LSCnVAjUT5cFDID3RVOUR42VreYQqdh0mcikjQzIDa5w+3zDf5f
	 ha8/1rbxx+ILcKulqwg1BwMUL5KNens57UHG7E2g8A37ICbdqz2+y4zwZ11ny3jO+C
	 vl1h5rThtJLmM7spI+/l1DA121UGKeZA6hzIB1gRVfJ0rhLHI+99PM+wvrH/BQUEBf
	 aczoiBIxd0lzleVdvPw5/5mqFHVVvZBVe1fPG9BTAtPEJNWb7VTaMXj3Or1EYZ7oqC
	 94vMymsp6fw3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 0/2] lib/crc: simplify choice of CRC implementations
Date: Thu, 23 Jan 2025 13:29:02 -0800
Message-ID: <20250123212904.118683-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series simplifies the choice of CRC implementations, as requested
by Linus at
https://lore.kernel.org/linux-crypto/CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com/

Eric Biggers (2):
  lib/crc: simplify the kconfig options for CRC implementations
  lib/crc32: remove other generic implementations

 lib/Kconfig          | 118 +++--------------------
 lib/crc32.c          | 225 ++-----------------------------------------
 lib/crc32defs.h      |  59 ------------
 lib/gen_crc32table.c | 113 ++++++----------------
 4 files changed, 53 insertions(+), 462 deletions(-)
 delete mode 100644 lib/crc32defs.h

-- 
2.48.1

