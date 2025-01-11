Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3E428FF
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jan 2025 00:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556570; cv=none; b=YQJ8RySOtK2cDpa6jxQgyZZ6oWCdW1z1XybTJ3kwVYcFwdzkVh/ORNv6ul8bvhrAUeZld+IjRb+9PxzZbpo9ZaUDs9LSepeuNf2TvPzSJzSI1wCWDDhjJJEPme2dAH18xo4Gw5PFZkffNtVk00SovZzXjlqXRDqeGKYIRO39TCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556570; c=relaxed/simple;
	bh=DqbsPM7pbMq3tNO53LpeaJ86ETg2ScGj8LGDaaUTLJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hRbMhszJA58cwjnaVHOkKo1FcWGq/4Jf9sxWDD2L9UPKhzmCifyggouCC6E4vA+IvIL/N4UZ1pL1302MkZ5oBWrvZXI9nS+yNIv6xffNHTgpntROmzssR7sEsh90Yb1t3hlHRzcaQShNcklyV6NPQcI4TYbEfGCUcGRQUdYtcyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nu902t86; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nu902t86"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee46799961so6695965a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jan 2025 16:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556567; x=1737161367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YX28d/CEykAYv4b51S4uD+A1lpSwnJPjWn7kTo7F+wY=;
        b=Nu902t86+h2+UCpAerjCkL1TxbV1qTw+ub+wiooHKXwFb+VvD7cGumqCUdu4VdJaVC
         wQRcVfcjLeG+0OD+ph810tBX2DRJnI1sKuYSWyaYS85EkRagqODZsqYf4Nh5Jlf8MWfU
         OoblEve0Cu5eGvBTfN0E1VBNgLEwTRwRVkuAOTnlFaUSNboPXKpf4nQ2M4WirwklA9I4
         L5GyIAofAqrnmPwlZBuC4nSx6DrCGjg6kLbTs5u6YVuCOjk35n+cCqh7qib4W2uJ3JNQ
         S6pEt9JhWGBvZ1aI0GBgJXJxfkCn6yXuS2+b6AQTFzW67CTkKeIGuAK/O1p8hz1VGjth
         1txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556567; x=1737161367;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YX28d/CEykAYv4b51S4uD+A1lpSwnJPjWn7kTo7F+wY=;
        b=JazGMfyUSWrj8e8udTKR79IA6zP0YkShEnQ3Ot/A+0/3HSy+3j1TQ/tSeM8unB1pQX
         5CImoT19t5Jgk/7GblsjbdY+AsG+YgYbRhIeloT825wcP2rq0+ESEQNIXuHd4n1Pm7is
         a40xAtSRURwTRz07GZ2VXV4NjGxApZ+KZW33a9RDm6JRhgPQaNm9TMTYo52QAhWfFDAl
         8Ol/r+eetkN9lKjv8UXhz2YzaRZEZ4sNgCxdoSrOwciGl9+339pi9mnaBxh5QQCp+In0
         Jz6fijo/3TCuDluJqV6JuVdpjDXhDn6NPrpn98UgXv88ML2JClBERewx+pMEgvc/Pu6C
         udsw==
X-Forwarded-Encrypted: i=1; AJvYcCX3QVGmfn+VZzqci2PO75883ApFmV6xyKtdqIRuR5kC5U3WQqZqArWAfMcYf8rvG/tguem79XPW7gZvAS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqelSneuIRlVSn6InnRTgNrY90mam67n0Pg2C1Kl2S1aFWRW52
	PmYePHkichi4eQLLnx/UcY+4I2La55Wb8dhbx7kj+axsTiEqy1vq5a0YqiYFw/dwCFedSGfSyig
	crw==
X-Google-Smtp-Source: AGHT+IH361hyEP8ZBxDjRVTWmQZDmlNvVhHg1tXUKZ2PrfsrRNnR2/vcWBj5z0ljoK7+gcYBV3qV4n3VGY0=
X-Received: from pjbhl13.prod.google.com ([2002:a17:90b:134d:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2747:b0:2f2:a664:df1a
 with SMTP id 98e67ed59e1d1-2f548e9c9bcmr19626538a91.2.1736556567441; Fri, 10
 Jan 2025 16:49:27 -0800 (PST)
Date: Fri, 10 Jan 2025 16:49:26 -0800
In-Reply-To: <CAAH4kHZn_gtspOisv6gxQiD=JeZbZstQoR68mFCxn34Am76Bdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com> <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com> <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com> <CAAH4kHZn_gtspOisv6gxQiD=JeZbZstQoR68mFCxn34Am76Bdg@mail.gmail.com>
Message-ID: <Z4HAFmyhw5DeIRBT@google.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025, Dionna Amalie Glaze wrote:
> On Fri, Jan 10, 2025 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > Is there a way to change the load order of built-in modules and/or ch=
ange
> > > dependency of built-in modules ?
> >
> > The least awful option I know of would be to have the PSP use a higher =
priority
> > initcall type so that it runs before the standard initcalls.  When comp=
iled as
> > a module, all initcall types are #defined to module_init.
> >
> > E.g. this should work, /cross fingers
> >
> > diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> > index 7eb3e4668286..02c49fbf6198 100644
> > --- a/drivers/crypto/ccp/sp-dev.c
> > +++ b/drivers/crypto/ccp/sp-dev.c
> > @@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
> >  #endif
> >  }
> >
> > -module_init(sp_mod_init);
> > +/* The PSP needs to be initialized before dependent modules, e.g. befo=
re KVM. */
> > +subsys_initcall(sp_mod_init);
>=20
> I was 2 seconds from clicking send with this exact suggestion. There
> are examples in 'drivers/' that use subsys_initcall / module_exit
> pairs.

Ha!  For once, I wasn't too slow due to writing an overly verbose message :=
-)
