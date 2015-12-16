From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] crypto: qat - fix CTX_ENABLES bits shift direction issue
Date: Wed, 16 Dec 2015 09:09:34 +0100
Message-ID: <56711C3E.6070302@bfs.de>
References: <1450233580-58266-1-git-send-email-pingchao.yang@intel.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, dan.carpenter@oracle.com,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, kernel-janitors@vger.kernel.org
To: Yang Pingchao <pingchao.yang@intel.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1450233580-58266-1-git-send-email-pingchao.yang@intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Am 16.12.2015 03:39, schrieb Yang Pingchao:
> AE CTX bits should be 8-15 in CTX_ENABLES, so the mask
> value 0xff should be left shifted 0x8.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_hal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
> index 45c1739..81bd1fe 100644
> --- a/drivers/crypto/qat/qat_common/qat_hal.c
> +++ b/drivers/crypto/qat/qat_common/qat_hal.c
> @@ -418,7 +418,7 @@ int qat_hal_check_ae_active(struct icp_qat_fw_loader_handle *handle,
>  
>  	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &enable);
>  	qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &active);
> -	if ((enable & (0xff >> CE_ENABLE_BITPOS)) ||
> +	if ((enable & (0xff << CE_ENABLE_BITPOS)) ||
>  	    (active & (1 << ACS_ABO_BITPOS)))
>  		return 1;
>  	else

Is there any reason for using 0xff << CE_ENABLE_BITPOS instead of 0xff00 ?

re,
 wh
