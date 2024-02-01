Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC4E7D3F1
	for <linux-crypto@vger.kernel.org>; Thu,  1 Feb 2024 05:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706766569; cv=none; b=S8cskmLi49wX8dO5I7cn/d2N2fw/w+Dyj5BOS8fb1yOW24X/3cchQa/4SAYkJNTL+s+5bG6NW9H3YulR74qguylFbEKYIJbLzhuDIXpyn6w05f2VByCRdhdy9XsjDdIj8t+tA1orDm0JJYEw19zqKn082lfiQi1UmGGf7XEJWBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706766569; c=relaxed/simple;
	bh=KIExdWHVmutlvlT3+obd3h+YUc2wXhpfig1qUZ2NMOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LxrSQheTygQ4KvUf3MAVuZpF2qavb+SHnPwciKwwJKnU/6QWAHrUOSOQD0FRLX+XuR2NsTaXmptD5577gWCp+5muYhQqRd3aHiZzOCsUj92tbcyNTx9KhgcMpqSoubViIACOYFuZTvg1aOV2Wz7DPQD3qw2TTzYPbB2zfiZGDWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HiPDTYhp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HiPDTYhp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706766565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgbdx/AAaJZ7DeK9FOsHQhtQNYQ6A6a2HZZVAxKhKQQ=;
	b=HiPDTYhprKnOWm+9bzsnARnRuH4JvfeSrCVd4enMfyaQCzY2ajqJiYcJmrcG0cIVEBN63Y
	GT9jeJE0bjEuwQmRZI0RzzpBd1PjYwA3viS+uyMaSaX1aWMmaJwWWVVj9Hoxh4Wqo5SBSq
	fnL5Y/x7vMVkdQFIf+pMU6zbtvKjHTg=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-OOSIk1ZQN863vTL1JqRgiw-1; Thu, 01 Feb 2024 00:49:24 -0500
X-MC-Unique: OOSIk1ZQN863vTL1JqRgiw-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3be76c32883so528998b6e.2
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 21:49:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706766563; x=1707371363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgbdx/AAaJZ7DeK9FOsHQhtQNYQ6A6a2HZZVAxKhKQQ=;
        b=Iku/IcmgA8q2nLQsSRTHLDV1OKyBwnLuhktonM5S0Ka3NoGIFdMpIbvB5R093QJYqs
         Oaq2ixFv386VV2RF207/Yp3WN680cvhg3iGr7rhAKekC5az92zxO6l8u+ayb+EjscJ2O
         0V9IJMLi+FGvmY9B8AU2eHpm9NY7sG5BqRUN0CRRURSQqmI68eu8RiQ3ybgsELzwVDgF
         rtgNpzR29qF5k9C0CLfMBCcGrqPft9qNdaAfh9SIWT0NPslgwV19pWWrwrz6Vlcy0lHw
         AS9evO8ilypJ+FiJhpT5nevt1+pKEWM51xZKbLHC/jGknj/Iv6x4Ij/5oyd8Jwqn99QB
         WrEg==
X-Gm-Message-State: AOJu0YxabouLucrIN8VnuyKWYeulG1O49i6rQvuYA9yEynboZZC4uxco
	7cJq+YhJT7GU8Ye+3IXS00bJqxA2n9xNUnj11jEenzhhU+fEDNc8pMcTYSwQ9OkN0DSN3kT4vxE
	VOLN2gmJnXkUvK94Wc3qF+ya+eLhIps9irJuo23CMKK5QwpHU/1TYdgiuO0Lb4e/9vpBNHiWnkU
	EZZR/gvozwbUaVm6dCHsld86JoVNN5W3SeXLPE
X-Received: by 2002:a05:6808:3092:b0:3be:37ff:47d5 with SMTP id bl18-20020a056808309200b003be37ff47d5mr4229264oib.32.1706766563547;
        Wed, 31 Jan 2024 21:49:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXjMe0eEIqZ9DC5AR6JP7575RarbQIvdtQ/UTHdrVnUvzMt8FJ1hfqImdtib1VNlENwMqnPvjlqh4Qnql0aEg=
X-Received: by 2002:a05:6808:3092:b0:3be:37ff:47d5 with SMTP id
 bl18-20020a056808309200b003be37ff47d5mr4229249oib.32.1706766563285; Wed, 31
 Jan 2024 21:49:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130112740.882183-1-pizhenwei@bytedance.com>
In-Reply-To: <20240130112740.882183-1-pizhenwei@bytedance.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 1 Feb 2024 13:49:11 +0800
Message-ID: <CACGkMEsrMcAbrsfupDJ_fK_RTA8zRtGh77UBHeXZMiRxCaWypg@mail.gmail.com>
Subject: Re: [PATCH] crypto: virtio/akcipher - Fix stack overflow on memcpy
To: zhenwei pi <pizhenwei@bytedance.com>
Cc: arei.gonglei@huawei.com, mst@redhat.com, herbert@gondor.apana.org.au, 
	xuanzhuo@linux.alibaba.com, virtualization@lists.linux.dev, nathan@kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 7:28=E2=80=AFPM zhenwei pi <pizhenwei@bytedance.com=
> wrote:
>
> sizeof(struct virtio_crypto_akcipher_session_para) is less than
> sizeof(struct virtio_crypto_op_ctrl_req::u), copying more bytes from
> stack variable leads stack overflow. Clang reports this issue by
> commands:
> make -j CC=3Dclang-14 mrproper >/dev/null 2>&1
> make -j O=3D/tmp/crypto-build CC=3Dclang-14 allmodconfig >/dev/null 2>&1
> make -j O=3D/tmp/crypto-build W=3D1 CC=3Dclang-14 drivers/crypto/virtio/
>   virtio_crypto_akcipher_algs.o
>
> Fixes: 59ca6c93387d ("virtio-crypto: implement RSA algorithm")
> Link: https://lore.kernel.org/all/0a194a79-e3a3-45e7-be98-83abd3e1cb7e@ro=
eck-us.net/
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

