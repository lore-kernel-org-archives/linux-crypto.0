Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677592EAD16;
	Tue,  2 Sep 2025 08:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756802201; cv=none; b=R9rMB2UDVdBjAvBVDcwd+OmBwkqnJizQ/6eqdNpSLnBBx5l6BVvFDWQ4i8uP+iR1hwQxZZhjecpNjMIA3GScrd8iOXnQd2WDwTkgshND7/0szWvt3FJvusx2OhnZfduGEy/iZI3x2d6ykKAf51bVOpIfmdF3xbW7xv0TL/LfsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756802201; c=relaxed/simple;
	bh=Ub+UvkB9betFxoCuZ51G0L+ar17mRVAqrJJNS3Uh67w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Czdp1INGXUUuWmLGoHaLL41bXAFO0HHK2HzvsfihNOzTlbzI2HVBob3rGH15msLWeqjzNJplQKA4s85vd45Zqpv60++Tcjszn9l+cHQd4Tg6pPsJDdWaXdH4BKj1myPTveWyK83C1/pUeQU7fUpN7Rw9n10lQR9XNaqu17A1rWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhUVE8Je; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhUVE8Je"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b627ea685so43424525e9.1;
        Tue, 02 Sep 2025 01:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756802198; x=1757406998; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pd0HNMyoa7GX2rFqQ+9Q5g/is+Fz+zmtx6GmLNHbP0k=;
        b=DhUVE8Jegp77DUwJ2DElbjHxcE6F42Td6qnxMM0DFQm7ZayWwAoBtxvn6PoVTP+7p3
         yH5yN1IYLr5/Cn/qhyXeXvXc7QXoCl1+PnXx6ghE56eMITj3qEqGGFtmpMNSu5kDD8uZ
         weKK9wFZxX6hwSg6xwXMbrddiX3sl4edZFgDE96dhaf/JpQFu3sKXV25qvv7NvEXCgBL
         oE85sqKL7cVIpJbLZtKc0exVPM4ychkcYdpRuNwFrIZ4Qdn3vBVwGUd2QVXWKi2rUYUH
         yRv7cPbhfMbiUJmcSZOdkrkpFozd48Wgb5YIGK7QHGpkHvrkAvlTmIM7ALye2UgQBSqP
         D4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802198; x=1757406998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pd0HNMyoa7GX2rFqQ+9Q5g/is+Fz+zmtx6GmLNHbP0k=;
        b=jEcoLHk4L/68EHuqQtEqJtAOj/SIFlYaC2aWGdw41EAiy099jcrQEOe0jCV5KGOI3p
         ouqyOP6mA/qIvZNG7Hf1rkUEwKf9NWJ7Q9K2C7HGSFbNrU5Dslt6MhALqhEs7sastc/l
         huaNZkqjKZ6ol+dboZyM4zKmit3+YTUz9d6dxxO6T49NSSj9aJHno+usn/XpS4/wNDwv
         AdexElCdvGVVysBaoxOi4r5iWYqbsSwmdPw24fl65r7h3NmmgY2EFnicSm4LMT/TYXaQ
         RlOseHC2l7V9au0995QFsWGwQKcLZHpCoC7Xt17WMhwt6dYHBfPBj5MjGT0fu5znmEXM
         08/w==
X-Forwarded-Encrypted: i=1; AJvYcCXVPgOKDdN9dBvN52g1i5wiFE2gZd/IVbXiXProHAjHZ90RtunW94FEVHpG1b/tZ5O43e6H28wsZkisvQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykymnb0FJG0HGjKy1gffRnmaQJ1E/xUPTaXecfDPJ94QsimFNC
	uFClQrt0o+dfOd6VPw0/i6/KlrUB4fw2g4E3OYFIqn2fnOjVv9ua+voU
X-Gm-Gg: ASbGncvyJjY4eUpxCMrQBgYnXyXeNy6ps90mbfJNIZdxYNzbu59Ah5PRfawcSLrhcnf
	1r4SwuXgCg1GziilMJGxvLUHcVyq49q71ZwzQOnLu3Hmxs9tcNvVrlwApALejlJvXwMSYnEHfQs
	kFTmC9f6/JP/Tg9ID71IzUH4ZoBp49fHzo+ay87gISVMrgonnMdrg+PZ0eoviFyoeqkQd1fNcd1
	Mcv9cTXNXgpymrWlZ1Wpm+MGKIXEmkf/r7HdHqMPF1s+lBd6CulFcEi7UvNXpjAK/D0XxLajxzV
	nYs5bGUtGJ26afSIOIsxIHFyDIimFGrQf5FQ2uIc6OT/+kv7xXl0SjWY3KbJ9DO/83JY/IOFalc
	dHzZoByuN2dzzAl4AXDvUHzx4EoOzpGGmZm4guE7NCQIPqozZlmliQ3hY+nV8Mkqh5/mIygTaC0
	RFzTmRe+L9Taufh5FQj/6Py06rLg==
X-Google-Smtp-Source: AGHT+IFredUcE0J703UP17d/yQu6vaZQmOwLi0akdJ9z4SKK8eYSX+Xw5FrpRNpvS8MeSaTTMfCMZQ==
X-Received: by 2002:a05:600c:4454:b0:459:dfde:3324 with SMTP id 5b1f17b1804b1-45b855b34f8mr79542435e9.29.1756802197404;
        Tue, 02 Sep 2025 01:36:37 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c207:b600:978:f6fa:583e:b091? ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e380b77sm193355795e9.11.2025.09.02.01.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:36:36 -0700 (PDT)
Message-ID: <ed2b6a23-4369-4b38-8ae1-7dd7fc763191@gmail.com>
Date: Tue, 2 Sep 2025 11:36:35 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] crypto: sha512 - Implement export_core() and
 import_core()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20250901165013.48649-1-ebiggers@kernel.org>
 <20250901165013.48649-4-ebiggers@kernel.org>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250901165013.48649-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/25 7:50 PM, Eric Biggers wrote:
> Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in
> API"), the recently-added export_core() and import_core() methods in
> struct shash_alg have effectively become mandatory (even though it is
> not tested or enforced), since legacy drivers that need a fallback
> depend on them.  Make crypto/sha512.c compatible with these legacy
> drivers by adding export_core() and import_core() methods to it.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
> Fixes: 4bc7f7b687a2 ("crypto: sha512 - Use same state format as legacy drivers")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Tested-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

Thanks,
Ovidiu

