From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [V3] crypto: qat - fix timeout issues
Date: Fri, 15 Jan 2016 10:29:01 -0800
Message-ID: <56993A6D.4060901@intel.com>
References: <1452130786-147187-1-git-send-email-pingchao.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pingchao Yang <pingchao.yang@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbcAOScp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 13:32:45 -0500
In-Reply-To: <1452130786-147187-1-git-send-email-pingchao.yang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2016 05:39 PM, Pingchao Yang wrote:
> Change the variable times data type and timeout conditon since the value
> of times should be -1 after loop.
> 
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
> 
> ---
> drivers/crypto/qat/qat_common/qat_hal.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
> index 0ac0ba8..7786e6e 100644
> --- a/drivers/crypto/qat/qat_common/qat_hal.c
> +++ b/drivers/crypto/qat/qat_common/qat_hal.c
> @@ -389,7 +389,7 @@ static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
>  {
>  	unsigned int base_cnt, cur_cnt;
>  	unsigned char ae;
> -	unsigned int times = MAX_RETRY_TIMES;
> +	int times = MAX_RETRY_TIMES;
>  
>  	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
>  		qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT,
> @@ -402,7 +402,7 @@ static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
>  			cur_cnt &= 0xffff;
>  		} while (times-- && (cur_cnt == base_cnt));
>  
> -		if (!times) {
> +		if (times < 0) {
>  			pr_err("QAT: AE%d is inactive!!\n", ae);
>  			return -EFAULT;
>  		}
> @@ -453,7 +453,8 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
>  	void __iomem *csr_addr =
>  			(void __iomem *)((uintptr_t)handle->hal_ep_csr_addr_v +
>  			ESRAM_AUTO_INIT_CSR_OFFSET);
> -	unsigned int csr_val, times = 30;
> +	unsigned int csr_val;
> +	int times = 30;
>  
>  	csr_val = ADF_CSR_RD(csr_addr, 0);
>  	if ((csr_val & ESRAM_AUTO_TINIT) && (csr_val & ESRAM_AUTO_TINIT_DONE))
> @@ -467,7 +468,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
>  		qat_hal_wait_cycles(handle, 0, ESRAM_AUTO_INIT_USED_CYCLES, 0);
>  		csr_val = ADF_CSR_RD(csr_addr, 0);
>  	} while (!(csr_val & ESRAM_AUTO_TINIT_DONE) && times--);
> -	if ((!times)) {
> +	if ((times < 0)) {
>  		pr_err("QAT: Fail to init eSram!\n");
>  		return -EFAULT;
>  	}
> @@ -658,7 +659,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
>  			ret = qat_hal_wait_cycles(handle, ae, 20, 1);
>  		} while (ret && times--);
>  
> -		if (!times) {
> +		if (times < 0) {
>  			pr_err("QAT: clear GPR of AE %d failed", ae);
>  			return -EINVAL;
>  		}
> 
Herbert,
This fixes integer overflow issue around csr initialization.
Please include this fix into 4.5.
Thanks,

-- 
TS
