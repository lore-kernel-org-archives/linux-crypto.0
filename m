From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v9 10/38] crypto: ccp: Define SEV userspace ioctl and command id
Date: Mon,  4 Dec 2017 19:04:10 -0600
Message-ID: <20171205010438.5773-11-brijesh.singh@amd.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171205010438.5773-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a include file which defines the ioctl and command id used for
issuing SEV platform management specific commands.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Improvements-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 include/uapi/linux/psp-sev.h | 142 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)
 create mode 100644 include/uapi/linux/psp-sev.h

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
new file mode 100644
index 000000000000..3d77fe91239a
--- /dev/null
+++ b/include/uapi/linux/psp-sev.h
@@ -0,0 +1,142 @@
+/*
+ * Userspace interface for AMD Secure Encrypted Virtualization (SEV)
+ * platform management commands.
+ *
+ * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * SEV spec 0.14 is available at:
+ * http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PSP_SEV_USER_H__
+#define __PSP_SEV_USER_H__
+
+#include <linux/types.h>
+
+/**
+ * SEV platform commands
+ */
+enum {
+	SEV_FACTORY_RESET = 0,
+	SEV_PLATFORM_STATUS,
+	SEV_PEK_GEN,
+	SEV_PEK_CSR,
+	SEV_PDH_GEN,
+	SEV_PDH_CERT_EXPORT,
+	SEV_PEK_CERT_IMPORT,
+
+	SEV_MAX,
+};
+
+/**
+ * SEV Firmware status code
+ */
+typedef enum {
+	SEV_RET_SUCCESS = 0,
+	SEV_RET_INVALID_PLATFORM_STATE,
+	SEV_RET_INVALID_GUEST_STATE,
+	SEV_RET_INAVLID_CONFIG,
+	SEV_RET_INVALID_len,
+	SEV_RET_ALREADY_OWNED,
+	SEV_RET_INVALID_CERTIFICATE,
+	SEV_RET_POLICY_FAILURE,
+	SEV_RET_INACTIVE,
+	SEV_RET_INVALID_ADDRESS,
+	SEV_RET_BAD_SIGNATURE,
+	SEV_RET_BAD_MEASUREMENT,
+	SEV_RET_ASID_OWNED,
+	SEV_RET_INVALID_ASID,
+	SEV_RET_WBINVD_REQUIRED,
+	SEV_RET_DFFLUSH_REQUIRED,
+	SEV_RET_INVALID_GUEST,
+	SEV_RET_INVALID_COMMAND,
+	SEV_RET_ACTIVE,
+	SEV_RET_HWSEV_RET_PLATFORM,
+	SEV_RET_HWSEV_RET_UNSAFE,
+	SEV_RET_UNSUPPORTED,
+	SEV_RET_MAX,
+} sev_ret_code;
+
+/**
+ * struct sev_user_data_status - PLATFORM_STATUS command parameters
+ *
+ * @major: major API version
+ * @minor: minor API version
+ * @state: platform state
+ * @flags: platform config flags
+ * @build: firmware build id for API version
+ * @guest_count: number of active guests
+ */
+struct sev_user_data_status {
+	__u8 api_major;				/* Out */
+	__u8 api_minor;				/* Out */
+	__u8 state;				/* Out */
+	__u32 flags;				/* Out */
+	__u8 build;				/* Out */
+	__u32 guest_count;			/* Out */
+} __packed;
+
+/**
+ * struct sev_user_data_pek_csr - PEK_CSR command parameters
+ *
+ * @address: PEK certificate chain
+ * @length: length of certificate
+ */
+struct sev_user_data_pek_csr {
+	__u64 address;				/* In */
+	__u32 length;				/* In/Out */
+} __packed;
+
+/**
+ * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
+ *
+ * @pek_address: PEK certificate chain
+ * @pek_len: length of PEK certificate
+ * @oca_address: OCA certificate chain
+ * @oca_len: length of OCA certificate
+ */
+struct sev_user_data_pek_cert_import {
+	__u64 pek_cert_address;			/* In */
+	__u32 pek_cert_len;			/* In */
+	__u64 oca_cert_address;			/* In */
+	__u32 oca_cert_len;			/* In */
+} __packed;
+
+/**
+ * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
+ *
+ * @pdh_address: PDH certificate address
+ * @pdh_len: length of PDH certificate
+ * @cert_chain_address: PDH certificate chain
+ * @cert_chain_len: length of PDH certificate chain
+ */
+struct sev_user_data_pdh_cert_export {
+	__u64 pdh_cert_address;			/* In */
+	__u32 pdh_cert_len;			/* In/Out */
+	__u64 cert_chain_address;		/* In */
+	__u32 cert_chain_len;			/* In/Out */
+} __packed;
+
+/**
+ * struct sev_issue_cmd - SEV ioctl parameters
+ *
+ * @cmd: SEV commands to execute
+ * @opaque: pointer to the command structure
+ * @error: SEV FW return code on failure
+ */
+struct sev_issue_cmd {
+	__u32 cmd;				/* In */
+	__u64 data;				/* In */
+	__u32 error;				/* Out */
+} __packed;
+
+#define SEV_IOC_TYPE		'S'
+#define SEV_ISSUE_CMD	_IOWR(SEV_IOC_TYPE, 0x0, struct sev_issue_cmd)
+
+#endif /* __PSP_USER_SEV_H */
-- 
2.9.5
