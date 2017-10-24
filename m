From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6 10/38] crypto: ccp: Define SEV userspace ioctl
 and command id
Date: Tue, 24 Oct 2017 13:40:31 -0500
Message-ID: <6172bd98-f97f-164e-51e6-a1ac7579ead0@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-11-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0052.outbound.protection.outlook.com ([104.47.34.52]:64100
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750908AbdJXSkj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 14:40:39 -0400
In-Reply-To: <20171020023413.122280-11-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/19/2017 09:33 PM, Brijesh Singh wrote:
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
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   include/uapi/linux/psp-sev.h | 113 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 113 insertions(+)
>   create mode 100644 include/uapi/linux/psp-sev.h
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> new file mode 100644
> index 000000000000..1dd98ba4ff22
> --- /dev/null
> +++ b/include/uapi/linux/psp-sev.h
> @@ -0,0 +1,113 @@
> +/*
> + * Userspace interface for AMD Secure Encrypted Virtualization (SEV)
> + * platform management commands.
> + *
> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * SEV spec 0.14 is available at:
> + * http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PSP_SEV_USER_H__
> +#define __PSP_SEV_USER_H__
> +
> +#include <linux/types.h>
> +
> +/**
> + * SEV platform commands
> + */
> +enum {
> +	SEV_FACTORY_RESET = 0,
> +	SEV_PLATFORM_STATUS,
> +	SEV_PEK_GEN,
> +	SEV_PEK_CSR,
> +	SEV_PDH_GEN,
> +	SEV_PDH_CERT_EXPORT,
> +	SEV_PEK_CERT_IMPORT,
> +
> +	SEV_MAX,
> +};
> +
> +/**
> + * struct sev_user_data_status - PLATFORM_STATUS command parameters
> + *
> + * @major: major API version
> + * @minor: minor API version
> + * @state: platform state
> + * @flags: platform config flags
> + * @build: firmware build id for API version
> + * @guest_count: number of active guests
> + */
> +struct sev_user_data_status {
> +	__u8 api_major;				/* Out */
> +	__u8 api_minor;				/* Out */
> +	__u8 state;				/* Out */
> +	__u32 flags;				/* Out */
> +	__u8 build;				/* Out */
> +	__u32 guest_count;			/* Out */
> +} __packed;
> +
> +/**
> + * struct sev_user_data_pek_csr - PEK_CSR command parameters
> + *
> + * @address: PEK certificate chain
> + * @length: length of certificate
> + */
> +struct sev_user_data_pek_csr {
> +	__u64 address;				/* In */
> +	__u32 length;				/* In/Out */
> +} __packed;
> +
> +/**
> + * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
> + *
> + * @pek_address: PEK certificate chain
> + * @pek_len: length of PEK certificate
> + * @oca_address: OCA certificate chain
> + * @oca_len: length of OCA certificate
> + */
> +struct sev_user_data_pek_cert_import {
> +	__u64 pek_cert_address;			/* In */
> +	__u32 pek_cert_len;			/* In */
> +	__u64 oca_cert_address;			/* In */
> +	__u32 oca_cert_len;			/* In */
> +} __packed;
> +
> +/**
> + * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
> + *
> + * @pdh_address: PDH certificate address
> + * @pdh_len: length of PDH certificate
> + * @cert_chain_address: PDH certificate chain
> + * @cert_chain_len: length of PDH certificate chain
> + */
> +struct sev_user_data_pdh_cert_export {
> +	__u64 pdh_cert_address;			/* In */
> +	__u32 pdh_cert_len;			/* In/Out */
> +	__u64 cert_chain_address;		/* In */
> +	__u32 cert_chain_len;			/* In/Out */
> +} __packed;
> +
> +/**
> + * struct sev_issue_cmd - SEV ioctl parameters
> + *
> + * @cmd: SEV commands to execute
> + * @opaque: pointer to the command structure
> + * @error: SEV FW return code on failure
> + */
> +struct sev_issue_cmd {
> +	__u32 cmd;				/* In */
> +	__u64 data;				/* In */
> +	__u32 error;				/* Out */
> +} __packed;
> +
> +#define SEV_IOC_TYPE		'S'
> +#define SEV_ISSUE_CMD	_IOWR(SEV_IOC_TYPE, 0x0, struct sev_issue_cmd)
> +
> +#endif /* __PSP_USER_SEV_H */
> 
