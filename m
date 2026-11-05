Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793914453;
	b=PVnzpdN8qmB7ixjr8MBQ6hitTcxvidMIcGOv9LtPtPv96Q36AbP91FvQj+NzRjzvXFc4
	 LZ3va4mbfGkxPVTaNdcKaafqBnosuEms/g01AEV2xAD+IYb3jkv1c+JdkfPgi2YzL5nb9
	 Kzk1lvVfX9Ga1NOlewZ57udDfnIC6sVvC3fEb10XoqRv+6iRJr5eyoAuLKAyaK1S/H7Jm
	 5YRAz+3D5sLiizmy+ILh4HRPkt+vv3JmZx0SZ3frbX2UHYS6IN08xlhbDcirApmwIzxK3
	 AlYKVQTgG1BbC27TecqGnbnizSiBJp0Q+hUR6nFFOmKY34OF+FDzGpZsi6BrpJq4CKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SI00QxGGBKrcJzsigG/IXk3v6J7kiDinn5cvl23JkuI=;
	b=2zijsaXNvPm8TDi2vqEGICVAMYpTTlXc1ZNVrq5ZlgWaPPHxMF4aAjjDXoVLdAa6GGi7
	 Nx9i4USzwXgazDC+6moK/3leljE0aW12Cov2n4gocoE5VvRORa7cUcl+MGiPmHkawkfCO
	 5HjBBO6QbajWjUQBVGd7laAwMnBXKQKQAWYH9MqrbZLBakEqSprRWS3aI0x4fm4rQdjqt
	 7G2v+DiVlnsret7l7lLLOg8POrGhcl5Z7RtnQtrf1AJgXi0QXaJST+Fd81VwupXrajQ8q
	 Flt/8/OL+qTUxqTUyM//u6WCGZD7o3RH05yWVPeP8WlH9ZnTsD61KAbdAF1bNKGM4Jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Hl+ccYah;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D12606D81F
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 21:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D12606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Hl+ccYah
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso2051091a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 13:34:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793914451; cv=none;
        d=google.com; s=arc-20260327;
        b=TR+996jzrp/CWtn3Hu10nbX7LscVwTEQRX9TLXb9wZPC/SJr+l5Lvq9Sl1nO3JqVYS
         c0ygtI3DaeUW9TaRNUoRs+sNx9dkcaUQ46nCf8mhdu2GWOpz5jWSRLdQ1P0wddEs1qyG
         HPQvIXnUqOssTrpk+/xZZ3fJ/mBFXJ7E9bzmEvT+xW0CXYWAYO5S9Ohbvva0GWd+K8eq
         b6f7iklMed4u5JqKqbyNSjaXLQ9Ntw21RnKNtpSbi8cXn0oRH3vr30C3WXKX2NIRf1MB
         mwtegM7yfU5l7furWa17AtR0VL659rv4bBleCklepG/1dRje9SJevCZvUr5o7/z5XgSh
         o4fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SI00QxGGBKrcJzsigG/IXk3v6J7kiDinn5cvl23JkuI=;
        fh=Tr1MhugdnwBzNDhOHbpg1gqr0zasV/0Ohm8MKN9q56Q=;
        b=E4NeJt1p4WpLs9+sNvivPBjDQ2Xx7iFPlDOFhn3yHB12jvkO6HNFUK9ldB8vd+5ZhY
         PsIYFY/PAeEgyvAb5mH7DTCtUw9B74GBiAk434sAZzXtnw5pwXeg5zVGl1WqBmQpCZen
         uPlylc/wu+SSbzn2OEDOBKCjYgOb9gJEvBT1NO88kA958nBaVs7DsmJ5T9SUQLUm6x6a
         drJwuP9l7pR0OLVb51IW2bblZkMPPQmbBWtDYLN+P3yYaJRRCI+ZsVNdlC5KAWflOh6z
         UXPY+tTaDN2YjdTWF1K1NMYoSlYDUqOuUn7we0W4JrWybgU1tCyg6pwCfpSg84ajOtWQ
         4tIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793914451; x=1794519251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SI00QxGGBKrcJzsigG/IXk3v6J7kiDinn5cvl23JkuI=;
        b=Hl+ccYah2c2TJGKzEuwCSZ2271/KIZUZBHSnk/+2IE/cCUZsXxa2GexStU3GPccu+L
         c9pguKwDW+Sf+Fn+GA68uVtKE0t0VnesyC9yU3Jw4FKh2SwwCcWgdL2nNGu0/Ie35U8B
         MGFXARhSF03AY42sAaITfjloe8nQY7YlibBJwWQhm2G09NxtgMXOGI+31ENhOhfFM+cn
         w91MMdS5EWN2I5AhdOUPtXuGCNt3rlaFsouQf6OUuSgJlQBtaB8pXMA4WlaGx4kg9P6M
         1zDjWLxzILMZlaS3Ofwh41t66qSb1pk/CND/b/5SIoRVPIhCTDyNDTAqPkiK5WkbHu3D
         c5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793914451; x=1794519251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SI00QxGGBKrcJzsigG/IXk3v6J7kiDinn5cvl23JkuI=;
        b=jN2Ql6UiZBQcxjiojX3mrni4qRYCSJO/d9OVXIfn7JqlFYAH1lY4t5zQbCn/VXxhTh
         7ZkCBjeT24UOUeIhcUdtvOWz27NmmZrKone9TWgXzxaQv24/wUH0CYEujwVNWhT6Hs+t
         BZarj5O+dd9M8UMAgtj5T9ePIGAW+fOH8TqOuu/VR6Bp7TdXKaRCEM7Wes26hzhQKnVY
         54mKCK60bFadARs+dvrH3upfIjLZasN34G6IF62ZI9364MZTOFuMR+xBaM/IyYsJurw0
         EBhegeOhFnshH7KEpzXpkEGIhHCQ+gMtFtAjQ2krQZyQ7RZe+P9deXj6h6XMdV8a2qEZ
         aDfw==
X-Forwarded-Encrypted: i=1; AKwUvBwg6ON4xdU2VYMBqEETJLDX2zP+9g0gSdhKf+Dp/dLR+Zax6Sr8TcUKwBrDGpBpDOONROjV+R7mV+7Lxa4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8rKFV5pzkpSTOnZaSxO2OnU4KWZaaKQ9rNUKZCzAp8EYoIiACd
	E6Py85OZyz5fXhmE5MK4KOULojG3QlJHLa003t054O66w7ohffVYha93IkArrrofrpmkaaE7QAT
	/+8g+53PdtLfheBhovi4Pjwx0vfz01Sc=
X-Gm-Gg: AYBFou184X7hpuAlcCmZPjKO54Mpi+hmfBWsDWu64u3jz7Bj6bJITMLl221K8PsP91+
	cvleXyQYoY5/477lhByytvfg6e0/bAVhX8MUVYvUe02eWUIbwJP66R2CE4nlagY54azV6dJDIDE
	MxGRKKdPNLQQXtMylp1IixbqZ0M9YSZCCagRG5EpoeVnVtgk/E6ln+b6AyZAXLCcSrKFRLmSeYJ
	ttK7zUuKqYXR/XVmfwEo48mwVC4svMlElsUjgfHdvGI5A8QkYBOnXf7sbcQ+JxkVOS3yc6Uu+1w
	SRVfA2K0ONvfmu+zr2Epilb0XQSxxFsaHXktUZH0uZGtGJNhMFvWOB+vAB0OXhwKKO2uhDTT2ql
	HmdyLHrDV4YZJmNhJGqO4hfl2yhn9EAghW7fJZ+3d50EMJSWQ2ZP1x6QBrrlqoUMQwGnT95k=
X-Received: by 2002:a05:6402:3883:b0:6b5:114d:cf36 with SMTP id
 4fb4d7f45d1cf-6b597474b45mr392264a12.0.1793914451121; Thu, 05 Nov 2026
 13:34:11 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031010232.3361085-1-samarth.colleges@gmail.com>
In-Reply-To: <20261031010232.3361085-1-samarth.colleges@gmail.com>
From: Samarth Narang <samarth.colleges@gmail.com>
Date: Thu, 5 Nov 2026 16:33:59 -0500
X-Gm-Features: AclHuK_MtBiurCXf6HQzaNhcFD5EDBMpBf2QfAxGsVk3Isuov9i5p3cCovbCXtE
Message-ID: <CAAbz3fQbs_+aubvjLmApkGaYtiAdQLZ0RRJKjjpRogFQmCDeQw@mail.gmail.com>
Subject: Re: [BUG] crypto: starfive - DMA left running after timeout while
 buffers are unmapped
To: Jia Jie Ho <jiajie.ho@starfivetech.com>, William Qiu <william.qiu@starfivetech.com>, 
	conor@kernel.org, kernel@esmil.dk, hal.feng@starfivetech.com, 
	changhuang.liang@starfivetech.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

The two addresses listed under STARFIVE CRYPTO DRIVER in MAINTAINERS
(Jia Jie Ho and William Qiu) both bounced this report with "550 5.4.1
Recipient address rejected".  I have added some more folks on this
thread, who seem to be active in the STARFIVE ecosystem who perhaps
could weigh in on the report quoted below.

Thanks,
Samarth

On Fri, Oct 30, 2026 at 9:02=E2=80=AFPM Samarth Narang
<samarth.colleges@gmail.com> wrote:
>
> Hi,
>
> I found two DMA cleanup issues in the StarFive JH7110 AES and hash
> drivers. On timeout, or when preparation of a subsequent descriptor
> fails, the drivers can return an error and unmap their scatterlists
> without terminating previously issued DMA descriptors.
>
> Line numbers refer to mainline at 83f32c773255. I could not find any
> dmaengine_terminate_*() calls under drivers/crypto/starfive/.
>
> 1. AES (jh7110-aes.c)
>
> starfive_aes_dma_xfer() submits and issues out_desc on cryp->rx (lines
> 471-472), followed by in_desc on cryp->tx (lines 481-482). It then waits
> up to one second for the RX descriptor's completion callback (line 484).
>
> If the wait times out, the function clears alg_cr and returns
> -ETIMEDOUT. The caller, starfive_aes_map_sg(), subsequently unmaps the
> source and destination scatterlists (lines 520, 540-541) and propagates
> the error.
>
> Nothing in this error path explicitly terminates either DMA channel. The
> descriptors may therefore retain the ability to access their mappings
> after those mappings have been released.
>
> There is also a descriptor-preparation failure path. If
> dmaengine_prep_slave_sg() fails for in_desc (line 474), the function
> returns -EINVAL even though out_desc has already been issued on
> cryp->rx. The destination scatterlist is subsequently unmapped at line
> 541.
>
> Since the RX descriptor transfers data from the device to memory, any
> later execution of that descriptor could write to storage whose DMA
> mapping has already been released.
>
> 2. Hash (jh7110-hash.c)
>
> starfive_hash_dma_xfer() submits and issues in_desc on cryp->tx (lines
> 150-151), then waits up to one second for completion (line 153).
>
> On timeout, the function clears alg_cr and returns an error.
> starfive_hash_one_request() subsequently unmaps the source scatterlist
> at line 235.
>
> The TX descriptor has not been explicitly terminated before the unmap,
> so it may retain access to the old source mapping.
>
> DMA provider and possible consequences
>
> On JH7110, the AES and hash DMA channels use the sdma controller,
> associated with the PL080 DMAengine implementation through jh7110.dtsi.
>
> The transfers are flow-controlled by the crypto hardware. I could not
> establish from the driver source whether clearing alg_cr fully
> suppresses further DMA requests, drains requests already accepted by the
> DMA controller, or retires the corresponding descriptors.
>
> Even if clearing the register prevents immediate further transfers, that
> does not by itself establish that the DMAengine descriptor has been
> retired. If the controller can resume the outstanding descriptor when
> requests become available again, a later crypto operation could cause
> accesses using the previous request's mapping.
>
> Depending on the DMA mapping configuration and subsequent memory reuse,
> such accesses could read from or write to storage belonging to another
> operation.
>
> Proposed fix
>
> I think the error paths should explicitly terminate the outstanding DMA
> operations before returning control to the callers that unmap the
> scatterlists.
>
> Specifically:
>
> In starfive_aes_dma_xfer(), synchronously terminate both RX and TX
> channels after a timeout, and terminate the already-issued RX channel if
> preparation or submission of the TX descriptor fails.
>
> In starfive_hash_dma_xfer(), synchronously terminate the TX channel on
> timeout.
>
> Both functions execute in the crypto engine worker context and already
> use wait_for_completion_timeout(), so a synchronous termination call
> appears appropriate. The cleanup would need to preserve the original
> error and account for the outcome of termination.
>
> Would dmaengine_terminate_sync() be the preferred approach here, or is
> there a crypto-controller-specific shutdown sequence that must precede
> DMA termination?
>
> I can prepare and compile-test a patch if this direction is acceptable.
>
> These cases were identified by a research static analyzer for DMA
> lifecycle ordering and subsequently reviewed against the source. I have
> not reproduced a timeout or late DMA access on JH7110 hardware. The
> reported issue is the absence of established DMA retirement before
> unmapping, rather than an experimentally demonstrated memory corruption.
>
> Thanks,
> Samarth
