Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A3225417
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254715; cv=none; b=iY+dJwJz0SawDCf+SdQ26rRDfdcRQ74ELSAMnQZr+nfpMmLtoFMqHPVFRcceE2lFli+PecAfjJ1VZL7BNiV+Hr60UaCCkLc/BZM34CBFoC4aKXIlhf0RO9pGlJHwXwfYqaHfbGpJuGYmbP1PtJZE3L1FVucCpgZumxr60Tqpwl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254715; c=relaxed/simple;
	bh=9tmXfHJq0QVXqDhHx3V0hpna8uVRq5KY1OcI6d6XAb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CP87GbMedDLYwy9ylaJQEW5vBG96byFBtQySkrgP4xtALYMZmrFDcnLbxz6+x3eb/oa96cUEoKQbJoUhDSuU5EBoCsDuzt/JdzTtzxDUvT81ks4edEB83NBB8XRMkMPmvB87hFr/JoRwQngsA1WgBr5q26wU9jkR/A1Z5h1NwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzZZh00r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nSooa4c9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzZZh00r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nSooa4c9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765254713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tmXfHJq0QVXqDhHx3V0hpna8uVRq5KY1OcI6d6XAb4=;
	b=GzZZh00rSBmE9KpEwHFNXXpxOSRrvKJ9DMDzyicjfX93aUlisijsH8KmLXlgAAEH/Jnh5I
	En7RQZGOjYZX+RnQeD0A/IwxyDUiXY6b9Wf3EvbUcpYd/2zT0pLoC4HCzp1XpaDgdYVEBJ
	UmBT7TmoBhG35C1UsQw5bsUuk6hSKyM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-RecfxH96O3GFNdTNfNlOTw-1; Mon, 08 Dec 2025 23:31:51 -0500
X-MC-Unique: RecfxH96O3GFNdTNfNlOTw-1
X-Mimecast-MFC-AGG-ID: RecfxH96O3GFNdTNfNlOTw_1765254710
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-343e262230eso5988933a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 20:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765254710; x=1765859510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tmXfHJq0QVXqDhHx3V0hpna8uVRq5KY1OcI6d6XAb4=;
        b=nSooa4c9G1dKk/7tz5zJmY4U0HFXopm1gFAZassmcUMTlZ1uBGeHJF/634qSGzb72T
         6i/ORhawNqs5zsym2rSeiJjplv71vo1LWAmB0P/mC5szl9rNdD2iO7uGTcSxcuk+6ZBk
         IPZWzWKEIpmY+hHTdNyS6XE3aDlUqQxD33CMuu2lhhmzDv+o1sZ4asQfzjtnWszTQ3i0
         G6793PvMjM0zyGsCCGOLxLPV/G30XoAYa1Btiurs6Gz4brnZ1dyn84NeBvL827B+HuMs
         SX/qFNnSPCy0cIvl2Vr6lR2BqanZLdcEeWCMeJv6dOFmRB32gvYynyI5U8mZAM5eLEkQ
         5Dfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765254710; x=1765859510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9tmXfHJq0QVXqDhHx3V0hpna8uVRq5KY1OcI6d6XAb4=;
        b=kwLMoHVfXzc8a3ZmDRwpfo6pujPeik/YUS5T5rOov4IMDro/2GJgViyxKD2J77lg/u
         zXEAGC23W2sIqJrWtLkP8or/pcoPQ9icxi7xXsv0sySBWrTTnhniVUmCvHPKVdcoo8Rr
         te6+YGTktR++BBx4lDsW5bSde7nYV8XcDOxocTHYV/fGuGUKh+ZbqjSDBtagXa2b/iDl
         KF6VkKgAbtybytJ167nDKjq6Xvs0reLY10kni6p7uwiRwtJsUI4lZ+PrNMwyG/VF9LyR
         qMiW8Ecn9gyvznOK2Jt/a402VGKO6YqUSgk3cufE56EFGrMDJPOXk25QrHM1wKEFufWq
         Kuqw==
X-Forwarded-Encrypted: i=1; AJvYcCWsmZ3kDQMaxN4ryw507cfHgmOhHJo3L/ObAdLoarwwtD9kbHEZ7N5cvy9beHhFZPLtvpfUtv+2fJj7OZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdINbqCtoG1zimiZoyN0wbw8UlS+bCKuSW1EUbSRMxFm2CX52L
	UtB3vKDeUbxQy/ZXwtGD2YSMKUWjd7ZWzwA45i4sOHhsg84vl1QlqwNNPkqQN/C9/RZnoTVgUAn
	tTj9wPfS65LuhwRJUWz97WrTFPtpDnr83TLqbej/sIIP7X6PdJqwfgKPFwE7vj9Kj6+N8lTe/ec
	f5ObzAz1mp1KhaNkfs4ItM6kKmhae3sVqQbiZzG8Ck
X-Gm-Gg: ASbGnct0lOG+fXmofX4au5hDpugSeBkpUbnoPxa9FCrs569vNAfszZNALLNvWHXbFTB
	f/kk03g0Ho63sndMEYn0YO8qVM/NFUI5aERS1DFy3Ca6Ml8I9mTcdIiPekkbikzArqRxJxMwW0L
	ytlE55sJ/dJmEa2zG1tV4BawOAADvJ/KBdgvcoLg1RYp8rYsJRpmtyIjQOV0bs/KEhfQ==
X-Received: by 2002:a17:90b:1fc6:b0:327:9e88:7714 with SMTP id 98e67ed59e1d1-349a260cd80mr8868160a91.37.1765254710098;
        Mon, 08 Dec 2025 20:31:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFagAAGBSIWmzncNsxEEwGIidmm4QE94jTVbMl759ESR/ChF09NNZHQVDtrpBmXJlpRB/zIr6Mggn3wUbwJ7vY=
X-Received: by 2002:a17:90b:1fc6:b0:327:9e88:7714 with SMTP id
 98e67ed59e1d1-349a260cd80mr8868139a91.37.1765254709673; Mon, 08 Dec 2025
 20:31:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209015951.4174743-1-maobibo@loongson.cn> <20251209015951.4174743-3-maobibo@loongson.cn>
In-Reply-To: <20251209015951.4174743-3-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 9 Dec 2025 12:31:38 +0800
X-Gm-Features: AQt7F2pZ0rzBBD0Uxig88MPBNmx1a0sCvffl8bC7YDxWOQkpVfaZ_NVPBNCGzo4
Message-ID: <CACGkMEs8E9DYzmZ8k4fH7h=fxC07wMsHizyDAE3wiKmQhkW3Uw@mail.gmail.com>
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

On Tue, Dec 9, 2025 at 10:00=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> With function virtio_crypto_skcipher_crypt_req(), there is already
> virtqueue_kick() call with spinlock held in funtion

A typo should be "function".

> __virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
> function call here.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

