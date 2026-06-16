Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10DF2E7162
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606487; cv=none; b=YADpGcfjzN0qX0sVpCVdcuOunVv1Y2NXrFcRojH9q/7PW3dGbfcr+bUNyVJ9iNmxpVQWcsTv4BXLu2feTlB0DlN/JHOQfR1ffYBNu4QMIqxfQJYJ3VMOGSArDsZ/QpfHS6Y5Wb43zE5NwsdYXDnu2Q5bh/M81HEPJ/cl/dJLEWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606487; c=relaxed/simple;
	bh=GiwgUDhVPuccDsHM6fcajwPeBmdY/V23LoCQ/JyqQ5w=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a4MX9Cl5OO7sJ8joCWpehgEPh0H/exMnVYoAPvqWgF+bL1o9T9uWlCvcUlck0e8VlGoJy4pAMCQDlXNrgglxktL8t0+bZH+X7mwp2pXdkP7/70PqD2kjjz1f9aSVccCS4ZJTTYGJ8Gsez1dGO6f84jmk+JqMWHiARHiRyBY30I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDST57TJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDST57TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B677D1F01559
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 10:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781606484;
	bh=2tpmLa3dd6flsbsy+JH4P54/CMX4D7LsJ6W8CltvTok=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=lDST57TJodRceigb2VwiaQ0BBbw1vD9bcd9X+L/nZuc6pTHePvV4PTHHs537n9baA
	 67mbbjNVI3bXFnrZcPIUhGxb4fRHzSstlZPhGjb1gUDOui4i92rQevtsl4KRu5s+/j
	 2B9u0UDWiPDndFFN60XSAIdtKWCIPeoP+spHQctav/sGCBTE8KIcMW1AZtt5Ytfhjv
	 nrJn6CdUEheRPHjszM3T5wAzpxGipr4r/hjfBCCTKzppunk8tdW7OYuxo0yDYA5C72
	 RXkFbjX3cgn4dc3P9PweExe7AuoSMG7XiyGF+ZQad0sEK+YfaxLoOmf0/MV7haV9dG
	 8+XZ1+sV/eSLw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa63daf2a5so3214368e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 03:41:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/4A8ZRBA0/H2sEMb2bUAmzuDPtYZD2hcpzc2oRLvLS7+3AL0wnEI5uH61toygkaqxkaL0md7ldX567HCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPjMB4wVXA+5a5wIf+m6p2cmIkIhXO+UDXMveJ730zTlYPOFlO
	qUAAKMSexxQCc6oyD0p6bO54YmLZlHlNK5DYEypOTjiUiDLWBrVUoP+VmyV3NJTHMU2ObvGdRir
	JyVXGR69jD56PR43kZZXWpZ/fA57XScwiJ+NIg22ykA==
X-Received: by 2002:a05:6512:3e17:b0:5aa:6946:6e4d with SMTP id
 2adb3069b0e04-5ad4351b594mr963896e87.19.1781606483423; Tue, 16 Jun 2026
 03:41:23 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 10:41:21 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 10:41:21 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260616051820.GA127019@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
 <20260615-qce-fix-self-tests-v2-1-dc911f1aad42@oss.qualcomm.com> <20260616051820.GA127019@sol>
Date: Tue, 16 Jun 2026 10:41:21 +0000
X-Gmail-Original-Message-ID: <CAMRc=McmpeWY2yVbf-KoAG-uC8_cvcW6MJXFSOjnEFqpmjaoig@mail.gmail.com>
X-Gm-Features: AVVi8CfBtys2dQpRs7E2oMR0x48_wmRqAKjUTOb8b_ZnXmDQi8Ass0ebG3f0ZrY
Message-ID: <CAMRc=McmpeWY2yVbf-KoAG-uC8_cvcW6MJXFSOjnEFqpmjaoig@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] crypto: qce - Remove unsafe/deprecated algorithms
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org, stable@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jun 2026 07:18:20 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Mon, Jun 15, 2026 at 05:49:52PM +0200, Bartosz Golaszewski wrote:
>> Remove algorithms that are either unsafe or deprecated and have no
>> in-kernel users that cannot be served by the ARM CE implementations.
>>
>> AES-ECB reveals plaintext patterns (identical plaintext blocks produce
>> identical ciphertext blocks) and should not be exposed as a hardware-
>> accelerated primitive. DES, Triple DES and HMAC-SHA1 have been
>> deprecated for years.
>>
>> Remove ecb(aes), cbc(des), ecb(des3_ede), cbc(des3_ede), hmac(sha1) and
>> all AEAD variants built on these primitives. Also clean up the - now dead
>> - code, flags and constants.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>
> What is the rationale for still supporting the following?
>
>     sha1
>     ecb(des)
>     authenc(hmac(sha256),cbc(des))
>

No, I should have removed those too. I'll update it in v3.

Bart
