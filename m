Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35669C10DCE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 21:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E123F2072A
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 21:54:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GfPMFn2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCHVyn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 17:54:43 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35956 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHVyn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 17:54:43 -0400
Received: by mail-pj1-f67.google.com with SMTP id l41so3525767pjb.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2020 14:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=3b9YvnaJn7dLBvWlOl+wgyd0P+akPRxHVaDRv4vDCY4=;
        b=GfPMFn2Mmoi2TfjPogvcmslUvY5y3HEkMHhqem0k3g17W0eLAJTFaA9tr4YcX/sESF
         kWxNIQP1S0Vq4sh8RL5qRHZOCQTu/OPrWdxNGGa1L15QyfpnQo0UcNVCm/n9EXPkznTX
         Qdz++WOgDnYhSOmBkCqX/xi086qpC38N2nC8Ao7PM/YD7RN6CTFy0Dq7sZgwNH5wbADa
         NufJW01ZOUVpAzaAof6EWa1xGICvcNWnZx704Wcd8M10OxGKs2cKpg5WvW2tp235ZUaP
         GaDOLGseSYQx77pjDpnpAelgzKjSmG6kOlcbMr2AytYYC04y9exrlL42vCbGQ5gfTiun
         PluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=3b9YvnaJn7dLBvWlOl+wgyd0P+akPRxHVaDRv4vDCY4=;
        b=h1N6W1Iliz1j/jBtSBS+c3MpPf+Fea1z9Z6QIXvQbNFXMTTbGSqPUyzPoUI+l65Bhu
         /ZmGjQPgSXwT5Ab9XcoXiZnok/nfSPyKBwyDaSQxcWggfPDg0EM8zLQP1fMyCa9040tp
         6761M/q/UNuRKGalwxjNizoN7dSSvlqBFt/RCpd9cTVFVpsSck3mP5kai6DKmOsLSVN+
         celtR+SGwCb445HliuIC2lwflf7dm39BYhDVJ7jfIdE6D8VizRJIxwG68bHSNqg1CepB
         cFZU3zGyDwejOfKHkunZXNW9iDsiygWHpgrqo4p/vD4CSoBwMWgroMJ/P6EihOjd8oM1
         EQrA==
X-Gm-Message-State: ANhLgQ06hcFMO/4jSr4z9rmgUCsamaTdvKqYq/prE3XxCYjwMoHJqzLp
        NWo5rWT4chkaAiC2t87w24OjMw==
X-Google-Smtp-Source: ADFU+vtyHaZuSBsw70rOnr4UdHI8lOzfbeoCNetIC2SJEt63jsn9Yc5Mr/NAmjmVPU/DwruGwOJfBw==
X-Received: by 2002:a17:90a:c301:: with SMTP id g1mr15323465pjt.173.1583704481165;
        Sun, 08 Mar 2020 14:54:41 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id t11sm16231813pjo.21.2020.03.08.14.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 14:54:40 -0700 (PDT)
Date:   Sun, 8 Mar 2020 14:54:39 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Connor Kuehl <ckuehl@redhat.com>
cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, gary.hook@amd.com, erdemaktas@google.com,
        brijesh.singh@amd.com, npmccallum@redhat.com, bsd@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl
 permissions
In-Reply-To: <20200306172010.1213899-2-ckuehl@redhat.com>
Message-ID: <alpine.DEB.2.21.2003081450450.58178@chino.kir.corp.google.com>
References: <20200306172010.1213899-1-ckuehl@redhat.com> <20200306172010.1213899-2-ckuehl@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 6 Mar 2020, Connor Kuehl wrote:

> Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> check the file mode for write permissions before executing commands that
> can affect the platform. This allows for more fine-grained access
> control to the SEV ioctl interface. This would allow a SEV-only user
> or group the ability to administer the platform without requiring them
> to be root or granting them overly powerful permissions.
> 
> For example:
> 
> chown root:root /dev/sev
> chmod 600 /dev/sev

Hi Connor,

I'm curious why do you need to do the two above commands?  It implies that 
/dev/sev is either not owned by root or that it is not already restricted 
to only being owner read and writable.

Or perhaps these two commands were included only for clarity to explain 
what the defaults should be?

> setfacl -m g:sev:r /dev/sev
> setfacl -m g:sev-admin:rw /dev/sev
> 
> In this instance, members of the "sev-admin" group have the ability to
> perform all ioctl calls (including the ones that modify platform state).
> Members of the "sev" group only have access to the ioctls that do not
> modify the platform state.
> 
> This also makes opening "/dev/sev" more consistent with how file
> descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> the file descriptor could be opened read-only but could still execute
> ioctls that modify the platform state. This patch enforces that the file
> descriptor is opened with write privileges if it is going to be used to
> modify the platform state.
> 
> This flexibility is completely opt-in, and if it is not desirable by
> the administrator then they do not need to give anyone else access to
> /dev/sev.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e467860f797d..416b80938a3e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -283,11 +283,11 @@ static int sev_get_platform_state(int *state, int *error)
>  	return rc;
>  }
>  
> -static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  {
>  	int state, rc;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	/*
> @@ -331,12 +331,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (sev->state == SEV_STATE_UNINIT) {
> @@ -348,7 +348,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>  	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>  }
>  
> -static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
> @@ -356,7 +356,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>  	void *blob = NULL;
>  	int ret;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> @@ -539,7 +539,7 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_cert_import input;
> @@ -547,7 +547,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>  	void *pek_blob, *oca_blob;
>  	int ret;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> @@ -698,7 +698,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pdh_cert_export input;
> @@ -708,7 +708,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
>  
>  	/* If platform is not in INIT state then transition it to INIT. */
>  	if (sev->state != SEV_STATE_INIT) {
> -		if (!capable(CAP_SYS_ADMIN))
> +		if (!writable)
>  			return -EPERM;
>  
>  		ret = __sev_platform_init_locked(&argp->error);
> @@ -801,6 +801,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	void __user *argp = (void __user *)arg;
>  	struct sev_issue_cmd input;
>  	int ret = -EFAULT;
> +	bool writable = file->f_mode & FMODE_WRITE;
>  
>  	if (!psp_master || !psp_master->sev_data)
>  		return -ENODEV;
> @@ -819,25 +820,25 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	switch (input.cmd) {
>  
>  	case SEV_FACTORY_RESET:
> -		ret = sev_ioctl_do_reset(&input);
> +		ret = sev_ioctl_do_reset(&input, writable);
>  		break;
>  	case SEV_PLATFORM_STATUS:
>  		ret = sev_ioctl_do_platform_status(&input);
>  		break;
>  	case SEV_PEK_GEN:
> -		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
> +		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input, writable);
>  		break;
>  	case SEV_PDH_GEN:
> -		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
> +		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input, writable);
>  		break;
>  	case SEV_PEK_CSR:
> -		ret = sev_ioctl_do_pek_csr(&input);
> +		ret = sev_ioctl_do_pek_csr(&input, writable);
>  		break;
>  	case SEV_PEK_CERT_IMPORT:
> -		ret = sev_ioctl_do_pek_import(&input);
> +		ret = sev_ioctl_do_pek_import(&input, writable);
>  		break;
>  	case SEV_PDH_CERT_EXPORT:
> -		ret = sev_ioctl_do_pdh_export(&input);
> +		ret = sev_ioctl_do_pdh_export(&input, writable);
>  		break;
>  	case SEV_GET_ID:
>  		pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
> -- 
> 2.24.1
> 
> 
