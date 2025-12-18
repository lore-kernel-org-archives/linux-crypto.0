Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ECF2BEC57
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029981; cv=none; b=QyG1Cp7PI2KZogRAhmglwgQTFpHKc7hw6lTNLrjhs+4vDFBLe4lNjxsKL2CRP38eWe2/67KVidZ2k4JnAVIJBjvv7xutTudfeNMWERA+npV0Wo0jhLmzW8BqY+n0c3zvhZdGeQjHY6AcU/pnqT+mv2YDdaeaaQkX+uYzPHjEt9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029981; c=relaxed/simple;
	bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cL0rdjEP/ye9o0z8QxO+PTTEjYVj7UwRtOUUrOE2ZYK5Ya000j7FHJpJJBBp99YXpgIb37egFg7OIK8qYkgYhUSCO0XL3ZY+5ArKDyl6dDTHLx6hAA2i2RT35GjdHtE+7WG1CTO/G2i6OpdUdULEicuw7KW1lMPhsc3X2E1N+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QK40YqQ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k+e+s4HN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QK40YqQ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k+e+s4HN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766029976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
	b=QK40YqQ39mPPKK0GAiQv6RT4DB7A0rVH3wbASKq+8q3cUBfjuMhLXQrAIwlBF08HaJnm9r
	oZYJZ6y+jZyp11E8QTt9CdWIRoWeJ8OWHY7KPbO7kJvy9xtcjhUWsm5P4MBz5iSd7IJE2Y
	X2NeFlBHPquo6qDCrgNCIQeyG0lX0EI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-t6qerKr6Mu6G9P8shnWuTQ-1; Wed, 17 Dec 2025 22:52:55 -0500
X-MC-Unique: t6qerKr6Mu6G9P8shnWuTQ-1
X-Mimecast-MFC-AGG-ID: t6qerKr6Mu6G9P8shnWuTQ_1766029974
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0a0bad5dfso4438835ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 19:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766029974; x=1766634774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
        b=k+e+s4HNnZewU/pX5QWpphFgZNQnFcYBTaNVpMVZctsfx918Jny2rX2lMe07sh93w7
         MNZxOWBt3AH04y6Yw5MgM73QcTXHs3UwqQUZ5l6UZo3V2LrBMTHgjb8rkAjrsD42Hoh4
         THK8dAXe3b9kwMoyunySKb0qOwyKjyocY1SxzIL8jDn8NAtfmQqpFNgcWHNeM86aSSkd
         gPw1y7hh82DYhbfUM2fDCLITX28gqLwwsSP8eTnN82a5+WDTsAeVnWQUs+/8LBZFXG+J
         KsgNbtQTwOhubNL2KlJQXo1nzdcQI1IjnKVHFrxRvhcSabSiFvE9rQMX/AXIkKuwwckj
         Q+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766029974; x=1766634774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
        b=jjmW0Zk43ASMJ3PTgnuTv7MsHekmE8EzGxyc9bDYdlCsTSAK541T7UtK4OZ+HEzri0
         B7RpwFcnj0qDOaSob/VlG5Gr7bwU3dBw+Wg9seBEWtxxKiY58UUIg8AmFmwrbzyQgJce
         I52qCg+ivegykBNWZ8GBPdraWIPHOkk+nJ9CcHpbfZw8UjwcJd2BggRlkZnrgyA/FdoK
         9ybgOIlK26SUZyzZdjOjZrtiD7Co8rmte5yBSW+qNnxZS5BYFqqMTjP/hWUiMsEonExH
         z+kQVNeWWFbUIGuniRaKxVn7Gbzhfzz9nPs2HrpSqHESCSsZqItETG5r8x86D7TZ8ZVq
         0NKA==
X-Forwarded-Encrypted: i=1; AJvYcCULzt8posWqP2a9iE+nSKomBxFggx2qZxSMorNZiVHueu48qd9nBvAKou5QwH3fZUeUENv51BAY7NYHj7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyltpCW9so1f6wPbVQwQ/twoEGI4XMjbCDFApj6gT39eOod7YqB
	komrd07E2e/MJsMOy2xYV/k7uPutj3ibpxlEVqmor4S1/l0Mtih0h3Jbb3dxy3KYWUK+AQkbP3H
	YhKZraB5lQqDNqwCBRqyHQAq7OFYJKR+T/e2TZJnNCBGRegskF3zp8Y6EeT2xYy7uQiqaptcSD5
	rKKbAAkCz2E2JE6+LYxFM5vmxz375Hruh4aWu1xeDj
X-Gm-Gg: AY/fxX5pddrrpd6wKboetKklZklXRWqK9Sl276KQRpQrY0KJBnlVqpKaUnn3tF5+qF4
	SmBOckRzWUijMpJJJEgqeHWuE23x59htCClGOWfCsQSdIgs0VWW2KoqZlu4SL/RNj3Mx0hRII0h
	/ibv/HiL72PqzNbzGKBJoaeKLWm8QbBppaov5LHZ+0TBFtGT4nKC9ZNQ+4O8PYHxEzdRg=
X-Received: by 2002:a17:903:1aac:b0:298:5fde:5a93 with SMTP id d9443c01a7336-29f23c677edmr196912205ad.32.1766029974597;
        Wed, 17 Dec 2025 19:52:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHw9DNEwmWjxWfi+F7K4n2BB/diI3M5uZKNjbX0bS9zDqcVCQPXZbRoNc0uTilQyHet8P2VB9LVOiFRTvTgn7U=
X-Received: by 2002:a17:903:1aac:b0:298:5fde:5a93 with SMTP id
 d9443c01a7336-29f23c677edmr196912045ad.32.1766029974179; Wed, 17 Dec 2025
 19:52:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218034846.948860-1-maobibo@loongson.cn> <20251218034846.948860-3-maobibo@loongson.cn>
In-Reply-To: <20251218034846.948860-3-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 18 Dec 2025 11:52:42 +0800
X-Gm-Features: AQt7F2qn7yrgQLTm-jx-zOUUwaHI5CYNjj2jNdNQeouWQKRiXmdxNRu5gCHge8I
Message-ID: <CACGkMEv-zTNkyxQHx5v5FGZE12SHib_73Lf10wF50_7B1WrPbg@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] crypto: virtio: Remove duplicated virtqueue_kick
 in virtio_crypto_skcipher_crypt_req
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Eric Biggers <ebiggers@kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 11:49=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With function virtio_crypto_skcipher_crypt_req(), there is already
> virtqueue_kick() call with spinlock held in function
> __virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
> function call here.
>
> Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

