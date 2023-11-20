Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEACDD7C
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 05:51:51 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-32f831087c6so1198238f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 05:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700488310; x=1701093110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBjfkJyBXoUSjJtDaLOjdUY1bhjBGKEs8k1Y4r3sMi8=;
        b=QQBkGrVuQugrFsKcuDt+hrBui6vpXvalttPk5QrnisqNRHOhJPvfphAKQdqHc7aeD/
         i3gYKmekYBrEyOZ7He4hrE5tzXtE8z3ImAMuPMuC5ebmaHfiDRBhp5kJ23bk00zM5KUL
         LkXu2WYBIX42AGt1QGdyqbUrzPLs6/T3xHnVAlT0X3Xz/j2InHICtc6+DLBDpTHTIzSK
         GQs8liU+L/VVpqPVMv3QjeRweZp7s0s8XUXJHp/51MkF2gHhsP/Q5buXoLYYk3seWb3v
         9D9rR27uqoSVxh3g2Uh78I+KYbQAYm/jH7LfKRj/TPgJpP2MhZvwiddfW8CpNxb2qXDS
         Ro5g==
X-Gm-Message-State: AOJu0Yzh58FPW2hEtMExJ662d5R0Z2BeBi3jCfJhJBe5qWTfc2I8o6mz
	2QtE/9q9d6xwLfb89oau8HI=
X-Google-Smtp-Source: AGHT+IGtfGcszaALKdok/gQAg+bpVnqvh3VY7SQ0fRrzq8DdiWFTac+fVhWZmnuemP/JJv76xozspw==
X-Received: by 2002:a5d:44c9:0:b0:32d:e435:92c4 with SMTP id z9-20020a5d44c9000000b0032de43592c4mr4973906wrr.0.1700488310124;
        Mon, 20 Nov 2023 05:51:50 -0800 (PST)
Received: from [192.168.64.177] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id z18-20020a5d4c92000000b00331424a1266sm11249805wrs.84.2023.11.20.05.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 05:51:49 -0800 (PST)
Message-ID: <82b827fc-ce2c-4d87-b796-3ce81c4b52ce@grimberg.me>
Date: Mon, 20 Nov 2023 15:51:48 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvme-auth: use crypto_shash_tfm_digest()
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20231029050040.154563-1-ebiggers@kernel.org>
 <20231030132816.GC21741@lst.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20231030132816.GC21741@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> From: Eric Biggers <ebiggers@google.com>
>>
>> Simplify nvme_auth_augmented_challenge() by using
>> crypto_shash_tfm_digest() instead of an alloc+init+update+final
>> sequence.  This should also improve performance.
> 
> Nice:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Indeed. fwiw:
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
