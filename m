Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D282528FD;
	Fri, 23 Jan 2026 11:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769169216; cv=none; b=pnDVRDhPSAMGHctsl7y6XIHeVCRplz8Xr5hMRW3jstO2UkI3XMwB+lVGWc5QfPTNGD8Zz9Du7QUQRZ8qUE+DqQES7Ksq9UnlR3QAaxItWco8n/s8dnKQ7lHtjDk/PNIL8E6xb1zx4vgw7uA9MhrdXqtScr7WZ7FS5wdeBbWQdY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769169216; c=relaxed/simple;
	bh=8ltmt17sKrOxdbQGDeGpA+eDpc3qM4YKEMJSVX4V+as=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QKi2VH6JckTdu8z+KhNt0Y/+VPcM6jyWw4HAAvqoY054QvVQedChCuu20N1yG8La1phqDl5N3PVo0Pk1t5T5/1XHh+oo8BIUyGef0JQX4nz2lK77HCrM1FFL2Q07D2uuQPQYcg6V3JSgjEt3adyzsPZB+gyOhxebbrK8KPgyMWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=eoYGr8FI; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="eoYGr8FI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769169207; bh=8ltmt17sKrOxdbQGDeGpA+eDpc3qM4YKEMJSVX4V+as=;
	h=From:To:Cc:Subject;
	b=eoYGr8FIYsDquTQOZ+mesrjm/NnECNLE2JiMd6QFtBV8+GIxHicw+zVo45AwD3ALf
	 04soeumGbn0kLEAhQfzbIvby8QJ1zrmUxV67Gca14MhIWsbuTc5IFNtK+zu02Z8ytV
	 kpBcPWEFzAgybJLXwD2qmRYGP/FQDdYpjbP2ZX8Y1rzUbIDTb0gQBV7iEyvVkzZWGx
	 waJh0KkBTLZT4P1516oxXwQJmmp1CZCzMHlqQe3Tqu8Btt1SzmH96I0eHiiZJj54t+
	 A5tiktbarorJArBeVNLUJBL9H/STJaMdd+uBsi4jtVUytmfacvzQG33lQ6f9Su8bfM
	 QS2z77H5QE9Cg==
From: Thomas Courrege <thomas.courrege@thorondor.fr>
To: ashish.kalra@amd.com,
	corbet@lwn.net,
	herbert@gondor.apana.org.au,
	john.allen@amd.com,
	nikunj@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Thomas Courrege <thomas.courrege@thorondor.fr>
Subject: [PATCH v4 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Fri, 23 Jan 2026 12:53:04 +0100
Message-ID: <20260123115306.430069-1-thomas.courrege@thorondor.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For testing this via QEMU, please use the following tree:
        https://github.com/Th0rOnDoR/qemu

Any feedback is appreciated.

Thanks,
Thomas

Thomas Courrege (1):
  KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command

 .../virt/kvm/x86/amd-memory-encryption.rst    | 29 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 130 insertions(+)


base-commit: 3611ca7c12b740e250d83f8bbe3554b740c503b0
-- 
2.52.0

