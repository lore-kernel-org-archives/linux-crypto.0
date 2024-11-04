Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DB91F7553
	for <linux-crypto@vger.kernel.org>; Mon,  4 Nov 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730755665; cv=none; b=gpstCL3zYRXLJY7dHUbVy0zHwyx5NNC8Ho0S6+7MbqF3ppD7/I7RJzRhmdciy9rmHlKU76KRCPbmkpeEAtIHaRvHk5KT9/GtnMtvXqoC19w8M0d/3h+cOlu5roT251k+vMPj2Oxx+klTS0nMDXWs5/deT0jt9lJEYiClDe1byT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730755665; c=relaxed/simple;
	bh=OTPmTDfD/LS3/LJwgXWQCeU9scm0B9BjWhRHcAzrkVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmO1C8lgS7E4DQtsN25L1TH9m1ocCmqzx/oqHGugv+egsR2/j42sDj7h49ZjdrOMsuo2btfgTtyl9ydSb/RU8XRxWrgi9BC0T7mSHI4Q8LnVKA9lYFYxAFeOiFxpzkP6dGhhqAIuuHon3QxL+wygTjbsPN+BogAJssJG3jL31aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V2+s1W+s; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V2+s1W+s"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9acafdb745so816112266b.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2024 13:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730755663; x=1731360463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTPmTDfD/LS3/LJwgXWQCeU9scm0B9BjWhRHcAzrkVA=;
        b=V2+s1W+sEg2ZOqv8yokRzzOVi2ztsGuk+bRNBkmgHRFX2aZdUWBfiBK9C3iREgEqp0
         GpyKjiRMrc4N+fcnGY1iZLfaDOns14w1h8u8+OPrFGqlXWaW3aKB6OKacKMXJEqtsmSV
         7XO6E9tVjTxleYktBuM4KN2ogOO29luJt/YLzhNj2Hq/LF06pk+w4crkd/RvUMaueQrK
         SMlWbZnPBuvGZIvPQ1tgbpzIaNdgmk5zKxzh6j5O6fs7Q9yinIjP0H6dLygiNDw8I+jX
         zVaQiShp3Kz+vmUG99jgrLTOvxj8xHtCpHjoguyzs8iRnNEC9PX0B8HeRmxNHY/SoqIF
         VXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730755663; x=1731360463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTPmTDfD/LS3/LJwgXWQCeU9scm0B9BjWhRHcAzrkVA=;
        b=iVFmdzdpGJiOWQkKP2+Cr71h+htV5oTRs8HZiSnFzocvf0HknhmVN5jEVPl66dVr2O
         lteM5P7R4hVFE/9weGoSucAgb1iKBFCyOVuJbGeEtyIl6TV+jKH9s/ZvvrzZe8Zxlrq8
         XwGNCAvmTfvQkYvNvMWAXgz9tEWhCQBDomiJv3gQkf1P7DbZKvyp+/dMlQQOAbueRAs0
         i68CBRMrpiBghpwO5KAszR+vx5riNTB5gJ2ghFDPZT943I+/+PkdBqMAe+UJKI6rhIcm
         UGyUTewadOY2WOqRqVJHaHQtyH6WIgLTjiLKkZ22wNICuyWvjdS71kjcsKT44ODbBSXv
         3RKg==
X-Forwarded-Encrypted: i=1; AJvYcCXNGB6l5+w/BIYaPVhjwA249rXOOTvItAAbjfKBOIaTbeDNXmcu65c5wvAdSn/yRRTovo0dREVc6lC0j3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKJuxDUA6izcjcjCVfc+mUekfwHxCsh2dmwHxA5c7KM3tZ27RX
	4djElSPgEYWkJc76FjRPIV9n1IpDn803jvjAcqxgOpHeQRCy1/5lceD+fxv1nHYt/S/VGTUslh3
	l8N05taQX8djc5HB+hjBFOc8nLxmb1AYPKlgf
X-Google-Smtp-Source: AGHT+IH6Tlp59MLzMnZ27hz+6+YmKqJ0W51BNUAsI9hKIHPFNI4RFLogDFRMR9fTfdbVlrh1GAS+OU9Ih7UE50SWPAo=
X-Received: by 2002:a17:907:7fa5:b0:a99:5587:2a1f with SMTP id
 a640c23a62f3a-a9e6533259cmr1328157466b.15.1730755662715; Mon, 04 Nov 2024
 13:27:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241102000818.2512612-1-dionnaglaze@google.com>
 <20241102000818.2512612-4-dionnaglaze@google.com> <91984541-504a-f029-47ca-bde538e07436@amd.com>
 <CAAH4kHYqQAkUO8phdQaE=R0qHZjKBB1uXsKR3Nq5yJxeZS-o=A@mail.gmail.com> <b0a5d1a6-39ef-2637-ece0-387582b09fcc@amd.com>
In-Reply-To: <b0a5d1a6-39ef-2637-ece0-387582b09fcc@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 4 Nov 2024 13:27:30 -0800
Message-ID: <CAAH4kHbqE4X4zDFNLdY_xRhVCCWa_qaH_X2cyY4WbQfj-OkJGw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add SNP firmware hotload support
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 4, 2024 at 12:45=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
>
> That would be best as a separate patch series. But doesn't the
> SEV_PLATFORM_STATUS or SNP_PLATFORM_STATUS ioctl() give you all the
> information you need?

It does, it's just that sysfs is the preferred method of getting this
kind of information. If it's seen as duplicative for the upstream
kernel, then I can drop it.

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
