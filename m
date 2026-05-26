Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BABB3D9027
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 10:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779790969; cv=none; b=n4VsRZG0JIJBhWcK+manCSpaI/sDeGRnPBU4Rra3DfHjclTapXBYy6lfRjQMKWdIQop5mU9xyr89tE7lCY5KfFFh7IpycrVJiFME82LOZSOf7N2CaInl905VmbMcY+wmqUl/em8g0uTzvO8MOodydVR9Ql5fDWR2QExFsS9Cohw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779790969; c=relaxed/simple;
	bh=hwh3B6/puad1rCmOYcUBON3492pPHvci/7pX365vmes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CteHMUS91UF975a8UyFhYPTtqyu0oMRCZYaFBjwXnRzPK+CZobJ1E0zRqBOcFOK9MGT2eKqsGaz7w9POrTiftRcfn/NvasvdmIwL5lyIBV4xeHzFuy1iMfB2J1rh7UrIcHhsgyZktvGM6vxax2xuNwZDUNhHOGGIasR7QB8BX6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3faCngs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rb1YXpzq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3faCngs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rb1YXpzq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779790967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy2dkBwbMAseBkbcRQehUKk5GPec6RoU2Jo6UlJsQ8k=;
	b=G3faCngsrkqeQqSqWUofxs4afb7JgUHT886+OEwfZROkVtO6EELVLunMKY2rT8FxHwrHvZ
	T/so7zKq2BMASDCorOby2cpg13JWf1e7FeU+RROAigqTiybIHtayqZvXIVksfNbsmAHYoK
	5EPutZCHtIjgtAKx7mqAZi0+tt5rORE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-AEmxKKNlMdqo-x60aiBNgA-1; Tue, 26 May 2026 06:22:46 -0400
X-MC-Unique: AEmxKKNlMdqo-x60aiBNgA-1
X-Mimecast-MFC-AGG-ID: AEmxKKNlMdqo-x60aiBNgA_1779790965
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490479c2911so43639155e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 03:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779790965; x=1780395765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fy2dkBwbMAseBkbcRQehUKk5GPec6RoU2Jo6UlJsQ8k=;
        b=Rb1YXpzqCUE2RoDCacVzBV7bJxQfzV0FtPcXKgB59fQFQP+njPKcEAiWuhERoJcHef
         HTw0DIDT7uAwzNLymtUb8PFGWxhdmW/t9Ts8P+dFUdNQNhBhdYY+ziTCOHMOsEbclZkA
         ZwTe2vixWi6suaQA9K6znSZ4BrqqQ/xBwP+UCk1SeNCZhw9AeMw1/QYUEwsmOsNlxo+x
         1CUV2iUATX/mI8OyBPdEJb7wfwFidfmspNdXcXBMV0auNWOLFUHk6ToKGum3UDVuCkkm
         00P1jD6AWUCdJCCXdVUJGaaemtC8Jq84E1CKY3f2CjJbWQXA90M2PExSC6Tmmjv4BqS3
         Q3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779790965; x=1780395765;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fy2dkBwbMAseBkbcRQehUKk5GPec6RoU2Jo6UlJsQ8k=;
        b=RUAHjgyDNtJeqmIjwebwzpzv4d4SFeUwJRQVRnHMcobLwf2nLttfTkCBDwhPjrp6SU
         le4O01RCIVgGQ6cWq5oHg+M1otxhBvy0D1kcRT+9RHalT/XHECWL75fPCW3Uw3ObTvw5
         zc8MPi416ZIaD5enU+LbHijn8HGmLZzz/CG+MwnqCd/aDz3Ka5s/n5eXNo2+8BE/Twqn
         3pgLMSgHOBW7n1+CzEGs4H2/CTGlTib6PvfRqsVTncqLuht/LTWo8S212Y2dzgq+aEIe
         L77YWU6JoZsSZeNqkloI0LxxyIxXgV0PjFkFjscMgmlxqEaXXYm+P3DCzcnf4YcnOFVo
         /pnA==
X-Gm-Message-State: AOJu0Yxjnv1yMuPrVt9EzdnGDxdtvVMG3JEhVY8t/zow3KSeTxBqln9A
	IFfk6YlWUKfm0Z7TCbP43YrpYuhMnu1E1XXZ9vrsiH6+vLAUKpxsyaijCLrywtbEwQ6rDBdxgZ1
	+bh6U7zKsHSKvv+YGc4wl5TX17n4njfoVdD+uA8S5qYNidP9Mz4lT9EjF9X7s1kU/YQ==
X-Gm-Gg: Acq92OFQjM2zYwQnXmV/uBruezRINWU6wPidAlUdtn/a7cjgkoZk9Cx7kgdQI0uTtLr
	J9gVx2yx1ar0orbjjx4NKscM3ZHAl9cFBorkyQ4rsZo7p4+9xxCp6+tw4r33QKnVBsZuh56N7up
	33lbZV9xmmdeyur0ax+orM8wVH9p7P0vOsF4YQdTqOPXGBxnfTcsQk9xLnfMUsScLfULn44BfUG
	uI6irtjFte0ig+SAMYXspUQOcGvgflEuJdli/bfTXZVAka5i3I8yIi8qOVYIoJnHwLlDK4GIBXy
	oHMOcImkjgsDcH+P1ZBxGAChmdg8DWzrc2Dh+6i3LtUucWis3vgCjbjatjoJmxgLL5MJtJKwWi1
	JJ/+Hq1fWAP/27RBUenD4PB6UmOkoYXMRMLk8kKR8d+8Ld438Qq33t84kjA==
X-Received: by 2002:a05:600c:46c6:b0:490:4927:3777 with SMTP id 5b1f17b1804b1-490492738a4mr258449365e9.2.1779790964930;
        Tue, 26 May 2026 03:22:44 -0700 (PDT)
X-Received: by 2002:a05:600c:46c6:b0:490:4927:3777 with SMTP id 5b1f17b1804b1-490492738a4mr258448765e9.2.1779790964516;
        Tue, 26 May 2026 03:22:44 -0700 (PDT)
Received: from [192.168.88.32] ([212.105.155.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904527dbf3sm300099625e9.6.2026.05.26.03.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 03:22:44 -0700 (PDT)
Message-ID: <6e6a0129-ad37-486d-83e3-8914509b76b7@redhat.com>
Date: Tue, 26 May 2026 12:22:42 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/6] Remove unused support for crypto tfm cloning
To: Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller"
 <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Safonov <0x7f454c46@gmail.com>
References: <20260522053028.91165-1-ebiggers@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260522053028.91165-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/26 7:30 AM, Eric Biggers wrote:
> This series is targeting net-next because it depends on
> "net/tcp: Remove tcp_sigpool".  So far no commits in cryptodev conflict
> with this, so I suggest that this be taken through net-next for 7.2.

Makes sense, and series LGTM, but waiting a bit for an explicit ack from
Herbert.

/P

