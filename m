Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66239656D;
	Mon, 27 Apr 2026 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777323041; cv=none; b=eHu8i43+kfl74yOA0i4pEfcSZ0xfOZBKex9EDlSk/iX/M9dSCX0JuqTq3M7PYNY8n24HVm7tHG52AHCVTGjNx1DSPYp1k5RG/0opDX0KrUVCK94MI8S7LVq/r3f1dnaimRuSSJddVdz5sd3wfWPrFs/+xcRJ58dcvHKxFEc991I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777323041; c=relaxed/simple;
	bh=xioMO/UL0CvBPPzQEWOUt4oVRuZ2NEG3I7jSIsxV0YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOF+w2wWATW9/jTCd29fQEDfHxbOiy4q1y4bA7EhGfgmIy2jqrjcTq8Ip7mtQX4yAVVn2e9SCSNZAYdSacKxldE3Zh1Y8mTU6OQ62KH7LGxc6QLhVgPsyg+LrllwFY2unVc7MpynkmoIZR91HdFY+HwEC5/eWNBFxv79QklqBk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luPmFpvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luPmFpvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D901EC2BCB9;
	Mon, 27 Apr 2026 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777323040;
	bh=xioMO/UL0CvBPPzQEWOUt4oVRuZ2NEG3I7jSIsxV0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luPmFpvX04zWv09jN2p0rhoLxkN6Hz9rsT1L2yh1xVBEjQqwKgy06DcHcmXh0hUJ8
	 eqk/zabuzvO3sj6FxAmHTC3xSbvrf2IAwt+ZuasXf7AftXLThwbk3+3ov92IQWeYMZ
	 zBOGaTmLi9W9RE9EqDX6XzUDXS7aFDrDcKrMVpGLIeiZrM6zQGbQUmPfOJHRBFBXZD
	 URu5UFobS1sFLKwyVhNs1flbQ9k1fJgVkNgYac8dmAz8IwkLl/HCIkyFX3zbYkpCXE
	 5HTbznyXU6EB6SiurCmxBipev5Myr1GIkacGNw+ypEU9iZtUoVkJPzbQXs4E14/fc/
	 PogzEij2bKxmg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 2/4] crypto/ccp: Support setting RAPL_DIS in SNP_INIT_EX
Date: Mon, 27 Apr 2026 14:48:45 -0600
Message-ID: <20260427204847.112899-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427204847.112899-1-tycho@kernel.org>
References: <20260427204847.112899-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

From the PLATYPUS [1] attack paper:

    We exploit unprivileged access to the Intel Running Average Power Limit
    (RAPL) interface that exposes values directly correlated with power
    consumption, forming a low-resolution side channel.

The SEV firmware offers a mechanism to freeze RAPL counters across all
cores during SNP initialization via the RAPL_DIS bit in SNP_INIT_EX. The
counters remain frozen while SNP is initialized, and resume after an SNP
shutdown.

The SEV firmware also has a RAPL_DIS policy bit, allowing guests to enforce
that RAPL is disabled on a system before running. Since the kernel had no
way to set the RAPL_DIS bit during SNP init, trying to set the policy bit
would always result in a failed launch.

Allow setting the RAPL_DIS bit during SNP_INIT_EX via
struct sev_platform_init_args.

If the hardware does not support RAPL_DIS, set the rapl_disable parameter
to false so that consumers can detect when it was not actually initialized.

[1]: https://platypusattack.com/platypus.pdf

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 14 +++++++++++++-
 include/linux/psp-sev.h      |  2 ++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index bf54a3fadb28..6223d63e676e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1365,8 +1365,11 @@ static int __sev_snp_init_locked(struct sev_platform_init_args *args)
 
 	sev = psp->sev_data;
 
-	if (sev->snp_initialized)
+	if (sev->snp_initialized) {
+		if (args->rapl_disable && !sev->snp_plat_status.rapl_dis)
+			args->rapl_disable = false;
 		return 0;
+	}
 
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
@@ -1376,6 +1379,12 @@ static int __sev_snp_init_locked(struct sev_platform_init_args *args)
 
 	snp_prepare();
 
+	if (args->rapl_disable && !(sev->snp_feat_info_0.ecx & SNP_RAPL_DISABLE_SUPPORTED)) {
+		dev_info(sev->dev,
+			"SEV: RAPL_DIS requested, but not supported\n");
+		args->rapl_disable = false;
+	}
+
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
 	 * of system physical address ranges to convert into HV-fixed page
@@ -1426,6 +1435,9 @@ static int __sev_snp_init_locked(struct sev_platform_init_args *args)
 			data.max_snp_asid = args->max_snp_asid;
 		}
 
+		if (args->rapl_disable)
+			data.rapl_dis = 1;
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d5099a2baca5..55ffc098d573 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -848,11 +848,13 @@ struct sev_data_snp_shutdown_ex {
  *  unless psp_init_on_probe module param is set
  * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
  *  maximum ASID that can be used for an SEV-SNP guest.
+ * @rapl_disable: Whether or not to set the RAPL_DIS bit during SNP_INIT_EX.
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
 	unsigned int max_snp_asid;
+	bool rapl_disable;
 };
 
 /**
-- 
2.53.0

