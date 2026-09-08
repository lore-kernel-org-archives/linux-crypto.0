Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C4355F49
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883752; cv=none; b=PJO828GAwdak5rKlpBX0ZSxTNmdcEQgXJBPIINNI0bMTDF7mOfMJ1Pb94orHP6X8CZYjG/WpvjRc5RiJ52sP9fa7+SnFvpB24AdqmbHbmqzhJzrgfji03CudYZVyahUPu+BQQ5aIXFTn5wva1TUwCkCQu6oc8evcNdrBRywQfxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883752; c=relaxed/simple;
	bh=2jRw5avAI4HcRBiKnghRiXNBnwMn1VlWywX/m1PBwQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QKrUumQyRCxxDS3/FleMORzR2u7l8SFtg+a3XHOjKogwdmfdXz5Os82xFvl+vo1sreG2z6tNPHV1+cJo8PmYbfdxiO186SFaGKNwyV3ofSIT90iNRxuatBTi7HYdqJ6oOP3ye4cZZSH38gd/TQJDuP1JCw9k3UGp1bcz/5sK48E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYI6l440; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f1YI7wNG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYI6l440";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f1YI7wNG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788883748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3x7bWB9582wjHIO1v4KHpXP52Oa1CLx5XWxzNCr4lbo=;
	b=FYI6l440y3NSZgtCdUCEdKjTa0i5hJfCqmFnwgyCDzHXaas7bWnYpI2vCcKOn+9XERsIpJ
	t4ivZPBtdft6M8SWiupEXkbrB70dKOpIByD2+Na0jsnFKIJPKmtAmBirsZ+Nbmo734a4SR
	wQM7YojJj1ShcNtXRnKfcQsMFmVTS+U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-hDydaXGxNqyLyN-j9s2FJA-1; Tue, 08 Sep 2026 12:09:07 -0400
X-MC-Unique: hDydaXGxNqyLyN-j9s2FJA-1
X-Mimecast-MFC-AGG-ID: hDydaXGxNqyLyN-j9s2FJA_1788883746
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15e6109f9aso401509666b.2
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2026 09:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788883746; x=1789488546; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3x7bWB9582wjHIO1v4KHpXP52Oa1CLx5XWxzNCr4lbo=;
        b=f1YI7wNGNBeigKNvUmoZNqpbsp/mXDx1L477yHUgP1FyCWuz/Lgc5tJs0ZNIENb5zU
         ljSim2vSIfR1zMs7iTPNhm4hCogB77iY9bWS+wflcWc0RGn9vsu47yYI3wecP8quT5w7
         ZtcOXrcwJ5w/vzEVC3eP6zPBMAiTHU8iteX4QDUhUA+o1+KRjPAo79CwPawS0QP5zF8U
         7K3Qcq0K3W/KBqD4AY4mS3GbA7lmenH94m2VJM6oM8spCLyBtU6CqORe7XOXsEtmQA9e
         P5jwN/U2DT76kyITnY92Nvi2JYMOmRD2HNSTl63NvIdS4qkdfMKugvN7WMIsLRHWSe9S
         iqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883746; x=1789488546;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3x7bWB9582wjHIO1v4KHpXP52Oa1CLx5XWxzNCr4lbo=;
        b=c9k0cMgJyATlvYCAB/s4s9/VaYydGyqZHk25O48gLUqECD3pbdgwkGN7zGshthVUu6
         ToGmo8hyXE1Au0PYxSNKBiZvTDjRL+KcWoPP0ifnOOMYZg5OXdi2tY8fsh9vkUjJ3adI
         Pc8ESn3w6doiNi0SFoM2YVzRmZg0hooEUCK3ug1p8Rjv46fOqEMW31XQLbao2muXLtg6
         yRf6sFuoXrPhCfQVUbz/tH7N3xLi6gm+OC6SqxGVpaik7Md7upYh8sjUoZXU+8ubpH/0
         sJf5k1VtL/mdWlKymt5RnKlvS7MSvbwIzNEo5rfV6Ui0Nh83dDiVwL8LpqbiKAkQz3RG
         GInw==
X-Gm-Message-State: AFuF++lcRPWVjDol8VOJI0L9n3871Q9/Q5moH33fBgveiDAo28LCo5kv
	ti8oFPK8OLjGK8JfHbQnu5VYV9bxPgYFEozZjFJ67vO7orO+Bohmd5aFlz25YFyreXPyRi1LpQi
	Cwfy5fW3jUoHQH7Zhnc4SAWHJl95yJ36r7Bcuok5ztL3AtNEbOCAnmO5AUjngL7azqQ==
X-Gm-Gg: AYBFou2VNadFzPJZp/VhhRW7l46n8kl6UnszahRXvwCNMgqHM0n2JBc85Uy9F+vqLvx
	bh7h+FU81bPWamLe2stQlMCsShCtr8bn0328RBcJvqmH00NUpAwljmbZD4xF4K/lMe9t6aCWqWP
	C6SAhrgS+aYlGw076HnHJvDXV1d8fmHnjz5SOuBGwWRuS1/iou2DzL3IasBklDh5iKDkeILapxV
	Nmf7pymOL6rsZoB4tgCrdNTBBiuC/g1ToZ0v8suzW+A5RrrYfbZhvtUfrzPVOd17kUtKwen9aw4
	HkVT+k54oQi4mZ+1y7d1MrxMMJbqfESnx4WCP/yFUpcVPf7fO/doS3S6PtvD2ujxrSkhqleiPQ=
	=
X-Received: by 2002:a17:907:c0f:b0:c25:9102:ee with SMTP id a640c23a62f3a-c260c65bc82mr1163391466b.3.1788883746086;
        Tue, 08 Sep 2026 09:09:06 -0700 (PDT)
X-Received: by 2002:a17:907:c0f:b0:c25:9102:ee with SMTP id a640c23a62f3a-c260c65bc82mr1163390266b.3.1788883745663;
        Tue, 08 Sep 2026 09:09:05 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ac2b4cdsm35817738f8f.16.2026.09.08.09.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 09:09:04 -0700 (PDT)
Message-ID: <2fcf19b9-d049-43c8-900a-082377e30edc@redhat.com>
Date: Tue, 8 Sep 2026 18:09:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: qat - fix active_devs leak on crypto alg
 registration failure
To: Ahsan Atta <ahsan.atta@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20260908121013.697443-1-ahsan.atta@intel.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260908121013.697443-1-ahsan.atta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 14.10, Ahsan Atta wrote:
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
> error paths of both register helpers. While at it, propagate the error
> code returned by the register helpers instead of a blanket -EFAULT.
> 
> Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> Changes in v2:
> - adf_dev_start(): propagate the error code returned by qat_algs_register()
>    and qat_asym_algs_register() instead of returning a blanket -EFAULT.
> 
>   .../crypto/intel/qat/qat_common/adf_init.c    | 24 ++++++++++++-----
>   .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
>   .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
>   3 files changed, 45 insertions(+), 20 deletions(-)
Reviewed-by: Thomas Huth <thuth@redhat.com>

