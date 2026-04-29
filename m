Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946A37F00D;
	Wed, 29 Apr 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478282; cv=none; b=I+VVq9j5HE9uCunQ8ukz3Yd7mdd3PAzgBEdr4rBkzfVHmJQOCS6Vtklt+Rr4VJstLEq6EgeQbO0sEwmEGoCAYJoFbq1FsLmQoHRc89WtopXwl2vcL8tSYAeN56nkclGBraV1b4me1dY6yNSZMdiRwC53wVpvnnD3haSBi0ou+js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478282; c=relaxed/simple;
	bh=dIaEc70DuEDsmJ8TDmmUVfQcmrkzeFJn9yFTnRRGR1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EY3oh9LkTsvnusFO9PrnzV2r5tAc56W6D5fGKdWczf0sXtgi2mp8RWiBJ86I3AgLKpC25DQLZys/zbbXd37+BSsJoVu37sKN8mDwBDqMgtrJ0S8JfRQzsezARY/3lDsFMY1MAFKzMk8IYSvMYulVl1p9lTHKhaSrjurEbXbRMWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5UjC8EI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5UjC8EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402B0C19425;
	Wed, 29 Apr 2026 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777478282;
	bh=dIaEc70DuEDsmJ8TDmmUVfQcmrkzeFJn9yFTnRRGR1g=;
	h=From:To:Cc:Subject:Date:From;
	b=h5UjC8EIY99Nl896I7489CKal2/wV+OHET9J4oLO5NbEPY5Me5VjuWsnflDOiEnZ3
	 STfJFEgpZQKJBE7krq4JKkxAM/Sycebiq8CJidH3sNXEY4E6SopB/HoU/ChwmeLs1q
	 gwrNgUVij5yrKKf8otdXOOeBTfCnol7pdnVNTJAABvJrsW/wznaqK12vb7HgyzVqXj
	 Nn1EC9T6mSaAa8Mfv6iNyf/6IaEtTcIucWaPdlXW5estWdxS/esMO5Y6qh0YAZH8OY
	 T1SB4i8RrpSJvSmht/wt1RkjhvLggHs+FbDH8t2+4yAjNdZcVdRbvJnPRuEEP+wJI8
	 Pl5s9DKOHuoTw==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v4 0/2] Skip SNP inititalization if CPUs are offlined
Date: Wed, 29 Apr 2026 09:56:34 -0600
Message-ID: <20260429155636.540040-1-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The sole change from v3 is to fix the error message.

v3 is here: https://lore.kernel.org/all/20260409195602.851513-1-tycho@kernel.org/

Tycho Andersen (AMD) (2):
  x86/sev: Do not initialize SNP if missing CPUs
  crypto/ccp: Skip SNP_INIT if preparation fails

 arch/x86/include/asm/sev.h   |  4 ++--
 arch/x86/virt/svm/sev.c      | 18 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.c |  4 +++-
 3 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 8f1aacb683ef4a49b83dcc40bfce022aaa4aa597
-- 
2.54.0

