Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F84312807
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758290232; cv=none; b=qF5c2W5p3QkZpi930pp9HCIelQX+5xWYeb24ePOQRA0RcJ5Mm1dSi9NkgtMNm/BbWgjH8GE/hetibYcj90NUhXhpisv1OUqdVstDOzpDik7B8ppECvkT57jM8imAcfQSGv4FPRQro8+E9YJVGw797K9ziCTza28owD5t2t0oa1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758290232; c=relaxed/simple;
	bh=DMNjFIRdYGAFecE5NRxl03iUEzlodfkNNlXpcwuF6XY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d67La0PPLnDXh/XuOQFxkpXrnRxiLoy58VlOY7w+tj4Zdm7FvCul6tp/+CJMelfPdAl431ku8gd5TASV+YMZ2dN7IUPObi7+gZPFp+dBGlVobgI5BVuApzPN7wyvwAkuZMRKCwW4A0MoWrRWXmEGB91xHKH+VNSFtDvy+9R4fa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YD7erpR4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YD7erpR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758290229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjHyPThJqMEaxjiy8ZOBD72S9ScmNjfADYppC37Xj4I=;
	b=YD7erpR4x6LGMzGswMolAKBgE9p7h+laGWqBVH4pTm89dv90pkoUJ3koAJHiQ4sIR8tmJs
	UP1IbuJXVDa+D5Wuan1DDEIBij4/aoX/wdwxkifv3s3E/ULYIf9VA1AhiUpZkbL+q9Xm4B
	qMNedAVeC6XVYNGCeKTQu3h9muE2BRQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-nyXR8R3iMFiC7mtdbrpaIg-1; Fri, 19 Sep 2025 09:57:07 -0400
X-MC-Unique: nyXR8R3iMFiC7mtdbrpaIg-1
X-Mimecast-MFC-AGG-ID: nyXR8R3iMFiC7mtdbrpaIg_1758290227
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8217df6d44cso344528785a.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 06:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758290227; x=1758895027;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xjHyPThJqMEaxjiy8ZOBD72S9ScmNjfADYppC37Xj4I=;
        b=YPdJ20EydBbNyIBLGQlkKGstsS79hH98Ekkl7kRSZrxmW7v3lYSLhiHciOYxhsCGHn
         tH9CdHrUS41Y30FMSxnNLvgMQBpaeHuB0DW90e2g4jtWqW9mrSbtcqGNTHwVtbZeaaVy
         Z40gfDPMTPyy+MpEOOvw3vtSypomMydl8RiF9v3wup2jSljL67nLVH5iFYZtUwkm5bL7
         gwpgy1TzurnAvq3NXQu2y6KhukC6N+JhTNq03nARZAuhjWJacC5/gvolNSj/vl1Q6JfO
         0/erEdbwNXw32uQf8haOWYOb5HsPWKTr4pFwrymP1DAoLCofQzgdaBn4lnhsT/iJD1QJ
         EO3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmWRZ4ItWgUKineiN57TJ0J0LEiA1S2iLQCdRCgSnEsYgApKXSeLe66Y5pJ/xrvqcEDtHi6hTT0LCLHII=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtYaX3XY7ha0GUNRTU8ZWi87hZ23ISndRVc0mJhrz6M85rdewD
	AYeVH4eVp2Q8scFM9DZRur4BjWY0VB97IRGe9RqrJ5g4NXC1a7OPXSmWa7EQiO729WFlEi/2Wxr
	nH0CoQsBw82wiP99NKM8Ybt0yWUJJOIoeb4Ln+ESj6QliTxLJjSPp7UG9QZXoc7oJZw==
X-Gm-Gg: ASbGncv5q3cYsaoY0pOAx5LpElFf0tZ/QMLtQRpynsQX07tLPX+A85xarGbRipCGwX9
	MPbwwsoAO+R5CIYxyZOUYAiA1Kc22vYKqqlG6Z9GF3zf9r0vQ0Y/qlD6am0+0W5F7qLVvy9GxdI
	7LzfLrvTzgBcT0yN+1uIvIESDPoajSk0hqqssmu0AEvRZIjzuekPPfe1PypvmjEfAqBhUKAX+Mr
	JTmu7XWO7Xi5JjUUeCWTBYAuxfBbtVRKkYStdM9UGeOnopHaxyvXHsehguRrftcwfoT43DSaNr2
	XS9f8I0v1ZrOshMWWyWU4DbhhtsQcpWY0g==
X-Received: by 2002:a05:620a:4054:b0:829:cc0b:847a with SMTP id af79cd13be357-83bae441091mr341931185a.85.1758290226961;
        Fri, 19 Sep 2025 06:57:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfdS/zMLLd7FzsPOjcM9f2BXteVuayDMDJGYkajXEj37EsJLk3BN8J/COqLEMvW6R/aSvFzg==
X-Received: by 2002:a05:620a:4054:b0:829:cc0b:847a with SMTP id af79cd13be357-83bae441091mr341928285a.85.1758290226568;
        Fri, 19 Sep 2025 06:57:06 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83626595a14sm345727285a.12.2025.09.19.06.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 06:57:06 -0700 (PDT)
Message-ID: <31fa6cb0a6b72b9ceed9bd925d86ad92b78b5bdf.camel@redhat.com>
Subject: Re: Adding SHAKE hash algorithms to SHA-3
From: Simo Sorce <simo@redhat.com>
To: David Howells <dhowells@redhat.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Date: Fri, 19 Sep 2025 09:57:05 -0400
In-Reply-To: <3790489.1758264104@warthog.procyon.org.uk>
References: <aMf_0xkJtcPQlYiI@gondor.apana.org.au>
	 <2552917.1757925000@warthog.procyon.org.uk>
	 <3790489.1758264104@warthog.procyon.org.uk>
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

On Fri, 2025-09-19 at 07:41 +0100, David Howells wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
> > I presume the algorithm choice is fixed, right? If so you should be
> > using lib/crypto.
>=20
> Actually...  Having dug into the dilithium code some more, the answer app=
ears
> to be both yes _and_ no.
>=20
> It's quite complicated, and in some places it uses both SHAKE128 and SHAK=
E256
> fixedly, but I think it can also change the pre-hash between a bunch of
> different algorithms, including SHA-512, SHA3-* and SHAKE*.  At least, I =
think
> it can.

We are probably not interested in the HashML-DSA variant, so you should
probably ignore that part of the specification for now.
It is easy to implement on top of Pure ML-DSA if you allow the caller
to specify and externally composed mu.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

