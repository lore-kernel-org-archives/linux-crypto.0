Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A14D2DE6F1
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 19:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758049409; cv=none; b=Or0gqV8skX/7ETqAeNpFTr3De6EGRvV4WpS5CM/9m/1WlqIUH4W4c8qw/d/vrgHyIKj3mhX15eB7gbLkD9BOqtdgRMc8WM0UXxo9u3ZmtZXd7cy//qyGSTnATrdje7PXEzk2WzwvnsiS/+JGrlFnoYD7ON5EKC8t6Idz5/bfO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758049409; c=relaxed/simple;
	bh=1VNTL957WIhvioTfh4/tsp4JP4WAxr+HVfO9vcJE9mU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rZylNyOubIqLNZjasrUkjHL8PJvHnHhmrvPhRDXuZdAOxxpLo2JKsMHegQJGS3fqattZG5CfJu80s+rrHa9miFxXYRh+IQiE/qBwJIxNpdOO0wVWd6EXrtCizm72yMRRqhIJ0MDXrfcKVX4sK9vnGi9JNBEt5rpU+4EZE+aCBsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TSz7KWuN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSz7KWuN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758049406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1VNTL957WIhvioTfh4/tsp4JP4WAxr+HVfO9vcJE9mU=;
	b=TSz7KWuNj82rjPblB1uYqa6hDyIleOX8fYBafeo+zda40Id4L6HxsXM9cPjFPjg4uIlT0P
	e7rmLOAWYyq4PjRdch4bOJ57FhltctYHNIlFPBTUbSI5DLivJUtQkNt+9iLru8/p/UZ9rJ
	xGRKAUBsNipk+zSMqF1ifw7ZskSDZH0=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-Jd046V-2MkStc4juV_H8rA-1; Tue, 16 Sep 2025 15:03:25 -0400
X-MC-Unique: Jd046V-2MkStc4juV_H8rA-1
X-Mimecast-MFC-AGG-ID: Jd046V-2MkStc4juV_H8rA_1758049405
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5448916dd51so1909212e0c.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 12:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758049405; x=1758654205;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1VNTL957WIhvioTfh4/tsp4JP4WAxr+HVfO9vcJE9mU=;
        b=frKF65OTrMwYI98RAQs490yMhKuOZHOIju+DuPlJSfg6Z/PM3hYr7vwEduITtq3kLT
         6PRGqibCSzvSoItajea1vNZ9Q3v909H3Ow173daAiC0wJp7KgYTFpNqInMQBGgN5aQ1s
         LiQmqjquR2lWvF8e/LRmGSBTp5b6iMX201QQ1hzLdtUoG+6Ggczre148Tc8P5DBhZDua
         4rshQ9hFwayKbn2uzFeT14v13pC1yq6zmxR5OubMtI3LzwxVDs+xp/qMHqlFk1ekYb9G
         0zu/99AXbVn0vKpr29EmyYgd+3QhR7MZRDIW1YAe1261NPm5c4AwUGxT9SYgWG8fZ1hm
         qOkg==
X-Forwarded-Encrypted: i=1; AJvYcCUiQ/eet1fprTbhfBKhvDvIza/Bbst/iSO2f996uJ3AiZP3DEITlVdRzUMcFJo7oUx1njU11fPVK/HQYG0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1h0M8lUCnokEMFAVZghMbiXRLJKYDgh/d4/olJ3Y1cGPpPiUS
	qbXhQXmmKxX2oyFY90F9SMZS8qyZM7UZ+JF84hjJjTw7n9kfnb5t5EUfbB0x/H5hMFK3FpBiHe7
	KiO1kv7kF2hdWrHkUwFVM+E05IdFB3Tkbqts1YLyUdZuxISg09dIv6HEip+4N6FRGdw==
X-Gm-Gg: ASbGnctS1vkXyumePJ9JcuUWXsx1t4NOFUNukfPOjTTLNj59f8TJAeu20NDt1iVRB3a
	hoBMABBepKv2yIJULA/bVUb+DmfwrUrhk2DhsmUZAJcyOYY5nET620dQV/7/UAl9UKx0NVcdJF6
	Sx5GIQrgwSkYiXsRUJtxbuaHFYho7w+WLslFiYJIFDhQVAQcp8wHS+QVXjxhyfgpkq7EsvrTit9
	2ZCo8iJLNh4GfZdfBoO5uQwnuZdnbnEDe9NmnvQi6Fbv7s0IRizeP1RHmLKPg4IAD4kx9lB6bji
	jEHHo2Szx0MqrOInnCm6QWly8vJ7Raltgg==
X-Received: by 2002:a05:6122:1acd:b0:549:f04a:6ea8 with SMTP id 71dfb90a1353d-54a16c8a782mr5005455e0c.9.1758049404628;
        Tue, 16 Sep 2025 12:03:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUJaABKCnPu+9dAC9ObU7pvuXaGco2cLR7bJnObkQ9soP+eCsQOzFxULb3IY0kBcrWcvAahg==
X-Received: by 2002:a05:6122:1acd:b0:549:f04a:6ea8 with SMTP id 71dfb90a1353d-54a16c8a782mr5005300e0c.9.1758049403460;
        Tue, 16 Sep 2025 12:03:23 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820c8bb8d9esm1025710285a.3.2025.09.16.12.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 12:03:22 -0700 (PDT)
Message-ID: <70efab856f0940cba715572c417e0b249388da14.camel@redhat.com>
Subject: Re: [V1 0/4] User API for KPP
From: Simo Sorce <simo@redhat.com>
To: Rodolfo Giometti <giometti@enneenne.com>, Ignat Korchagin
	 <ignat@cloudflare.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers
 <ebiggers@kernel.org>, 	linux-crypto@vger.kernel.org, "David S . Miller"
 <davem@davemloft.net>, 	keyrings@vger.kernel.org, David Howells
 <dhowells@redhat.com>, Lukas Wunner	 <lukas@wunner.de>
Date: Tue, 16 Sep 2025 15:03:22 -0400
In-Reply-To: <ca36a11e-ca2e-41ee-b0d3-f56586d50fd4@enneenne.com>
References: <20250915084039.2848952-1-giometti@enneenne.com>
	 <20250915145059.GC1993@quark>
	 <87f17424-b50e-45a0-aefa-b1c7a996c36c@enneenne.com>
	 <aMjjPV21x2M_Joi1@gondor.apana.org.au>
	 <fc1459db-2ce7-4e99-9f5b-e8ebd599f5bc@enneenne.com>
	 <CALrw=nEadhZVifwy-SrFdEcrjrBxufVpTr0BSnnCJOODioE1WA@mail.gmail.com>
	 <ef47b718-8c6b-4711-9062-cc8b6c7dc004@enneenne.com>
	 <CALrw=nGHDW=FZcVG94GuuX9AOBC-N5OC2aXiybfAro6E8VNzPQ@mail.gmail.com>
	 <ca36a11e-ca2e-41ee-b0d3-f56586d50fd4@enneenne.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-09-16 at 14:33 +0200, Rodolfo Giometti wrote:
> I understand your point; however, I believe that allowing the AF_ALG deve=
loper=20
> to use a generic data blob (of the appropriate size, of course) as a key =
is more=20
> versatile and allows for easier implementation of future extensions.

The only thing something like this allow is huge foot guns.

The current trend in cryptography circles is the exact opposite, ie
strong typing where keys are defined such that they can be used for a
single purpose even when the general mechanisms allows different
operations.

Ie even if an algorithm that allows both encryption and signing the key
is specified to be used only for one or the other operation with
metadata that accompanies they key itself at all times
so the cryptographic implementation can enforce the binding and fail
the un-permitted operation.

In general using random blobs as asymmetric keys is just not possible,
the size alone is no guarantee you have a valid key, so you would have
to spend significant amount of CPU cycles to validate that the blob is
a valid key for the given algorithm, rendering any HW acceleration
effectively pointless by the time you cross all the layers, context
switch back and forth from the kernel, validate the blobs and all.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

