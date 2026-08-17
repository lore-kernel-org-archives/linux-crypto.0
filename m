Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70F13FC5AF
	for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786965477; cv=none; b=pKoUx7mnSlQs+WM84F0VRsLD/R0UXpTbxKnqhserS8q+TEWUMLWjOwuUZhbyccUv2t2Zq3zUVIE/uEkT8DvoqG7P5ohu1w3LNYwBTfcIZ9gHbbgwLewjwZaqjHKVeHQ5v0x18D0vZ/pd7I77g67brwZOvEAtU2iIOozFvLbDtmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786965477; c=relaxed/simple;
	bh=AayGtOQDKtX9pm0ZEeABQelkCQowJyXQKLwBThQ68+k=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=Po0izK2Aulun2xc8SpNRRbKqWL2hHDvuBbmVlEZnKahOgF96AMI+EQER8T0nLY3ulZJ12SJ9TIADgE47dDBq2wRvfKpX6666WV/soqJfpDrotWjO2FghqAu5A4hNxORhQ8Ya0xvms9ZrbsBf/wiLz1R1XNVMiU41W1s3hTy0kkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEVDAfQM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lkyPCwBk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEVDAfQM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lkyPCwBk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786965474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHaC1wb6A4UB6rpudHDIMeHC+iY8LxyInz0ILy0oT4A=;
	b=OEVDAfQMqJTokoDqjTmiexpv/gzfADgayW2jOCLi+ai0LIp7x5LGe+hMxkN2VG3fGIUMpP
	CHgGnP4l+xhrPCbIhIn0TZovo9ZkJpctoYZ7mQEv3QF//cf0h1WcGN96SCPQYLpVTuJILb
	5DkuVQvbqwsow6bhJgcnmWPdKCEP20k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-NOsAsNwJPpON1WQEquIeQQ-1; Mon, 17 Aug 2026 07:17:53 -0400
X-MC-Unique: NOsAsNwJPpON1WQEquIeQQ-1
X-Mimecast-MFC-AGG-ID: NOsAsNwJPpON1WQEquIeQQ_1786965472
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493bfc3b84aso18646465e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 04:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786965472; x=1787570272; darn=vger.kernel.org;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iHaC1wb6A4UB6rpudHDIMeHC+iY8LxyInz0ILy0oT4A=;
        b=lkyPCwBkdwlGI2lgzvhc/68VXSGfuRoT+rAsu/EvJrlViIyzARZfwK5RbYqJMEpo+4
         mbDWBl1QIKmAZbBPWNQFXUfUDgqRhEDk8EnrVAAYUOyZcNHGdIYEbwP0MeCPhpv3lx1e
         4X0hScitwRLMDK2yRl4Stq7IQBidSEquaLoRGA9PohdgzCS6eNa/ZEt5ChZ0+C/oFDDS
         OI+LmUWIsL4K1BeuXDs1eswBuUmMut3st4s7JuuOuHum29HMSxFUZ1kjgTVyDhUyI0UG
         9BEAgWPfbVl2hH8Mt+qKLsaso21VJ9KbjsaS/5pxO7lRvXu3wFugMiXL3+CHfXhcVeir
         iLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786965472; x=1787570272;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iHaC1wb6A4UB6rpudHDIMeHC+iY8LxyInz0ILy0oT4A=;
        b=bmzPalmwTYVepJ9i4W6M6Lz2RDLKabuMkjdn1wwn33qvFTA4x0X84kmz+eJIYwe7pE
         hCGtmsEaRg0W+TXG4FgNXFCKnLw/9ta6ecceedKhs+ZDM78e6GE3k9ptDDm5RCGnJ2bW
         NnGPpK80sxvLnLGW9jtaVVNrdt8oeraOLD0G5L1Zq03wzQdw4olMjTJxQYIg+TPqV0GM
         9gZXg3VXdyJpQmj9fWd/pNCItNU1dIKW7zQorvQ2HhOdAHAt5EzKFPRrXBqRPBIUL/+m
         AvsDSHR+pbnwny56EVeUbRu/ODrf8ebZa1t+nLqhX/utKxlco12LyKXrqZxVzre1hJ1B
         wd5w==
X-Forwarded-Encrypted: i=1; AHgh+Rrn4RWYr1+vHA7IwJO61OsvHP/58HmAQWoE+1GTYJcAmXyxZ9ntpBNumPJcpJwlMnSE/LxnbN+xdXt8Gqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLVsn+cuNOZF2r99cFEc2Nlhqq9xHjrz8U7157Twgtnvb7tLGy
	MOwMAU1ohu7KxVSerOrF88EmTROJ4w2tN4GAVtzRqtjEcSN7WTbsc/9RwOODpZNjLumD1rkq4sL
	5V6eOHSEk75ddc+qY6lqgF/Hkd7PAd8hHMQoWDGP5HQHCI6arbjPjrTPj44WDmWAVfA==
X-Gm-Gg: AR+sD11PaGdvOD2Ri0OseHs5tzL/4CI89FAJaPX7e3GhKPoWv49VyOvLtdTlf8M9J4V
	CYmHf62rvG0bT9OZyDS5sjXJY2d2UBhQA3Wnay6hAkhs7NMiZL1cF2WDsA5qMx5n6zXZE46gJX8
	E0y5QU3atexz8Jk6cjGmB95PcHWditLL03wo2LZiOzm1Rxluz8WpdwqbZtg+sl5Dj53uB60ZpCq
	3BAOUSzhn2UyzUEzg18EXr1DPA41HJg5PUw4THyPiZav3ybf/M9S9nCVg5FxDFxkljZpxn8lPpu
	WBHfUhQ/QL5HoiYvQGq6yMY5UcHC7lCFuEqzkTXAw2niVp0Sm2NfhKcQPqO6iihL8cgzKVhdIbI
	AU6OTopbG05hVR9vB5pf3+EJdDduO
X-Received: by 2002:a05:600c:2185:b0:496:bffb:fb7b with SMTP id 5b1f17b1804b1-4998797cc60mr279142065e9.10.1786965472210;
        Mon, 17 Aug 2026 04:17:52 -0700 (PDT)
X-Received: by 2002:a05:600c:2185:b0:496:bffb:fb7b with SMTP id 5b1f17b1804b1-4998797cc60mr279141055e9.10.1786965471771;
        Mon, 17 Aug 2026 04:17:51 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d0876b8sm44870005e9.8.2026.08.17.04.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 04:17:51 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>, stable@vger.kernel.org
Subject: Re: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing
 vzeroupper
Message-ID: <20260817131749.6e1408bb@elisabeth>
In-Reply-To: <20260815205750.169336-7-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260815205750.169336-7-ebiggers@kernel.org>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Aug 2026 13:17:50 +0200 (CEST)

On Sat, 15 Aug 2026 13:57:50 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> returning from it.  This is needed to avoid degrading the performance of
> any later SSE code that may happen to be executed.
> 
> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Cc: stable@vger.kernel.org
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

