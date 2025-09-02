Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E42E7F17;
	Tue,  2 Sep 2025 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756801399; cv=none; b=FJD2K2MyJztgiesngf/x+XZqdvnPH0YXA5J9y+TfuBvXJArKNmVacSjVVHvowu+pGxSJJS4q+sG3Z+1g3or8PQ1o2gOXL5THlSwAKGGykOkrMiTGcAzxCKgmVtjdNCRJktQ9FFWqQuRm0alakm7fkz/Loa5txLJOKpXIYOSd0OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756801399; c=relaxed/simple;
	bh=5NFNRe/Gmt1676vKMgaqLTj18M4jFRkBjsyRt48xLI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ls47zFpg6JzwX0TP1l0uAkYLYzf6ERNLPth+ut819NbCRkXvmM4o5/S61kukAHTCW7Ht+spP+KDhVePkMdXcPbt4I66mrgY4msv1EyaSZawVH1flkwx+VaXu7mlmw1wMP0qedi6Z5Ton5Ng02Ch5OU48Bqd/qJaTd/Fl7oBeYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MT+4QeMQ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MT+4QeMQ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so20963005e9.0;
        Tue, 02 Sep 2025 01:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756801396; x=1757406196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZcBNVGNlq8zOfYcQ3WD1GYe89jtbvhCgJlY40nKWISY=;
        b=MT+4QeMQg4gcr484ccDsOSs5FoO41/Mdif3wqHY71vp0VEDLac5YSA3g4oT9aZj/lM
         3sQhK0G8dDhcNmAzoI1ldcx84wMkt5ZkBMt9yiX/9D7PzKgHwP1vmlXKRPTIIlsmK55i
         LCWeG8voZe+lLxh/VhDvyyLGboz6aWqpNYD1vMLhmPv7HfKxpTnGsW1qyJXfPyJIi06j
         VxhCtnCgU7OUyCeXE5KkPBtuj3BhVV0nTT+sNtwfrVcQPiERkCEHdU6qSHCZZa6//x3O
         DgNk7+b3pH1adbgLL4N0smfZaRhiGIsgHk17nCuMMLnZ++UgEp/GNAIHxAwVoI3i7UfI
         sOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801396; x=1757406196;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcBNVGNlq8zOfYcQ3WD1GYe89jtbvhCgJlY40nKWISY=;
        b=IyiUKlj2BdaKdm9Av+akXy8mRLZWSIePzN6Venq7pTeovrEruy1nNWSN8DmSdtmMBK
         Wk6bagBJPLDGfUI3FQyEqgRZjgSjX3Rswtiz3tUcbwhJ3aWiH82gn8UCFWLr8CtcvXx+
         lM1ajlpcWtRwucdk5fx5qYENTPwiJbs+6cW4ISBAcPluz68JS5poAMEhsJICNCmFvArI
         L7oewVmKy2XMOEBFMAaIXrVzC5FIMs8uLAQSq9HEOzqcBM3ffsmNR174aOCWjjp12+13
         YuJveVpoabzeMU7jnN28ch4Fzkk2VTiwpcoeyv65AkdvJa5kobahSOaSDhDkNq0HryZA
         oDdQ==
X-Forwarded-Encrypted: i=1; AJvYcCX37poeyq/EHVAuJb3Gi4V0tb7TrDjteBGRmXyi6ZLsfZH+V6gDt7LmpDR04OIM1I4EdglUC89QwqOQgoI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9rcofpZzwtN8lpZUKRWUs+H3w3Hickqbi3dZ1MZT3vIBbfasN
	U0hRVv6McuMq6uwyh8oTOkH8dusMngKwNQ7Q1Ug5yZMMa3YUUpRlW4kU
X-Gm-Gg: ASbGncuHgJbZ/t/DOJW5wjNimoCsONOYdLPvV1xUwDjfixVdYEmk1ekYRIXniG7pmhE
	z2v/4Avn444q934pkg+LYCo82nbYgrsdLa7IZz5ALPMh1NbO/WcGy5XC8Ga8a0hbJdd4qxL4YXf
	Vo0Bwr903F5LcPVN3leomSQX/9U/d5V/+U/IxhAG3r7o+DLTfzpwSCSOvkAMbs3ZNd8rC1LCpQf
	zpN9KkHf5lB6+MS9SnAV28E45KaNgnRwKHZPYdEc1G/n/BfrxAYgXWkD+q0Vyc2o0GcDEg+0P5D
	DS5TFxPcaptrqPYCrbATZ63dyA7uw2YIQM2FyuJcS8oFVguSOUMbnZYY3UJ5CphYN6+/u87B15v
	l6JcpF+FRTZMD+wSSjQIqA6ZiAKwi8xQQ/17AFZ3rVjnoUdqMbVCXztfMgVQJ7jXG7/FbsJZJzx
	8et8u0hb4qeNbignI=
X-Google-Smtp-Source: AGHT+IET7dm5cPsdd/R1TFjz5Gw1szA05Yk52hQ3K5jEMdARsMYJw5vs/XgDdfywfE2Z+CiQ9+2Ccg==
X-Received: by 2002:a05:600c:3b11:b0:45b:8436:1bf7 with SMTP id 5b1f17b1804b1-45b8554d659mr95012775e9.9.1756801395472;
        Tue, 02 Sep 2025 01:23:15 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c207:b600:978:f6fa:583e:b091? ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66bbcf19sm161655755e9.4.2025.09.02.01.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:23:15 -0700 (PDT)
Message-ID: <62ea21e5-d1b4-4c86-b836-219a966f9f81@gmail.com>
Date: Tue, 2 Sep 2025 11:23:13 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: sha1 - Implement export_core() and
 import_core()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20250901165013.48649-1-ebiggers@kernel.org>
 <20250901165013.48649-2-ebiggers@kernel.org>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250901165013.48649-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/25 7:50 PM, Eric Biggers wrote:
> Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in
> API"), the recently-added export_core() and import_core() methods in
> struct shash_alg have effectively become mandatory (even though it is
> not tested or enforced), since legacy drivers that need a fallback
> depend on them.  Make crypto/sha1.c compatible with these legacy drivers
> by adding export_core() and import_core() methods to it.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
> Fixes: b10a74abcfc5 ("crypto: sha1 - Use same state format as legacy drivers")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Tested-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

Thanks,
Ovidiu
