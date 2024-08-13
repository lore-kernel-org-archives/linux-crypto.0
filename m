Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B536B1C287
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 19:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723578429; cv=none; b=B/joqbswvz20dToPc+JEksvejiV0MfyLWvgx5b+K7PPFIYS3u8S1Z+nrNAoLgE7g5AhxTJay6ilDREhobsDPbgPHElUyEBD8TwUP9uLuygDKoVAATB+Obt9p5o27kjiqv+9Z7/SAVN5Yj0Ewah6nEjHpMEg8hbKlfVGh1F03CoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723578429; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hL5VK78ZWbfrXBFdMZYfTyckhUtdswfY6UFzPW4F9F/18SFGHUQsXVCePMf3/apmO8IB8h9e4X5uys9kE8qtSQ5hRjErKZUy8/itWFPQC1+R96qWq2aYfCkTnhCDkEJy+mGZ1fs3QEyTYOHZI5iUaDGbnV5Q0tbgEzReRwEAkbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4281e715904so6906965e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 12:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723578426; x=1724183226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=dbFpCJodVTgup6u2cK5Gb/9W7UyMyTltT8MoKXvf6kefRhxp2WUg+Q9pqMOXKCB+s8
         bRy4cJKsfuVifFBX7khbc0SRPk+1xQkyAwBwAO2hZMHJ3CxvLwKN0lxSaYUe1Z+GEt60
         pYjxY6JaJOP7cUoyTj7O685V91+sHjosUyUCgtp+4DVgVKMrr6BbNvCNbfe0LVqjYnou
         F93UpSISybrEmfJcR04Es/XcuOwvaZlP69+33aM27Muy+skXaWL5lyDOzOmKEhSeKR3O
         tzZO2z8UH3rKznMl1BGCDyyWaiO7DOl8GLbWE/nNFxf7RTrFFyey3j1YF/Y9D7H3nD9K
         TS8A==
X-Forwarded-Encrypted: i=1; AJvYcCV8cpdDlYlsYdMCAbLlt8XVD50zEN6kpeB2YFVTKJSoX1FwBuJnRLuC+4WwYKGKXK/sR7B7izUU7PMjUhD/RCsz5IKTZM4DXuIEiEev
X-Gm-Message-State: AOJu0YyERgPvH0mn1UENt0lPoFgtG76m61pk5lV0fiKHUDZAKhw+SJHQ
	GnviZ++0/Xmbr1lHbdpSL74XY/xu9EjGO/dE9MJL8MFCiu6aQGLA
X-Google-Smtp-Source: AGHT+IEOkM8UusNgFt3Ow+DJBfNIYzlBzvrLvR8A1vO6j2H2y+TrcvSIOkJamB8rdBfNFEXw4LvO6Q==
X-Received: by 2002:a05:600c:3b88:b0:425:73b8:cc5d with SMTP id 5b1f17b1804b1-429dd31fc89mr2093265e9.1.1723578425794;
        Tue, 13 Aug 2024 12:47:05 -0700 (PDT)
Received: from [10.100.102.74] ([95.35.173.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429dea45445sm14165e9.6.2024.08.13.12.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 12:47:05 -0700 (PDT)
Message-ID: <a41d4e6e-84b5-4fd3-a220-4d9db859626d@grimberg.me>
Date: Tue, 13 Aug 2024 22:47:04 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] nvmet: add tls_concat and tls_key debugfs entries
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-10-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240813111512.135634-10-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
