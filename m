From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5 11/31] crypto: ccp: Define SEV key management
 command id
Date: Thu, 5 Oct 2017 22:56:58 +0200
Message-ID: <20171005205658.77onrn2mr2mrxafs@pd.tnic>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-12-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171004131412.13038-12-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 08:13:52AM -0500, Brijesh Singh wrote:
> Define Secure Encrypted Virtualization (SEV) key management command id
> and structure. The command definition is available in SEV KM [1] spec
> 0.14.
> 
> [1] http://support.amd.com/TechDocs/55766_SEV-KM API_Specification.pdf
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  include/linux/psp-sev.h | 515 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 515 insertions(+)
>  create mode 100644 include/linux/psp-sev.h

Some fixes ontop below.

With that:

Reviewed-by: Borislav Petkov <bp@suse.de>

---
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f01d0e3b09b8..496375d7f6a9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -122,12 +122,12 @@ enum psp_ret_code {
  * @tmr_address: system physical address used for SEV-ES
  * @tmr_len: len of tmr_address
  */
-struct __attribute__((__packed__)) sev_data_init {
+struct sev_data_init {
 	u32 flags;			/* In */
 	u32 reserved;			/* In */
 	u64 tmr_address;		/* In */
 	u32 tmr_len;			/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_status - PLATFORM_STATUS command parameters
@@ -140,7 +140,7 @@ struct __attribute__((__packed__)) sev_data_init {
  * @build: firmware build id for API version
  * @guest_count: number of active guests
  */
-struct __attribute__((__packed__)) sev_data_status {
+struct sev_data_status {
 	u8 api_major;				/* Out */
 	u8 api_minor;				/* Out */
 	u8 state;				/* Out */
@@ -150,7 +150,7 @@ struct __attribute__((__packed__)) sev_data_status {
 	u32 reserved2 : 23;
 	u32 build : 8;				/* Out */
 	u32 guest_count;			/* Out */
-};
+} __packed;
 
 /**
  * struct sev_data_pek_csr - PEK_CSR command parameters
@@ -158,10 +158,10 @@ struct __attribute__((__packed__)) sev_data_status {
  * @address: PEK certificate chain
  * @len: len of certificate
  */
-struct __attribute__((__packed__)) sev_data_pek_csr {
+struct sev_data_pek_csr {
 	u64 address;				/* In */
 	u32 len;				/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_data_cert_import - PEK_CERT_IMPORT command parameters
@@ -171,13 +171,13 @@ struct __attribute__((__packed__)) sev_data_pek_csr {
  * @oca_address: OCA certificate chain
  * @oca_len: len of OCA certificate
  */
-struct __attribute__((__packed__)) sev_data_pek_cert_import {
+struct sev_data_pek_cert_import {
 	u64 pek_cert_address;			/* In */
 	u32 pek_cert_len;			/* In */
 	u32 reserved;				/* In */
 	u64 oca_cert_address;			/* In */
 	u32 oca_cert_len;			/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
@@ -187,22 +187,22 @@ struct __attribute__((__packed__)) sev_data_pek_cert_import {
  * @cert_chain_address: PDH certificate chain
  * @cert_chain_len: len of PDH certificate chain
  */
-struct __attribute__((__packed__)) sev_data_pdh_cert_export {
+struct sev_data_pdh_cert_export {
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In/Out */
 	u32 reserved;				/* In */
 	u64 cert_chain_address;			/* In */
 	u32 cert_chain_len;			/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_data_decommission - DECOMMISSION command parameters
  *
  * @handle: handle of the VM to decommission
  */
-struct __attribute__((__packed__)) sev_data_decommission {
+struct sev_data_decommission {
 	u32 handle;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_activate - ACTIVATE command parameters
@@ -210,19 +210,19 @@ struct __attribute__((__packed__)) sev_data_decommission {
  * @handle: handle of the VM to activate
  * @asid: asid assigned to the VM
  */
-struct __attribute__((__packed__)) sev_data_activate {
+struct sev_data_activate {
 	u32 handle;				/* In */
 	u32 asid;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_deactivate - DEACTIVATE command parameters
  *
  * @handle: handle of the VM to deactivate
  */
-struct __attribute__((__packed__)) sev_data_deactivate {
+struct sev_data_deactivate {
 	u32 handle;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_guest_status - SEV GUEST_STATUS command parameters
@@ -232,12 +232,12 @@ struct __attribute__((__packed__)) sev_data_deactivate {
  * @asid: current ASID of the VM
  * @state: current state of the VM
  */
-struct __attribute__((__packed__)) sev_data_guest_status {
+struct sev_data_guest_status {
 	u32 handle;				/* In */
 	u32 policy;				/* Out */
 	u32 asid;				/* Out */
 	u8 state;				/* Out */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_start - LAUNCH_START command parameters
@@ -249,7 +249,7 @@ struct __attribute__((__packed__)) sev_data_guest_status {
  * @session_address: physical address of session parameters
  * @session_len: len of session parameters
  */
-struct __attribute__((__packed__)) sev_data_launch_start {
+struct sev_data_launch_start {
 	u32 handle;				/* In/Out */
 	u32 policy;				/* In */
 	u64 dh_cert_address;			/* In */
@@ -257,7 +257,7 @@ struct __attribute__((__packed__)) sev_data_launch_start {
 	u32 reserved;				/* In */
 	u64 session_address;			/* In */
 	u32 session_len;			/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_update_data - LAUNCH_UPDATE_DATA command parameter
@@ -266,12 +266,12 @@ struct __attribute__((__packed__)) sev_data_launch_start {
  * @len: len of memory to be encrypted
  * @address: physical address of memory region to encrypt
  */
-struct __attribute__((__packed__)) sev_data_launch_update_data {
+struct sev_data_launch_update_data {
 	u32 handle;				/* In */
 	u32 reserved;
 	u64 address;				/* In */
 	u32 len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_update_vmsa - LAUNCH_UPDATE_VMSA command
@@ -280,12 +280,12 @@ struct __attribute__((__packed__)) sev_data_launch_update_data {
  * @address: physical address of memory region to encrypt
  * @len: len of memory region to encrypt
  */
-struct __attribute__((__packed__)) sev_data_launch_update_vmsa {
+struct sev_data_launch_update_vmsa {
 	u32 handle;				/* In */
 	u32 reserved;
 	u64 address;				/* In */
 	u32 len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_measure - LAUNCH_MEASURE command parameters
@@ -294,12 +294,12 @@ struct __attribute__((__packed__)) sev_data_launch_update_vmsa {
  * @address: physical address containing the measurement blob
  * @len: len of measurement blob
  */
-struct __attribute__((__packed__)) sev_data_launch_measure {
+struct sev_data_launch_measure {
 	u32 handle;				/* In */
 	u32 reserved;
 	u64 address;				/* In */
 	u32 len;				/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_secret - LAUNCH_SECRET command parameters
@@ -312,7 +312,7 @@ struct __attribute__((__packed__)) sev_data_launch_measure {
  * @trans_address: physical address of transport memory buffer
  * @trans_len: len of transport memory buffer
  */
-struct __attribute__((__packed__)) sev_data_launch_secret {
+struct sev_data_launch_secret {
 	u32 handle;				/* In */
 	u32 reserved1;
 	u64 hdr_address;			/* In */
@@ -323,16 +323,16 @@ struct __attribute__((__packed__)) sev_data_launch_secret {
 	u32 reserved3;
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_launch_finish - LAUNCH_FINISH command parameters
  *
  * @handle: handle of the VM to process
  */
-struct __attribute__((__packed__)) sev_data_launch_finish {
+struct sev_data_launch_finish {
 	u32 handle;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_send_start - SEND_START command parameters
@@ -348,7 +348,7 @@ struct __attribute__((__packed__)) sev_data_launch_finish {
  * @session_address: physical address containing Session data
  * @session_len: len of session data
  */
-struct __attribute__((__packed__)) sev_data_send_start {
+struct sev_data_send_start {
 	u32 handle;				/* In */
 	u32 policy;				/* Out */
 	u64 pdh_cert_address;			/* In */
@@ -362,7 +362,7 @@ struct __attribute__((__packed__)) sev_data_send_start {
 	u32 reserved3;
 	u64 session_address;			/* In */
 	u32 session_len;			/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_data_send_update - SEND_UPDATE_DATA command
@@ -375,7 +375,7 @@ struct __attribute__((__packed__)) sev_data_send_start {
  * @trans_address: physical address of host memory region
  * @trans_len: len of host memory region
  */
-struct __attribute__((__packed__)) sev_data_send_update_data {
+struct sev_data_send_update_data {
 	u32 handle;				/* In */
 	u32 reserved1;
 	u64 hdr_address;			/* In */
@@ -386,7 +386,7 @@ struct __attribute__((__packed__)) sev_data_send_update_data {
 	u32 reserved3;
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_send_update - SEND_UPDATE_VMSA command
@@ -399,7 +399,7 @@ struct __attribute__((__packed__)) sev_data_send_update_data {
  * @trans_address: physical address of host memory region
  * @trans_len: len of host memory region
  */
-struct __attribute__((__packed__)) sev_data_send_update_vmsa {
+struct sev_data_send_update_vmsa {
 	u32 handle;				/* In */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In/Out */
@@ -409,16 +409,16 @@ struct __attribute__((__packed__)) sev_data_send_update_vmsa {
 	u32 reserved3;
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_send_finish - SEND_FINISH command parameters
  *
  * @handle: handle of the VM to process
  */
-struct __attribute__((__packed__)) sev_data_send_finish {
+struct sev_data_send_finish {
 	u32 handle;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_receive_start - RECEIVE_START command parameters
@@ -429,7 +429,7 @@ struct __attribute__((__packed__)) sev_data_send_finish {
  * @session_address: system physical address containing session blob
  * @session_len: len of session blob
  */
-struct __attribute__((__packed__)) sev_data_receive_start {
+struct sev_data_receive_start {
 	u32 handle;				/* In/Out */
 	u32 policy;				/* In */
 	u64 pdh_cert_address;			/* In */
@@ -437,7 +437,7 @@ struct __attribute__((__packed__)) sev_data_receive_start {
 	u32 reserved1;
 	u64 session_address;			/* In */
 	u32 session_len;			/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_receive_update_data - RECEIVE_UPDATE_DATA command parameters
@@ -450,7 +450,7 @@ struct __attribute__((__packed__)) sev_data_receive_start {
  * @trans_address: system physical address of transport buffer
  * @trans_len: len of transport buffer
  */
-struct __attribute__((__packed__)) sev_data_receive_update_data {
+struct sev_data_receive_update_data {
 	u32 handle;				/* In */
 	u32 reserved1;
 	u64 hdr_address;			/* In */
@@ -461,7 +461,7 @@ struct __attribute__((__packed__)) sev_data_receive_update_data {
 	u32 reserved3;
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_receive_update_vmsa - RECEIVE_UPDATE_VMSA command parameters
@@ -474,7 +474,7 @@ struct __attribute__((__packed__)) sev_data_receive_update_data {
  * @trans_address: system physical address of transport buffer
  * @trans_len: len of transport buffer
  */
-struct __attribute__((__packed__)) sev_data_receive_update_vmsa {
+struct sev_data_receive_update_vmsa {
 	u32 handle;				/* In */
 	u32 reserved1;
 	u64 hdr_address;			/* In */
@@ -485,16 +485,16 @@ struct __attribute__((__packed__)) sev_data_receive_update_vmsa {
 	u32 reserved3;
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_receive_finish - RECEIVE_FINISH command parameters
  *
  * @handle: handle of the VM to finish
  */
-struct __attribute__((__packed__)) sev_data_receive_finish {
+struct sev_data_receive_finish {
 	u32 handle;				/* In */
-};
+} __packed;
 
 /**
  * struct sev_data_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
@@ -504,12 +504,12 @@ struct __attribute__((__packed__)) sev_data_receive_finish {
  * @dst_addr: destination address of data to operate on
  * @len: len of data to operate on
  */
-struct __attribute__((__packed__)) sev_data_dbg {
+struct sev_data_dbg {
 	u32 handle;				/* In */
 	u32 reserved;
 	u64 src_addr;				/* In */
 	u64 dst_addr;				/* In */
 	u32 len;				/* In */
-};
+} __packed;
 
 #endif	/* __PSP_SEV_H__ */

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
