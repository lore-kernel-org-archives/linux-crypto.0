From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [patch] crypto: qat - fix some timeout tests
Date: Tue, 15 Dec 2015 12:27:23 -0800
Message-ID: <567077AB.8040602@intel.com>
References: <20151215100515.GB20848@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151215100515.GB20848@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/15/2015 02:05 AM, Dan Carpenter wrote:
> We do an "if (!times)" test later to see if we ran the loop too many
> times, but because it is a postop negate that means times is -1 when we
> exit that way.  I have fixed this by changing it from a post op to a
> preop.
> 
> Fixes: b3416fb8a2f5 ('crypto: qat - Intel(R) QAT accelengine part of fw loader')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This means we only loop 9999 times instead of 10000 like before but I
> figure it probably doesn't matter.
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
> index 45c1739..2b078a6 100644
> --- a/drivers/crypto/qat/qat_common/qat_hal.c
> +++ b/drivers/crypto/qat/qat_common/qat_hal.c
> @@ -171,7 +171,7 @@ static int qat_hal_wait_cycles(struct icp_qat_fw_loader_handle *handle,
>  
>  	qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT, &base_cnt);
>  	base_cnt &= 0xffff;
> -	while ((int)cycles > elapsed_cycles && times--) {
> +	while ((int)cycles > elapsed_cycles && --times) {
>  		if (chk_inactive)
>  			qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &csr);
>  
> 

Since the times var is an signed int I think we should rather change the condition:

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 45c1739..864a5ea 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -186,7 +186,7 @@ static int qat_hal_wait_cycles(struct icp_qat_fw_loader_handle *handle,
 		if (elapsed_cycles >= 8 && !(csr & (1 << ACS_ABO_BITPOS)))
 			return 0;
 	}
-	if (!times) {
+	if (!(0 < times)) {
 		pr_err("QAT: wait_num_cycles time out\n");
 		return -EFAULT;
 	}

Pingchao could you test and send a patch please.
Thanks
-- 
TS
