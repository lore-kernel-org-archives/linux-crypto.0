Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8202AF1D
	for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 11:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735040729; cv=none; b=Y+9M7SyXPZSSfjVwzbRs322OZOtGCnHtiexDm/QwmAkBxkV3ji//DQdWUrzgoqeomO5+Nqat1y22L15/WpGZJKRaMumCW0vN+TPkZVhBwT93UVeFzGLooTz5pebdIxEbJp6dYlcLsBkpB9DzO6XMWTQOsOyNvtvTeccfq+UPvAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735040729; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tDve0JINstMvHNxhBxyHpRdRZV0uQj2s/QnUGZVKMBUwCeREhAurBvO2R3+gyNhJMgyzccQG5OSyOgh80D5vUWX3qJRFUilNlJ/bkBwTkc3j8DCeuMjhrM719NfrqhatRlQhQ7gdy+sW6+p3VPzc1lgJY8//HaFB0qsDs30dXnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-432d86a3085so33154275e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 03:45:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735040726; x=1735645526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=bQcVfzar20PVPbX3/lhIcO3zYRukJmA4ySJcDzroYKUNdHVyg0DHs7MjT5dBx8jw2+
         c6WTgZPF5gixjFJSnisi3o26wJUnrBLG/xG+5/GJ2YzRP4nINrygfBAbb0bGC+A8RZ5v
         08FXRvpwMIaI5YXryUKcirg4SAIB2XoDyfuvbeQ0Cf6/NWhlE921RzrS6FOoykn4O7Cp
         ynThPwtHPrFKBO5nAoC5VieSHOQS+fjiDahbQQRsWl/g2tVCovN2F28soYoXCnp0H7op
         qygIH1Xl51+8mKwpXDxE9igsG2Hyjyiw2n/AfHldMVaakBBzPN8CVxbvhSNR0bHGsDRG
         5Fww==
X-Forwarded-Encrypted: i=1; AJvYcCXiwm3Be4K15hgJQpKPewf9+H3tcjh+WqLHZO6hhKCZPsUZK/MYKDnrxogJ4ZPnH1XKydqutrulpYf7ie8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuN+wK1n4RKUXLOWJoqslC8xJWFlQ/lrD0FFmyqAT2Gi9R/Ejk
	hy1QyohdWDajv2pBnj+S8/zPKUOHXHT6Dl5oMf3OjQdfyftvTCSo
X-Gm-Gg: ASbGncsuFFyYxhXFZ8HrUirva3KAy7WYZaZH2Br4a3cXTN9X4ehX5OIfNFjSKlKY8eX
	DDV/AD9LM1DOPXiOtv9Ayd+z1EiVwNZAu/2s71vhuw0FOh2rmtCHELwRiJemD5aKjjrD208F4xS
	6oFhkcyZJqBHZoVq1qAh47dW1UXLwWCO0pSfga3T2+XNH4NHuOlhbta49nlBK3lEpMSJXE8FcQa
	7b/9B9kE98PaWe768AkqgbpIq+23cpWpBrnEjgsmJP99qaPhkXSukH/zvhXV7rLz0zjPOINv8Jy
	mJQX5gdXi2kMimSam/H6Qu0=
X-Google-Smtp-Source: AGHT+IGjTXQdPg0fSv0+ap6PO/q4p+AqDO6lV20nFhqhSwkDoRnneYsYeuNvKM8j47Y+SVeRnp0Ydw==
X-Received: by 2002:a05:600c:1c0b:b0:436:1ac2:1ad2 with SMTP id 5b1f17b1804b1-436686469d0mr139293505e9.19.1735040725769;
        Tue, 24 Dec 2024 03:45:25 -0800 (PST)
Received: from [10.50.4.206] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8472b3sm13924121f8f.58.2024.12.24.03.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:45:25 -0800 (PST)
Message-ID: <fce9c164-ae98-415c-ac1a-4ac9d7b9cd18@grimberg.me>
Date: Tue, 24 Dec 2024 13:45:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] nvme-tcp: request secure channel concatenation
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-9-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241203110238.128630-9-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
