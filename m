Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BEE192589
	for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735040816; cv=none; b=dthKsAzQEAHafbuHq+ciLgUcuzlrSFBNw0QWft42bZDDROoVajlohyCB/nL6gE1zpMP9IOrVyv9/tehweKfapRDiQI8Y5j6WvlY2DzQfONo+Y9QP28SurGFArmNEnwJDOYi/436fGqeJNgJ+jino4j06veLcslHP9BzMl1+S/BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735040816; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgrXOA2foQPuARrHatwH3gPuqlxPiSIEe1I7Pog4o/n3aiekuAPMJKZgMtNhIetZ0NXn7/1F+B9IdcS75KLETRlG3HpktIlLwY1rdhUVuriAHOswd6GVWmrOUfqdpMye3Z1lw9YxNZTl1lN7k1awUgqlfwxTQ7zfKz6hAcoV9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385e0e224cbso2747270f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 03:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735040813; x=1735645613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=oQKRIXLqWszq3HxGXvsym8T8l9KE+Ra7+PX/61IYH83upNLa2RzuMmgQdvPXIpkKMT
         X4Nwi/MsPXnrKtsYrz1XP1VSLaiuXE97+ubRPjLS2UeSMR5p8SvMUjNfJ/EEnPp9K2ai
         cuQ/BzWheHqguWqCA0bNdZmiD3TdkFgS0TKdZC4UxLVWnkn4MI2DLXbNJt9GHKhf8VZz
         9fKt0w9YefyZaKPSBKUSeDuJIrdUH2hHXSmSUjO1MZhwJA1TD4r9AMHH7jwhNQZT0z7a
         hXZEAi+gMO6PxsZBgnQXmSH6gGK1LX0CeaCHaxjkECCajB+sPZdH7HGExHOtT6nPgoOk
         yYUw==
X-Forwarded-Encrypted: i=1; AJvYcCV/5yqZtRMS0tdC5IFmKholUCTms3LL/nh5WgJX5cSVe/NnmH4Twq2ZWCw0xSG0xJBFUT4IsB1I5o7Lvd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkTg6uN4W50V/H8HwQPrRlRv8SjHlNs3L5SZZzni/VLg0ZJwJ9
	gCHavM8//o1JpTruc5dPg342hXTW7qBVrGRJoSeRJQGq9qBSbwqK
X-Gm-Gg: ASbGncupn9HCVK3977kXpEJZOA+WmO57t5IV1oSnysquX81/VkliYVM7Uop8gh4wr++
	JjKPd/AA//4PQtfZ4VJtrKIdkmrtbvohLTwyO5eaIneyls8n+8p2Fq2g22yHdu7Q9Qwmrq6yt5B
	XZEHOW1j5zoKoWPUcMSyZUIA/+Sz7PoGx0VX+2NaQod8m0HS+rBURgq3vYGwbH7BYKEOC5ViuTt
	lummJprVSQBr6jMCYblr+KHmQbPgEmTT0eK19kpb0JKOXfaxm+X4IZ4riHRisRj3dFKMnChOxtY
	TpDh34r2B4O580guRlIH8kA=
X-Google-Smtp-Source: AGHT+IHnznZ8IxV/crppyah3y6+Xkdi+9yR6gororlr7qVkgHMqD+A8FuOPob4cD+FXFTEwlgzsKUA==
X-Received: by 2002:a05:6000:480e:b0:386:39fd:5ec with SMTP id ffacd0b85a97d-38a22408c8cmr10928848f8f.57.1735040813117;
        Tue, 24 Dec 2024 03:46:53 -0800 (PST)
Received: from [10.50.4.206] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c84840asm13931504f8f.61.2024.12.24.03.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:46:52 -0800 (PST)
Message-ID: <344a701c-8086-47c3-8e83-c4666f338bd0@grimberg.me>
Date: Tue, 24 Dec 2024 13:46:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] nvmet: add tls_concat and tls_key debugfs entries
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-12-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241203110238.128630-12-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
