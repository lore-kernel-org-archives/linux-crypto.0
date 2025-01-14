Received: from zxbjcas.zhaoxin.com (zxbjcas.zhaoxin.com [124.127.214.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEBE15250F;
	Wed, 15 Jan 2025 03:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.127.214.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913483; cv=none; b=esWHgjA7Vx0UbojAY4INXJSdUT7AQU+sZV6pyioNEg1ffOL95Z8PIU/JhM2rhIb0/sJQ/xjs6Hqd142bG+LdAx/SmrG4TF4NcaESkMmiRSXKQmqbohq4geDfL9egzgwvima0Iir8qTJmkVUeLXGTV2eQj5xpuQU9Gmjg+Urjj2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913483; c=relaxed/simple;
	bh=JI2tQDpge/uA7aClnvx9Zrq/4FFihdCyqzLYekxXXDQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GB9Qof2RL36KsKzItVRRYHPFhomBUyLR+F+uRlah7B4SrfSVt7jzH9sUpyyJ5Kiro9sNqH3TenvJEH3tT9sRCuMC4xvpUbPej5r1LSF7x/Ad8ilnERXXe7Kz2VSAhfUhdHdwbDfVtXg6VomrtMgrYPklBZO+M2DOcGBaxP1LhdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=124.127.214.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zxbjcas.zhaoxin.com (localhost [127.0.0.2] (may be forged))
	by zxbjcas.zhaoxin.com with ESMTP id 50F3VswZ014561;
	Wed, 15 Jan 2025 11:31:54 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from zxbjmbx1.zhaoxin.com (zxbjmbx1.zhaoxin.com [10.29.252.163])
	by zxbjcas.zhaoxin.com with ESMTP id 50F3T9fi013878;
	Wed, 15 Jan 2025 11:29:09 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 15 Jan
 2025 11:29:08 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64]) by
 ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64%7]) with mapi id
 15.01.2507.039; Wed, 15 Jan 2025 11:29:08 +0800
Received: from tony.zhaoxin.com (10.32.65.152) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 14 Jan
 2025 20:12:53 +0800
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
Subject: [PATCH 1/2] x86/cpufeatures: Add CPU feature flags for Zhaoxin Hash Engine v2
Date: Tue, 14 Jan 2025 20:13:00 +0800
Message-ID: <20250114121301.156359-2-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
References: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
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
X-Moderation-Data: 1/15/2025 11:29:07 AM
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:zxbjcas.zhaoxin.com 50F3VswZ014561

Zhaoxin currently uses CPUID leaf 0xC0000001 instead of VIA/Cyrix/
Centaur to represent the presence or absence of certain CPU features
due to company changes. The previously occupied bits in CPUID leaf
0xC0000001 remain functional, and the unoccupied bits are used by
Zhaoxin to represent some new CPU features.

Zhaoxin CPUs implements the PadLock Hash Engine v2 feature on the
basis of features supported by CPUID leaf 0xC0000001, which indicates
that Zhaoxin CPUs support SHA384/SHA512 algorithm hardware instructions.

Add two Padlock Hash Engine v2 feature flags support in cpufeatures.h

Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
---
 arch/x86/include/asm/cpufeatures.h       | 4 +++-
 tools/arch/x86/include/asm/cpufeatures.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
index 508c0dad116b..92d2a83499d0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -143,7 +143,7 @@
 #define X86_FEATURE_RDRAND		( 4*32+30) /* "rdrand" RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR		( 4*32+31) /* "hypervisor" Running on a hy=
pervisor */
=20
-/* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 =
*/
+/* Zhaoxin/VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001,=
 word 5 */
 #define X86_FEATURE_XSTORE		( 5*32+ 2) /* "rng" RNG present (xstore) */
 #define X86_FEATURE_XSTORE_EN		( 5*32+ 3) /* "rng_en" RNG enabled */
 #define X86_FEATURE_XCRYPT		( 5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
@@ -154,6 +154,8 @@
 #define X86_FEATURE_PHE_EN		( 5*32+11) /* "phe_en" PHE enabled */
 #define X86_FEATURE_PMM			( 5*32+12) /* "pmm" PadLock Montgomery Multiplie=
r */
 #define X86_FEATURE_PMM_EN		( 5*32+13) /* "pmm_en" PMM enabled */
+#define X86_FEATURE_PHE2		( 5*32+25) /* "phe2" Zhaoxin PadLock Hash Engine=
 v2 */
+#define X86_FEATURE_PHE2_EN		( 5*32+26) /* "phe2_en" PHE2 enabled */
=20
 /* More extended AMD flags: CPUID level 0x80000001, ECX, word 6 */
 #define X86_FEATURE_LAHF_LM		( 6*32+ 0) /* "lahf_lm" LAHF/SAHF in long mod=
e */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/incl=
ude/asm/cpufeatures.h
index 17b6590748c0..2206fe3ce49e 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -143,7 +143,7 @@
 #define X86_FEATURE_RDRAND		( 4*32+30) /* "rdrand" RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR		( 4*32+31) /* "hypervisor" Running on a hy=
pervisor */
=20
-/* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 =
*/
+/* Zhaoxin/VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001,=
 word 5 */
 #define X86_FEATURE_XSTORE		( 5*32+ 2) /* "rng" RNG present (xstore) */
 #define X86_FEATURE_XSTORE_EN		( 5*32+ 3) /* "rng_en" RNG enabled */
 #define X86_FEATURE_XCRYPT		( 5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
@@ -154,6 +154,8 @@
 #define X86_FEATURE_PHE_EN		( 5*32+11) /* "phe_en" PHE enabled */
 #define X86_FEATURE_PMM			( 5*32+12) /* "pmm" PadLock Montgomery Multiplie=
r */
 #define X86_FEATURE_PMM_EN		( 5*32+13) /* "pmm_en" PMM enabled */
+#define X86_FEATURE_PHE2		( 5*32+25) /* "phe2" Zhaoxin Padlock Hash Engine=
 v2 */
+#define X86_FEATURE_PHE2_EN		( 5*32+26) /* "phe2_en" PHE2 enabled */
=20
 /* More extended AMD flags: CPUID level 0x80000001, ECX, word 6 */
 #define X86_FEATURE_LAHF_LM		( 6*32+ 0) /* "lahf_lm" LAHF/SAHF in long mod=
e */
--=20
2.25.1

