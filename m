Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA862472A6;
	Thu,  9 Apr 2026 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775764580; cv=none; b=Kd94CTPt3Hcm0fx1anNGNHSxcGlSF87O8GgJu/0cRMk4EeZMZC6n91/s9veUKnM6MkE75Oe8SjQFV4Ro0RmzaEAkP6KuBfZy7OYHGqqXH/VpFXRZxetoR2Rssq9H5NNMbFO26jCGOnmPC7ZP5FsvttwoKlUywy6noIXawesdbRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775764580; c=relaxed/simple;
	bh=AWsXnQv98fIRWxVfdx70zhiJpa6+Hdrpnsq8JUjO7PM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TIfPO9Puf7QZnwgix8ZbkAQtO3MktQUAVDMXZTq+uOmmQtr3lYZIfhk/LYKKXkf4/PQ90ZZHQUg6A+xa6lt0/ujNDnoppKT1xeAQq5V0OctflTBtO5sHqUnN520xivRPNHEwYit7IOGVmXVB4WS0HkNMmVLMqwUlX57q/yZUI8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUowbXXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUowbXXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA8FC4CEF7;
	Thu,  9 Apr 2026 19:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775764579;
	bh=AWsXnQv98fIRWxVfdx70zhiJpa6+Hdrpnsq8JUjO7PM=;
	h=From:To:Cc:Subject:Date:From;
	b=oUowbXXwJ8tET9Zf5u1wpTdll+QBnDwkiDIE52cEaL+lGUVZROjvrrRm5mS2eSNn5
	 YfhYJBGVe88QG53GxjNrtYWEVWAimSLjNwP5wpMxRmACYWEnBQGV8k3icJSrddkCk1
	 ZSN9XJGH3JKOs/w0JiQz/6nGpVx2pPqBjbF9RDdl+j/Tg2bBe3ysapJJzwJ49NJK7D
	 ZpepKvWTTrmjMjGl36GE3bRrwxAjNI5rwg/2E5PDrvDIufuNv47/04HO/khJnSJObQ
	 nkt3IuUzMirbd+ISNJg9JNpfgjYZpZZUwxIRwsPjfnnMd21+hDageQkOXm03vkVG9S
	 dwODzNXW0jXDw==
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
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v3 0/2] Skip SNP initialization if CPUs are offlined
Date: Thu,  9 Apr 2026 13:56:00 -0600
Message-ID: <20260409195602.851513-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Changes are:

* add some newlines
* move error setting into cpumask check
* head off AI review complaints by adding the note about SNP failing all
  initialization previously to commit message of patch two
* drop mention of reasons for snp_prepare() failure from commit message
  of patch two
* carry review tags as appropriate

v2 is here: https://lore.kernel.org/all/20260407174713.439474-1-tycho@kernel.org/

Tycho Andersen (AMD) (2):
  x86/sev: Do not initialize SNP if missing CPUs
  crypto/ccp: Skip SNP_INIT if preparation fails

 arch/x86/include/asm/sev.h   |  4 ++--
 arch/x86/virt/svm/sev.c      | 18 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.c |  4 +++-
 3 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 6c927e5ca9d238f8ae40b453a8382eb9cf4ee855
-- 
2.53.0

