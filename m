Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A673D47885C
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789087; cv=none; b=nPOaLucgEje5bfg3dLQiKZSmlD2IFTqTr+1pbvo8z0NcoOZyT3tI3Tvb7DmsnNJJy+SPmXk0FC+mYbD3XwmBVOE3My0H2j5WkeUD2sAuJkc0Vl0YFRzIopmMPuqod5Krg2V90T4FPZohrytqRzOPz6qzErmV3XDvhh2sG0t02MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789087; c=relaxed/simple;
	bh=3TNtFTlqrdZ5+YZy+EC2OaylrmIovS91jV6acWJlinI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EY4kQTgUFI1/b/GaQkBu88teUlCYC2m/wuzHzcMCwtH7jlTQSkXHvxmWzGOff7k6+r6jB8B1dtU+6eEdoguYmY31vBDK6BQ3ShUWtL4TpHZiBk7RsIr7l4Yp310GmCi6fBAN9yXlcTJ1dvvyVnFx8W0DYLR+0EEoze4nPt6T8iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eughWgDv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qewaq5To; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eughWgDv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qewaq5To"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788789084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IK1b3/uf3qXoeBbeOklu6NoaQHInpz2yTIvSfFIZiH0=;
	b=eughWgDvy/Jzo6HIehw66A1Sr7H095qUd/L9Rg/ga0RDkvUjj7FhQ6CjMs+bnwe7auU4Yf
	4BlyulwjALIXI4GwUiFBSzpPNxcCEviG2Hn84gh7M1qBkV0NRAA10SIwq7EM3Ikmh74LMI
	yVz1F30Kbf6jNrcK9ADN6I25Lc66QsM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-Ino18ps4Num0OZRztLFYDA-1; Mon, 07 Sep 2026 09:51:22 -0400
X-MC-Unique: Ino18ps4Num0OZRztLFYDA-1
X-Mimecast-MFC-AGG-ID: Ino18ps4Num0OZRztLFYDA_1788789082
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-485835753caso2791181f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 06:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788789082; x=1789393882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IK1b3/uf3qXoeBbeOklu6NoaQHInpz2yTIvSfFIZiH0=;
        b=qewaq5ToqByNpBtQkn93tUFUq6wGqE39nnkFENbrgd0mxAojAnWTtfDKnmKZwpqsKF
         40bztzp4LIZ15DUhPwUYN/44yXeLgd2saC7+cSB+N6YRbAZYSuX5Rp3BEIt/B51ik+Kv
         UXfhZRvh59mjJvx8iMjOw609tLRXFyO6riwVSTdEGNlNgciXOakDYwawD4IjY9dFWTxU
         2f6UzPnjlXRURMUdUECpV8YqSFYvfRDZm4WOaofDxwVazOAkRo1yptRLvs1Bar51z34v
         nwWOgU4bbEdgsxsnzxXX84LmVKl37iRRW/MwZM+B/0Jv/NZuQ+NO/arSWgX4MfQnzcYn
         WDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788789082; x=1789393882;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IK1b3/uf3qXoeBbeOklu6NoaQHInpz2yTIvSfFIZiH0=;
        b=H5ZbiwhwdTTW/swUGnyVHwlpDICNFZLcfvtRSL+2ghg5pjqEcDHayt59ecAABG3EyI
         OxY9Wt9EUYZOyEA9oNYo+mMj0EDRclnqYmn21x799CsOq04aV3kXL8eCHUNCqlmPj9Pf
         AIHr06+yi783PU4YAe8JUWgZkBwWWUSBLq8hOC3x9eznSVimWsDPCqEkeCBEHzOUx6ay
         sXrxiz4HuhhzWL0BPvJ7lQrq3s+du0zhLbj8M2qMq0W5yO59E1VUc10GFyN3hPTp94xl
         FccFOuqJoi+hc2+336eh4JUx3/KbRYTNpSpjdl5leYli1nwvmFkl2/+HUycFvR6yxHYt
         5ILQ==
X-Gm-Message-State: AFuF++mVpnK1xEoKeJPSzgiC7OL2oBrDfpKqgOCUSGqEUMZqlqL2hACO
	l0tZVkVUAYg4fVeoLBop+7XzMaCxavPG4ynHwWGysiBLY8Ssf11P1Gu1SRGmuHm59NevUUAH9vN
	9LV2sp2mqgG/xrm2yV2y8mb3FabXS0mW1VuvsgewFxO14Swvt9DbV5WOEJxCoi0GVyoMoIjcrvQ
	==
X-Gm-Gg: AYBFou1lMJWir+bStIlFF1CNNTojY4IU4HaEV3jvSbVk1ywpKzES/SZcKKLLna+NHJT
	e92BQBoaGOXyr2JeZon0cuLaD204nOM9LLZ+/t7YWBBqg/bd9iiBwzkhX72SGTDL/DTzUfWrNpd
	h8szvNjbieuCkaFJLO0zPUMJV1ko/7wfxkL3nHSJ/76GTF/izY1t6uFVRg9L72SkfaUBC31djo1
	A8gD25wEjYjccL3pxS/ysVyZGw5ilJ+tJmbZXDH+HapAYeXFAR0hIE2wt6y7VXI6aewQt2+ceu9
	Byu7c1ecUHkcSDkJiBqh+z/BljV+bqUeQTyBIEgP1anPRLVjJuBfjjSnyE6UlB/+uGbZ5QSF
X-Received: by 2002:adf:e194:0:b0:485:8606:ebb7 with SMTP id ffacd0b85a97d-48587286257mr23496172f8f.8.1788789081804;
        Mon, 07 Sep 2026 06:51:21 -0700 (PDT)
X-Received: by 2002:adf:e194:0:b0:485:8606:ebb7 with SMTP id ffacd0b85a97d-48587286257mr23496142f8f.8.1788789081389;
        Mon, 07 Sep 2026 06:51:21 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883927a3sm22251697f8f.11.2026.09.07.06.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 06:51:20 -0700 (PDT)
Message-ID: <2cd6e3c2-bd01-47df-b58c-f1f207f856c6@redhat.com>
Date: Mon, 7 Sep 2026 15:51:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - fix active_devs leak on crypto alg
 registration failure
To: Ahsan Atta <ahsan.atta@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20260902101216.1226292-1-ahsan.atta@intel.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260902101216.1226292-1-ahsan.atta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/09/2026 12.12, Ahsan Atta wrote:
> adf_dev_start() registered both alg sets in a single condition.
> If qat_algs_register() succeeds but qat_asym_algs_register() fails,
> ADF_STATUS_CRYPTO_ALGS_REGISTERED is left clear, so adf_dev_stop() skips
> qat_algs_unregister(): the skciphers and aeads stay registered with
> active_devs stuck at 1, pinning the module.
> 
> Both helpers leak active_devs internally as well - they increment it and
> return without decrementing when a crypto_register_*() call fails, and
> the asym path also leaves the already-registered akcipher behind.
> 
> Split the registration in adf_dev_start() so that an asym failure
> unregisters qat_algs, and unwind active_devs (and the akcipher) on the
> error paths of both register helpers.
> 
> Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>   .../crypto/intel/qat/qat_common/adf_init.c    | 22 +++++++++++-----
>   .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
>   .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
>   3 files changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
> index 3e39c53814de..558467dea1a5 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_init.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
> @@ -260,13 +260,21 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
>   	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
>   	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
>   
> -	if (!list_empty(&accel_dev->crypto_list) &&
> -	    (qat_algs_register() || qat_asym_algs_register())) {
> -		dev_err(&GET_DEV(accel_dev),
> -			"Failed to register crypto algs\n");
> -		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> -		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> -		return -EFAULT;
> +	if (!list_empty(&accel_dev->crypto_list)) {
> +		if (qat_algs_register()) {
> +			dev_err(&GET_DEV(accel_dev), "Failed to register crypto algs\n");
> +			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> +			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> +			return -EFAULT;
> +		}
> +
> +		if (qat_asym_algs_register()) {
> +			dev_err(&GET_DEV(accel_dev), "Failed to register crypto asym algs\n");
> +			qat_algs_unregister();
> +			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> +			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> +			return -EFAULT;

EFAULT is the error code that should be used if accessing memory failed, 
it's a very bad choice for an error code in this case here.
So while you're at it, could you maybe change this to return a more sane 
value here? I think the best option is likely to pass along the return value 
from qat_algs_register / qat_asym_algs_register.

  Thanks,
   Thomas

> +		}
>   	}
>   	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);...

