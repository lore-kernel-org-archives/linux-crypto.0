Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FF296BDD
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 23:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757977627; cv=none; b=EqM6K60gKidfWglkc6xEJvtm6oLy5WNxSGRzdvT1Vx+QKE64TgNoqpQCRvYwrVcLx6lH1gjNq6lS2kNEqFYBe0BNT2VITvJwL5ltQWwzHF7u/g2ew4Bxcj3r4+VujwFZDV1tUrhpbNTMVtpZsTr45KauDSstNXwBgKM7MRKhkn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757977627; c=relaxed/simple;
	bh=excbcDwDxrEvuwHqwKVQbW2H0N+JOeSU0RhDz8Q5Z7I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=iIhTKQPAxodrvAysvpdXdgdqFei/t3rjvqZ0SkUktYtO5hyNERyEuYt1ejNN+0l0sO89xtNJN5ASnjehPPYKaQngXeH9pHjjVOReB9A6PwRxglMeskiebfM3RSesGOC/O3hQhfmiAKNNY1n27WZOWJUsb1gOexY2/FC4ZVvbMiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32e741a51fcso234056a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 16:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977625; x=1758582425;
        h=content-transfer-encoding:organization:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tG2/pl1HRKUlyAsj9zDa+uGnIDTNYDArMaYIOnk47U=;
        b=H22J0C6HNJoqPTO+XgLdrYPYJMhV9VjXPhIGOKUDfEmlmjIASj0+NZZKxI9Gw+eIbH
         6QdvOVRueMWnNwsgXsRHWZrpIBAQ8V7JfJdbIAICoLZGiRZn/c20gx8v9X2C3QxrOBvA
         pCK6sIJH/pPtQZs6KV9oSnlwxn14WVFokvyoucHykIR1URMiKjcHGKv6BPy0xRo3UA08
         GA7Rwtou69h5MhB7pF8NZA9UB5W6qvwovlyxiy9yzS9hG1Nuk00J/fwkwM0elZRZdbPF
         epBPqDHE200+E248REz48Uy3lbA+MWmek7p/i5NXjLlnP6JongUtjR8a7/77eU6kmjJX
         xUqw==
X-Forwarded-Encrypted: i=1; AJvYcCU3l7eqb88cBb7Rn5+yLljRStZQwxyVhpV2RlqADZabcIkQj0Q7EyT0wufsYAZb2BpuKozRsESmpdjd88Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLPLHFqOz6vfeE6wTj/LXmWOfjUAyFLSZvTQ04rsKMytC0jDhn
	TVZlAw52rXJkNT6bLMWxcO7+V10tGZqugAEm9/ZQbFgkDumecmGOzWgB
X-Gm-Gg: ASbGncuRZOaQg2wrz5ucRh23trDz6hGH/UIe/61tCnuP/Kg85xRRwLfgnScfWm6UScp
	n6MNtnrLChmgNS6rHAuSawPHjMNFU/rCSwDHM7/Ukh9UvkNn/17c31kqzKcnwve8JburN4U2z8l
	uivGhVI+aMCxPcSIGOmwS59cDiD5tH+AnkfSghdQL9t5r10POqcmx68H8Dx9F4tsgMQp34vGJhC
	xsrvQ0acggzHlBe8+V4DnNZa4cAjOd5UuLn9k/gUxTA950A2lWljHaP3WqJOA59jRIw5WXH0lld
	3pyVRh+AmHPdQRB7RuSu3Is4YcMHcrNAS8BxaV0n+kVhV15+p6765jdh7n/ajqTTMFSRicjAOnI
	hMZ9CMtJi7Bjk6A7D/7sXXbj+eVidQEAcOOZkiXfXeaDuPV0JZNjJHUzpEKH2DZsogh/3iQDrOs
	0JJbujjfgnK47VtTX1KZX/gQe9RcFU
X-Google-Smtp-Source: AGHT+IGbqBJF/id9+qYtY3KsiDNgt+EfjytBm4qa0ZzMz3igOef+VrgCD1CGjFg5iy6cetqBPVxKGA==
X-Received: by 2002:a05:6a20:914c:b0:251:31a0:9e70 with SMTP id adf61e73a8af0-2602cb012a7mr10124077637.7.1757977625339;
        Mon, 15 Sep 2025 16:07:05 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54b169f2edsm9504128a12.19.2025.09.15.16.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 16:07:05 -0700 (PDT)
Message-ID: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
Date: Tue, 16 Sep 2025 08:07:02 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Yunseong Kim <ysk@kzalloc.com>
Subject: [RFC] ksmbd: Deprecate MD5 support and enhance AES-GCM for SMB 3.1.1
 compliance
Organization: kzalloc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

I'm looking into contributing to the ksmbd crypto module, specifically
around crypto handling in crypto_ctx.c. I wanted to send this RFC to gauge
interest and get feedback before preparing patches.

First, regarding MD5 support: The current code includes HMAC-MD5
(via crypto_alloc_shash("hmac(md5)")) which appears to be for legacy SMB1
compatibility. SMB1 is widely deprecated due to security issues, and MD5
itself is vulnerable to collision attacks, making it unsuitable for modern
use. I propose deprecating or removing this support entirely, perhaps with
a config option (e.g., CONFIG_KSMBD_LEGACY_SMB1) for those who absolutely
need it, but defaulting to off. This would align ksmbd with security best
practices, similar to how Windows has disabled SMB1 by default.

Second, for SMB 3.1.1 compliance: The code already supports AES-GCM via
crypto_alloc_aead("gcm(aes)"), but to fully adhere to the spec (MS-SMB2),
we should explicitly handle AES-128-GCM as the default cipher, with
AES-256-GCM as an optional stronger variant. AES-256-GCM isn't mandatory
but is recommended for higher security (e.g., in Windows Server 2022+).

This would involve:
 - Adding key length checks and setkey logic in the caller side
   (e.g., negotiate or session setup).
 - Updating the negotiate context to include cipher selection
   (0x0001 for AES-128-GCM, 0x0002 for AES-256-GCM).
 - Potentially separating signing (AES-CMAC) from encryption ciphers for
   clarity.

Is this direction worth pursuing? I'd like to prepare patches for review
if there's consensus. Any thoughts on priorities, potential pitfalls, or
related work in progress?

Thanks for your time.

Yunseong
