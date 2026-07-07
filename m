Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCC02F7EE4
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430464; cv=none; b=bwAAaaEyw7ZJ/3hQqcGIoa2oq37sh7innAJW5l8FxEAd1aOH4MoqJHaBmak29DaqwOOBQoNkCJ17G3TVhVoILjcgBrRS769HUKhTu79Ylno9/AQkIi6kWJLAF6uugcVDGOmFPQthJ6nzaw3rxEVQ33z6/hL87LLqNKyi1290Jx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430464; c=relaxed/simple;
	bh=xg5hsY7PfaZz7tmomblJ706RMfq/d/rrxkObrmo2auc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQlooxVDiNeWNMZ5D4Q55jrQ4qY4XAmXk9FEOdbfPdT2OVhzTvGD0WIE6AeNcgOhkUDvTUY6vyH65bglmcy6+Z+9AAqzpOjDmJzWEqyqYXqAXFozs9Zu7MHpbHs+K07DA9gxmsE94xEXPmjY8qtuHmlhKk10Ar9svUvBg7U+yMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d9+prLCP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ekIRXoR8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d9+prLCP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekIRXoR8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783430461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=thP5aj3x3fmC56uJZPEDVBx/SACxtUKRw32asI5LSP4=;
	b=d9+prLCPr6prfvDqQ63rpbN2Llyn2M610JNWJr1vf2HYhFXs5k1Ch1xZ+eP1ZeW686PwhE
	08OVQ3fLxL7zCFTsCwXOp15R8DSwTXxIv/o5IswC53OT/yHQjlzPeaWh/Zwm8I0vlFHA7q
	Kr3vvwB/jBPNjL66lyiVc778UsIa5b8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-W4fF5AVRNem5KKt37KgYMw-1; Tue, 07 Jul 2026 09:21:00 -0400
X-MC-Unique: W4fF5AVRNem5KKt37KgYMw-1
X-Mimecast-MFC-AGG-ID: W4fF5AVRNem5KKt37KgYMw_1783430459
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493bf840a69so30881465e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 06:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783430459; x=1784035259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=thP5aj3x3fmC56uJZPEDVBx/SACxtUKRw32asI5LSP4=;
        b=ekIRXoR8ExG8hYlPCGFJrAo1nv2zFxspFydkyZYTd7kNLTmp+rZ6lZJDDo/STT7vXU
         GBdZz0BQ8kD7hbhTfZcT2h7kv/qFV1jOPkC04gSZeQI/Wy9njo6npLnZzxmrX2vMeYkb
         TxJbjT+OEBXp95IBcpuLZIfLz7bw08a3BUzdOsbEN3NVSz/eMydbX0s40OM+qTe2ZCT0
         LUW4hI0ZG5QHYIc/vdw/P8P95p6fb1ABa3qDDops/cQTWXj/4zkBNT5cmrdVQMgUC5jJ
         e77x4Y7puAw9YQ2uwkOuaYikfcRVrE7fjF64StXTr4rBhYL4AYUvcqhX4Dayh2T+t9Hg
         t9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783430459; x=1784035259;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thP5aj3x3fmC56uJZPEDVBx/SACxtUKRw32asI5LSP4=;
        b=nofsB7VTYp18RMWQ53mlTfkn8QI7KHtPLccW+z3xcMHwbEubPNpRpyBawVyVIBh0yK
         ximStyOVntcmVIxYPqSS/m93lGyWhZWADWY/zX0NUTf3up98aanTtYz+4zVDyOEcCkSU
         IJCHfGwguCrK6Mbcqj6lCpcunibQPM4a3v9r5uPfau+6J6XKEA+zUK1LD8tFjSwWD7iI
         icWW9xwXS/34AuNb63hxZuA0gc0kcz5vz9tewrGjG/kyeaoPcWlpsi5GbmbLSACAh5SW
         bxC0wqpS/cPBYNVW86euXX3QStUYg02Qc+d6kj7JlfPqpg45FeG2MDxEYuXHmwYRdcZt
         3XPg==
X-Forwarded-Encrypted: i=1; AHgh+RondWYQNlqA8eeTTyjQb8SPwQ3RTNjVUkN88G88H+1UvJF6Fris++UvmV/ftPKZiNCR0v4W+silb4a3y0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkswnwQ1Xd26JB7jScqn2wQ1PcagCBQW7BK759tXSRejyFVkx9
	Umg4TC+r2R4VnhzlJFOmm3Gk0ZupriseHdEKgH3xbM5X6+ESeWWqTb/tDDcPZGjnTpe8cKGeN6L
	4rWIYstH+oEKRD5gaQFwxA3IlbT23h86KXdmuUVkm/b1J/UPVcGqFnA4BwCRJrdU2kg==
X-Gm-Gg: AfdE7ckAJ3497aLILmo1fz7fUNHv0aHx8z4PMhtznfF3qy6PaE4FAaCEa3LIPGHWkGh
	R6xF1oVcDFOwr2k7MLsvILgWHFx32ixUKK/wcisWyg9VlZLMKnhfpTwREFuvT/nR5Km9tkq/9dp
	WwePmKF57fFGuH5kcgZVfqkV3c8kyxSrFiisLaIEHkVSAkBYevTOruD9k5WaHy5ZLLEq2WDDBmg
	mscmoWWp9RzkGE4PkhqKKds46HXEHxpKHVmncHZdgmLrdM/EShCe+J1IAhBSRLrwI9nzvXdJqX2
	EjyA1+8MACqeBZlYZZjI6LyG7BCUTHPz7p6XDViwQkuZZtRNm6uEBS3w7Twf1NQ2ZiSJA3Vm2ZK
	SrRvK2g==
X-Received: by 2002:a05:600c:8011:b0:492:6113:d4fc with SMTP id 5b1f17b1804b1-493df048928mr58962155e9.17.1783430459065;
        Tue, 07 Jul 2026 06:20:59 -0700 (PDT)
X-Received: by 2002:a05:600c:8011:b0:492:6113:d4fc with SMTP id 5b1f17b1804b1-493df048928mr58961625e9.17.1783430458560;
        Tue, 07 Jul 2026 06:20:58 -0700 (PDT)
Received: from [10.22.2.34] ([91.26.127.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e01d21eesm52585715e9.2.2026.07.07.06.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 06:20:58 -0700 (PDT)
Message-ID: <0f703207-ab66-43da-a9b8-fc8b043bdd34@redhat.com>
Date: Tue, 7 Jul 2026 15:20:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/33] crypto: xts - Split out __xts_verify_key() helper
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-2-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260707053503.209874-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 07.34, Eric Biggers wrote:
> Make the AES-XTS key verification code callable by the crypto library by
> splitting out a helper function that doesn't use crypto_skcipher.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   include/crypto/xts.h | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
Reviewed-by: Thomas Huth <thuth@redhat.com>

