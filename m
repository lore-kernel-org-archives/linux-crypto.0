Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41FE218EB1;
	Fri,  9 May 2025 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746788487; cv=none; b=O3equcl+Z7p7Hl1oomW1a6laCRB9rQB5t6fMqgmZugFLqLohHPS3HsxJXoyn5wwRsCqSwhYpqjfpwZ63Fdq/y9jiB7JXvAQrfbN2SYfY5xAURKfoFcJQpI0Ou6ssIHSh3gE0oxjcCxigZ7/SXidP9WSvSsvZeT87LR8Ub0jq6CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746788487; c=relaxed/simple;
	bh=gRgLFX3wudpilZbhg89XKnOTVJhitrzM2EL48kaXQIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fowYU7zsuty+6rnhZEMPrmqXoBqt9qdSOEH1RirsthnqTD9NYoFkSeM8W9zNeBkgHmnnWRs1QntOgG2KJvEAA+ivpml7iLAP9+BgxPWwKByns69vpyK1ffd6kNvyk8qr0YLpj9bAuf9DTHQYMc8QKp/Zoi7u1T3wTCgCYWKPRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOQ6qiBt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOQ6qiBt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a1fb17a9beso178404f8f.3;
        Fri, 09 May 2025 04:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746788484; x=1747393284; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r53khiO3ex71dGFIBcMlSGwX4XCBTtxUE+p0BbXkqFo=;
        b=bOQ6qiBtWmUJBqJUHnTjFVAcT2k1Vr8P2CNv2wxfNgqHRHQl1Ww+zEMhCdRIvYba6s
         jHPaLyPI+yQbAMeRpN/ItUKP+qa8hlYS6Asrn25FWvuSaGPHc6nuHA2hYtZWymEM7nqK
         iq8bKrqfRTeHhOzRtjlDdSnt6pAMEen0PiR0dh+e9lPuOqlGag/buFo931kjOVeuLbWF
         GY0J9/uAJMiLLxOnyvJK7WS0OFv8WPVFPPruBdP9zVxWuoPDOhhSPEPScAoiaOW5FWQC
         ofJJ9RXhKgHvnQcxGg25fF9ZxQx8otBA6uR4+ZlXrn7rQGTMaN59/A8AXbY+N7kyd9U9
         HEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746788484; x=1747393284;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r53khiO3ex71dGFIBcMlSGwX4XCBTtxUE+p0BbXkqFo=;
        b=DOa687Fxa9qf9iQdhOFVm7m0ObZ5XNol9M+COtcRDDIrvxU81TRXDMVXOmmC0t4hfF
         PJ8TDzsYAh2ezRXnvkyk6IuvDutz+EIeP68ag8pqHq7AnvRdsevMm1AvD6vCjeYrKuPX
         JJwHEG8ogWWpx1cVNnq8KKJ3ihUGSIGOGUbVMoMJo8ICEo3ak2SAzOVIO4WoME+NHM8u
         spBODrDVEXP451LLfPXZFN21bh/yNH4ywrKgAfC6nGR4PwKSYzA3+KGkVA2CxKju2a4G
         WL3wHtjyQ71GW98nRtz353OWXrXXnb+gpgKH539a9FpyOK3LaccO+KwivPFVx1zhAeJi
         YNgw==
X-Forwarded-Encrypted: i=1; AJvYcCWfsZe+EE7u1v/yKrgZP8thf9IpcdBPoxLr7pKu6gKa+ucb4Z5d+Cv4FkWqR/7Z4rFF27xL79wBoMSdzf0=@vger.kernel.org, AJvYcCXn0lbPOfVK0Ir7Wz61U95U9HF90659o7eDAZjyPrWAZVShFE8mWhlsuwLuMqJpXh52CLXDl/UilgY4IpLw@vger.kernel.org
X-Gm-Message-State: AOJu0YyAml8b5CLWST71kuvTeqa9RhYsnKOqU5KRCe5s1N54nTof1M3K
	zbPP6LrGjX03HnuF3PWmq1TuO3ZL8UZvLJrQSxubKWRN29bHWZCk
X-Gm-Gg: ASbGncsEsM5jhHfh3OFygnz9yhNHjRJ4Nt0SIEbfN4vK7HBz27l0PaidYthpgaiTIfT
	1Ips47ZIcWhVBmJYnjpMZLO0p8Wif/1XU+t2dAkT5FP5SLSXcUtJTLw1HqXAQE27Byrnnq+nl/j
	aWY1Z5GE4NiZH0nI8PwCnWGLcz+l+aaHQQ7jW1i8jHjDc4HhPjv+U3txN+g5b5eZVYCOjoMaEfP
	33pGQQBgf86lQKBQ9Gd049XfslWWSb2rzuFuQrugp7lZq4pEbp2RWI9IpYAREnL8dDgcgTxkZQi
	ZCF3EzDaQJUKsPstmfMt6tSeIwfPkXrCvcrEvbJltg==
X-Google-Smtp-Source: AGHT+IHxdrrT1mXNTg47HWfTSTmmEC51lBLDoX8qYM2Pqx0cEOFChgQ2wd+oIPWDgDsHqFvJei+Rdw==
X-Received: by 2002:a05:6000:430d:b0:3a0:b9a9:2fd9 with SMTP id ffacd0b85a97d-3a1f64a34c6mr2544261f8f.51.1746788483860;
        Fri, 09 May 2025 04:01:23 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a1f57de100sm2871878f8f.2.2025.05.09.04.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:01:23 -0700 (PDT)
Date: Fri, 9 May 2025 13:01:21 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB3ggeQDdaPblUxi@Red>
References: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
 <aB10PqZNk0L-ly70@gondor.apana.org.au>
 <aB24nSeEJKtP1bO_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aB24nSeEJKtP1bO_@gondor.apana.org.au>

Le Fri, May 09, 2025 at 04:11:09PM +0800, Herbert Xu a écrit :
> On Fri, May 09, 2025 at 11:19:26AM +0800, Herbert Xu wrote:
> >
> > I wonder if the skcipher code is corrupting the ahash state when
> > run concurrently (and chained together).
> 
> Please try this patch to see if the hashes can work without
> the skciphers.
> 

Hello

Got http://kernel.montjoie.ovh/478064.log

Thanks
Regards
