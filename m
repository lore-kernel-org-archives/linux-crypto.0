Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09A2EFD86;
	Mon, 19 Jan 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840962; cv=none; b=iWlxmawY9cWTvk0TSolId4fcq9nRkLironUrBVs3vTrb9DFV1+e4eHLuRRyDzvtGKZ7Fpg+D3dF5v0N9/ywjA4b6wF2h37D5SbdZgd6J9vUoF82bJhY4fs4dCoSxVz28IHSNTEKpApuRfIOx3LbyUKCPfzya9D7dKaAVpdNRvNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840962; c=relaxed/simple;
	bh=1VZsu9LsLuH1ggECT86Hb3smqTOxy9/ZekvmUGwGVIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RawW6rUrY5F+wlQNsDO580RcfwJSlxt+vRuGsGGU71Hfbe7lNOICsfwx3ZMtjKVW7xX9Fk73nBreiLQWTwlOI1IufXb7f2RGEy57/tJDVmaAFYhi9TnwIAcRyRoVKWThmYre6P4zQLJpYeXpm34+mI+nqRpgW/bP5AhcwwI4X4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=G0wV/e9C; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="G0wV/e9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1768840952; bh=1VZsu9LsLuH1ggECT86Hb3smqTOxy9/ZekvmUGwGVIk=;
	h=From:To:Cc:Subject;
	b=G0wV/e9Cac2ASjlkLdJBU4Qc1umHKDEDSpL5FXAnboC4mmXPRrqfNR8ROVkthRcqF
	 hlu5CSxlGHh8DsfiIpHu/4m2wn/1aJNVxxQ8QBqFV3lKfOO/23YpjKGH8TZO9mqEAO
	 wmpQxcCcL+Ua99FJ+Z3frL3Z/X1DaXQkILcSdq1jubB4XnvFZlG90Eawm0baikHoj8
	 QtFF+yruQZaUwY1RpY0zti1Ts4pNyY/XSjwnqRzrU4VXkvE/Q13nmDuQJN6ZsrEgoH
	 s/DZeCpBTblNgWzHOJJoRmJFt+vsQ4C6FwZ/h3m7BnxlWjSDULf+Vv6prhtiN6NiK4
	 BIbEXd2PqJ5Ag==
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
Subject: [PATCH v3 RESEND v3 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ
Date: Mon, 19 Jan 2026 17:42:27 +0100
Message-ID: <20260119164228.2108498-1-thomas.courrege@thorondor.fr>
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

 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 128 insertions(+)

-- 
2.52.0
