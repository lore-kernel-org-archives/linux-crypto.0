Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD7731F9AE;
	Tue, 24 Mar 2026 19:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381322; cv=none; b=Ybe/hpzDmKdQtMQxRE4rZdx0ie+3q6CHfvfxKL/kBJsddCZNILBkvHV0Jg6KVUk8EoBgYMYcfRGSBO8cjqQyRyx9wuV2ZGWLPKnHLrsM6oFvN+fED7rl58bJqxdopvPREMQcDx/Q7usIHl7TzPWyLzwB5oJ62KDbrgr8tNm87yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381322; c=relaxed/simple;
	bh=EDp2PqomJ7j/PaKC37IBr/64z9hRuHXco1IUNza/j7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxlO5Vxc5HKcd0PojYSXBnIrBzFY9Q3q/32NYIcfNPM2cRFaxNmI4ScwGxgT1sQTjgn5wAQJlzDljlW0zHN/7rox9XITeQR+zMUVH5rt9dVP3ci+OcqPVPsMIKi47lexzGKYoYOqNa5sfQ25wENkr2YZM/z/NYnELmZGk1V7QNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBQwnK//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBQwnK//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429DEC2BCB2;
	Tue, 24 Mar 2026 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381322;
	bh=EDp2PqomJ7j/PaKC37IBr/64z9hRuHXco1IUNza/j7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBQwnK//oM+RnXbrzeoFI5pONhC9XR2JG96K6YLtnwhKsbDsC+CHLnOEB+OqfLOsQ
	 lW0/VBvmyjDHNueFRwk00F+cWoJtsC4E8ZvM9lvegTcdUrXTV1Nu7HorYZxycARAU6
	 N5qfVR3ZG0HsV5laIJ5TJOc1nG+oMg/2bZ/p+OkJBsI6E6iwd6ZKkNW3v+Rxuz8gMo
	 DMORGJM4CqfHhQDkr8YlYaqVB00K1HmYfsIuh7k2njJnKxX7gsq8INN5QED16tST+4
	 X3CEptoWI4rks1MOy1fiEF8gkCcfyyOmWqr/qA4S2DmH7Ae9ch+9nUfMYpRg1Yc8+d
	 WZcFBs6S1IlqQ==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 2/5] crypto/ccp: export firmware supported vm types
Date: Tue, 24 Mar 2026 13:40:31 -0600
Message-ID: <20260324194034.1442133-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324194034.1442133-1-tycho@kernel.org>
References: <20260324194034.1442133-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In some configurations, the firmware does not support all VM types. The SEV
firmware has an entry in the TCB_VERSION structure referred to as the
Security Version Number in the SEV-SNP firmware specification and referred
to as the "SPL" in SEV firmware release notes. The SEV firmware release
notes say:

    On every SEV firmware release where a security mitigation has been
    added, the SNP SPL gets increased by 1. This is to let users know that
    it is important to update to this version.

The SEV firmware release that fixed CVE-2025-48514 by disabling SEV-ES
support on vulnerable platforms has this SVN increased to reflect the fix.
The SVN is platform-specific, as is the structure of TCB_VERSION.

Check CURRENT_TCB instead of REPORTED_TCB, since the firmware behaves with
the CURRENT_TCB SVN level and will reject SEV-ES VMs accordingly.

Parse the SVN, and mask off the SEV_ES supported VM type from the list of
supported types if it is above the per-platform threshold for the relevant
platforms.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 70 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 37 +++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 64fc402f58df..1e3286c048fe 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2940,3 +2940,73 @@ void sev_pci_exit(void)
 
 	sev_firmware_shutdown(sev);
 }
+
+static int get_v1_svn(struct sev_device *sev)
+{
+	struct sev_snp_tcb_version_genoa_milan *tcb;
+	struct sev_user_data_snp_status status;
+	int ret, error = 0;
+
+	mutex_lock(&sev_cmd_mutex);
+	ret = __sev_do_snp_platform_status(&status, &error);
+	mutex_unlock(&sev_cmd_mutex);
+	if (ret < 0)
+		return ret;
+
+	tcb = (struct sev_snp_tcb_version_genoa_milan *)&status
+		      .current_tcb_version;
+	return tcb->snp;
+}
+
+static int get_v2_svn(struct sev_device *sev)
+{
+	struct sev_user_data_snp_status status;
+	struct sev_snp_tcb_version_turin *tcb;
+	int ret, error = 0;
+
+	mutex_lock(&sev_cmd_mutex);
+	ret = __sev_do_snp_platform_status(&status, &error);
+	mutex_unlock(&sev_cmd_mutex);
+	if (ret < 0)
+		return ret;
+
+	tcb = (struct sev_snp_tcb_version_turin *)&status
+		      .current_tcb_version;
+	return tcb->snp;
+}
+
+static bool sev_firmware_allows_es(struct sev_device *sev)
+{
+	/* Documented in AMD-SB-3023 */
+	if (boot_cpu_has(X86_FEATURE_ZEN4) || boot_cpu_has(X86_FEATURE_ZEN3))
+		return get_v1_svn(sev) < 0x1b;
+	else if (boot_cpu_has(X86_FEATURE_ZEN5))
+		return get_v2_svn(sev) < 0x4;
+	else
+		return true;
+}
+
+int sev_firmware_supported_vm_types(void)
+{
+	int supported_vm_types = 0;
+	struct sev_device *sev;
+
+	if (!psp_master || !psp_master->sev_data)
+		return supported_vm_types;
+	sev = psp_master->sev_data;
+
+	supported_vm_types |= BIT(KVM_X86_SEV_VM);
+	supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+
+	if (!sev->snp_initialized)
+		return supported_vm_types;
+
+	supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+	if (!sev_firmware_allows_es(sev))
+		supported_vm_types &= ~BIT(KVM_X86_SEV_ES_VM);
+
+	return supported_vm_types;
+
+}
+EXPORT_SYMBOL_FOR_MODULES(sev_firmware_supported_vm_types, "kvm-amd");
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..383a682e94fd 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -899,6 +899,42 @@ struct snp_feature_info {
 /* Feature bits in EBX */
 #define SNP_SEV_TIO_SUPPORTED			BIT(1)
 
+/**
+ * struct sev_snp_tcb_version_genoa_milan
+ *
+ * @boot_loader: SVN of PSP bootloader
+ * @tee: SVN of PSP operating system
+ * @reserved: reserved
+ * @snp: SVN of SNP firmware
+ * @microcode: Lowest current patch level of all cores
+ */
+struct sev_snp_tcb_version_genoa_milan {
+	u8 boot_loader;
+	u8 tee;
+	u8 reserved[4];
+	u8 snp;
+	u8 microcode;
+};
+
+/**
+ * struct sev_snp_tcb_version_turin
+ *
+ * @fmc: SVN of FMC firmware
+ * @boot_loader: SVN of PSP bootloader
+ * @tee: SVN of PSP operating system
+ * @snp: SVN of SNP firmware
+ * @reserved: reserved
+ * @microcode: Lowest current patch level of all cores
+ */
+struct sev_snp_tcb_version_turin {
+	u8 fmc;
+	u8 boot_loader;
+	u8 tee;
+	u8 snp;
+	u8 reserved[3];
+	u8 microcode;
+};
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
@@ -1045,6 +1081,7 @@ void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
 bool sev_is_snp_ciphertext_hiding_supported(void);
 u64 sev_get_snp_policy_bits(void);
+int sev_firmware_supported_vm_types(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
-- 
2.53.0

