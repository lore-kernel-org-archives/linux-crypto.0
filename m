From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [patch] crypto: qat - silence a static checker warning
Date: Sat, 22 Aug 2015 08:29:30 -0700
Message-ID: <55D8955A.5010106@intel.com>
References: <20150821084745.GB25369@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46913 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbHVPar (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Aug 2015 11:30:47 -0400
In-Reply-To: <20150821084745.GB25369@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dan,
On 08/21/2015 01:47 AM, Dan Carpenter wrote:
> My static checker assumes that if we are getting numbers as a string
> using kstrotoint() then that means they come from outside the kernel and
> are untrustworthy.
> 
> This may or may not be true in this case, but it seems harmless to add
> a range check here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
> index d5d8198..ec3abf9 100644
> --- a/drivers/crypto/qat/qat_common/adf_transport.c
> +++ b/drivers/crypto/qat/qat_common/adf_transport.c
> @@ -264,6 +264,10 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
>  		dev_err(&GET_DEV(accel_dev), "Can't get ring number\n");
>  		return -EFAULT;
>  	}
> +	if (ring_num >= ARRAY_SIZE(bank->rings)) {
> +		dev_err(&GET_DEV(accel_dev), "Invalid ring number\n");
> +		return -EFAULT;
> +	}
>  
>  	bank = &transport_data->banks[bank_num];
>  	if (adf_reserve_ring(bank, ring_num)) {
> 

ACK, although I would use the ADF_ETR_MAX_RINGS_PER_BANK define.
So if you don't mind.
Thanks!
---8<---

Add range check for ring number.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index d5d8198..3865ae8 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -264,6 +264,10 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		dev_err(&GET_DEV(accel_dev), "Can't get ring number\n");
 		return -EFAULT;
 	}
+	if (ring_num >= ADF_ETR_MAX_RINGS_PER_BANK) {
+		dev_err(&GET_DEV(accel_dev), "Invalid ring number\n");
+		return -EFAULT;
+	}
 
 	bank = &transport_data->banks[bank_num];
 	if (adf_reserve_ring(bank, ring_num)) {
