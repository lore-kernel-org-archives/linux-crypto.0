Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7E2DDC5
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jan 2025 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556135; cv=none; b=UOQ0DVKctpXR02Cv9aYIlGKuHFQ8xFKakJeXmtu7WsDFIXskntGa9I/Gb4ld+a2aNKIfQxv+pxcBH8X8BX4sLV7ASDajWxGin6eAmAvipvwA7MZC37Y6iIe8Q8ZPLQhcdYfbxfZq3Lx+58fNj6SSLGDe183sd4NCU+sAwLfCKEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556135; c=relaxed/simple;
	bh=hRD5KbUlL2kRCf11F1yR1V2YcLXONkcm5oTmEpI5QFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TXh6bQSrKMdg8i5CKRlTYAGrUveF/7+bbVSiTgmVPEEmQPg1xhoVVQ1qP+dfZedY3dVI0T47fcpJ5u8L4du1KiaRSS6XRfuIRo8D/FefhFFiLT+QyGTXyl1o+uC69B/ByhRoDMExdvlljvwQdXJTifQIPk8w9Z34gUWTggKU3G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OMPnomCy; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OMPnomCy"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaec61d0f65so470922766b.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jan 2025 16:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556130; x=1737160930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H71gULN/f4ZVIM4QE3DnJcZj1WtlYtK4rRl/zQFrEsM=;
        b=OMPnomCyDfjxC1iOGr/TASC+5XQy3N+bJmA9DVqFEcgFrI7iMhj93tmqsSMZrReucR
         uKE7WV80HNFZNt8Ee6o+3hepUxD6FZptoYBSYzQT1n17m1/cQ/zKvruMsvigBbBMkoRO
         T5o+7hakg+4eTZuP+ftHYUAu4IIHNjkKQITdhnq0+WpszquTqHQzZ2KQNzw264kHVeHW
         RQZBseZLqFLCYfeLlobD69qvLlvmvVgwyWDoKNCyZPGWhqM4bomZfCZen79VE7MhHWlO
         10lsrDSSOBf9/F8n6P+9YvCqAQgHWCf5FQ1CN9DnKupsuw+pgs0vpj6nAhKMmmYfgHOe
         xjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556130; x=1737160930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H71gULN/f4ZVIM4QE3DnJcZj1WtlYtK4rRl/zQFrEsM=;
        b=MoT50+Fc241dcBYTWVmE8GOODNN1Vjsv+8FDMVpFtSzPQTJTUdij2jH0tGHv4gnui1
         f4yQzL6cCQGNAIZ23K05sR7hN2JrnKMA5vrdYUF48Vgu7abqdgdZpcG3T4P4wpSBR0E2
         gE1NLXoo+S2gqkukKYJmtkRoTrQysuFVhUb56GRfFGsrnfyYUNFztpIll4pNvtg1gfse
         pasrWSDGs4eOFUbDus21FvL2VCH2J1UwFaCFVsLsrvZW3nQXw4pHNZMOlF6SD+/ZmRmM
         nIodBJ4R/v+WTF3q8+qWCZBSYkI6APxkzsE0iYI84kaqshugg4sg9re7i7k+XOo+37bS
         kbGg==
X-Forwarded-Encrypted: i=1; AJvYcCXKfhoYsX5RkHm7fo/aKmbKTSO+h1rh4Rf3fm+sQPwLSg6HpVgDQjirSVW1D4F/VWm4yiZYOdzvj4TFgws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqrhRC0AxWSTo91JobIAaMp7LWGOhqPxjXsDh1GJK6T/Qj9zkP
	VF/KYDbc7c+M8vVeSY0Xep+3no0Hp3oXbTDVpWTx0lu5IqnXuROYN5pxJOQTVbBEYBPKlAMG7Lf
	OFQiDUiXbDu5/xNq4mBDUsXu0JzklS956vuVZ
X-Gm-Gg: ASbGncun9Sv6H0/Gj97wrElzH3zrc6UeQrw4F2EtafgLV7UmxnxBn+vCViCSzMsCijg
	z7o3HL/RHwNanx2FfOqbAbiFWt6b1q3fOitDc6Q==
X-Google-Smtp-Source: AGHT+IHnAcTpkMhnCUpEDsY91lMMXnwtF43O44NyvOYn8vK3nLCx5uflDA4w+bsnKKifCJWnR4f1aVK7tRgiodgVLV8=
X-Received: by 2002:a17:907:60cf:b0:aa6:88f5:5fef with SMTP id
 a640c23a62f3a-ab2ab6fb426mr1135502966b.32.1736556130359; Fri, 10 Jan 2025
 16:42:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com> <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com> <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com>
In-Reply-To: <Z4G9--FpoeOlbEDz@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 10 Jan 2025 16:41:59 -0800
X-Gm-Features: AbW1kvbtOeKPvMgrARDb9RvsQ9Se6P9Q-W0NbYwxtNZu3a8sopMZf__reaYZRUY
Message-ID: <CAAH4kHZn_gtspOisv6gxQiD=JeZbZstQoR68mFCxn34Am76Bdg@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 10, 2025, Ashish Kalra wrote:
> > It looks like i have hit a serious blocker issue with this approach of =
moving
> > SEV/SNP initialization to KVM module load time.
> >
> > While testing with kvm_amd and PSP driver built-in, it looks like kvm_a=
md
> > driver is being loaded/initialized before PSP driver is loaded, and tha=
t
> > causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fai=
l:
> >
> > [   10.717898] kvm_amd: TSC scaling supported
> > [   10.722470] kvm_amd: Nested Virtualization enabled
> > [   10.727816] kvm_amd: Nested Paging enabled
> > [   10.732388] kvm_amd: LBR virtualization supported
> > [   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
> > [   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> > [   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> > [   10.753768] PSP driver not init                        <<<---- sev_p=
latform_init() returns failure as PSP driver is still not initialized
> > [   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
> > [   10.763124] kvm_amd: Virtual GIF supported
> > ...
> > ...
> > [   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
> > [   12.521691] ccp 0000:23:00.1: no command queues available
> > [   12.527991] ccp 0000:23:00.1: sev enabled
> > [   12.532592] ccp 0000:23:00.1: psp enabled
> > [   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
> > [   12.544389] ccp 0000:a2:00.1: no command queues available
> > [   12.550627] ccp 0000:a2:00.1: psp enabled
> >
> > depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on=
 the list and before kernel/drivers/crypto/ccp/ccp.ko
> >
> > modules.builtin:
> > kernel/arch/x86/kvm/kvm.ko
> > kernel/arch/x86/kvm/kvm-amd.ko
> > ...
> > ...
> > kernel/drivers/crypto/ccp/ccp.ko
> >
> > I believe that the modules which are compiled first get called first an=
d it
> > looks like that the only way to change the order for builtin modules is=
 by
> > changing which makefiles get compiled first ?
> >
> > Is there a way to change the load order of built-in modules and/or chan=
ge
> > dependency of built-in modules ?
>
> The least awful option I know of would be to have the PSP use a higher pr=
iority
> initcall type so that it runs before the standard initcalls.  When compil=
ed as
> a module, all initcall types are #defined to module_init.
>
> E.g. this should work, /cross fingers
>
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 7eb3e4668286..02c49fbf6198 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
>  #endif
>  }
>
> -module_init(sp_mod_init);
> +/* The PSP needs to be initialized before dependent modules, e.g. before=
 KVM. */
> +subsys_initcall(sp_mod_init);

I was 2 seconds from clicking send with this exact suggestion. There
are examples in 'drivers/' that use subsys_initcall / module_exit
pairs.

>  module_exit(sp_mod_exit);



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
