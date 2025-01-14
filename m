Received: from zxbjcas.zhaoxin.com (zxbjcas.zhaoxin.com [124.127.214.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6421C190;
	Wed, 15 Jan 2025 03:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.127.214.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913505; cv=none; b=HkWEHe7KmcDaEGxh4DmTzu/8QVGijvP7t+ytA4lTjItke4BGzyug2W0arJQ5mE1Pq2H4mJUClnMB3r1fOl131QGpyMSzA7DCVW+ZH//85MsPG2tAf2gFFYqL+KdTKKIrPGflcX4nKtNYXCamhtO4r9gS7sUOCMczMiBgzoGUvI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913505; c=relaxed/simple;
	bh=cYGFKlgd4SSkI92x/MDN+1caDaBNPEj+ttaY7igNQV8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k94geMI2o8SJt6U0jb6218/WfsrXEVDwMedlcjzri4Xk1BDwDeEZTbP9/LcNeT7czIxFok52L7saEHaE3eqxuIDPEXL7AtRyE4tLg4otJU7US7YOLnQwhbxd0CCfx+DL0NsS2I88Zdk39yi39VhE4LLUZyznXJpEYQCQmfrKvDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=124.127.214.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zxbjcas.zhaoxin.com (localhost [127.0.0.2] (may be forged))
	by zxbjcas.zhaoxin.com with ESMTP id 50F3W4Ng014586;
	Wed, 15 Jan 2025 11:32:04 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from ZXBJMBX02.zhaoxin.com (ZXBJMBX02.zhaoxin.com [10.29.252.6])
	by zxbjcas.zhaoxin.com with ESMTP id 50F3T62k013867;
	Wed, 15 Jan 2025 11:29:06 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 15 Jan
 2025 11:29:05 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64]) by
 ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64%7]) with mapi id
 15.01.2507.039; Wed, 15 Jan 2025 11:29:05 +0800
Received: from tony.zhaoxin.com (10.32.65.152) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 14 Jan
 2025 20:12:50 +0800
From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <pawan.kumar.gupta@linux.intel.com>, <jpoimboe@kernel.org>,
        <daniel.sneddon@linux.intel.com>, <perry.yuan@amd.com>,
        <thomas.lendacky@amd.com>, <sandipan.das@amd.com>,
        <namhyung@kernel.org>, <acme@redhat.com>, <xin3.li@intel.com>,
        <brijesh.singh@amd.com>, <TonyWWang-oc@zhaoxin.com>,
        <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TimGuo@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>,
        <GeorgeXue@zhaoxin.com>
Subject: [PATCH v3 0/2] Add Zhaoxin hardware engine driver support for SHA
Date: Tue, 14 Jan 2025 20:12:59 +0800
Message-ID: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX03.zhaoxin.com (10.29.252.7)
X-Moderation-Data: 1/15/2025 11:29:03 AM
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:zxbjcas.zhaoxin.com 50F3W4Ng014586

Zhaoxin currently uses CPUID leaf 0xC0000001 instead of VIA/Cyrix/
Centaur to represent the presence or absence of certain CPU features
due to company changes. The previously occupied bits in CPUID leaf
0xC0000001 remain functional, and the unoccupied bits are used by
Zhaoxin to represent some new CPU features.

Zhaoxin CPUs implements the PadLock Hash Engine v2 feature on the
basis of features supported by CPUID leaf 0xC0000001, which indicates
that Zhaoxin CPUs support SHA384/SHA512 algorithm hardware instructions.
So add two Padlock Hash Engine v2 feature flags support in cpufeatures.h

Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
instructions, including SHA1, SHA256, SHA384 and SHA512, which conform
to the Secure Hash Algorithms specified by FIPS 180-3.

Zhaoxin CPU's SHA1/SHA256 implementation is compatible with VIA's
SHA1/SHA256, so add Zhaoxin CPU's SHA384/SHA512 support in padlock-sha.c.

v2 link is below:
https://lore.kernel.org/all/20240123022852.2475-1-TonyWWang-oc@zhaoxin.com/

v1 link is below:
https://lore.kernel.org/all/20240116063549.3016-1-TonyWWang-oc@zhaoxin.com/

---
v2->v3:
- Add Zhaoxin SHA384/SHA512 support in padlock-sha
v1->v2:
- Make Zhaoxin SHA depends on X86 && !UML
- Update MAINTAINERS for Zhaoxin SHA


Tony W Wang-oc (2):
  x86/cpufeatures: Add CPU feature flags for Zhaoxin Hash Engine v2
  crypto: Add Zhaoxin PadLock Hash Engine support for SHA384/SHA512

 arch/x86/include/asm/cpufeatures.h       |   4 +-
 drivers/crypto/Kconfig                   |  10 +-
 drivers/crypto/padlock-sha.c             | 200 ++++++++++++++++++++++-
 tools/arch/x86/include/asm/cpufeatures.h |   4 +-
 4 files changed, 208 insertions(+), 10 deletions(-)

--=20
2.25.1

