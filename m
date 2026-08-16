Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FB83DD847
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786876729; cv=none; b=gsOJoXy4lkbzlr1RDciL+GuUMqFKgzBAG3ti16ncjlTCpC7gjF4nQcNMURDEhtSc1NGpCVaM9ZO1HdOmD93dX967gG/dcjGPBdUf2LJ2/HMtog0VsN6SsaSER922lhZWfrcDJnusdfGsoZLACkS/OKKYJMQs4HTr1zul1jyRQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786876729; c=relaxed/simple;
	bh=E1DtirF/DQyijYx6juRJxgXtDCMrWh5fDkYaKtFffkE=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=Xa5GuVlNUgGI4Kg103ZyC9WhsjfZh80mjla4zNvPoGIpO8JXOT82Z27gnShYnxuuujBQgSv1riLIj9St+y/1wGiPQLWba0JEOICJNJtk11MlJhdto6n6k51/D1yUN9RE4cPOkltAI3I9tt7YVkEwKP94gwXcJigxBCNDWguHBAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsRXYRA6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pJFpEucP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsRXYRA6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pJFpEucP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786876727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
	b=UsRXYRA6WzR/zomyUSFt1ABo4djxG1VLgQgofDkfjScogF1T32fRSVpoRlnUAIMCnpxWnp
	zq5QTr9Eb5kX0lr0k3nIC9jfscojBFnvIWJR7/m3C4tZInxpKxNI/JEiYwLQbi1YbE7s8Z
	Nkky5DEeSauy0rMJ2KX+Cr55aOpIW/s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-r_gpp610OAyqxDEAYyXamQ-1; Sun, 16 Aug 2026 06:38:44 -0400
X-MC-Unique: r_gpp610OAyqxDEAYyXamQ-1
X-Mimecast-MFC-AGG-ID: r_gpp610OAyqxDEAYyXamQ_1786876723
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994cf6cdb9so16578515e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 03:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786876723; x=1787481523; darn=vger.kernel.org;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
        b=pJFpEucPf5DMeLJKJbdO7d89hkwY8IsKiYvq6ZSvcHOuPuDUK6F2hFGkbiaIClq37j
         oN6Yn42ONARMQUK5Uezx7sV6DsGZNXEmLZ0oDAVCV875FumDIEOlkK9VbvOcqmC9LzMc
         YUlO2RsrLy3swiVkHVKWCGbA0m3wHLZmoj5+kWIEjlnQwHyMWATXz2fIXe3xXM63lm3s
         F0tlssNvjL20XoAqo5YZc3vz5zg8nlVF3BFzbqpNBGZH4vhG7NkX45zE62kvbm/+2FyC
         8kNrLwzHJfN9avw4s3Y40llt0PNgtRHY11ID5mrUqep3YYusXHHvqywKYmfMz7GyqPdg
         XOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786876723; x=1787481523;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
        b=Dm4fQSe21uaeJdYWEVoDDjIyyondEAC2LVXHMp50/orF0tcdMeVkhlbypvngfz8MB6
         IRWLeIjnYZwFuEglaTTFJck5F80bYMqt21hqCT3nrP3TQ6ava1kpfViIKvWQ1yf0/OBs
         N7gzAHz5I2VvAF8X4zpgcVTtmlGL/dHuDHqUAH+j0W6JWVZx4ze4dOrO/mnxqa4CgrUO
         GZHHtEn4eDSBT1lcaq+CEQlzWlFzH5/dQ+b/xwE7PYggZmlaSSBW3y9izZHZrY5gX3ta
         ha2LJRNIMTYiK4zUsS8W3xRfI0k3IP3bkqpldSsWIbx6els/OX8LlPHQ7Ae9AUoqHPjx
         KiSg==
X-Forwarded-Encrypted: i=1; AHgh+RptPnu7nV8vZ0ukBaBEflkKC4Z5IiY/dppSE7UhAV/tro9h4+MhPX126HPtVWjV9O8rkRWlA9gDkmAtqUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRwWbu98qz67c5S2zBMw3y292H0sOitObvNjXNjPS9+/NhsD1X
	qCCnnwAgsNZsAB09rcKnpHycfNUp7/DftlK6M6w6XUchTQ12BILrg1HI7bsIk+dz40PsQ5PqWBy
	8nvi0oa1aefqkkyu8W/6NJ1rh+usw/NLLS0Q04TkCIliCZdUBVwAHjQ5pSmX1l0BPLw==
X-Gm-Gg: AR+sD10Sth8z+pvGaPbn9vgbyQiU71nAFDGS4b6aCFAUxh3BA7AAbTENcPPBM23OBn4
	8utD/2t4ev1xt8+9M+kf0flsM5tfDj7E2iXcteScpK+e7IU7CeDJ83YREzfwuiiiv0rYz6TaA99
	GnuEPqCjwYF/7ZdpE6TO4rY6+oFjNeugxZNEpAG3gHRYhJy+Lng3rjrWjYrpzSuh2Hei97o8lCu
	f/Ow7kstTBwrkwXxiipOMAmpB6r+Aj/k3jv3mB1NsptgdbWAsJJ4KgUacxAtNfJZpW+lar80L7W
	PCKmQp5tYmufqc3jg6t6tdvmeqaa1SySyOuLFO+UDiA4VcJ1TZr54RsuF4ntPCpQOnN25l1Wipp
	szg4F0N/1+Mc=
X-Received: by 2002:a05:600c:1f91:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-4998797d111mr236172455e9.15.1786876723030;
        Sun, 16 Aug 2026 03:38:43 -0700 (PDT)
X-Received: by 2002:a05:600c:1f91:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-4998797d111mr236172095e9.15.1786876722609;
        Sun, 16 Aug 2026 03:38:42 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b1a31esm211201745e9.2.2026.08.16.03.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 03:38:41 -0700 (PDT)
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
Message-ID: <20260816123839.3670e5c3@elisabeth>
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
Date: Sun, 16 Aug 2026 12:38:41 +0200 (CEST)

Eric, thanks for taking care of this.

The patch looks good to me, I just have two questions:

On Sat, 15 Aug 2026 13:57:50 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> returning from it.  This is needed to avoid degrading the performance of
> any later SSE code that may happen to be executed.

Out of curiosity: was this prompted by some observed latency spike in
execution of SSE code, or it's just meant to satisfy the recommendation
from AMD and Intel to use it while transitioning from AVX to SSE modes?

> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Cc: stable@vger.kernel.org

Is this really stable material? Skipping vzeroupper might have a
performance impact, but it's not an issue for correctness.

The main reason why I'm asking is that, while vzeroupper might look
harmless and obviously safe, it actually caused CVE-2023-20593
("ZenBleed") on AMD Zen 2.

I expect systems receiving stable kernel updates to also run the
patched microcode by now, so I'm not overly concerned in any case.

-- 
Stefano

