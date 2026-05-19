Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FB7233937
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193467; cv=none; b=dDPZMF/EnIMw4PhL9hxaeIX/8uqartmGnPfYKD6+yJZWxAE2EvS1xFwg+DQzWJ28xiBKl4Tb+KnEdPFp2lgp9MYRUf0eTFBVKc7e5ymspVW3sJyecibdiA2k3l+RqNJIU+FOTW8xdRvBZuECIrLIEglKkrPbz6RRm/7keIT2K9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193467; c=relaxed/simple;
	bh=xTOZFkdwaHTIi4LBFjC/re1Gqzaz3oflEzC5vauqpX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvk7Ggd2GRXO5bZV90FiwE6AnkQEI1MvFDL2ymaywYUVDYSiOr2L6wvvhhWit6XxF7Av7FlzTuBq+erQj6J+xA6us496d/r2BafU1KyzA8bxNp7HTWdgXlbTEKqNCL4d4Mjoar+nu0qcYmXFFsXstT/XjpN7qc3n0NpHasXS0gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HMn+CnWG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMn+CnWG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779193464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fLKlWochEjg6erN1qhELyXE0SxpIuzT6CN0hNtcb+o=;
	b=HMn+CnWG+Jmc+4di161nGn6E6a30By6ejjDLGEqIQUX6EBMzB9ZhIMNRVio2D4D9xU7WZJ
	gGvWzzXnMRLe5/bhKphBgJx7wxltI8MSXVrKZshA8sOghgz8GfNLzsip9CobK+2TivENvQ
	AGw87YUFwNzaUdML093Id3CQdxljX0c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-f4TLgOK1M-yF59u116AQlA-1; Tue,
 19 May 2026 08:24:21 -0400
X-MC-Unique: f4TLgOK1M-yF59u116AQlA-1
X-Mimecast-MFC-AGG-ID: f4TLgOK1M-yF59u116AQlA_1779193460
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A60718005B6;
	Tue, 19 May 2026 12:24:20 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2363230001A2;
	Tue, 19 May 2026 12:24:17 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: herbert@gondor.apana.org.au
Cc: akhilrajeev@nvidia.com,
	linux-crypto@vger.kernel.org,
	ptalbert@redhat.com,
	vdronov@redhat.com
Subject: Re: [PATCH] crypto: tegra - Fix dma_free_coherent size error
Date: Tue, 19 May 2026 14:24:05 +0200
Message-ID: <20260519122405.10860-1-vdronov@redhat.com>
In-Reply-To: <agvleqNqloWB6tpf@gondor.apana.org.au>
References: <agvleqNqloWB6tpf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, May 19, 2026 at 6:22 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
>         /* Allocate buffers required */
> -       rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
> -       rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
> +       bufsize = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
> +       rctx->inbuf.size = bufsize;
> +       rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
>                                              &rctx->inbuf.addr, GFP_KERNEL);
>         if (!rctx->inbuf.buf)
>                 goto out_finalize;

sashiko.dev makes a point here ( https://sashiko.dev/#/patchset/agvleqNqloWB6tpf%40gondor.apana.org.au )
that the code does not set ret to an error value, as done in the other similar places, see:

> -       rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
> -       rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
> +       rctx->outbuf.size = bufsize;
> +       rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
>                                               &rctx->outbuf.addr, GFP_KERNEL);
>         if (!rctx->outbuf.buf) {
>                 ret = -ENOMEM;                    <<< HERE
                  goto out_free_inbuf;
          }

This looks valid to me, I'd suggest to add {}s and:

+                 ret = -ENOMEM;

to the patch indeed.

Best regards,
Vladislav Dronov

