Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41473D7D8B
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777899525; cv=none; b=VhriP31GVo0nOmp500YMyTwO+a6X+PkJiX3bz8YC+/2/ju68EmHo4bdpPttIwSzzNqe6DRzvjWQ1OSgZiIAWliN8V1/Zhzg23jQ30xJmZlumLG53dFMrbIsEm41kWpen45ubc/Y+0VOv+SvF54NPnTOHuDlnVHClwWz33KZd/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777899525; c=relaxed/simple;
	bh=NmoK00K18ee0KWR0BRNW6Sy1q35LGoXy6wYg8Lac6Ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PddRpRWJGlXTYI+t0Q2eXXJhDql1aQn1636QojDNnSQuOT04QCbyS7EGqB4fkY8uaWO/AG7WMPTZrRpl/i8BPkSB2kdXWLFcnj6bLllvxH/QFCiY7MjFB4a1EQhAp6hwDhPT8NuFCtEl+X2JwcedZIR054NH73VYiK4pEmjSjGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGxgXcMF; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGxgXcMF"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8f231f3b130so277904785a.3
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 05:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777899523; x=1778504323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ypd1QBD8IL5nEI5wKW5JxIvcEM/x3rJY8yhwAEDZ758=;
        b=jGxgXcMFQYkTOXfAZCzIdJyr2IXdpGEw92l5CjA9XZNUnMhxhXH/LYIPsmMOl2FYhl
         X7CgKOkL3SKD/83wujPXWnPASXjH0uFdb+SDexSlkXLswQiJFe8kzjjYAhd9UdK3ptxq
         H2x/bX+WAxMkh0AGMpEYK/v+8L2NO/NIEeUAV5WYvFtJThvZh6Tw+dUQEgCS92ismGws
         a6XriNoomevi8IIYK3rpMwysiky28dnzQZC8hm80kuO8cJ2WG0MqgvLcGJqdO3+/PN/i
         XBf2p4yUMwEygnaB23AU5PMkqXQlOjGFnn7a/tpExw3e507jE+WW4wB3B4fA/VBpTtLx
         PFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899523; x=1778504323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ypd1QBD8IL5nEI5wKW5JxIvcEM/x3rJY8yhwAEDZ758=;
        b=Jbg6kPDN3+iiNnpvSxTcemwGbgHZd/NvlS4FCueam4YumROATQTlmNQF6y7ev5XfJj
         I4Hznxh7He3ZXX+DrZdLoMHepegaI/Z0A/oaG/nMjNfKlIrWrs9bGIVcoOvYeih9JO7J
         eDSSnnx0uZpXqFzl/6gqfoX/k8H6168RdoulwX5hM77BRdoI2pZbiGzP8sKA9mKwqfjr
         tyTbVIgQ30/CPgz9dJQUsvi0j8XoDrCDPRtVTBFDqj+xf4B5GhgZTKmlNAcwQmuGLbVX
         H5/wR1JbLhBujE+EAtIe61o4MFDoBq4WuENbsb8B87Bi2/tKCcZ7+4qS6UyCb1KtIYhd
         Gqkg==
X-Gm-Message-State: AOJu0Yx2U2l4wDyaoCr/dH2AX4LAa39wabIS/c4Isot42B64vDMOlBfW
	OJcXzFTQvJxvStnC2FJLKIxQzq97y2NKsdC45kbZ5JMqP8k+caHOLnop
X-Gm-Gg: AeBDievr1cdD1Jrtbkomebg1XJ4S1kvTnU4w4TgooeuXkVL/dp+Gjmc7ncsqvP2pXUy
	2/W70Mo96Dc+8DUeszmYhiSfA8otPyL9CtLTH3+8qVxWO9BTFpJT/FPJ2jXXdsxJ4welOJAw3Wo
	AqJLX3Vh1Q5OzzN5axxj0c2Sp9fW/Pd6vInNjP789/JXOcnqVBp/RP9wccpS5nGdJJowkLhjFFX
	REOMRucQPZ5caf0QgS8BZH9mEG7Y65IDbNlpII5N5TdVHJYMzQtey+JGZNkL69aN94FQhZjHqJm
	+sTHRemimqUJi57LqnetJ4JIYgcUmfIgPtYV/tUFwAh3Cb215vYcFPfxttyEyiTTZbmTbgva2cz
	cOz9OPzKwAdoDYgAJRWIP/SC5SPFHKd0QC4p+fUs6bgJQqVynshU+xhJWulPmemSRMb6zZRusXi
	8eiZo3iYIHyAtLg0EejbXVycMeJKMbON7dUIWdAl1CEm0kWTdfTh4Xpp4j0TRsBlo8pGNNDAtrg
	a9BAh4=
X-Received: by 2002:a05:620a:4010:b0:8ed:c0bf:2c24 with SMTP id af79cd13be357-8fd19122e53mr1413514585a.62.1777899522542;
        Mon, 04 May 2026 05:58:42 -0700 (PDT)
Received: from [10.100.121.202] ([152.193.78.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91cd7dsm1031615585a.37.2026.05.04.05.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 05:58:42 -0700 (PDT)
Message-ID: <bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com>
Date: Mon, 4 May 2026 05:58:39 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Complete list of AF_ALG algorithms used by iwd
To: Eric Biggers <ebiggers@kernel.org>, iwd@lists.linux.dev,
 Marcel Holtmann <marcel@holtmann.org>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260504045007.GA2289@sol>
Content-Language: en-US
From: James Prestwood <prestwoj@gmail.com>
In-Reply-To: <20260504045007.GA2289@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 5/3/26 9:50 PM, Eric Biggers wrote:
> With AF_ALG being on its way out due to its frequent vulnerabilities,
> iwd will need to be fixed to follow the standard practice of using
> userspace crypto code (for example, libcrypto) instead.  In the mean
> time, AF_ALG is at least going to need to be hardened by removing
> unnecessary functionality, for example unnecessary algorithms.
>
> Based on the iwd and libell source code, it appears iwd is relying on
> the following algorithm names from AF_ALG.  Please confirm that this
> list is correct and that these are the ones we need to keep for iwd:
>
>      cmac(aes)
>      hmac(md5)
>      hmac(sha1)
>      hmac(sha224)
>      hmac(sha256)
>      hmac(sha384)
>      hmac(sha512)
>      md4
>      md5
>      sha1
>      sha224
>      sha256
>      sha384
>      sha512
>      ecb(aes)
>      cbc(aes)
>      ctr(aes)
>      ecb(des)
>      cbc(des)
>      cbc(des3_ede)

This looks correct from IWD's standpoint, but ELL does support 
additional checksums:

- sha3-224
- sha3-256
- sha3-384
- sha3-512
- hmac(sha3-224)
- hmac(sha3-256)
- hmac(sha3-384)
- hmac(sha3-512)

Marcel may be able to comment on what projects are using these, if any.

>
> Also, does iwd always hold CAP_NET_ADMIN?  We're also considering adding
> a privilege check to AF_ALG.  (It's TBD whether it would be
> unconditional or controlled by a sysctl.)

Yes we require CAP_NET_ADMIN:

https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/iwd.service.in#n15


Thanks,

James

>
> - Eric
