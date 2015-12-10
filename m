From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [patch -next] crypto: qat - uint8_t is not large enough for
 accel_id
Date: Thu, 10 Dec 2015 14:23:03 -0800
Message-ID: <5669FB47.60308@intel.com>
References: <20151210220044.GA21797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151210220044.GA21797@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Dan,
On 12/10/2015 02:00 PM, Dan Carpenter wrote:
> ->accel_id has to be large enough to hold ADF_MAX_DEVICES + 1 (which is
> 1025) so uint8_t is too small.
> 
> Fixes: 890c55f4dc0e ('crypto: qat - add support for c3xxx accel type')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
> index 4d78ec0..1e1cdef 100644
> --- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
> +++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
> @@ -251,6 +251,6 @@ struct adf_accel_dev {
>  		} vf;
>  	};
>  	bool is_vf;
> -	uint8_t accel_id;
> +	unsigned int accel_id;
>  } __packed;
>  #endif

Yes, that's correct. That was part of my next patchset, but since
you sent the patch..
We also need to change the corresponding field in the
struct adf_dev_status_info, and change the instance_id to match the
instance_id in the adf_hw_device_data struct.
I would also prefer u32 instead of unsigned int.

---8<---
accel_id has to be large enough to hold ADF_MAX_DEVICES + 1
(which is > 1025) so uint8_t is too small.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 4d78ec0..f96d427 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -251,6 +251,6 @@ struct adf_accel_dev {
 		} vf;
 	};
 	bool is_vf;
-	uint8_t accel_id;
+	u32 accel_id;
 } __packed;
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index 673dbf7..8c4f657 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -80,8 +80,8 @@ enum adf_device_type {
 
 struct adf_dev_status_info {
 	enum adf_device_type type;
-	uint8_t accel_id;
-	uint8_t instance_id;
+	u32 accel_id;
+	u32 instance_id;
 	uint8_t num_ae;
 	uint8_t num_accel;
 	uint8_t num_logical_accel;

