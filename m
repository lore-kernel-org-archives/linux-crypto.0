From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.2/31] crypto: ccp: Define SEV userspace
 ioctl and command id
Date: Sat, 7 Oct 2017 16:20:28 +0200
Message-ID: <20171007142010.6cnkeyywbitk6u73@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-2-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbdJGOU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 10:20:57 -0400
Content-Disposition: inline
In-Reply-To: <20171007010607.78088-2-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 06, 2017 at 08:06:00PM -0500, Brijesh Singh wrote:
> Add a include file which defines the ioctl and command id used for
> issuing SEV platform management specific commands.
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
>  include/uapi/linux/psp-sev.h | 115 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
>  create mode 100644 include/uapi/linux/psp-sev.h

First of all, thanks for splitting the patch - it is much easier to
review this way.

Then, this patch should be 12.1, i.e., the first of the split because otherwise
the previous one - which should be the next - fails building due to

drivers/crypto/ccp/psp-dev.c:26:32: fatal error: uapi/linux/psp-sev.h: No such file or directory
 #include <uapi/linux/psp-sev.h>
                                ^
Just swap them in their order.

Also, those SEV commands should be __packed, see below.

With that addressed:

Reviewed-by: Borislav Petkov <bp@suse.de>

---
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index a385bf2b8d2a..b63e116f18c1 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -53,7 +53,7 @@ struct sev_user_data_status {
 	__u32 config;				/* Out */
 	__u8 build;				/* Out */
 	__u32 guest_count;			/* Out */
-};
+} __packed;
 
 /**
  * struct sev_user_data_pek_csr - PEK_CSR command parameters
@@ -64,7 +64,7 @@ struct sev_user_data_status {
 struct sev_user_data_pek_csr {
 	__u64 address;				/* In */
 	__u32 length;				/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
@@ -79,7 +79,7 @@ struct sev_user_data_pek_cert_import {
 	__u32 pek_cert_len;			/* In */
 	__u64 oca_cert_address;			/* In */
 	__u32 oca_cert_len;			/* In */
-};
+} __packed;
 
 /**
  * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
@@ -94,7 +94,7 @@ struct sev_user_data_pdh_cert_export {
 	__u32 pdh_cert_len;			/* In/Out */
 	__u64 cert_chain_address;		/* In */
 	__u32 cert_chain_len;			/* In/Out */
-};
+} __packed;
 
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
@@ -107,7 +107,7 @@ struct sev_issue_cmd {
 	__u32 cmd;				/* In */
 	__u64 data;				/* In */
 	__u32 error;				/* Out */
-};
+} __packed;
 
 #define SEV_IOC_TYPE		'S'
 #define SEV_ISSUE_CMD	_IOWR(SEV_IOC_TYPE, 0x0, struct sev_issue_cmd)

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
