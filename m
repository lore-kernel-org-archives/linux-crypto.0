Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792563510;
	b=fobe9sVUZJlisx9WZkEVyPZPuG84W83KjbGCk7AeCjU2dfnz+lE5ug4Um6vh61kRIH20
	 CAfKjsttJoYs6s2nkJIgBi5dc8lUP2UOGpNvR+j4ri6kjhanrxgL9mVPh2eHM2bjwFS+p
	 l+5eUk8cCTR0QEhTUf8VG1QRC8xV7OJ6Zb/k/H2lgJbYFFF0Xy1hDAXlKbyMu1NQvvClP
	 /B1J/kaEidczafhGNj/Kib/T2FKxt/vti6kvI5ePgITo1hWYFy9Daxe7vUI4znnpmHfy8
	 WRNW0dhnhrFei4fwmg/Y7E8Gqba7OFNf/QJdbqnhP8kuvGYHgR7H3dqqAKqlaShoXcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792563510;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Dc99l8hZHLRPV53wZqdZeHZkP09EWg2fvUHtV/eWOEI=;
	b=HvXtiN3WOR/IOV50ilwA1XJcJHXcA6cqb4uTrbMTtK1zLSw1fDinoPhI6Uh+GImg6w7W
	 15J0xbbfq5fF6lKNXVJ+kRSDfyCjynR78P9nTM74lEdQ11NGcNjStmhE5sf3+weN3L+Km
	 oBbNEBnC/KyAlG1HzALEjY/KGbxfjcRagTA9wCy3eU9Z2K19zPGjSyNCWS55erLk5fTXk
	 K/gWOlFx/eH4RysCgFdWf5ONP+f5y01qCBClD5hu4r82wp2ZT2F9tXnBpFfor7Z0zjXnq
	 d4vg7pjAyx06qZhpdkpFGSZ4S7sQZe9MXdkBggPkgeIUyoYCt5BZdOXmexZBqpgDqDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e6F1aAcC;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=do0XXv7r;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4571E606A31A
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 06:18:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4571E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e6F1aAcC;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=do0XXv7r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792563509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dc99l8hZHLRPV53wZqdZeHZkP09EWg2fvUHtV/eWOEI=;
	b=e6F1aAcCzDnZoz6xCPbmNRSMxaPZzpKIYJpAsfjPVMvDSsfKVyKBOaYX1rRSYzjVFDMkTS
	kBE63iDGvKMpFHz8tjtrk7Qymt8mKt6Dx0VbBX2MX8HB370t9L9/tGZp5W+Jr+rqxIlMBN
	jGGYokZgCnPElAqV+vcdoDqp2LGuCmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-1Ayh9PAwM0e0WXcOy4vDNQ-1; Wed, 21 Oct 2026 02:18:22 -0400
X-MC-Unique: 1Ayh9PAwM0e0WXcOy4vDNQ-1
X-Mimecast-MFC-AGG-ID: 1Ayh9PAwM0e0WXcOy4vDNQ_1792563501
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a01ba12198so10043155e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 23:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792563501; x=1793168301; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dc99l8hZHLRPV53wZqdZeHZkP09EWg2fvUHtV/eWOEI=;
        b=do0XXv7r3wdi3jtBXRysBdMkbmcdmdusJVc0YRNfsTHVc53uRPuB7aMtfyL9NGyLEC
         LztIqqhslmLVExu580P29pvTkB0oGCIbns5/ulgi4MA1+StE3EcPhOHLroIAyDwoOhwf
         ScSnWpduVgmdlK4fvaqsjE2uj8DvuLKvUdL65zXdY/mBJDzKotPZDxn7PIVqaUz/Kvfz
         2/jsAlOq4veDJagATwM7YxLIX2JZOmp+ld0+dLlDKhEo4Y5ribhLQ7o74aCvMx/RQOTy
         1u4UQMpWHSdvEGXDUwf2MmIJtMcUvI1pP524wOXilv1WWS6NP2xovYk33YdJuTUy/7u4
         bSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563501; x=1793168301;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dc99l8hZHLRPV53wZqdZeHZkP09EWg2fvUHtV/eWOEI=;
        b=CSz/Jkgs4n8MY/vyYuXQ1z/KWJU+TyIh45udy4WQljALY2liKYz7bO9nVJ23jH+yGm
         xZiGzr7FgCQ2Zb+5Wj+RFecvNHTdp5oW89e9J2oEEcxWhTlddOu8mqXNCe30kBBpBSx8
         gQPAtIzY+b4tWi+ik9v75GexjD4AhHTitvSnr7YT4hNifW8gkyq7yJjUmyzsH0yWRdZq
         zIHYvUTHVso9pfppuqjWGQYf/itRUv1i7OyKiFKfVTjNT6rnZnnHjKjJdQH+ySr7Syma
         AnVSkiLK+NDHWLFbaLuYVnEmCEom1BOIvyBScA0q7Rl0HWwxHnYogkWXdmuuKpGfYwWU
         zPnA==
X-Forwarded-Encrypted: i=1; AKwUvBw/3SDOvn0L15m13LoVAIw51IqxvSPWgQ1of/DeWYGvlZujqm+kqfCYq2f9dD/5lSEGH03fWW7klvf/wNs=@vger.kernel.org
X-Gm-Message-State: AFq9FYLTMMG3P2chEMQkDcm0y8V8zxPx0IZ+OPpPqRhKQfQk+Tda3xbo
	D32l4jpH9Iyyn0vDN2LbhCdw6a25Qk4sdUbRXgQGiPS3av0dZlFoBMONIdVEu/8TEQr33GBMMvT
	19ubwEjKZFeDiNx05w9DvGpPiys7sc0AP0yxHSb8Nl9Be5CxmF0biphPmokIulKDXMg==
X-Gm-Gg: AYBFou1ur0/AJ5QKMERMowO3Eqy1khaM7/4YAaFDXB8H3+Bkj4yAnyjJDfBHS3qoy4Y
	3nSSGRYX+9WvkeHoZx739/ccwzQPDTwMGhEoUkP2pQPleQ9oKRBTI09zJs6CpYG4kqOLtdIG0A0
	I/dAPIFVlURRmi4ZG7lwAaR7j4M+AE0tvy3R+OZKVVgE81s9XhaXk0sFZzQQkXrqvoOjVsXvLUp
	uWEwGSZMiOy2NbxaNwAzB+UGKi5CtXC7hCs0Z5nFGsC4dEZqfKiIbnhe8ek3RwMQjsng5eEa4Uq
	NcRrnm/MJGl9AVQPtaUtGUCse4qrc/2fvoCVm/nl3Tt0U7bBroSef/Eno+YdkOAnlROhPNje
X-Received: by 2002:a05:600c:a0b:b0:4a1:efbe:529c with SMTP id 5b1f17b1804b1-4a1fdd2443bmr17517245e9.12.1792563500799;
        Tue, 20 Oct 2026 23:18:20 -0700 (PDT)
X-Received: by 2002:a05:600c:a0b:b0:4a1:efbe:529c with SMTP id 5b1f17b1804b1-4a1fdd2443bmr17516885e9.12.1792563500396;
        Tue, 20 Oct 2026 23:18:20 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd234fasm21744535e9.3.2026.10.20.23.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 23:18:19 -0700 (PDT)
Message-ID: <d3dc7e74-0189-4aa6-b23d-0fa8ad75e059@redhat.com>
Date: Wed, 21 Oct 2026 08:18:18 +0200
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Enabling Sashiko replies to linux-crypto?
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20261020215744.GF699485@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261020215744.GF699485@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/10/2026 23.57, Eric Biggers wrote:
> Currently, Sashiko is configured (in
> https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml)
> to monitor linux-crypto for patches, but not to send emails to it.
> 
> Would there be any objections to me opening a pull request that changes
> it to the same setting that I set the fscrypt and fsverity lists to?
> 
>      ["linux-crypto@vger.kernel.org"]
>      reply_to = ["author", "list", "recipients"]
> 
> That would enable emails for issues found, with reply-all.
> 
> (There's also a 'positive_review = "all"' setting that would enable
> emails for positive reviews, i.e. "Sashiko has reviewed this patch and
> found no issues. It looks great!"  But those are kind of noisy.)
Is it possible to configure it in a way that it only sends mails if it 
really found something? ... always getting "Sashiko has reviewed this patch 
and it looks great" mails is rather annoying than helpful ...

  Thomas

