Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE3F7FBDA
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713523803; cv=none; b=h4l2OYc1l9u+OLdTbffxJ9wPGUtCmISgbOVd1w6OVJoCFFiqRtTkzEt7hpUJk8hEc30jwX5ZGBd5+/vIyRDnfEHOKgGkynuKSRltB63T8SV+h+kN5FH8U2f/GLT8NNr1JGMwTr5oKJPBltoOVNi8DoQXjgzuwpQQmB9RNVgyqyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713523803; c=relaxed/simple;
	bh=hjId5g25Qv0MAFJVEGSlgl5IE0yTiV+lXkMvoweZIJc=;
	h=From:To:Cc:Subject:Date:MIME-Version:Message-ID:In-Reply-To:
	 References:Content-Type; b=AQXSbwcP6niNfAdDJGHr1fg+zVcgmrF2AVgB7ewCkc00m+y4USHzXRZVALnjaB2QiSTwHjVNAs3/nC1/7WjNnhxLSw1odtSDRPcV8nZa5grccpZHQZ7yLLmw2SVYTX3sGoOvJQqriVZY72lHE/lQGc77Y/pGvoJeGdcV+4QQt5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKfyyfNO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKfyyfNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713523799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EeYX0GCkCOIaHHXjBHu66M1OAJv9FbPYfe8qhd0NzCo=;
	b=XKfyyfNOEGLTjk6cq5GNb7+j84LxdQPtgrORGDubTfemRBuRG+qh8jVq7AR4RYwNg0oieW
	VGvRXLcvBRhYd86KWHovwySF3B1bLelLwiIT/9JhiB6tjtZTH1VGexHU3M9y24cDoz/hg1
	BjMvOiVuBAQL95z01BBkTz1smLsI6/g=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-Do5MaIPeOdelWllsCcPjqQ-1; Fri, 19 Apr 2024 06:49:57 -0400
X-MC-Unique: Do5MaIPeOdelWllsCcPjqQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2dad70b6e03so14035001fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 03:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713523796; x=1714128596;
        h=content-transfer-encoding:user-agent:organization:references
         :in-reply-to:message-id:mime-version:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EeYX0GCkCOIaHHXjBHu66M1OAJv9FbPYfe8qhd0NzCo=;
        b=dRtSpQPnXGjKcoRIUt7dBVidLgg6o5lIw/9d0IlFDaeJGCd8SXpzKakK4hSnOW26Xu
         nU+BGpm85L+7PIGo2IkT8W1BIzfCsNdWf2HCdpL8iabvBr2EAFh/7i6njBahphZ4hNO1
         dzmHaEzEtaT5xm0GZHh6R+6W4+++xf2fNkGr8VS0jQZtPsRcdzNyydRIbn2egPnw2WS/
         r95l5h+uH+JKig+rYEra+65vpQtjF2u+ES2Di7xvECraOj1k4yT1UJ3nQfAnxav5yTYZ
         oLjhrAwY5oCdJd1BaXjnXgSqf1pCj78oiMJrm5KOc6/0uF1RGsHc1ESGHdzk+Tz5i5Sh
         /8Bw==
X-Gm-Message-State: AOJu0YwhcwqhcsjG4OogeVL2xeQf7eEtn5rnFvRjpeDSW1emkQrZuLrS
	ZYUFm6GILGB0dYMNTNE8zmbaGJo5W48AR8TLLIoo/yAJrx90uRVVtW4R+Zv7qG+6ek5VTxeps6e
	MxzSgTrtmdyWhCo4fHBKIF61ISOritndCrr6QyOPn5t/oc+avwXnLgxu54RLnSQ==
X-Received: by 2002:a05:651c:ba8:b0:2da:802b:2154 with SMTP id bg40-20020a05651c0ba800b002da802b2154mr1212116ljb.16.1713523796109;
        Fri, 19 Apr 2024 03:49:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKOtccsa62gbBZd13tf2iicSZXbwVy7DIQiuVk1wQcVTSS2RHGWNvJAuAi46NFjX5Oaqwdcw==
X-Received: by 2002:a05:651c:ba8:b0:2da:802b:2154 with SMTP id bg40-20020a05651c0ba800b002da802b2154mr1212098ljb.16.1713523795706;
        Fri, 19 Apr 2024 03:49:55 -0700 (PDT)
Received: from localhost (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id fm25-20020a05600c0c1900b00418e2b69e14sm5765738wmb.40.2024.04.19.03.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 03:49:55 -0700 (PDT)
From: Hubert Kario <hkario@redhat.com>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: <linux-crypto@vger.kernel.org>,
 <herbert@gondor.apana.org.au>,
 <davem@davemloft.net>,
 <linux-kernel@vger.kernel.org>,
 <jarkko@kernel.org>,
 <ardb@kernel.org>,
 <git@jvdsn.com>,
 <simo@redhat.com>
Subject: Re: [PATCH v3 0/2] crypto: ecdh & ecc: Fix private key byte ordering =?iso-8859-1?Q?issues?=
Date: Fri, 19 Apr 2024 12:49:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <15623fb6-1ecc-4e6a-872b-07172a3674aa@redhat.com>
In-Reply-To: <20240418152445.2773042-1-stefanb@linux.ibm.com>
References: <20240418152445.2773042-1-stefanb@linux.ibm.com>
Organization: Red Hat
User-Agent: Trojita/0.7-git; Qt/5.15.11; xcb; Linux; Fedora release 38 (Thirty Eight)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Both patches look good to me.

On Thursday, 18 April 2024 17:24:43 CEST, Stefan Berger wrote:
> The 1st patch fixes a byte ordering issue where ctx->private_key is
> currently passed to ecc_is_key_valid but the key is in reverse byte order.
> To solve this issue it introduces the variable 'priv', that is already used=

> throughout the ecc and ecdh code bases for a private key in proper byte
> order, and calls ecc_is_key_valid with 'priv'. Note that ecc_gen_privkey
> also calls __ecc_is_key_valid with 'priv' already.
>
> The 2nd patch gets rid of the 'priv' variable wherever it is used to hold
> a private key (byte-swapped initialized from ctx->private_key) in proper
> byte order and uses ctx->private_key directly that is now initialized in
> proper byte order.
>
> Regards,
>   Stefan
>
> v3:
>   - Added Jarkko's A-b tag
>   - Expanded on the description of changes to ecc_gen_privkey (2/2)
>
> v2:
>   - Added missing zeroizing of priv variable (1/2)
>   - Improved patch description (2/2)
>
>
>
>
> Stefan Berger (2):
>   crypto: ecdh - Pass private key in proper byte order to check valid
>     key
>   crypto: ecdh & ecc - Initialize ctx->private_key in proper byte order
>
>  crypto/ecc.c                  | 29 ++++++++++-------------------
>  crypto/ecdh.c                 |  9 ++++++---
>  include/crypto/internal/ecc.h |  3 ++-
>  3 files changed, 18 insertions(+), 23 deletions(-)
>

--=20
Regards,
Hubert Kario
Principal Quality Engineer, RHEL Crypto team
Web: www.cz.redhat.com
Red Hat Czech s.r.o., Purky=C5=88ova 115, 612 00, Brno, Czech Republic

