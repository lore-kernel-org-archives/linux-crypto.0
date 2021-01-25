Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D21C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A4622D50
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbhAYRxn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jan 2021 12:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731106AbhAYRxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 12:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611597100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xODWl/rovJkT4NW0P+V0xEqTdFWADSeZHn3xURKPRRA=;
        b=ExRy+eKgpXOuiqI3C84btHRjMuVpjReBpRPpPl1SgU3BiWO/n+t2tqcY3KDU9XOjR0uojX
        OwRyiJz/SOLNBZDFmHidPBHnScdooeCI9nQUs/k4gpf5t/IlyZ24KlLsAKpanKfecpGr8X
        YWsrlKzWc7sbrtGBdm+JKsjOhCmYgPQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-kIRVwun6NAan00Q69N03DA-1; Mon, 25 Jan 2021 12:40:40 -0500
X-MC-Unique: kIRVwun6NAan00Q69N03DA-1
Received: by mail-ed1-f70.google.com with SMTP id j12so7864785edq.10
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 09:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xODWl/rovJkT4NW0P+V0xEqTdFWADSeZHn3xURKPRRA=;
        b=SssWJoeC3DoFDEa3L9nJkNIsCioBK8wRJDvYw/CK88cFA36wnrFoOWHwB4tzwemidG
         DWHdHdHTK1WMkMOsN3zv7X5471kFKO2As20KccuQ4bp37hTUerFanTugnz5q7xkR/sn6
         xuT4sWm6TfKn4QdERjRwVpm4dbpwXksHN2f7T/TqQa+7PF2Q/mbzyn3d53OX+NqZ5gub
         iiQMuHU0jHIr2/BBJZw6yxhoHFHj6r4zRPpxeDoaZDivxQcqYTfD+UPRWC931ok5ALD9
         QMVeeXQhAmnLf0i9Ua5Z/P3RwS2DBRwitSSRdgyPLyOUwoAG6Vn2Q0tLOUnSWJri0jvW
         Mjeg==
X-Gm-Message-State: AOAM530HkjBGONIAlwma2+ObzcmZDGyAVKrbwGr/6AH9zsdaT4NM78gn
        3uGQmmX2TRbMKD+sgVrMQpQ5WzZCItxYVlcFwx0yieMf6kiU4hc1U3IlkRTvdIaat/uzCyjAPOt
        xDM8rxjeZLKPBRKJJrOX8rYeTJabqTkCqayTjqxt7DyDsuxc3YvStq4VZWPHYX15dYQNCQZdrFd
        9A
X-Received: by 2002:a17:906:2743:: with SMTP id a3mr1107509ejd.378.1611596439049;
        Mon, 25 Jan 2021 09:40:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybbFIE0LZRQI9HeTMwIUBbVlJMu6onaNrnfZNHd1jFsNkphoNLfXXCuSzJ4agnaOQhuTxCNA==
X-Received: by 2002:a17:906:2743:: with SMTP id a3mr1107489ejd.378.1611596438719;
        Mon, 25 Jan 2021 09:40:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v9sm8552063ejd.92.2021.01.25.09.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:40:37 -0800 (PST)
Subject: Re: [PATCH v2] KVM/SVM: add support for SEV attestation command
To:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
References: <20210104151749.30248-1-brijesh.singh@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87dacde9-5b4e-71fb-e4cf-22d5504b830b@redhat.com>
Date:   Mon, 25 Jan 2021 18:40:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104151749.30248-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04/01/21 16:17, Brijesh Singh wrote:
> The SEV FW version >= 0.23 added a new command that can be used to query
> the attestation report containing the SHA-256 digest of the guest memory
> encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
> sign the report with the Platform Endorsement Key (PEK).
> 
> See the SEV FW API spec section 6.8 for more details.
> 
> Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
> used to get the SHA-256 digest. The main difference between the
> KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the latter
> can be called while the guest is running and the measurement value is
> signed with PEK.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> v2:
>    * Fix documentation typo
> 
>   .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
>   arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
>   drivers/crypto/ccp/sev-dev.c                  |  1 +
>   include/linux/psp-sev.h                       | 17 +++++
>   include/uapi/linux/kvm.h                      |  8 +++
>   5 files changed, 118 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 09a8f2a34e39..469a6308765b 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
>                   __u32 trans_len;
>           };
>   
> +10. KVM_SEV_GET_ATTESTATION_REPORT
> +----------------------------------
> +
> +The KVM_SEV_GET_ATTESTATION_REPORT command can be used by the hypervisor to query the attestation
> +report containing the SHA-256 digest of the guest memory and VMSA passed through the KVM_SEV_LAUNCH
> +commands and signed with the PEK. The digest returned by the command should match the digest
> +used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
> +
> +Parameters (in): struct kvm_sev_attestation
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_attestation_report {
> +                __u8 mnonce[16];        /* A random mnonce that will be placed in the report */
> +
> +                __u64 uaddr;            /* userspace address where the report should be copied */
> +                __u32 len;
> +        };
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 566f4d18185b..c4d3ee6be362 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -927,6 +927,74 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	void __user *report = (void __user *)(uintptr_t)argp->data;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_attestation_report *data;
> +	struct kvm_sev_attestation_report params;
> +	void __user *p;
> +	void *blob = NULL;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* User wants to query the blob length */
> +	if (!params.len)
> +		goto cmd;
> +
> +	p = (void __user *)(uintptr_t)params.uaddr;
> +	if (p) {
> +		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
> +			ret = -EINVAL;
> +			goto e_free;
> +		}
> +
> +		ret = -ENOMEM;
> +		blob = kmalloc(params.len, GFP_KERNEL);
> +		if (!blob)
> +			goto e_free;
> +
> +		data->address = __psp_pa(blob);
> +		data->len = params.len;
> +		memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
> +	}
> +cmd:
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
> +	/*
> +	 * If we query the session length, FW responded with expected data.
> +	 */
> +	if (!params.len)
> +		goto done;
> +
> +	if (ret)
> +		goto e_free_blob;
> +
> +	if (blob) {
> +		if (copy_to_user(p, blob, params.len))
> +			ret = -EFAULT;
> +	}
> +
> +done:
> +	params.len = data->len;
> +	if (copy_to_user(report, &params, sizeof(params)))
> +		ret = -EFAULT;
> +e_free_blob:
> +	kfree(blob);
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -971,6 +1039,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_LAUNCH_SECRET:
>   		r = sev_launch_secret(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_GET_ATTESTATION_REPORT:
> +		r = sev_get_attestation_report(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 476113e12489..cb9b4c4e371e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -128,6 +128,7 @@ static int sev_cmd_buffer_len(int cmd)
>   	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
>   	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
>   	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
> +	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
>   	default:				return 0;
>   	}
>   
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 49d155cd2dfe..b801ead1e2bb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -66,6 +66,7 @@ enum sev_cmd {
>   	SEV_CMD_LAUNCH_MEASURE		= 0x033,
>   	SEV_CMD_LAUNCH_UPDATE_SECRET	= 0x034,
>   	SEV_CMD_LAUNCH_FINISH		= 0x035,
> +	SEV_CMD_ATTESTATION_REPORT	= 0x036,
>   
>   	/* Guest migration commands (outgoing) */
>   	SEV_CMD_SEND_START		= 0x040,
> @@ -483,6 +484,22 @@ struct sev_data_dbg {
>   	u32 len;				/* In */
>   } __packed;
>   
> +/**
> + * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
> + *
> + * @handle: handle of the VM
> + * @mnonce: a random nonce that will be included in the report.
> + * @address: physical address where the report will be copied.
> + * @len: length of the physical buffer.
> + */
> +struct sev_data_attestation_report {
> +	u32 handle;				/* In */
> +	u32 reserved;
> +	u64 address;				/* In */
> +	u8 mnonce[16];				/* In */
> +	u32 len;				/* In/Out */
> +} __packed;
> +
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>   
>   /**
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..d3385f7f08a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>   	KVM_SEV_DBG_ENCRYPT,
>   	/* Guest certificates commands */
>   	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
>   
>   	KVM_SEV_NR_MAX,
>   };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>   	__u32 len;
>   };
>   
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> 

Queued, thanks.

Paolo

