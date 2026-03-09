Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE42C11D1;
	Mon,  9 Mar 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079272; cv=none; b=azx9p+zie7JZMiqY2wBEBF5wTZvD86sG9+VTB3Ag1vXwo3dvYSZkyVE1CFjQOvxykJ4Z+wBPRojjrwghrMwYbR0VzUVwB9fgEmu0cmZlgHYFAgpXJVy24t2nV4Adme/kp5AhZq+d0siW0yrFjlZASPB9CA+j0/38qR064p9zoSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079272; c=relaxed/simple;
	bh=omXIrDpdIqi3o5BW4XsJcO58ut9DRxY4c/VDjtGZInY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNfZ3VH/wNMaBECYuN+QW2pKYNiJsBmsrfzUn60NNMkhOGgdisAWsEuO9n08salxXNetBaYxBRPqap9CzBJ027hQNMwlwPntWLYdRabY3iu2Vxl6AbvHxy7XePAc7upeLuZhcIVChBwN2T1YmaayrkWO1ippU06RHqNtCBcgotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqFC7WcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqFC7WcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D44C4CEF7;
	Mon,  9 Mar 2026 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079272;
	bh=omXIrDpdIqi3o5BW4XsJcO58ut9DRxY4c/VDjtGZInY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqFC7WcHTw1Uh7UGLlwKPaxmAlRaezI7Oxm1kRcG0aOArrxLtB8OZq+p2r9+9m3G8
	 R5kmcNuNlv1UcQfJkL95J1Q/3fTx8lZuw2lLqqkBGMg/Eg/IgbA0wcx23L60DiRmfX
	 MZb/ZG4yY9lL4mXFiJZtoC03nDGZBYJUqYNZTiIgACxLUysXo0FI846Qncyu7v0lk4
	 /gCz4WuK1SwdNWfQ6f20dtuYA3tiM+pT3szG44bE/JJMxk9/pTYsuD+u7jDY83H6oZ
	 4W9npL7U0vPuTkJznU1P+siU1+nlgmgiuDtLC6k8vp5B9LYS+oV98i/WBpFMHkDppo
	 DdFE6TAV5qVtw==
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
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 00/10] Move SNP initialization to the CCP driver
Date: Mon,  9 Mar 2026 12:00:42 -0600
Message-ID: <20260309180053.2389118-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
References: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Here's v2 of the series. Changes are:

* squash MFDM helper into snp_x86_shutdown()
* move MFDM helper to msr_set/clear_bit()
* move SNP bit test during shutdown from ccp into snp_x86_shutdown()
* reorder so that the two code deletion patches come first
* commit message rewrites, carry Tom's reivews as appropriate

Tom Lendacky (3):
  x86/snp: Keep the RMP table bookkeeping area mapped
  x86/snp: Create a function to clear/zero the RMP
  crypto: ccp - Update HV_FIXED page states to allow freeing of memory

Tycho Andersen (AMD) (7):
  x86/snp: drop support for SNP hotplug
  x86/snp: drop WBINVD before setting SNPEn
  x86/snp: create snp_prepare_for_snp_init()
  x86/snp, crypto: move SNP init to ccp driver
  x86/snp, crypto: move HSAVE_PA setup to arch/
  x86/snp: create snp_x86_shutdown()
  crypto: ccp - implement SNP x86 shutdown

 arch/x86/include/asm/sev.h   |   4 +
 arch/x86/virt/svm/sev.c      | 161 +++++++++++++++++++----------------
 drivers/crypto/ccp/sev-dev.c |  62 ++++++++------
 include/linux/psp-sev.h      |   4 +-
 4 files changed, 129 insertions(+), 102 deletions(-)


base-commit: 59f9bfe4641c408c08824a9b52e9f7839bde57d8
-- 
2.53.0

