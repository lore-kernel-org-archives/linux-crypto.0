Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E0D239594
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 04:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254760; cv=none; b=LdtGSCGO93PHdOOmZ210J6wBQJLhk/yICvT/uDEeyw6IE9q1YbVhUNNRN8XGddDn91tcu3mEHgSvBh5Va4SNcvBZ1Q+dXuBw4LSioqAO9fQFIBcAtl5s1P5HYF5FqI6ozo3wMGyku2jzevQSqmyCfvJCXYwcOjxydTkZitX952M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254760; c=relaxed/simple;
	bh=J+hBl84WHm9dTvb2IVD17UN8GJ36a4ic9xIN7/1TU90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UMkNZgboXxINB1zNR0zJVW4/iGo2sWWjETRTYMyS1d5/DYEOWKHfEs6ZcL+D8vNvpN9QwX/WMdadIcBUm+dSg7W8gtlGCZjmfpSltaFMGfuujd/GFQIB3xWGJtu48NCeJ6UoK50EiGFltbIujjzw2iWPlR+RP0L4zSyBe3nDY20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J1iH4YWi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGrAX2fO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1iH4YWi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGrAX2fO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765254758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+hBl84WHm9dTvb2IVD17UN8GJ36a4ic9xIN7/1TU90=;
	b=J1iH4YWirI6GQuA3qJgioTOjrfKxfJUoY4n9O/SRzAL50HxVEBbegToRBpsJdgoGFeVFdT
	Dh1OjKICMIgCFN7Wj2jKW18IkfQkBwmURutrU46sSmRuJrkFAMx9YcS+RrZM0QDtsyF66p
	uteIVFBjtT5xXCghzveZjw4nPHXkBP4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-uLI0_Mj_PUehTr76-RoFbA-1; Mon, 08 Dec 2025 23:32:36 -0500
X-MC-Unique: uLI0_Mj_PUehTr76-RoFbA-1
X-Mimecast-MFC-AGG-ID: uLI0_Mj_PUehTr76-RoFbA_1765254755
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34a1bca4c23so2982508a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 20:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765254755; x=1765859555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+hBl84WHm9dTvb2IVD17UN8GJ36a4ic9xIN7/1TU90=;
        b=gGrAX2fOj4nGSoeDDX+7H9KVbNvSrTrUO5HsPyJoZJVPo+tT/ppcqWQhluuRaqFehH
         e9tIQQFuCQqIabqPADs+ZA/Rikxt8UBE771HSp5hJDU509Pkas8fHegnQZSqOGYirLWa
         1CSLTBmEmMqZYwZKQO77M0gNgGSyupTm3oz5dDSLpoKiwBw273vx0GHO5xEApuCO6Ric
         K7MyMGkDI0pYk6WAbDXiUiG4F6jgtIUBwee6qBdIgKoE2pmTqfKppprJ3ekB9K00xPu5
         gGmh6JJvaM3R5pytmWZqwdJ/tSCLZznyOUkKjkxwSBua6xBpZZvWjqPtpA70h/m59DCA
         ereA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765254755; x=1765859555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J+hBl84WHm9dTvb2IVD17UN8GJ36a4ic9xIN7/1TU90=;
        b=eSsm75HV1otSSCg/KqnEIKt+6PWx2VCy1PLV7l7dgfgpGT8FcNCZYUGAuenVDUwIjh
         0aGS7Cv9QJNzQQsnimMnj/xlTqNxGgB62A2CeIU6XYpRcRLwJjuyNNdpafwls1EABuxD
         5uXypWnIIHZGDcK6dGE2v2Gh++mRVtBv/6QE1Q/6yHgIjbJ0132ph/Nb8H4Ek1mJxqOE
         OfRfeyo6MgV1e1WQvUYBLXykvI0CswIRFtsUcUVVV9j8GUTdLjrs7HDS18RzU7uW+Wcl
         yXwwXUaP6s5gx+j4Yq8N90F508DunfyEmtD8yYLcwHSEqMNxVuQekH5spe+Jx73bfpq9
         ZnEg==
X-Forwarded-Encrypted: i=1; AJvYcCUIYsWhF2opijI787EuXO/MX19VK2fxDBdpToEnDjHTeTiKLBQ/vmS788AJ1vOvQJApDnY4tFcM/FYmdKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDmy+VEwkuhx2hXnSeynmex4kX2Q2znWxyF3MO914foCOfJQ8j
	twN6iR8yCybHkONRW5fhXaLDoAaU6eyXA1eytin+9vXaHONaUdSLOPg0zUmbuNTDrn1dhfNjUmi
	IuPSNR2s6le7SSmj7W8tawqWpmWkn7OXbgNaF1dDbcqO7gV+3LqUcZ1DJaNT2LJR9CyObD0dqyp
	aZj4HP7h9kKw/Kf8RC1AuAfPow21K5ZXVAx7+Ry2pb
X-Gm-Gg: ASbGncuSdeTbOwDV1mRrg2rCpbbQyrsyam/O/NAAcHGlFt7NSl38S6CAmav+6b9ir38
	kukQeSgaQkkNE5LgYTdsIbdlep717820Wsant47LbBKXUc3lMaIPRSxg/a/sANYYcNRkq9gQ11o
	ubWzWn4fOh7lJjpO1Vx/Ul0QGhQE/w7TTktRZUvfQlysmvQGJRtFygbLlndd1VG8Dxuw==
X-Received: by 2002:a17:90b:1c04:b0:34a:47d0:9a82 with SMTP id 98e67ed59e1d1-34a47d09bcdmr1283569a91.23.1765254755299;
        Mon, 08 Dec 2025 20:32:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZigLd+4tNDsEqpK7j1nL3e0eAUG/9ReuDlT5kDs4M6VOh8brOzGP77EQtaU2rfZiJeLxJLmD+gjQF4ATP5OQ=
X-Received: by 2002:a17:90b:1c04:b0:34a:47d0:9a82 with SMTP id
 98e67ed59e1d1-34a47d09bcdmr1283553a91.23.1765254754860; Mon, 08 Dec 2025
 20:32:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209015951.4174743-1-maobibo@loongson.cn> <20251209015951.4174743-3-maobibo@loongson.cn>
 <CACGkMEs8E9DYzmZ8k4fH7h=fxC07wMsHizyDAE3wiKmQhkW3Uw@mail.gmail.com>
In-Reply-To: <CACGkMEs8E9DYzmZ8k4fH7h=fxC07wMsHizyDAE3wiKmQhkW3Uw@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 9 Dec 2025 12:32:23 +0800
X-Gm-Features: AQt7F2rlxm1BYckxq9YbxOuPFOA7BbwOSR1nEKtVYCMLEczaDu9olC5Koe5SKPU
Message-ID: <CACGkMEviPVi+nJvS6rU55vF8xk08kAkr6ja0tYZp3BHJK=LtJQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] crypto: virtio: Remove duplicated virtqueue_kick
 in virtio_crypto_skcipher_crypt_req
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 12:31=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Tue, Dec 9, 2025 at 10:00=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wr=
ote:
> >
> > With function virtio_crypto_skcipher_crypt_req(), there is already
> > virtqueue_kick() call with spinlock held in funtion
>
> A typo should be "function".
>
> > __virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
> > function call here.
> >
> > Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Btw.

I think this probably deserved a stable tag as well as the
virtqueue_kick is not synchronized here?

>
> Thanks

Thanks

