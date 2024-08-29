Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BAA4C9A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895190; cv=none; b=P6h8Zb/0UCWWMF5GEzzyJy5G/Z1cq20/eJdnWilII+llOds0ZpVebRNqID7rJNp8xxfr9dO9/Pyfq9dxXB4IEe83cGnV3BIEf2SWPYrzE+W0MaxsAp/0uMzlaVtMb0+G22+QFNhsecqL2TRjYTLiDLfVWCVB8cVTsRS9ui1SJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895190; c=relaxed/simple;
	bh=vcV/EtgfSEZkTi7fPPscq2YKKTTxngZO+ZAgKKqLiA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFk/j9DkbOHrgaAWhWo8dTnN0Nf9xkvU0Qi/G7vff+XtZ1X0v/GRtYPr6qc5PaKsaJsBQtVVX3nuJNhz30NCjFIK4IV9P8oWSmVwZ/PN4pNLb4K3gmjt/COZNHH9u0TKRhMV4t1lA/BRiYIK/LPQkTqAnFL8GRlbbnxDbme2YHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8KxruKn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8KxruKn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724895187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=guVZQ+4Ujpsmei6SykN5ABhiPcX8ndAIleDb2wTj8Os=;
	b=K8KxruKnLwVEcwXdVwXM++lroroIRjkxQmm+l3pTlZDkKz5c+gSOAmr6HA0Jmm2vzOyiwI
	z16zOxkI3wlb4lUQfZOvaoXEHlFn6YKIlYgnGfCOIXAzLiODcpocFICWK/GLdy20lgB84u
	JKXq4sRaVlGMwJ6faljKtN1s2QM5YZ8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-2ZjJw_bRO9CxvFUOzTEFew-1; Wed, 28 Aug 2024 21:33:05 -0400
X-MC-Unique: 2ZjJw_bRO9CxvFUOzTEFew-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a867bc4f3c4so25851866b.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 18:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724895184; x=1725499984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=guVZQ+4Ujpsmei6SykN5ABhiPcX8ndAIleDb2wTj8Os=;
        b=BGiWC+WiYgirvmiZpcFEeHGnoXRpuynsGUidOllGhjYak2vQzWMmZhHsdYpwwq+UO/
         RVLng82vVeeUtS8vceARBCXttXpQgNULDWL0eNY02JJgffkzgmRnZBcPr4xJyyakVIig
         sSt/ieHQcW7BqyELgaZgQ9He366FovXyeiVTAArZcwryyQ2BicQhc7A+HWVWNgK1wkWY
         vUKee0HkjOH1RgzP55FvNyjsftDe5mgimKcEAixL8J4+diS/bcrETQ0Cl7Ck2saFCneo
         35CuTN8MIN79J0fexowY3eKevht2Y1h0gSvSPHdw5GSOalxQ0pOXBf6IXCx8/KJHEeA1
         v1KA==
X-Forwarded-Encrypted: i=1; AJvYcCWzDvf7dZMtdMMlte1iJViWVMBnMJIumunxm94GdYG5Da6H63tFxekQoeJ+5PUQEhvVfLeLvf2awKvWc88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7MA5qDVCnu8bS6kJO1NL62Oa6ITgjkNCJe2HJ7Em/26Guq/Hw
	3M9n1yqO8qnxKe/ArSEDwmNiN+7C5bMhNqu2ZJnjirEGOEjQrql6lof3tGmMOr96s1gDDQrT7I9
	+XN8FDAD96s0erujegaZGoJ6SPOFHH9KgYlV6yyHiIYfkrgTlFz/pQdmuoaC+KbEaaacWsasQDZ
	y0r8k8gpp1y32f5J+4NBebSbDRC8VvtBzsXpLe
X-Received: by 2002:a17:907:2d88:b0:a86:9e85:2619 with SMTP id a640c23a62f3a-a89827a3c54mr90996466b.25.1724895184576;
        Wed, 28 Aug 2024 18:33:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVuaa8PpTIB/qvdANkSSPCnKMBiHO0nIuN3ZJLxTk/dFv47bs73X+AN3Ug+YDJbxCeUQQYDVI5CGCDy1eBC10=
X-Received: by 2002:a17:907:2d88:b0:a86:9e85:2619 with SMTP id
 a640c23a62f3a-a89827a3c54mr90994666b.25.1724895184141; Wed, 28 Aug 2024
 18:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829012005.382715-1-bmasney@redhat.com>
In-Reply-To: <20240829012005.382715-1-bmasney@redhat.com>
From: Brian Masney <bmasney@redhat.com>
Date: Wed, 28 Aug 2024 21:32:53 -0400
Message-ID: <CABx5tqKrsVYQ1yHw3Lkt8sT957xLv-jKwpa7VxUSJ9QRXRGbiA@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: qcom-rng: fix support for ACPI-based systems
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, quic_omprsing@quicinc.com, neil.armstrong@linaro.org, 
	quic_bjorande@quicinc.com, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Ernesto_A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 9:21=E2=80=AFPM Brian Masney <bmasney@redhat.com> w=
rote:
>
> The qcom-rng driver supports both ACPI and device tree based systems.
> ACPI support was broken when the hw_random interface support was added.
> This small series gets that working again.
>
> This fix was boot tested on a Qualcomm Amberwing server.
>
> Brian Masney (2):
>   crypto: qcom-rng: rename *_of_data to *_match_data
>   crypto: qcom-rng: fix support for ACPI-based systems
>
>  drivers/crypto/qcom-rng.c | 50 +++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 23 deletions(-)

Ohh I forgot to add this tag to the series:

Reported-by: Ernesto A. Fern=C3=A1ndez <ernesto.mnd.fernandez@gmail.com>

