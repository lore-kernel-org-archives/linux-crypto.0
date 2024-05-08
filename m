Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6033D5338F
	for <linux-crypto@vger.kernel.org>; Wed,  8 May 2024 08:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157606; cv=none; b=AG83yTChBDUYkuCmYB+DR2WbOJ2uZ0U4+iDg04wdGt9qa9dXKYXg52LQ7DMdoJZA4YjRrabzesFx291cojJpNVdMIuGf6XlNrU/eBgMEuJJvkBT3B06Elz56ZzwdxxtterMy9Ovw4lnmPW0Y38kjohEzy6i/khqfLEvDQh/cR/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157606; c=relaxed/simple;
	bh=aCrdA+Vnwbrp7loJ4ejGB7iS3djJA76r0hGq1qxHMCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrSWn+0HcNBcCsExBzv9dLWsHOPAE1SNcKy893VMHnvg+rx2+SkqOYchLvXl3xWlk8I/PLN/NjCv5Amoy2ey/Yq32maC3LFfVdiYVyXn3tt7iA9/vRL6cZXXF/XxZusOMp4PXI0ZpQz8PU6XMc1dnL12ZIXbbJeC5pt5EPjXXe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s4cq7-00CKXs-1K;
	Wed, 08 May 2024 16:39:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 May 2024 16:39:52 +0800
Date: Wed, 8 May 2024 16:39:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak
Message-ID: <Zjs6VxtkL8QLtHIH@gondor.apana.org.au>
References: <20240209124403.44781-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209124403.44781-1-damian.muszynski@intel.com>

On Fri, Feb 09, 2024 at 01:43:42PM +0100, Damian Muszynski wrote:
>
> @@ -146,11 +147,19 @@ static void adf_device_reset_worker(struct work_struct *work)
>  	adf_dev_restarted_notify(accel_dev);
>  	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
>  
> -	/* The dev is back alive. Notify the caller if in sync mode */
> -	if (reset_data->mode == ADF_DEV_RESET_SYNC)
> -		complete(&reset_data->compl);
> -	else
> +	/*
> +	 * The dev is back alive. Notify the caller if in sync mode
> +	 *
> +	 * If device restart will take a more time than expected,
> +	 * the schedule_reset() function can timeout and exit. This can be
> +	 * detected by calling the completion_done() function. In this case
> +	 * the reset_data structure needs to be freed here.
> +	 */
> +	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
> +	    completion_done(&reset_data->compl))
>  		kfree(reset_data);
> +	else
> +		complete(&reset_data->compl);

This doesn't work because until you call complete, completion_done
will always return false.  IOW we now have a memory leak instead of
a UAF.

---8<---
Using completion_done to determine whether the caller has gone
away only works after a complete call.  Furthermore it's still
possible that the caller has not yet called wait_for_completion,
resulting in another potential UAF.

Fix this by making the caller use cancel_work_sync and then freeing
the memory safely.

Fixes: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Cc: <stable@vger.kernel.org> #6.8+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 9da2278bd5b7..04260f61d042 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -130,8 +130,7 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_restart(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
-		    completion_done(&reset_data->compl))
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -147,16 +146,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
-	/*
-	 * The dev is back alive. Notify the caller if in sync mode
-	 *
-	 * If device restart will take a more time than expected,
-	 * the schedule_reset() function can timeout and exit. This can be
-	 * detected by calling the completion_done() function. In this case
-	 * the reset_data structure needs to be freed here.
-	 */
-	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
-	    completion_done(&reset_data->compl))
+	/* The dev is back alive. Notify the caller if in sync mode */
+	if (reset_data->mode == ADF_DEV_RESET_ASYNC)
 		kfree(reset_data);
 	else
 		complete(&reset_data->compl);
@@ -191,10 +182,10 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 		if (!timeout) {
 			dev_err(&GET_DEV(accel_dev),
 				"Reset device timeout expired\n");
+			cancel_work_sync(&reset_data->reset_work);
 			ret = -EFAULT;
-		} else {
-			kfree(reset_data);
 		}
+		kfree(reset_data);
 		return ret;
 	}
 	return 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
