Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD3F2E175F
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 04:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774068256; cv=none; b=KsjTlPCjDCqlnQkM7aP5U49U5NczG73UsUh28mx5GyYGSg75EDlU6EZYULFV0jmNpjqi6YAxvMdz27iCKvTL+HeoDSOXzKBSLLIQWTbpAGHg1L10/INTAsmLcUCAW7hD0BHl2vs0DHVUtsYDvqOp29hfPV3etNMkcBujOR5OVa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774068256; c=relaxed/simple;
	bh=Bwqr5bQvT2QVLBZS5BmRUn0DZsUeaSqSykbvXA/p2vI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3bIz5SIsl4wrBZQxOd+1hyYEp++kdtOHDylyBOi0fIPq5Utb+JyzuDHSNQ1beZ5DI+pn0wq6kkV8mdNEaz5bjcsNQcw8IcoKxFS3d5FicipzaqSGzAzYvvSu3UIYeE9/tCduMd237BuuhSPnlO9mMvD6ep0TJ7Z/AYN44QUMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0QfTxI9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0QfTxI9"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82a646c96bdso1917526b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 21:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774068254; x=1774673054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lxnRdiDpSSBZYjdW0jVsW/gXZ4/lhIs//xte0OaizbU=;
        b=c0QfTxI94tIOASH3Y7LktIhDFa+kc6mgL5BHBWPnYA6UySZKQMZI2qDgPeaTzDLKBS
         jlNdh3vn3faLzsveCUXi8VeNw7Kb887a3Nk3byR0xXrp9c4wIzY/tBn0GAWFatsN/ac+
         iBvWo/Sw8Ga6cc8kkckNzWOcPCuS83tCLhB44wlo79nxrqXpKeMzdiNtsZWO46uB+GMW
         6qpWP3d/ZI1SSBAx2IQQVD1Nx4otHe6JjpkS4yaR5sUYfbzVjeDIHgjt5JV3GKJWbV9r
         9rasYw5QWUiXYHGMmY1TvY8F6xsOVr28JUPaLXR6uZb578l9IAWIAnHFGzHDIdC+ZdJU
         iTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774068254; x=1774673054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lxnRdiDpSSBZYjdW0jVsW/gXZ4/lhIs//xte0OaizbU=;
        b=H16zDjJxxDgPYNI8Ep7xvE//Jd4zxj5SfF/+ZaI7CiBqmasIxV6rU72oOpCxGha+I8
         0wMiujbABrA3Bolpdj2i64BQnq6SyGjUL8fX1x4B3gRRmxHoW6YW2kWUfu4f9FkxKCUX
         bkb+OLVnKAM/6SMyAoDYXXxZ29oW4nq/eg2hhWYaQjNYwNnsb2z8Zenvqs1Bqd8+wZln
         XDAMyKJtQtKJzP3BnqIYPAIRRqYswpGgoca5bG10v5Go3wBa+aCA826zcuP0rV4UuZjo
         zE5NI9Sx3LA7D4RtMZHmiEMKBmC/+06w52F3G07bqgylN8G7nqKPVtIK65uagnwqAPvg
         w+HA==
X-Forwarded-Encrypted: i=1; AJvYcCXUNRz535yWCygpq7+C75J1zPtd/eY7KBrgx71yMFo/MfTf0pk0sSNC5l7ITxvc4Rv2tuFQBx3sR83kzfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSKc7UnczYyNCv4SFldOTqWA4WHU8DsuAt26X+JzkDgZXLlJmu
	omQUvBhcZQopPziLbLXYpuvAW/MWijuSmBrLbGnjPwUhK1M9VB9WCW42
X-Gm-Gg: ATEYQzw+C1UDbrNI9uTOzekhTOhkKMqPYHKU48/JLMdvk+/+Dj1U7DTKsaA579voy7s
	3pqbr+eX68cM/QkBWqTqei4+5YW9ULkFHjzZWIg+UfxdxzpPla9/6qK0zk+iRW9qq79H4Va7KOc
	wSy24ATtpa3TFpauGN2fIDt2y8rQyFedwuTfvf36ZdpGhesAvTi1whuiu6kwssuFt7vrCdRU4Ih
	vk9pSd/IYt1eRwni8AbTA4WGp02Ll6xp78CO2v8WdQlFj7wb03G9+9V/eYCnfklBslMz0xmwiX8
	vVzrLSVwmqHqTeOKZ4dOCem0dn67HXu/mbz0YwwY8xlIcKithc3bPvSDYaV653x0AhNccV26wHv
	yNkTgzjbElnfcrPOs6gOt0juPXRSZ69juzVV5vAkGGMRFfmUHXMp+G4k6Qq3gXcMuvpGc7gtcfA
	wkeyAnZlmaluBqdcSxutpgfzB6+t2Ss4g=
X-Received: by 2002:a05:6a00:2eaa:b0:829:793f:da6c with SMTP id d2e1a72fcca58-82a8c3003f9mr4384350b3a.39.1774068253994;
        Fri, 20 Mar 2026 21:44:13 -0700 (PDT)
Received: from [192.168.0.106] ([103.216.213.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0410b1bdsm4344941b3a.57.2026.03.20.21.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 21:44:13 -0700 (PDT)
Message-ID: <e89054b1-5549-4fe6-be0b-a55cc5b185ed@gmail.com>
Date: Sat, 21 Mar 2026 10:14:08 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Crypto : qat: Replace scnprintf with sysfs_emit function
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260320-sysfs-v1-1-91fd5ef42dea@gmail.com>
 <ab232/oVbFU/+7Pd@gcabiddu-mobl.ger.corp.intel.com>
Content-Language: en-US
From: Atharv Dubey <atharvd440@gmail.com>
In-Reply-To: <ab232/oVbFU/+7Pd@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sure, I will send a v2 of the patch.

Regards,
Atharv

On 3/21/26 02:40, Giovanni Cabiddu wrote:
> Thanks.
>
> Can you re-submit with the headline below?
>
>      crypto: qat - replace scnprintf() with sysfs_emit()
>
> On Fri, Mar 20, 2026 at 11:49:28PM +0530, Atharv Dubey wrote:
>> Replace 3 sysfs functions in the Intel Qat Driver
>> to use sysfs_emit() instead of scnprintf.
> nit. scnprintf().
>> - erros_correctable_show(): Replace scnprint() with sysfs_emit()
>> - errors_nonfatal_show(): Replace scnprint() with sysfs_emit()
>> - errors_fatal_show(): Replace scnprint() with sysfs_emit()
>>
>> This change is in accordance with Documentation/filesystems/sysfs.rst,
>> which recommends using sysfs_emit/sysfs_emit_at in all sysfs show()
>> callbacks for buffer safety, clarity, and consistency.
>>
>> Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
>> ---
>>   drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
> Apart from the commit message, it looks fine.
>
> Thanks,
>
