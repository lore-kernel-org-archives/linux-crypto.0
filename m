Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581541D9A41
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733159115; cv=none; b=QNlnmLLPRiTVMMRWaC/r5eiDInoAAhYCptinXbcC63+gl8QUsAvKbXyVFSPs49lVBitMr0qMzpvM6qiRMx6lywPyPj9d+aGgD7oBje58zxkIXhbdfq/zDvvLOVwvNvX2j2FRZNeaPCFJ0solylsddb68/edOWvNaoOy0UmzXdvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733159115; c=relaxed/simple;
	bh=wuz6sBOCJh6l/J4xQGflDkPUAezYKlbVOC3pExLDdn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3zayUolzRWFP/C27vTSBVnqjZduXtkVaLQxjIQSVVbiytWlrSZVAOzfzaaV3KFBFEXwq7+Dz0ZNS9kqIdcxuezzUJxjeR/X+lRD8ovT9s9sKRcprTGZhQWwn7HBtivD6VzphGHe7IfNXIQQo6Z/XE7qucgTys8+cZCA3V1zhEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9wxpvj9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9wxpvj9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733159113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TY2RNkMXPJD8Avo9kD2pk70Q+ZVywmDDBAMrAw6djsQ=;
	b=F9wxpvj9Zl5mHDoIDZWEyBLqtiF+3WhFngGnw8BUiEJmX2D+b3yh45OQfdfLZBfbG5Yp29
	VCJ2ZhIAI2jYMvdcm59T/yphqz59goCBxjfpl2WIXimk4h9S+S35T41n4aE8vwKaaoAL8Q
	l1W3jcXdsN9x2g1QPJSQlTHjI0PANts=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-EZQl8nwWOZuTNVqi0w8rzA-1; Mon, 02 Dec 2024 12:05:11 -0500
X-MC-Unique: EZQl8nwWOZuTNVqi0w8rzA-1
X-Mimecast-MFC-AGG-ID: EZQl8nwWOZuTNVqi0w8rzA
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d3a07b63e6so75947716d6.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Dec 2024 09:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733159111; x=1733763911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TY2RNkMXPJD8Avo9kD2pk70Q+ZVywmDDBAMrAw6djsQ=;
        b=iHX1bxt0szkm7tHALnYg34H4HkqPqu+Hf5LViRPrt2l6zCzApVC+YPQDWTye85VGM8
         9q6rwjl9LMEArClMVjhbem/U/HxRX2xqTFORmaFnYM0hpSZazVhKXmN9SvJQfSs4UUTi
         0oPGLnv+3vCKy8ak3DNuP5wtFyjkpIZu66Wa78iDxRkMWpjKezf8lQldVif+TzFiFEo5
         n6b9JhJsUvbpWE4Eq2BEdZlt1ILMMCpQwiVISDYTEKydt8SFUCgpkJE05iEkXXTw4FYt
         aPurF84yA/+TqVoV4EY5UcrVjGm9zm+lz4BPS8q68M4FeYVxOPCuqAd90RcXeRirdUGK
         Kjvg==
X-Forwarded-Encrypted: i=1; AJvYcCXJW/hxIB/B1jGby6d/Zb3H0tQh1U668KZ4dUBPQFqh5ZqGvpa+3DmTHJyLkg5mn0NqHZGwWOa/UBMF+Rw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6TEz/y8cdw7L6m9+Kc59Ozc1ujCw3/Qe5nIirsPFuFMpFPP/C
	VL07SCjfQbedg4HoJQF2ge/2kS3cyRrbg51OMNRHQcyT4C0QGfhnt4YCChxkn42NQlgIg/KHeem
	7+aOxg1IlKZYkTISzNUkLdnZcjr9YMmx2IkaQO7qz2CSawOoQ0eb0kpU3irfLVyWRB3v/qKNyG/
	MRzPmTBvzE7D8cAYePnMTdp2nvoMul/YZNNHsKjXfVI16LJJA=
X-Gm-Gg: ASbGncvnePWmOD4nj7ivPNNi14e1XkgBswSlHxk9Fjq5mssdpwUC24Zt2Rb2tMDGKu1
	PQoe7EMpxm6KfOKgo5OM4fz3+3dFCLeI=
X-Received: by 2002:a05:6214:48c:b0:6d4:c6d:17fe with SMTP id 6a1803df08f44-6d864d791a2mr339245066d6.25.1733159111093;
        Mon, 02 Dec 2024 09:05:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPsLMeCA7wiyfC7KaB7AfgDMZdSETIQyMQz+hhgRNHzWR9AcawpYFXQ4wUarhrKHF5GO3vDo5BqhO6R6YoSv8=
X-Received: by 2002:a05:6214:48c:b0:6d4:c6d:17fe with SMTP id
 6a1803df08f44-6d864d791a2mr339244526d6.25.1733159110703; Mon, 02 Dec 2024
 09:05:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241202142959.81321-1-hare@kernel.org> <20241202142959.81321-5-hare@kernel.org>
In-Reply-To: <20241202142959.81321-5-hare@kernel.org>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Mon, 2 Dec 2024 18:04:59 +0100
Message-ID: <CAFL455kHV2ADBs2wUe3i0j00c1SHyKdjs=OeGj4uTZyCDdP6iQ@mail.gmail.com>
Subject: Re: [PATCH 04/10] nvme: add nvme_auth_derive_tls_psk()
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-nvme@lists.infradead.org, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

po 2. 12. 2024 v 15:32 odes=C3=ADlatel Hannes Reinecke <hare@kernel.org> na=
psal:
> +       ret =3D crypto_shash_setkey(hmac_tfm, prk, prk_len);
> +       if (ret)
> +               goto out_free_prk;
> +
> +       info_len =3D strlen(psk_digest) + strlen(psk_prefix) + 5;
> +       info =3D kzalloc(info_len, GFP_KERNEL);
> +       if (!info)
> +               goto out_free_prk;

ret should be set to ENOMEM here

Maurizio

