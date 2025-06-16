Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349F322A
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750082567; cv=none; b=tFtmxYp2Fhjv4VoQGV0rfwMcCv6892dBA8z4L+cMxQPjUWjDQvQ1srrHc6CY4oeFMeO2qvcvEGtplgo5nSHuKvZ/1SZP6YYhtyLTHED2ftn9g7f1wA2JWhGSurCAV7aopOorIhYP5bNomoMBZPhALiIrRjU2cm4Ky2GXpZMmlkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750082567; c=relaxed/simple;
	bh=d0ARDgvB9SsiJbkPZbgooQRX1EUc9fd8sBsLDXLnLXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WVnh1Xj8c8qKHgKBE6zfwX7mmAK26V6r6slxSKExEEdLDcZR029r82CXgnvwR7FhtyoG0vv8wsfd8SYMcrGQQ4cpsprqUXynfQLGUoIp66t5oHeo+JUqW6XWHRceJzYQOmXf61YXo/ahKoBigpVqOVLkCx2X0M5HFIWJtPzWUdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDQPjJa4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDQPjJa4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750082564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0ARDgvB9SsiJbkPZbgooQRX1EUc9fd8sBsLDXLnLXk=;
	b=GDQPjJa4oxjfDf9MW+tCwyhBcw+1rju8SzGY+ZGOqMenDkzUAWboLVQi47r8tqItpTc3K4
	STpsw+8dkiVkr4aADRm27TVStWImsfvbrSFOluPNosVzMdRyPy3Y7e4ZsaMXB3UQs9b5Ii
	/WIQZStZBAC3QsayDpYDAw+uxTlfFVM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-7RpjBdVZPXmu5o1AVSvAQg-1; Mon, 16 Jun 2025 10:02:41 -0400
X-MC-Unique: 7RpjBdVZPXmu5o1AVSvAQg-1
X-Mimecast-MFC-AGG-ID: 7RpjBdVZPXmu5o1AVSvAQg_1750082561
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6fb1f84a448so43257846d6.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 07:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750082561; x=1750687361;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0ARDgvB9SsiJbkPZbgooQRX1EUc9fd8sBsLDXLnLXk=;
        b=nRsxIeOjyCgOAt763o9Dds008Va8jMA+r73IBBpPSApnypaIWDkGG/TDYUY+qV2JJR
         t7UdCTUsr4A7RZAUUdPmbEhur3WOakZQrg5fA3m9Owhid855PR5bJLvqjLIXajP752bS
         gNLpd2hQPhe/SsRBjIPyHbps9ygQNdMJhaaDNWSdW8bmAKn2tBaajqYV7n4yNWah1xrq
         ti2MXMafzsquMinkoiFEanZAryZo3pFG1wFDq2AXo2RNgDN9w+U3tTsLKxdcIVxtKKq0
         grNf7yfa2eVDpbyEMN1RKHSSrc12Yc3DE2fOUI5uXBooXLMb8P1PcxbjBN7buncyRP2Q
         1avQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOzyYAZjmYdj5fG9veUOp9Ha2SwQl71LLhirsbCf4uyx0JgqDhzv91j0cEkY4hej5oqHwmTdKgvOrlkR0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1atJ7b/DPrYheXpISw/50Jl9VKt7m4YCcBoqpUTJTdrguPpl8
	gFDI6Z6p3vyy79NBHhiGnqnNf3MZz/J574Hqraarf+QFJUKke2VAW136M7nZ8gtqljDagat5u18
	ZURtu3yJEO/dWp/kdT6Z8gsw9dE4wMnHcty7IcbjKsdudC2ExpFkuryzyUEuFY9wUvw==
X-Gm-Gg: ASbGncv9ZTXdLXiTdzyoj3cV0jPqZozgWQnVfti7BBv7I60fxTa/hdpxTDfbwpalNiQ
	NVkF+hnKAJVlt0Ijgy6+RgcYA7AEu/Idh9gTYyNy0FI1b3QgLzlF8C79jQPW8ZxWHYXJ7Fq7uWW
	o9EKTcObI1xNzoHm/pEMBnMu+RlTl3G/shB5t4mA2t0ICOXiGzSbYg8yBEzj6cDC7mTzz2pZxGD
	cl+h68ZY1Gqj4LcW3sSVVVB45aDcBUfqjA6Ytt1E714o8wwj+A6OMm5fhlL6viI2PeKOugNDJR6
	ecKnVU751xyBSjrx
X-Received: by 2002:a05:6214:5707:b0:6fa:c46c:6fa6 with SMTP id 6a1803df08f44-6fb47725e9emr140484886d6.12.1750082560763;
        Mon, 16 Jun 2025 07:02:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBcR/KFEr6tqTnCHltQ+VrJiT6moThRhF0UozL35I/ow0X/uSWOEQ9XgxjQtT6GjShaQTWUA==
X-Received: by 2002:a05:6214:5707:b0:6fa:c46c:6fa6 with SMTP id 6a1803df08f44-6fb47725e9emr140484276d6.12.1750082560204;
        Mon, 16 Jun 2025 07:02:40 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::baf])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb525553c3sm16042316d6.104.2025.06.16.07.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:02:39 -0700 (PDT)
Message-ID: <7ad6d5f61d6cd602241966476252599800c6a304.camel@redhat.com>
Subject: Re: Module signing and post-quantum crypto public key algorithms
From: Simo Sorce <simo@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Ignat Korchagin
	 <ignat@cloudflare.com>, David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller
	 <smueller@chronox.de>, torvalds@linux-foundation.org, Paul Moore
	 <paul@paul-moore.com>, Lukas Wunner <lukas@wunner.de>, Clemens Lang
	 <cllang@redhat.com>, David Bohannon <dbohanno@redhat.com>, Roberto Sassu
	 <roberto.sassu@huawei.com>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2025 10:02:38 -0400
In-Reply-To: <3081793dc1d846dccef07984520fc544f709ca84.camel@HansenPartnership.com>
References: <501216.1749826470@warthog.procyon.org.uk>
		 <CALrw=nGkM9V12y7dB8y84UHKnroregUwiLBrtn5Xyf3k4pREsg@mail.gmail.com>
		 <de070353cc7ef2cd6ad68f899f3244917030c39b.camel@redhat.com>
	 <3081793dc1d846dccef07984520fc544f709ca84.camel@HansenPartnership.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (3.56.1-1.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-06-13 at 13:50 -0400, James Bottomley wrote:
> I agree it's coming, but there's currently no date for post quantum
> requirement in FIPS, which is the main driver for this.

The driver is the CNSA 2.0 document which has precise deadlines, not
FIPS. That said ML-KEM and ML-DSA can already be validated, so FIPS is
also covered.

> Current estimates say Shor's algorithm in "reasonable[1]" time requires
> around a million qubits to break RSA2048, so we're still several orders
> of magnitude off that.

Note that you are citing sources that identify needed physical qbits
for error correction, but what IBM publishes is a roadmap for *error
corrected* logical qbits. If they can pull that off that computer will
already be way too uncomfortably close (you need 2n+3 error corrected
logical qbits to break RSA).

> Grover's only requires just over 2,000 (which
> is why NIST is worried about that first).

Grover can at most half the search space, so it is not really a
concern, even with the smallest key sizes the search space is still
2^64 ... so it makes little sense to spend a lot of engineering time to
find all places where doubling key size break things and then do a
micro-migration to that. It is better to focus the scarce resources on
the long term.

>=20
> Regards,
>=20
> James
>=20
> [1] you can change this by a couple of orders of magnitude depending on
> how long you're willing to wait

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

