Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4736C585
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762877706; cv=none; b=NrU7p/10lIbFsPkqX2TpFwvak47VgIyxSWx+Qc4B2I2TNQeRcRvlEkXCsQBvdxY0LL1ccxeHiZUsxsfbZyuu2dB6FM2v7FCnk7Ynhyvm+1y1e35nTQtBfynbOjnG0qpFA0dzayYZxPx5nYFt/1mGuXUkITBnleO6vjPrRZN7Eho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762877706; c=relaxed/simple;
	bh=CAzz4tdO9jRd3NYeIx+mzCdWu/XNR9YZQNSh6xs3tkM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bo11sOAn9FeGonubVe4DQVrsGzqpJExwSnfh9hcoNU0pKgB0vCYOBoEHXqJN8eyA4QU06lmiHiF3is5i0hxU4G/CNfC6dVS54halpYI4AaJC1+QJfOtAwd3Gx9U5kxdov00Llmw/GKgqc5exS359DsMlhWecvw8oWnGETH5TMUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShpdqHqd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7gO8GYo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShpdqHqd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7gO8GYo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762877703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CAzz4tdO9jRd3NYeIx+mzCdWu/XNR9YZQNSh6xs3tkM=;
	b=ShpdqHqd+rzXQjaYRwkTL8gcJ24Pgkfs9TIw6ziKC4xuK2NdrxtcRnkVHXUony4ixqWMAZ
	T+pG42eOOzzv/Ga/HnJxqzdBHw9Xy7bvHAYjroeN7yIJiOhyFSssJTpSKgRtbqnqry6tCq
	ju2Co95NeFB89rsiYwwfkIYg1M3KAPM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-KlonSBIwPACvpA8hKOzU7w-1; Tue, 11 Nov 2025 11:15:02 -0500
X-MC-Unique: KlonSBIwPACvpA8hKOzU7w-1
X-Mimecast-MFC-AGG-ID: KlonSBIwPACvpA8hKOzU7w_1762877702
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-89ee646359cso794849385a.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 08:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762877702; x=1763482502; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CAzz4tdO9jRd3NYeIx+mzCdWu/XNR9YZQNSh6xs3tkM=;
        b=f7gO8GYoC8MqmXdqCaeuPrwYc/o1ZTt5TwoG+7p497nALVc5haN6UkLoPC1fPUq4i6
         aqqVaMBUoXfZvcMvIIucuWFbg/+UeQGALsvDt9eabZLkj6ekGsR1pJY2zne/54OIbeOH
         RXhpKQw7KJs5Kauii1V+AVaDnTUecJ/QynXXQh03T4hwpopeyBgdR36oOGytl/XahJPV
         Y5nNtsQlj/K0UGYfQYABkfQP80YJWEa/6V+PspzlB1ogQRgNFQ/q5pOOuMqH2yggMaC+
         GZhw5EnbnY5BILZUiV3AyeYhNMPt7DPHSwpQs8XkQvO9yPslLowfkwaBnTQLK9doxkRl
         ldEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762877702; x=1763482502;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CAzz4tdO9jRd3NYeIx+mzCdWu/XNR9YZQNSh6xs3tkM=;
        b=F0ZRiZoufL/0iU79Y5nOVPllNpRJNVkHHATMIttaLOX/nDfwByZ/priIC+em4sIh/C
         GdjHNWtPGgMfTRk06bLg0zOTnoO7lMM6QfUAaLMasCF6HsNtVrFUn0J+homzY6UtiHUU
         +iUHiQtnm86xOPmq2e/SQo5k5eQ3lULWrgh7ycMroAlOjLASK/Zha+LalPVUllI/mn/g
         ZvJO6gzRAx4k0mn6m4T1s4uF35JTQbwrQRNH8cN2Ic34ZPFbSkyqbBCYqc2KWPMgr8VM
         hv0tn8sEQKxUPJ/RmV1HHiBIdunbLfh6EZ5zrwvrmjRyDeKxPeMaYZCka7Q4D9pgoKin
         4WSw==
X-Forwarded-Encrypted: i=1; AJvYcCUXf7zuxPxj8cnS6WjSVZA5//Dksv36UceEOhP2uKmuludVDT1Y6/nvzzmR//bic/FcCGGe3R6rn9QJDUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8/kZC+gLxCVSt0/rVx7l8223ZW9/xPxDyGrmWwvS7HYGG+VQr
	ZEjIbAa7jYrJBoxmB3xErEAupX8Buw0Tht6gDkxVBm3k0kfe5QSP0t7LrHE7Ho2CNqPtUPAyAtb
	y9MTf00f66fkXLj3oVGNV/acTgv2OxoA0wYSoBH4+9fHu+31i0JcRtadjvXnUKXRl1A==
X-Gm-Gg: ASbGncsIj8Dpa/40740I3jQ88WeVXax2reKV3e+J6P5K+156zbvzAcrx2LMEr9g57yb
	CpVttXlZceHNOWFw4eafocAUm76bj2eGFhxImsDBfQFZB/joq9zeurKTOAj5cvMfQfHIA7uvOdz
	BuS5hbNXjxky7Facpw1NOqOHJnQn5qYApkO75Ckb8GHL7ni8KYhRumGcor2j37w0NcvOM4xkWv0
	GO/2jWeKT3RBmF+IeWPZSvgc+dmM9cQ5MlhBFzSquKuMjOdfMnhuIRLdqzHrA71mil+/QVyguR1
	ts7THIDgOCYPNi9kz5n/+/A1sJvYpASJwEyL5WA+sFDeNg7GP/v9+dM9rc7MWztzfxa79A==
X-Received: by 2002:a05:620a:6914:b0:8b2:1f64:7bc5 with SMTP id af79cd13be357-8b257f69f9emr1539504085a.86.1762877701871;
        Tue, 11 Nov 2025 08:15:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZzM88+sgVGmR4fCbMdvG+bTstulnQHQtfzsOqHKlcvJHTzfGD4ZKhDU5deE0z92drdTBPyA==
X-Received: by 2002:a05:620a:6914:b0:8b2:1f64:7bc5 with SMTP id af79cd13be357-8b257f69f9emr1539498485a.86.1762877701360;
        Tue, 11 Nov 2025 08:15:01 -0800 (PST)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa25791sm9814985a.52.2025.11.11.08.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 08:15:00 -0800 (PST)
Message-ID: <1ce413b202ca7c008e077a6f1cfa88f94a3a7cbd.camel@redhat.com>
Subject: Re: Module signing and post-quantum crypto public key algorithms
From: Simo Sorce <simo@redhat.com>
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, David Howells
	 <dhowells@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ignat Korchagin
	 <ignat@cloudflare.com>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan
 Mueller <smueller@chronox.de>, "torvalds@linux-foundation.org"
 <torvalds@linux-foundation.org>,  Paul Moore <paul@paul-moore.com>, Lukas
 Wunner <lukas@wunner.de>, Clemens Lang <cllang@redhat.com>,  David Bohannon
 <dbohanno@redhat.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 "keyrings@vger.kernel.org"	 <keyrings@vger.kernel.org>,
 "linux-crypto@vger.kernel.org"	 <linux-crypto@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"	
 <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2025 11:14:59 -0500
In-Reply-To: <IA4PR84MB4011485C0EFFFF9F2820A1BFABC1A@IA4PR84MB4011.NAMPRD84.PROD.OUTLOOK.COM>
References: 
	<IA4PR84MB4011FE5ABA934DEF08F1A263ABC3A@IA4PR84MB4011.NAMPRD84.PROD.OUTLOOK.COM>
	 <501216.1749826470@warthog.procyon.org.uk>
	 <CALrw=nGkM9V12y7dB8y84UHKnroregUwiLBrtn5Xyf3k4pREsg@mail.gmail.com>
	 <de070353cc7ef2cd6ad68f899f3244917030c39b.camel@redhat.com>
	 <3081793dc1d846dccef07984520fc544f709ca84.camel@HansenPartnership.com>
	 <7ad6d5f61d6cd602241966476252599800c6a304.camel@redhat.com>
	 <69775877d04b8ee9f072adfd2c595187997e59fb.camel@HansenPartnership.com>
	 <3d650cc9ff07462e5c55cc3d9c0da72a3f2c5df2.camel@redhat.com>
	 <534145.1762588015@warthog.procyon.org.uk>
	 <IA4PR84MB4011485C0EFFFF9F2820A1BFABC1A@IA4PR84MB4011.NAMPRD84.PROD.OUTLOOK.COM>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2025-11-09 at 19:30 +0000, Elliott, Robert (Servers) wrote:
> The composite motivation is to provide some protection if someone
> discovers a basic flaw in the PQC algorithm. If quantum computers
> haven't arrived yet to break the traditional algorithm, the
> composite still proves validity.

Given you quoted me wrt composite signatures, I'd like to make clear I
do *not* necessarily favor it.

Unlike regular software or firmware, kernel modules are generally tied
to a specific version of the kernel, therefore there is no real need
for long term resistance (unless you plan to never upgrade a kernel).

If a defect in a signing algorithm is found you can simply distribute a
new kernel with modules resigned with a different algorithm.

The problem of using composite algorithms are many:
- You need composite keys (or at least two keys, depending on the
implementation).
- You will pay a higher price in terms of CPU/time for verification for
each signature.=20
- You will pay a higher price in terms of disk/ram space to store
multiple signatures.

It is generally not worth paying this price when the remediation is
easy.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

