Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5FCC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 09:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECF3206C3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 09:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgFDJEY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 05:04:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgFDJEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 05:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F6A2ACF1;
        Thu,  4 Jun 2020 09:04:26 +0000 (UTC)
Date:   Thu, 4 Jun 2020 11:04:13 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kbuild test robot <lkp@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix sparse warnings in sev-dev
Message-ID: <20200604090413.GA3850@zn.tnic>
References: <20200604080941.GA8278@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200604080941.GA8278@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

+ Tom.

On Thu, Jun 04, 2020 at 06:09:41PM +1000, Herbert Xu wrote:
> This patch fixes a bunch of sparse warnings in sev-dev where the
> __user marking is incorrectly handled.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: 7360e4b14350 ("crypto: ccp: Implement SEV_PEK_CERT_IMPORT...")
> Fixes: e799035609e1 ("crypto: ccp: Implement SEV_PEK_CSR ioctl...")
> Fixes: 76a2b524a4b1 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 439cd737076e..aa576529283b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -376,6 +376,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
>  	struct sev_data_pek_csr *data;
> +	void __user *input_address;
>  	void *blob = NULL;
>  	int ret;
>  
> @@ -394,7 +395,8 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  		goto cmd;
>  
>  	/* allocate a physically contiguous buffer to store the CSR blob */
> -	if (!access_ok(input.address, input.length) ||
> +	input_address = (void __user *)input.address;
> +	if (!access_ok(input_address, input.length) ||
>  	    input.length > SEV_FW_BLOB_MAX_SIZE) {
>  		ret = -EFAULT;
>  		goto e_free;
> @@ -427,7 +429,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (blob) {
> -		if (copy_to_user((void __user *)input.address, blob, input.length))
> +		if (copy_to_user(input_address, blob, input.length))
>  			ret = -EFAULT;
>  	}
>  
> @@ -438,7 +440,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> -void *psp_copy_user_blob(u64 __user uaddr, u32 len)
> +void *psp_copy_user_blob(u64 uaddr, u32 len)
>  {
>  	if (!uaddr || !len)
>  		return ERR_PTR(-EINVAL);
> @@ -447,7 +449,7 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>  	if (len > SEV_FW_BLOB_MAX_SIZE)
>  		return ERR_PTR(-EINVAL);
>  
> -	return memdup_user((void __user *)(uintptr_t)uaddr, len);
> +	return memdup_user((void __user *)uaddr, len);
>  }
>  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>  
> @@ -622,6 +624,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  {
>  	struct sev_user_data_get_id2 input;
>  	struct sev_data_get_id *data;
> +	void __user *input_address;
>  	void *id_blob = NULL;
>  	int ret;
>  
> @@ -633,9 +636,10 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  		return -EFAULT;
>  
>  	/* Check if we have write access to the userspace buffer */
> +	input_address = (void __user *)input.address;
>  	if (input.address &&
>  	    input.length &&
> -	    !access_ok(input.address, input.length))
> +	    !access_ok(input_address, input.length))
>  		return -EFAULT;
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
> @@ -667,8 +671,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  	}
>  
>  	if (id_blob) {
> -		if (copy_to_user((void __user *)input.address,
> -				 id_blob, data->len)) {
> +		if (copy_to_user(input_address, id_blob, data->len)) {
>  			ret = -EFAULT;
>  			goto e_free;
>  		}
> @@ -727,6 +730,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_user_data_pdh_cert_export input;
>  	void *pdh_blob = NULL, *cert_blob = NULL;
>  	struct sev_data_pdh_cert_export *data;
> +	void __user *input_cert_chain_address;
> +	void __user *input_pdh_cert_address;
>  	int ret;
>  
>  	/* If platform is not in INIT state then transition it to INIT. */
> @@ -752,16 +757,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	    !input.cert_chain_address)
>  		goto cmd;
>  
> +	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
> +	input_cert_chain_address = (void __user *)input.cert_chain_address;
> +
>  	/* Allocate a physically contiguous buffer to store the PDH blob. */
>  	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
> -	    !access_ok(input.pdh_cert_address, input.pdh_cert_len)) {
> +	    !access_ok(input_pdh_cert_address, input.pdh_cert_len)) {
>  		ret = -EFAULT;
>  		goto e_free;
>  	}
>  
>  	/* Allocate a physically contiguous buffer to store the cert chain blob. */
>  	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
> -	    !access_ok(input.cert_chain_address, input.cert_chain_len)) {
> +	    !access_ok(input_cert_chain_address, input.cert_chain_len)) {
>  		ret = -EFAULT;
>  		goto e_free;
>  	}
> @@ -797,7 +805,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (pdh_blob) {
> -		if (copy_to_user((void __user *)input.pdh_cert_address,
> +		if (copy_to_user(input_pdh_cert_address,
>  				 pdh_blob, input.pdh_cert_len)) {
>  			ret = -EFAULT;
>  			goto e_free_cert;
> @@ -805,7 +813,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (cert_blob) {
> -		if (copy_to_user((void __user *)input.cert_chain_address,
> +		if (copy_to_user(input_cert_chain_address,
>  				 cert_blob, input.cert_chain_len))
>  			ret = -EFAULT;
>  	}
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 7fbc8679145c..49d155cd2dfe 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -597,7 +597,7 @@ int sev_guest_df_flush(int *error);
>   */
>  int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>  
> -void *psp_copy_user_blob(u64 __user uaddr, u32 len);
> +void *psp_copy_user_blob(u64 uaddr, u32 len);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
