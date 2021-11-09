Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543B7C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 17:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3624061208
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 17:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhKIRYL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 12:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240848AbhKIRYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 12:24:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1438FC061766
        for <linux-crypto@vger.kernel.org>; Tue,  9 Nov 2021 09:21:23 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y7so5095282plp.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Nov 2021 09:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pEhykE0VQ1RjgNLwWloLbQVJi0CNrM80lN+tcveqYhM=;
        b=d/29pT8TylpnH3AI6LgbzGny2Qnin76m+CaiOKx6+dEIyOs680IBcvFYzaaOjZOtIb
         aUFCbJ/2Rs4JVWVqgD9SLbkfLwC/5j98ndIjFBSyEKlGPdDC17GDAPPGDhYUuFMUzAU+
         iOqzthkjKVudZxkx7fDC6ddHd4MK7GrxApspvBkEzbB3F41pbKbNwRRd7WYiQYGeIpH1
         8NKOBEXQC1/4aV6hBsxKD9XxgwJZ/sGWIk51hkw230DZrMphJwd/6rM8wSbX51sa57Ho
         qkNMCsPeTN1PdezeGhvEQU8ObziJq7MijLbpNiI42Vs+m7YOTFbZiX26XwMyjYAKUrrv
         2NSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pEhykE0VQ1RjgNLwWloLbQVJi0CNrM80lN+tcveqYhM=;
        b=oeoUHW7JfD4ymBWQjPY2F/kQrCCRtTzqMjivfhTstC61/gbVDn7X6cSjAwe7hoaAvS
         iuF1MI7uGO6yETg/ehy1li7s9cVd/7r5W71Y9EgDqeH2Ubb77wQRYVv6NIp5DYa7m5RR
         FTcQt7cIxMOod1xSg5bTleR07iFvvQaetlo3VSOdu6WDYYN6ClGTJNHm6XC1iN9xVFDk
         XN4UBVaHJ0vagEqJIFvR0Uay0/1o1g0A1ZQSlpuh6IOK509b5R1vTfettmasGnlq0gHc
         boL3P96D/rU6l9bb7UxX0ul7FaxmBBzm3lWKxGoX3koiyKb2wiPuNHNoEiDtOZwb/U5W
         uUBg==
X-Gm-Message-State: AOAM530UxE+aqpG7hX3eTZL1Cnn2Hw39+POWK/Cnap0gKlRLpHwLCKj3
        LKbxj2s6FolcnmVnzp9EZ+SPhA==
X-Google-Smtp-Source: ABdhPJwXzN2fnJu1wzbY6Y6gbKjm2YmyiVtQh+86C4aZBTSX2WDaUtFxUJqs3x9PyA6AU0MxA3u6Ug==
X-Received: by 2002:a17:90a:ea09:: with SMTP id w9mr8994091pjy.46.1636478482194;
        Tue, 09 Nov 2021 09:21:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i68sm19409162pfc.158.2021.11.09.09.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:21:21 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:21:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
Message-ID: <YYquDWbkIwCkixxD@google.com>
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-5-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102142331.3753798-5-pgonda@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 02, 2021, Peter Gonda wrote:
> @@ -43,6 +44,10 @@ static int psp_probe_timeout = 5;
>  module_param(psp_probe_timeout, int, 0644);
>  MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
>  
> +static char *init_ex_path;
> +module_param(init_ex_path, charp, 0660);

Why is this writable after the module loads?  At best, it seems like it will give
userspace an easy way to shoot itself in the foot, at worst it will lead to a
TOCTOU bug in the kernel.

> +MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -58,6 +63,14 @@ static int psp_timeout;
>  #define SEV_ES_TMR_SIZE		(1024 * 1024)
>  static void *sev_es_tmr;
>  
> +/* INIT_EX NV Storage:
> + *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
> + *   allocator to allocate the memory, which will return aligned memory for the
> + *   specified allocation order.
> + */
> +#define NV_LENGTH (32 * 1024)
> +static void *sev_init_ex_nv_address;

The "address" part is redundant and potentially confusing, e.g. one might expect
it to contain a physical address.

And the "NV" part is kind of a lie, this isn't in non-volatile memory (it's a
kernel buffer) and it's obviously volatile in the sense that it can be changed
by the PSP.  I get that from the PSP's perspective it's _intended_ to be NV
storage, but (a) this does not point at NV storage and (b) there is no guarantee
that the path provided by userspace points at NV storage.

Maybe "sev_init_ex_buffer" or something along those lines?

>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -107,6 +120,7 @@ static int sev_cmd_buffer_len(int cmd)
>  {
>  	switch (cmd) {
>  	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
> +	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
>  	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
>  	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
>  	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
> @@ -152,6 +166,87 @@ static void *sev_fw_alloc(unsigned long len)
>  	return page_address(page);
>  }
>  
> +static int sev_read_nv_memory(void)

Similar to above, this is reading from a file that's backed by who knows what,
i.e. it may or may not be reading NV memory.  And if it's going to implicitly
read into the buffer, that should be reflected in the name.

> +{
> +	struct file *fp;
> +	ssize_t nread;
> +
> +	if (!sev_init_ex_nv_address)
> +		return -EOPNOTSUPP;
> +
> +	fp = filp_open(init_ex_path, O_RDONLY, 0);
> +	if (IS_ERR(fp)) {
> +		int ret = PTR_ERR(fp);
> +
> +		dev_err(psp_master->dev,
> +			"SEV: could not open %s for read, error %d\n",
> +			init_ex_path, ret);
> +		return ret;
> +	}
> +
> +	nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, NULL);
> +	dev_dbg(psp_master->dev, "SEV: read %ld bytes from NV file\n", nread);
> +	filp_close(fp, NULL);
> +
> +	return 0;
> +}
> +
> +static void sev_write_nv_memory(void)

Same comments here.

> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct file *fp;
> +	loff_t offset = 0;
> +	ssize_t nwrite;
> +
> +	if (!sev_init_ex_nv_address)
> +		return;
> +
> +	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
> +	if (IS_ERR(fp)) {
> +		dev_err(sev->dev,
> +			"SEV: could not open file for write, error %d\n",
> +			PTR_ERR(fp));
> +		return;
> +	}
> +
> +	nwrite = kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &offset);
> +	vfs_fsync(fp, 0);
> +	filp_close(fp, NULL);
> +
> +	if (nwrite != NV_LENGTH) {
> +		dev_err(sev->dev,
> +			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
> +			NV_LENGTH, nwrite);
> +		return;
> +	}
> +
> +	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
> +}
> +
> +static void sev_write_nv_memory_if_required(int cmd_id)

And here.

> +{
> +	if (!sev_init_ex_nv_address)
> +		return;
> +
> +	/*
> +	 * Only a few platform commands modify the SPI/NV area, but none of the
> +	 * non-platform commands do. Only INIT(_EX), PLATFORM_RESET, PEK_GEN,
> +	 * PEK_CERT_IMPORT, and PDH_GEN do.
> +	 */
> +	switch (cmd_id) {
> +	case SEV_CMD_FACTORY_RESET:
> +	case SEV_CMD_INIT_EX:
> +	case SEV_CMD_PDH_GEN:
> +	case SEV_CMD_PEK_CERT_IMPORT:
> +	case SEV_CMD_PEK_GEN:
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	sev_write_nv_memory();
> +}
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -221,6 +316,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
>  			cmd, reg & PSP_CMDRESP_ERR_MASK);
>  		ret = -EIO;
> +	} else {
> +		sev_write_nv_memory_if_required(cmd);
>  	}
>  
>  	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> @@ -247,22 +344,42 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>  	return rc;
>  }
>  
> -static int __sev_platform_init_locked(int *error)
> +static int __sev_init_locked(int *error)
>  {
> -	struct psp_device *psp = psp_master;
>  	struct sev_data_init data;
> -	struct sev_device *sev;
> -	int rc = 0;
>  
> -	if (!psp || !psp->sev_data)
> -		return -ENODEV;
> +	memset(&data, 0, sizeof(data));
> +	if (sev_es_tmr) {
> +		u64 tmr_pa;
>  
> -	sev = psp->sev_data;
> +		/*
> +		 * Do not include the encryption mask on the physical
> +		 * address of the TMR (firmware should clear it anyway).
> +		 */
> +		tmr_pa = __pa(sev_es_tmr);

I realize this is copy-pasted from existing code, by why bother with an intermediate
tmr_pa?  Just set data.tmr_address directly.

>  
> -	if (sev->state == SEV_STATE_INIT)
> -		return 0;
> +		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> +		data.tmr_address = tmr_pa;
> +		data.tmr_len = SEV_ES_TMR_SIZE;
> +	}
> +
> +	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +}
> +
> +static int __sev_init_ex_locked(int *error)
> +{
> +	struct sev_data_init_ex data;
> +	int ret;
>  
>  	memset(&data, 0, sizeof(data));
> +	data.length = sizeof(data);
> +	data.nv_address = __psp_pa(sev_init_ex_nv_address);
> +	data.nv_len = NV_LENGTH;
> +
> +	ret = sev_read_nv_memory();

Why defer reading the file until INIT_EX?  Why not read the data when the path
is first verified and consumed?  More comments below in the retry path.

And what happens when sev_platform_init() is reached through a path other than
sev_pci_init()?  I guess that's a question for the existing code since sev_es_tmr
will be NULL unless sev_platform_init() routes through sev_pci_init().  So either
the sev_platform_init() call from KVM's sev_guest_init() is pointless, or there's
potential for some truly bizarre and confusing behavior.

> +	if (ret)
> +		return ret;
> +
>  	if (sev_es_tmr) {
>  		u64 tmr_pa;
>  
> @@ -277,7 +394,27 @@ static int __sev_platform_init_locked(int *error)
>  		data.tmr_len = SEV_ES_TMR_SIZE;
>  	}
>  
> -	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> +}
> +
> +static int __sev_platform_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	int rc;
> +	int (*init_function)(int *error);
> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp->sev_data;
> +
> +	if (sev->state == SEV_STATE_INIT)
> +		return 0;
> +
> +	init_function = sev_init_ex_nv_address ? __sev_init_ex_locked :
> +	    __sev_init_locked;

There's no need for this to be a function pointer, and the duplicate code can be
consolidated.

static int sev_do_init_locked(int cmd, void *data, int *error)
{
	if (sev_es_tmr) {
		/*
		 * Do not include the encryption mask on the physical
		 * address of the TMR (firmware should clear it anyway).
		 */
		data.flags |= SEV_INIT_FLAGS_SEV_ES;
		data.tmr_address = __pa(sev_es_tmr);
		data.tmr_len = SEV_ES_TMR_SIZE;
	}
	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
}

static int __sev_init_locked(int *error)
{
	struct sev_data_init data;

	memset(&data, 0, sizeof(data));
	return sev_do_init_locked(cmd, &data, error);
}

static int __sev_init_ex_locked(int *error)
{
	struct sev_data_init_ex data;

	memset(&data, 0, sizeof(data));
	data.length = sizeof(data);
	data.nv_address = __psp_pa(sev_init_ex_nv_address);
	data.nv_len = NV_LENGTH;
	return sev_do_init_locked(SEV_CMD_INIT_EX, &data, error);
}

> +	rc = init_function(error);
>  	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>  		/*
>  		 * INIT command returned an integrity check failure
> @@ -286,8 +423,8 @@ static int __sev_platform_init_locked(int *error)
>  		 * failed and persistent state has been erased.
>  		 * Retrying INIT command here should succeed.
>  		 */
> -		dev_dbg(sev->dev, "SEV: retrying INIT command");
> -		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +		dev_notice(sev->dev, "SEV: retrying INIT command");
> +		rc = init_function(error);

The above comment says "persistent state has been erased", but __sev_do_cmd_locked()
only writes back to the file if a relevant command was successful, which means
that rereading the userspace file in __sev_init_ex_locked() will retry INIT_EX
with the same garbage data.

IMO, the behavior should be to read the file on load and then use the kernel buffer
without ever reloading (unless this is built as a module and is unloaded and reloaded).
The writeback then becomes opportunistic in the sense that if it fails for some reason,
the kernel's internal state isn't blasted away.

>  	}
>  
>  	if (rc)
> @@ -303,7 +440,7 @@ static int __sev_platform_init_locked(int *error)
>  
>  	dev_dbg(sev->dev, "SEV firmware initialized\n");
>  
> -	return rc;
> +	return 0;
>  }
>  
>  int sev_platform_init(int *error)
> @@ -1057,6 +1194,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  			   get_order(SEV_ES_TMR_SIZE));
>  		sev_es_tmr = NULL;
>  	}
> +
> +	if (sev_init_ex_nv_address) {

It really seems like the the teardown path should be paranoid and do a final
writeback of the kernel's buffer.

> +		free_pages((unsigned long)sev_init_ex_nv_address,
> +			   get_order(NV_LENGTH));
> +		sev_init_ex_nv_address = NULL;
> +	}
>  }
>  
>  void sev_dev_destroy(struct psp_device *psp)
> @@ -1101,6 +1244,18 @@ void sev_pci_init(void)
>  	    sev_update_firmware(sev->dev) == 0)
>  		sev_get_api_version();
>  
> +	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
> +	 * instead of INIT.
> +	 */
> +	if (init_ex_path) {
> +		sev_init_ex_nv_address = sev_fw_alloc(NV_LENGTH);
> +		if (!sev_init_ex_nv_address) {
> +			dev_err(sev->dev,
> +				"SEV: INIT_EX NV memory allocation failed\n");
> +			goto err;

Why does this nullify psp_master->sev_data but later failures do not?

> +		}
> +	}
> +
>  	/* Obtain the TMR memory area for SEV-ES use */
>  	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>  	if (!sev_es_tmr)
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d48a7192e881..1595088c428b 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -52,6 +52,7 @@ enum sev_cmd {
>  	SEV_CMD_DF_FLUSH		= 0x00A,
>  	SEV_CMD_DOWNLOAD_FIRMWARE	= 0x00B,
>  	SEV_CMD_GET_ID			= 0x00C,
> +	SEV_CMD_INIT_EX                 = 0x00D,
>  
>  	/* Guest commands */
>  	SEV_CMD_DECOMMISSION		= 0x020,
> @@ -102,6 +103,26 @@ struct sev_data_init {
>  	u32 tmr_len;			/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_init_ex - INIT_EX command parameters
> + *
> + * @length: len of the command buffer read by the PSP
> + * @flags: processing flags
> + * @tmr_address: system physical address used for SEV-ES
> + * @tmr_len: len of tmr_address
> + * @nv_address: system physical address used for PSP NV storage
> + * @nv_len: len of nv_address
> + */
> +struct sev_data_init_ex {
> +	u32 length;                     /* In */
> +	u32 flags;                      /* In */
> +	u64 tmr_address;                /* In */
> +	u32 tmr_len;                    /* In */
> +	u32 reserved;                   /* In */
> +	u64 nv_address;                 /* In/Out */
> +	u32 nv_len;                     /* In */
> +} __packed;
> +
>  #define SEV_INIT_FLAGS_SEV_ES	0x01
>  
>  /**
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
