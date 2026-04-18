Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EF740DFDD
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776473242; cv=pass; b=Jugu9MYr37NthGfCh5PbcbEG4HQ/hhJb/VhaJ0Nc0T1MeVVmLFBJkOeYcDBHzFxin0gJzM5a3ndRKJMUS4/JSA02SAUujApx2aP0R6T7nVNG7OJrD9AYCnssB+fty7AZPSTnLYIzr+JkGxwLslNfGDlU81+vefETGuIhYbqRq5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776473242; c=relaxed/simple;
	bh=rI75D/XswJG3sRrX5mA7QIVX2img+GchrkKkvbE4OOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3eInRnCq8RjLhUZMZVkAqZpqRHAv3TqFfTvI4kdAaLf72i2kcT9Ep144VYH0ih9D9qKZlyXF847/7UgPY26VRt1H7DKMK9YSUmM3qTAB7Z7PZY2Bi6WxgS8h4p+pgPZu8xfi9TRTsy2vJP07V6aiUGjN9riczdeKzH7j2aF0UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qMu7FuYN; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qMu7FuYN"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-652f220595fso1386645d50.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 17:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776473240; cv=none;
        d=google.com; s=arc-20240605;
        b=HNh+pibWCToo5DpprdNf/tAFlU54QCvRxBABXAgxKsKmPkqXi175x5TAU97M2wMb+a
         zkm2NSOOvEP+oAyv8h2F76ORnmFUJPcndW6N+D801Fczzk7c0/OINo6b6CWn0eVWwt/E
         GCs51G7MfHfk9qohrp7J8Mde4ykPTLR/+aQw+xWwtDvPXryXrZHyzMNfHsbTzb/RNbGz
         YaO15hOLBqyNOhHE0wi1o5UYULag1sEh7jiY8cG7r7pLWiMwB4OUHhLwf8+u7P/mF0xk
         SRsN73cyfQLTK27nbe8x7ZazQyC70+0dbEKO0TAQHM0F1ArH6HmzaeL4mik5rLwjzD7o
         em/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72V9NqGcW6qqoMdzaKMDd1yz64pFCmzqJwHFxWDRYog=;
        fh=ttlgKAQTiJ1SBK4mc8WiaKGqAZaNmTWxY/4aD5jSmws=;
        b=E5IJ1/Fdnd1BGsVLbYARfVI/c4YA+Z5jis9ega/1nJ7o9c4NubcuqlaoCh/9+lHZSr
         mKHWh6NjMxgDhL4W3GMu7MVouc76cmvSQfp2JUsrOkt2h/J30oosjrttbU7iOB5RaBXJ
         CnPs2GsRb2mr6jxGar/FEPyKT/xO17b8Xy+aNDEI8q+72Ovkna/qyfarkjeNPFwUUZmb
         hHP7LPs84sLdNHPQy81sKEhK61lk6ZKhN/YOH0YLvVul5zMwGKOsXjeVHjOxUSBLMqPD
         VU31o17zbm9wT7oK3USxJSRc1jBsgpvx66IVSd/2c59pNxk/jNfI0ywMA15s4UeW2Vw5
         QRbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776473240; x=1777078040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72V9NqGcW6qqoMdzaKMDd1yz64pFCmzqJwHFxWDRYog=;
        b=qMu7FuYNbsMaExxAs+ADbtM3CrcAqfydxRe1UmME1TwKALSoNhZrx51V+dLH9oBfJp
         H7Ky6LnT/4aVt71WVJR7EAh5gVZtY4iXlribA0iFMskqTA0qiFO+5UqZEfNjFAw+lPcF
         Xz8SQKZvmA6HV82OSFr1H0wcyXn15+yEPWVI+yN50Q0ReVSegMzkD30JBnR7R2Iue+WS
         LRxiE2cCBah2XyqIUSw5TZcCnLNXFwVQ1Z8ao3fV9+VnKifS9O/as7BMFr65lpdopEdZ
         NjeVps0sbNXJoAJrt5784dJ3mxp7sVlZfPCITrSiZ2+nG97e9aH4Tho6to1j1Gn3j0td
         XXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776473240; x=1777078040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=72V9NqGcW6qqoMdzaKMDd1yz64pFCmzqJwHFxWDRYog=;
        b=GiJuGZh8MGSkqHoCiUnAigrJP6prDFqSA8FWoBtVDloN59J/cQP/6CrmFUyskmuUva
         9HT7tVq29PsBpop0NTZTDs5XuHsd3s3UeP0guDfojfqNsILQs2r3CQ//i52AnPXQnNi8
         I6y7z+JKdKTHr8+ISkgZ1u+5J0t/BUGCEdEBR/5g/SIytGtVxAhWM/l7hHD1odeZrx8O
         EWmmrX35rRhGaZwvjZA40WSTgc+Y8Dk/Lvo9X5ZtbeaagyYf9cEE/0OvVrEmeZBG1+Xj
         peajVkskMP4gLLh/7jwp6gJXON1Ip/fh7vcZrDCPOlzRn7OXLt1XyAlWmfC1v87dszVn
         maHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/zX9+6EcP+6XMxl2SkJALd0m0rt0mLxk+VhDDk5kkbCeooinaJNAhqilbwoge9jRHWDUFcNfRZEMDkIkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJoZ1xrDd64sGL5T1u6ifQ7ep26tQUbXI1qxw0vQQ9xqhlDUzI
	1y3O5vIM2oMenK8lAEnNNuyBHAu2ipdoqZAkFwZb1T/KCfQlAbJ2q1vjsRdYsdyKSrgJVcIM2Je
	VAnqhwZoB89JxI38rlL68ioBIhUGntxuP625m
X-Gm-Gg: AeBDiesv20sI2X2wZsVFoEluepRA+mK11ZIDCZeHztae9aTHLqf+Pgv6ykiMC6ZzD7L
	yB3J8rHXn29f0lL1u93XsYEIc8yZeNI3YQZXDbYjqSI9aic+nAK3z4/tZTlMQ3mu3cIZT9d2kDA
	vP3T9knlbzk1WlkjtKh0iTxLPSQtqs+DlIi32xLrHv+Lh+LMoKm8WayfB5xFdBxvC90BZDI2e0N
	Nbng9eLS3Yxn2utJHEYJ/GpsizSElx8bnQymAvwLv5LjT+V3wZLIjSa/BQ6wE9rVqLx2RXlBRjc
	14vnNo6okyjwdO5voVHcjXaftD6zC0AdTY+FNJlNFF2vigs=
X-Received: by 2002:a53:ac9b:0:b0:654:c28:551 with SMTP id 956f58d0204a3-6540c282024mr1617570d50.32.1776473240188;
 Fri, 17 Apr 2026 17:47:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260417201129-mutt-send-email-mst@kernel.org> <CAJJ9bXzhKTBx4m3-SCM+ccGd6ZhTXTAbRxKekCzidnXY6yXbWg@mail.gmail.com>
 <20260417202330-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260417202330-mutt-send-email-mst@kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Fri, 17 Apr 2026 20:47:09 -0400
X-Gm-Features: AQROBzC2J6INtNnpHboIyzK84Yzmhpw9H84-rHj4d_Q05M5JZKKJ7A_UXrtOiM4
Message-ID: <CAJJ9bXweZ2k+F5A7rOWSodzTN6UYOP3rf2oBbrVirOuof0tqNg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: virtio: reject invalid used.len from the device
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 8:31=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> Actionable meaning what?

Well, between the BLAKE2 pass and the fact that 99% of guests already
shouldn't trust what's above, I agree that actionable doesn't mean
much to most people, not even for breaking KASLR.

But after doing some research, I realized that SEV-SNP/TDX guests that
expect lockdown=3Dconfidentiality might actually expect otherwise under
that security model.  Still not a lot to work with, but more than just
correctness in those cases, and those might be the environments that
care the most.

> Maybe clamp at sizeof(vi->data) then? 0 might break buggy devices that
> were working earlier.
> Or just clamp where it's used, for clarity.
> And maybe we need the array_index dance, given
> you are worried about malicious.

Happy to send a v2 with those changes but I can only test on a 1-2 TDX
variants at home and don't have access to an EPYC bare metal box, so
not very confident about your buggy device point
