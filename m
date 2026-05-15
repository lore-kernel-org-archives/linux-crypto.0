Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916BE481FAB
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879712; cv=none; b=DgpKrsa0mfa/iuq+4XFZ0/Syrw/NeERJm7A9ssDWJ/OiKsNsIqld5yM/+5XilfjqOWTGzXEEz8LH2c1fJRJwXYTlhPlPzoYTqr3bBsvcSdhJZMOsQMSPPKbQMz5ogE9c00EeaIFsdtAM5w2M+MRZk9A6xdmAuVyqgOU5s3MypM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879712; c=relaxed/simple;
	bh=pAXY0cHMIh7GVzLL6RPpIUoU+IBO2kv57N0YT/cgq+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaGBJbxbl1ZEzXsbRfUoPeCJWYLfRPfMSPZ5yzQ+4nSsKENUKtXb/lekjgCPVd5Ko0yN/zWiit3t8bzwsdiJIy60Y6RCZWfsSU5xZbK4oJnzi00kwOSyH3STNhXEqbgvYGCG5HSMJHN7HgakCs+pfK88KGp/Bu2DavIzuqPDusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsjuM1C+; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsjuM1C+"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2f7ca62a3c4so297023eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879710; x=1779484510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4K56Y7dB3RpP0PwvxsPRXyN2MFU4pj7XmWxeU528To=;
        b=PsjuM1C+3PP+EwtxvdqhNFen+oroC06LSGkrGwne3yeDnRGRb4iFQtAT58MezegbLH
         8shvobNMQWh4Zqy8Io2xabmmL/5c+3ovwLcMUX28diBB3TbJeR491XZdeUaHdHF/cJE8
         l+JmHuWFRP9ZEfuZUb4rKUKzmJvWh4dPc0+5d9u2DD8xfKqrDR5Q/OV+2LOVpFN5QHz5
         2xm7JZ5/Nc1nMg39yXkQxi25BQpf6pMCXnp0cKRfTnRXv/asnEEYt0g3fTAZDOjOUsg7
         J221wgFR20YPig4oGaELWXfbI2ZX1Fyr6gO+QAqi1FpuvU0Ek9rBgEZw/o44k6ki1w7g
         6hRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879710; x=1779484510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f4K56Y7dB3RpP0PwvxsPRXyN2MFU4pj7XmWxeU528To=;
        b=kZ/Ybpwyv1pi0fIr0TZC3rcwlfFm/hqOgQyGXZiBjcNLTj0FCbcV9gaxtgEFmLX4wQ
         BezPLMYnovrBMrPuk7Wd/yG/cHN6W6JW98GLuGSLx8xAuEGJXxVOwSwsRxtGUISd1C5u
         ly1mnnghFEura3OMFRZNTBVxS3dn7nCrk1XweLjee8PBBxkcP5G1kKRyLC9QGlOMNqXv
         Sbn2w8xT/UZuPSo4yGom09tyKzsu5z5Cv8TxJdk3r/9AKqyOben7vgajgYKHdtDFwXw1
         RzBTu+c1SwjXTG5rVR53NMsPN1rNNusyPZhOilRGOmgAG/UtZsfSeVdQ0JTHlKA/hKbh
         BlqA==
X-Forwarded-Encrypted: i=1; AFNElJ9sxPhMznHGHF2ufgRKp69Xe8XHF3dtMqrxjPetrLbK0ssVYQIHW+snDybsnrers0ArAHYdId+U65N8Zfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB8HS92KTmd9a+dATOtGJVtwFHJ3TWo9mGmwpMMj2vSaJ12eGv
	dIoPXm68BlWTdMioyHtubN2YuVaVf424djrUeSsYouQQ/bT/h9YhO1El
X-Gm-Gg: Acq92OFBtMmygpngIZ4cCmhnsH8JJjypPqCPyAtYt5SBmEIlAQ0kkFiWKU5d3v55RSN
	t/AvQ+7EtXUAkoee66MmztiEW8j8UPhI5Eq9UZ7IOtQ4YeEv2Gnctkw0DidM1owxqkFyDzwp6GO
	8fqIHQnTpZBFxdHV3o3l4IRcdMe0Qw9QV2oIU2ak8sLAiGhhQes2UIAiewSD7So9NSzQNTcVncc
	cY2a3uFAWbbe7KpPS3hUsmzjsi8VqdZUXXtS1RBswQjV6nupmQ6XLhU+NbsL9iQtB55K6q2dFcL
	QQ8ARVnRfwQ3wpih85lGSDFmRjrw1RcoWueiE1DymFb9V02Vyg/+owPz/hH0GdU/ZPCCuSCX4nJ
	Vp5W/GyCYffOtpsgCMVJw3TswC/mJMXtjxYmp2jBXK7sJ3QNzIFZVk3n46jbQ/+paN3ZGCNsrJx
	N0GT3q3WUJBhqoHSCf9pzTZkSXi2c86+k=
X-Received: by 2002:a05:7301:688:b0:2e2:5bc5:f8eb with SMTP id 5a478bee46e88-303982c04demr2937773eec.9.1778879709562;
        Fri, 15 May 2026 14:15:09 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bbd50sm7962080eec.20.2026.05.15.14.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:09 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 20/38] x86/txt: Intel Trusted eXecution Technology (TXT) definitions
Date: Fri, 15 May 2026 14:13:52 -0700
Message-ID: <20260515211410.31440-21-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel TXT architectural specific definitions. See the specification
for detailed information:

https://www.intel.com/content/dam/www/public/us/en/documents/guides/intel-txt-software-development-guide.pdf

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/include/asm/txt.h | 281 +++++++++++++++++++++++++++++++++++++
 1 file changed, 281 insertions(+)
 create mode 100644 arch/x86/include/asm/txt.h

diff --git a/arch/x86/include/asm/txt.h b/arch/x86/include/asm/txt.h
new file mode 100644
index 000000000000..eaec915d4878
--- /dev/null
+++ b/arch/x86/include/asm/txt.h
@@ -0,0 +1,281 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Intel Trusted eXecution Technology (TXT) Definitions
+ *
+ * Copyright (c) 2026 Apertus Solutions, LLC
+ * Copyright (c) 2026, Oracle and/or its affiliates.
+ */
+
+#ifndef _ASM_X86_TXT_H
+#define _ASM_X86_TXT_H
+
+/*
+ * Intel Safer Mode Extensions (SMX)
+ *
+ * Intel SMX provides a programming interface to establish a Measured Launched
+ * Environment (MLE). The measurement and protection mechanisms are supported by the
+ * capabilities of an Intel Trusted Execution Technology (TXT) platform. SMX is
+ * the processor's programming interface in an Intel TXT platform.
+ *
+ * See:
+ *   Intel SDM Volume 2 - 6.1 "Safer Mode Extensions Reference"
+ *   Intel Trusted Execution Technology - Measured Launch Environment Developer's Guide
+ */
+
+/*
+ * SMX GETSEC Leaf Functions
+ */
+#define SMX_X86_GETSEC_SEXIT	5
+#define SMX_X86_GETSEC_SMCTRL	7
+#define SMX_X86_GETSEC_WAKEUP	8
+
+/*
+ * Intel Trusted Execution Technology MMIO Registers Banks
+ */
+#define TXT_PUB_CONFIG_REGS_BASE	0xfed30000
+#define TXT_PRIV_CONFIG_REGS_BASE	0xfed20000
+#define TXT_NR_CONFIG_PAGES     ((TXT_PUB_CONFIG_REGS_BASE - \
+				  TXT_PRIV_CONFIG_REGS_BASE) >> PAGE_SHIFT)
+
+/*
+ * Intel Trusted Execution Technology (TXT) Registers
+ */
+#define TXT_CR_STS			0x0000
+#define TXT_CR_ESTS			0x0008
+#define TXT_CR_ERRORCODE		0x0030
+#define TXT_CR_CMD_RESET		0x0038
+#define TXT_CR_CMD_CLOSE_PRIVATE	0x0048
+#define TXT_CR_DIDVID			0x0110
+#define TXT_CR_VER_EMIF			0x0200
+#define TXT_CR_CMD_UNLOCK_MEM_CONFIG	0x0218
+#define TXT_CR_SINIT_BASE		0x0270
+#define TXT_CR_SINIT_SIZE		0x0278
+#define TXT_CR_MLE_JOIN			0x0290
+#define TXT_CR_HEAP_BASE		0x0300
+#define TXT_CR_HEAP_SIZE		0x0308
+#define TXT_CR_SCRATCHPAD		0x0378
+#define TXT_CR_CMD_OPEN_LOCALITY1	0x0380
+#define TXT_CR_CMD_CLOSE_LOCALITY1	0x0388
+#define TXT_CR_CMD_OPEN_LOCALITY2	0x0390
+#define TXT_CR_CMD_CLOSE_LOCALITY2	0x0398
+#define TXT_CR_CMD_SECRETS		0x08e0
+#define TXT_CR_CMD_NO_SECRETS		0x08e8
+#define TXT_CR_E2STS			0x08f0
+
+/* TXT default register value */
+#define TXT_REGVALUE_ONE		0x1ULL
+
+/* TXTCR_STS status bits */
+#define TXT_SENTER_DONE_STS		BIT(0)
+#define TXT_SEXIT_DONE_STS		BIT(1)
+
+/*
+ * SINIT/MLE Capabilities Field Bit Definitions
+ */
+#define TXT_SINIT_MLE_CAP_RLP_WAKE_GETSEC	0
+#define TXT_SINIT_MLE_CAP_RLP_WAKE_MONITOR	1
+
+/*
+ * OS/MLE Secure Launch Specific Definitions
+ */
+#define TXT_OS_MLE_STRUCT_VERSION	1
+#define TXT_OS_MLE_MAX_VARIABLE_MTRRS	32
+
+#ifndef __ASSEMBLER__
+
+/*
+ * TXT Heap extended data elements.
+ */
+struct txt_heap_ext_data_element {
+	u32 type;
+	u32 size;
+	/* Data */
+} __packed;
+
+#define TXT_HEAP_EXTDATA_TYPE_END			0
+
+struct txt_heap_end_element {
+	u32 type;
+	u32 size;
+} __packed;
+
+#define TXT_HEAP_EXTDATA_TYPE_TPM_EVENT_LOG_PTR		5
+
+struct txt_heap_event_log_element {
+	u64 event_log_phys_addr;
+} __packed;
+
+#define TXT_HEAP_EXTDATA_TYPE_EVENT_LOG_POINTER2_1	8
+
+struct txt_heap_event_log_pointer2_1_element {
+	u64 phys_addr;
+	u32 allocated_event_container_size;
+	u32 first_record_offset;
+	u32 next_record_offset;
+} __packed;
+
+/*
+ * TXT specification defined BIOS data TXT Heap table
+ */
+struct txt_bios_data {
+	u32 version; /* Currently 5 for TPM 1.2 and 6 for TPM 2.0 */
+	u32 bios_sinit_size;
+	u64 reserved1;
+	u64 reserved2;
+	u32 num_logical_procs;
+	u32 sinit_flags;
+	u32 mle_flags;
+	/* Versions >= 5 with updates in version 6 */
+	/* Ext Data Elements */
+} __packed;
+
+/*
+ * TXT specification defined OS/SINIT TXT Heap table
+ */
+struct txt_os_sinit_data {
+	u32 version; /* Currently 6 for TPM 1.2 and 7 for TPM 2.0 */
+	u32 flags;
+	u64 mle_ptab;
+	u64 mle_size;
+	u64 mle_hdr_base;
+	u64 vtd_pmr_lo_base;
+	u64 vtd_pmr_lo_size;
+	u64 vtd_pmr_hi_base;
+	u64 vtd_pmr_hi_size;
+	u64 lcp_po_base;
+	u64 lcp_po_size;
+	u32 capabilities;
+	/* Version = 5 */
+	u64 efi_rsdt_ptr;
+	/* Versions >= 6 */
+	/* Ext Data Elements */
+} __packed;
+
+/*
+ * TXT specification defined SINIT/MLE TXT Heap table
+ */
+struct txt_sinit_mle_data {
+	u32 version;             /* Current values are 6 through 9 */
+	/* Versions <= 8 */
+	u8 bios_acm_id[20];
+	u32 edx_senter_flags;
+	u64 mseg_valid;
+	u8 sinit_hash[20];
+	u8 mle_hash[20];
+	u8 stm_hash[20];
+	u8 lcp_policy_hash[20];
+	u32 lcp_policy_control;
+	/* Versions >= 7 */
+	u32 rlp_wakeup_addr;
+	u32 reserved;
+	u32 num_of_sinit_mdrs;
+	u32 sinit_mdrs_table_offset;
+	u32 sinit_vtd_dmar_table_size;
+	u32 sinit_vtd_dmar_table_offset;
+	/* Versions >= 8 */
+	u32 processor_scrtm_status;
+	/* Versions >= 9 */
+	/* Ext Data Elements */
+} __packed;
+
+/*
+ * TXT data reporting structure for memory types
+ */
+struct txt_sinit_memory_descriptor_record {
+	u64 address;
+	u64 length;
+	u8 type;
+	u8 reserved[7];
+} __packed;
+
+/*
+ * TXT data structure used by a responsive local processor (RLP) to start
+ * execution in response to a GETSEC[WAKEUP].
+ */
+struct smx_rlp_mle_join {
+	u32 rlp_gdt_limit;
+	u32 rlp_gdt_base;
+	u32 rlp_seg_sel;     /* cs (ds, es, ss are seg_sel+8) */
+	u32 rlp_entry_point; /* phys addr */
+} __packed;
+
+/*
+ * TPM event log structures defined in both the TXT specification and
+ * the TCG documentation.
+ */
+#define TPM_EVTLOG_SIGNATURE "TXT Event Container"
+
+struct tpm_event_log_header {
+	char signature[20];
+	char reserved[12];
+	u8 container_ver_major;
+	u8 container_ver_minor;
+	u8 pcr_event_ver_major;
+	u8 pcr_event_ver_minor;
+	u32 container_size;
+	u32 pcr_events_offset;
+	u32 next_event_offset;
+	/* PCREvents[] */
+} __packed;
+
+/*
+ * Functions to extract data from the Intel TXT Heap Memory. The layout
+ * of the heap is as follows:
+ *  +----------------------------+
+ *  | Size Bios Data table (u64) |
+ *  +----------------------------+
+ *  | Bios Data table            |
+ *  +----------------------------+
+ *  | Size OS MLE table (u64)    |
+ *  +----------------------------+
+ *  | OS MLE table               |
+ *  +--------------------------- +
+ *  | Size OS SINIT table (u64)  |
+ *  +----------------------------+
+ *  | OS SINIT table             |
+ *  +----------------------------+
+ *  | Size SINIT MLE table (u64) |
+ *  +----------------------------+
+ *  | SINIT MLE table            |
+ *  +----------------------------+
+ *
+ *  NOTE: the table size fields include the 8 byte size field itself.
+ */
+enum {
+	TXT_BIOS_DATA_TABLE,
+	TXT_OS_MLE_DATA_TABLE,
+	TXT_OS_SINIT_DATA_TABLE,
+	TXT_SINIT_MLE_DATA_TABLE,
+	TXT_SINIT_TABLE_MAX,
+};
+
+/*
+ * Find the TPM v2 event log element in the TXT heap. This element contains
+ * the information about the size and location of the DRTM event log. Note
+ * this is a TXT specific structure.
+ *
+ * See:
+ *   Intel Trusted Execution Technology -
+ *     Measured Launch Environment Developer's Guide - Appendix C.
+ */
+static inline struct txt_heap_event_log_pointer2_1_element*
+txt_find_log2_1_element(struct txt_os_sinit_data *os_sinit_data)
+{
+#define ptr_after(p)     ((void *)p + sizeof(*p))
+#define next_ext_elem(e) ((void *)e + e->size)
+	/* The extended element array is at the end of this table */
+	struct txt_heap_ext_data_element *ext_elem = ptr_after(os_sinit_data);
+
+	while (ext_elem->type != TXT_HEAP_EXTDATA_TYPE_END) {
+		if (ext_elem->type == TXT_HEAP_EXTDATA_TYPE_EVENT_LOG_POINTER2_1)
+			return ptr_after(ext_elem);
+
+		ext_elem = next_ext_elem(ext_elem);
+	}
+
+	return NULL;
+}
+
+#endif /* !__ASSEMBLER__ */
+
+#endif /* _ASM_X86_TXT_H */
-- 
2.47.3

