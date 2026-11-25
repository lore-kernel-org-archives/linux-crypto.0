Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642417;
	b=uUCFFj5y/b8baI5ib2Qm2ACtsy7AzbFQTVyuZTKqUGbSX/NBbbeCdy/fqzn/wV7ILn4i
	 x6PK/0o9C2qLg9pdqBXhgi5LIafGK8JoFVpqS4AeU0H55qHHh5zt9HpljXhtFXjbgHDva
	 QSXn6XCiLGclBoOFqBM+uIonDQdL8YA82YiiCE2wmT2dtu6FUGn33N6Z08PKvN9yr7TUs
	 kwU0TS+/qEj5ElWIKCjCT51LzLIfRwJbManmuddcuI7VyuJyMBdFSm/QEvApouOZVEzUU
	 xbaVKsKjGxKdPX4eSMDDBB3YfqwpA5OuC8djwbIIr4zd6Cyy4v/h1HQj4ReXhcZqRVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
	b=Hx9OhLKDXGUfGx9lHlKqOwYq+8jMMjtKTiZLXmGwwd+tj5BWo7czO/VwzOzNPrD8QasA
	 D7kcSrwUl8C0gLqJz1MKaglJNayodvtme15Dqxa7iSicSmOW6bmuBJ4rTdKJRxsXxxm0N
	 BJAqEgyc5F/77Q5qV0uF3IbgLOwDTezI8pUvX+NAdyUJSQrj/K9HDSb8h4BykBmVi0TaN
	 EpSvRlLbTOZqkjbUCnhWZ+n6CjQKtH2ztZOHkJTWH1q/8YqskZDqDbQXX+u8n5IANOv0f
	 Aqp2FbOYxB0oZBDSc0K10VNKPSzPDAfNX+Q6N151P4rpTXsRHQDS6y2wlcvQeen9azg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyaNhQwk;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD75606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 21:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CD75606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyaNhQwk
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-49412eb1474so4084833f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 13:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642416; x=1796247216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
        b=LyaNhQwkXbqpnZKQEFhSkXYdJnRuGKBuuLo4jMsASztOhDAKo/KLjtuUsGuJcBlEXa
         L9q5KsH0RDu7VhTtDI/7sQNdeUHKbiCE4UoTYbpDjatBwUbHY0aghBKcJ1jAy3etEkOB
         SRACMXZz5iIdXEUmV0YEGNUmGpDA+sNgu6gEYF9DmXC8KGwmX9bCsi/CJOLNgO+wTbbG
         lhvnHY38xO9YEx6YYjl+XslYqIdorjHMYTu7z3o6izDZiq+V8t7zvkDvaFfxCYiKSkSe
         OIEvBBzRuYo1TczJtkPUnW8+3ij30yPkrtXbZqfgQ434wojlx8AeDgewp82b/5hogoP1
         RBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642416; x=1796247216;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
        b=18tTL9U6c9XeV/qH9PH+gCP7XPO1H4wVHR5cqLnyamClbB9ikds70cUc5VfgyqdwRs
         r48ZZ+wGEqIhw+jeDPz9XAlolvPzOj5sN4boFIrJPISGsGpO5VKF6b8NEugHI57ea1JR
         YtNLIvPu4Ke979/eM5kAQc5vOk3uazwG5Vqi0XNhGJYXLgq/7+dkszjZln1RPCkIFvTr
         kHNbj1jsAgzlVF7BK9DEsAs/tpviDZFE4QOFj8UuTX1Ut9NRlZbAtIqt+HxaCKxXcvB1
         Tl1eeqcqDKWW/FdHqCjG+/4Xzgq4qwNUqM9Vv+H79KMnMIBbTWRh9ShbZ70K4RaP/zyD
         +XSA==
X-Forwarded-Encrypted: i=1; AL+hErEEfnf2P8sloTpJmmNAb7cML1ZBnelLaAojFLx/9NBQN/5XCdlb3h4Q6zveY6n6qArpf9qZr8tsjDMkJ2w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+xW/DSmc0974E/xtglc5dJs+dutvS7VPVLGKQYBmmPj53ODRDa
	QApEAihVgsHkUAO5/r9w6JIYDQMNvKE12uRX5C8RzWs5RwejQ4XKcufH
X-Gm-Gg: AZFdTZcp2PiTnsYndBEYHFVdFLV59HTugWBUvVTLGhH2rQl2Q6dB5JXyGYry49Zvh7E
	rDUQEz1MFvjInTYTOzPJETZVlKyfNFK3eT3mR0n2lPVSMtEjWFGClIqmTlFFOSJpkRLaUdsogqU
	j4s+p52wWGjfFGWVife1IdZ7XifQULYoJF/1V2Y2k38VODMOJJmDNGKc2PtLR70bN65P7BQts4r
	E6M1yPC2U0x/Yhz5GYDeTybb55We9FIhaqLktVagya9f3QZ6ynK/S0JoofgCGAFtbb2pJiMOVfp
	ceSsij9PhqFGMDTPnkg2+LQrTFT7QC99AMjns5WP+qjXnmf0GjTisKygc1iC6bMRuatnVs+kyKN
	XtsmF6ieHmCH1jrJQQ3xvGBo9Tqkxg+gSNtjPgWeXiuspQ/KdZ4IzBaFphdkACeOxi38R12V/i5
	LxRobwyti3c4/r3QtiCnpqldCoq4s44jGPNAJLVRTY2tvmnDQefj5yRecyQyf8m+nQafrhKH2wi
	hpy43KD36Z202smXKwgwt3OfLxapNawIt5irqErX/Re+NwNbeXFvTtZCY463brg+kBPNhfwyT8r
	lA4Jq+oocf2oW1jCO6aYOTzMY3ilD11hl7hdjf2ZpHFij00KGat4r5m2HsJIxIek8Q==
X-Received: by 2002:a05:6000:4a0e:b0:48b:db7:86a7 with SMTP id ffacd0b85a97d-4abb7787c05mr35815085f8f.50.1795642415460;
        Wed, 25 Nov 2026 13:33:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a680355sm30439805f8f.27.2026.11.25.13.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:33:35 -0800 (PST)
Date: Wed, 25 Nov 2026 21:33:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Ahmad Fatoum
 <a.fatoum@pengutronix.de>, Alasdair Kergon <agk@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Gstir <david@sigma-star.at>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, David Woodhouse
 <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat
 Korchagin <ignat@linux.win>, James Bottomley
 <James.Bottomley@hansenpartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 2/9] lib/asn1_encoder: Add
 asn1_encode_integer_bytes()
Message-ID: <20261125213333.23eedef1@pumpkin>
In-Reply-To: <awcBD-bp27JCVpc-@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-3-jarkko@kernel.org>
	<20261125091921.4bf40279@pumpkin>
	<awcBD-bp27JCVpc-@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Nov 2026 17:38:55 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> On Wed, Nov 25, 2026 at 09:19:21AM +0000, David Laight wrote:
> > On Tue, 24 Nov 2026 21:40:36 +0200
> > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >   
> > > Add a helper encoding a positive integer from a byte array in big-endian
> > > format.  
> > 
> > Interesting...
> > You allow for integer values longer than 127 bytes but don't allow for the
> > much more common likelyhood of the encoding being 'implicit'.  
> 
> This is the first thing I wrote in 2024 and have not touched since
> without further feedback :-)

I wrote an ASN.1 encoder/decoder for a tcap library a few years back.
Pretty much everything was implicit and some of the tags exceed 5 bits.
About the only things that needed multi-byte lengths were constructed.
Oh - and you can't fit in a maximal length SMS if you use the indefinite
length for constructed items between 128 and 255 bytes, you have to use
the two-byte encoding.

There were a few functions for 'add item to buffer', but I didn't need
this one.

David

> 
> 
> > 
> > David  
> 
> 
> Br, Jarkko

