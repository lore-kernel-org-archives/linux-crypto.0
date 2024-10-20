Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40038194C9E
	for <linux-crypto@vger.kernel.org>; Sun, 20 Oct 2024 21:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729458837; cv=none; b=WzuWd8JOFOsN6/O9TlTNjwzy2QOl1kD6B9P6nCMbCipBo1hSqq47J2A1CTuliTDUs5MqsXZuCSDtTcU/zTz0R1z4Y+dVVVAW0lvU4bQeqynrl9tbPNGbb0lq7eVM2ESMFMk1uijoqOsxiwYbGufHR8OuVBzp4b7gij+a1266GPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729458837; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6l2CN9oP4/ffPhuBVVVEIylcgitemSPh5kbe99cinhkXFVibmIkEVmSYuVD0XBgFql47XG3l6wJQmKwEq2Zduxsrr9nhZb4f01URWHNP8IHna0S/m1QHtToM68KDkFYdOPln/nWz/lSPuXzRDpnDZaS6CiRwXy4WZSwD27kJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d518f9abcso2724821f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Oct 2024 14:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729458833; x=1730063633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=rxyt38NEgLO2eCtYBnOGi00Yfa/wRzAUm04e6Od69LrjTJJbMHjtTb4duZVYyPcNtg
         a5l4j9PL6+IK1QhREFa9BKWBcURmLwUymQD/SU+vZOlt5dc1b8qTFKiWi3/RuiMa7mt+
         dbQKPBy4wuo90mK7Y+3CPFYisuiEv1s+ZkDzYenc9U9pYpZSyE93PuTLFuZt7IZR5EBG
         wo/022R89QhchyfDgozh61qWR4ovsW8sxD7u3iKOHW4A6cALJfZOX9N4V+B+XDwxCNI3
         Tl7yh0pEuOJeWMnlRoG0Y7/RcZzjDqkJg+B5DU0PKQzB3jp8lCZovPkUE3HCvCmQt3Ym
         Gm3g==
X-Forwarded-Encrypted: i=1; AJvYcCWi8jT2ONZWaCeU68F/3n4/eD9THeYiTXXHzL56DdBJvOdjmGpX9FJ1CijF62QwdS/YVYoaLNk4tk/eVv0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3o7fggSnwOkxdiK/EKd8EKjSm9wz4NbL/61UIj24ycv/kClju
	m4RyLuxZY0Vn3dEulsLjEr8Mf6ceFT8QGG6ZiBLKuhUOG3GEFIE9
X-Google-Smtp-Source: AGHT+IHd7ek+uBZuiqrHPRkQ5UAytM9v6rWPivRjGpM4cr1mCk5MVwKCmh8v5sGXigBXl+yHf3BQGw==
X-Received: by 2002:adf:e643:0:b0:37d:50f8:a7f4 with SMTP id ffacd0b85a97d-37eb488d17dmr5841372f8f.52.1729458833397;
        Sun, 20 Oct 2024 14:13:53 -0700 (PDT)
Received: from [10.100.102.74] (89-138-78-158.bb.netvision.net.il. [89.138.78.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37958sm2573789f8f.15.2024.10.20.14.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 14:13:52 -0700 (PDT)
Message-ID: <175e4977-f865-43cc-827a-cceb8578af73@grimberg.me>
Date: Mon, 21 Oct 2024 00:13:51 +0300
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
References: <20241018063343.39798-1-hare@kernel.org>
 <20241018063343.39798-10-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241018063343.39798-10-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
