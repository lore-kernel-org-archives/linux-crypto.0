Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3E313264
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758290368; cv=none; b=juWwMwWBspYYVOGuJyXzD2jz8Yfsrxzi1IE923MABMzsV/UGJcZ0hwJac154yyVtijiwfRqAo2g0HBrI3qCREzne3kZ7UzPRE2W0CtPQSZngCNUTNmTE/T0ohsG8+42DgGRZXIj1kxhyO/3Z0WZqyy2dIcd+UmyGGfigEr1hTvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758290368; c=relaxed/simple;
	bh=E0aKd79dQRldmcXYoHZeP6fkSHuLvXaXqPGKYoA27iA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X+JOsXPdc5brwFD1zvIKSU+erPIZaMdOj5BxRJZy34uC5k9E6xBiR0iwEv3rG6Hy499fNlt+6iYDUn4E7dCXSFyu1pX8JfvWX62rmaJwt1tW0vxzaWFdoeE8PTp/Lnh5dp5fHyJ5GAgVBFwa81xy4D7JiOQzrYfDRCJYyOKt1uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dJ/IJkwA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dJ/IJkwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758290366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0aKd79dQRldmcXYoHZeP6fkSHuLvXaXqPGKYoA27iA=;
	b=dJ/IJkwAxkhLJOIyoOQjYtKneWPgI+IvdVHWolZw0VRQNgbj789+hlTgvilEafWbcbnlzm
	8oe/w69K+0QOqeLNW1GZ8uPDHNkl3wI1HFCgZ232co0BVR4kcN3IspoEGyaR7KVtI2IwTY
	cTJhq1zqXfAE8VK+aWah7wGfehb9r0Q=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-yDK1UUXiOU6fWnAWs0r-ew-1; Fri, 19 Sep 2025 09:59:25 -0400
X-MC-Unique: yDK1UUXiOU6fWnAWs0r-ew-1
X-Mimecast-MFC-AGG-ID: yDK1UUXiOU6fWnAWs0r-ew_1758290364
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b5e9b60ce6so61602981cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 06:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758290364; x=1758895164;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E0aKd79dQRldmcXYoHZeP6fkSHuLvXaXqPGKYoA27iA=;
        b=m75D+7C3AqrQ8HQgKQj13KIdLamGPJeiFJqYNZHjdaGLdA2+FJULIneNQYO3QE8wZy
         h4RxE6a0EXtv1mjKtUi16JtRlkRs24nolHHgou3ykR5+Ln/zvJJFgrd2fQdytcmsKkEP
         LEKF8epP4NqiUsPLKHm8TMPsCk0jg4VtSMuuF+RfUhOgLwEtR6vkgHOZIpeTKrPLui13
         lBfTOLLFfRbENNc6hv+pVrRTQl12LorYV9clWnR3sfgHnFlCNTdx/S10Rg0kX1BXQ6+f
         he8xbCo74mYhR7qsaMDfIuwU5Yfven6wOw7ttOh6bFLisrMnu4SZhUaNx8kfRSH4I+61
         ARww==
X-Forwarded-Encrypted: i=1; AJvYcCXpPpxbxLEcZm0znQFYsqSStKZsfHtA5e4n1w66S0VmcIoR6dLq9Jp98e4km2Cwr3xS2Cclpj+iwaMMoGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl8VAOUjlrQntfGSH4viAviH7E/B0UiBlLQRmR0qyUPaSsQz/j
	NuJtLYPjPWxpDmAiYqolI4HEj1cUvMDnhYW817fiICgrvSe0RaTJVT8ux9MIepouMni+hdUiXJZ
	H9Ct0ufhaH9I44gahJpKLdGjSNLz1Gvl0xQgna9M6Cu62sl+79pUc9pQ6QvoJ39MKFg==
X-Gm-Gg: ASbGncsB5m+ZtnyqRlXL+D/5/78cHgxBX+oSJw+KI59ibLkuvBqh/+DwlJFrJ2XZEkU
	q2pxIS4jYyv+eXg/DrgxxBPOsuumgkAsZ8oHhQ6yyd6kYEMQs5T7X+RMaoj4+HjDPpDesNAXgny
	otNoqcwBnN7CK3S8K14K7K0pucTUugnqsEhRPMhrzjCisUzntRC1HU4Z19vSvRkT9VLzPUI6k/p
	9snPJgDzLJ8d125/SlVLPebQdDmIuRN74+0pL2fvNelLh86NMzgpM8O8zh3kJVS4wf1xWcnHFdN
	qpU70XDT+2OXwirzZ4LVtkKiWGfvStrJtA==
X-Received: by 2002:ac8:5dce:0:b0:4b5:f59b:2e7 with SMTP id d75a77b69052e-4c06cdd8d53mr40676331cf.9.1758290363008;
        Fri, 19 Sep 2025 06:59:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZORXfI+7Pv8Nbr9EEpWupK3RCB0YdG+gi72RSlWrDN1wMdtZXcENcez+iU5vJ3qPlyNBw7g==
X-Received: by 2002:ac8:5dce:0:b0:4b5:f59b:2e7 with SMTP id d75a77b69052e-4c06cdd8d53mr40676021cf.9.1758290362591;
        Fri, 19 Sep 2025 06:59:22 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4bdaa0c5156sm29082401cf.45.2025.09.19.06.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 06:59:22 -0700 (PDT)
Message-ID: <2df4e63a5c34354ebeb6603f81a662380517fbc4.camel@redhat.com>
Subject: Re: [PATCH] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA-512,
 SHAKE128, SHAKE256
From: Simo Sorce <simo@redhat.com>
To: David Howells <dhowells@redhat.com>, Stephan =?ISO-8859-1?Q?M=FCller?=
	 <smueller@chronox.de>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>,  Ard Biesheuvel	 <ardb@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, 	linux-crypto@vger.kernel.org,
 keyrings@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Fri, 19 Sep 2025 09:59:21 -0400
In-Reply-To: <3788819.1758262666@warthog.procyon.org.uk>
References: <2952535.lGaqSPkdTl@graviton.chronox.de>
	 <3605112.1758233248@warthog.procyon.org.uk>
	 <3788819.1758262666@warthog.procyon.org.uk>
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

On Fri, 2025-09-19 at 07:17 +0100, David Howells wrote:
> Stephan M=C3=BCller <smueller@chronox.de> wrote:
>=20
> > For a multi-stage squeeze, it is perhaps not helpful to zeroize the con=
text=20
> > here.
>=20
> Yeah - I've seen this now that I'm starting to trawl through your dilithi=
um
> code, so it will need adjusting.


I strongly suggest creating a test vector where multiple absorb and
squeeze operations are done in intermixed order, and then use that test
vector in your Kunit tests to ensure changes to the code do not break
this fundamental property of the keccak sponge algorithm.

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

