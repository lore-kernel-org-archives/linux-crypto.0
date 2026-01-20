Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C02389E1C
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768935298; cv=none; b=OITpB3d0W9T80rgw3PZRclkvKjKal8RCTioG+ugjuryLPWyyJGQZGSozt4VHdv+2RBIokZwyAOmncSguWephydHZloVCH9kP8q9Y32Am5KrswJVo8VXl4EqsDBIAGUz4QJzsYQLo9CzlDIHkQguLTP4qqeNM7QshE+9M9QjTI10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768935298; c=relaxed/simple;
	bh=UmDmllkKFjkCiOZtqgSm9+YSpt4oICA2ToQGkwAkWHI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=QiY5ESKwzlqhAqRP4S1tN+zz7leeLS48fot1OOvrV7qVzQvsYJDrLVIE8gxH2rLOmZomoJzunB7HQN7Fsq9gWXmC2ivoigzGfDGR/6IHkUQH0Wj5zubDSlcfNB/1BFIa4EeZUlEwvxsBEyJuJbdBrX8fTDeGH0QViLKU6yP3wII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3KLBsqc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3KLBsqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768935295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGEbMO58pWFpo586Yx2mM/qYqmSSnya9dTWcBb/G2Ng=;
	b=c3KLBsqcg7HiuQPrHXVdB9RBailzz1jzrjophVelk7Bu+iXeWuSxkE64igjWtN3ByXRnae
	g8DpQFUglKHcCuWOZtwqAh4mA04w89i52r6mkSp5A8cY/c1Xc1mIYg2w20Vk+bm5mbSjqN
	RYYObEWbE+hMHFR6ZqYwHSlzLy8YYoU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-4rEg7r9ENG2dVlr-Ds-sMA-1; Tue,
 20 Jan 2026 13:54:52 -0500
X-MC-Unique: 4rEg7r9ENG2dVlr-Ds-sMA-1
X-Mimecast-MFC-AGG-ID: 4rEg7r9ENG2dVlr-Ds-sMA_1768935290
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D31C21800371;
	Tue, 20 Jan 2026 18:54:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6540D1800285;
	Tue, 20 Jan 2026 18:54:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALrw=nGSr7F-NJri+UFgBVz5J+KFAS6OXa9EFvYo-qitX9R2bg@mail.gmail.com>
References: <CALrw=nGSr7F-NJri+UFgBVz5J+KFAS6OXa9EFvYo-qitX9R2bg@mail.gmail.com> <20260120145103.1176337-1-dhowells@redhat.com> <20260120145103.1176337-12-dhowells@redhat.com>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>,
    Jarkko Sakkinen <jarkko@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Eric Biggers <ebiggers@kernel.org>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 11/12] x509, pkcs7: Limit crypto combinations that may be used for module signing
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1343167.1768935284.1@warthog.procyon.org.uk>
Date: Tue, 20 Jan 2026 18:54:44 +0000
Message-ID: <1343168.1768935284@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Ignat Korchagin <ignat@cloudflare.com> wrote:

> > +       { "rsa",                "emsa-pss",     "sha512" },
> 
> Don't we want to allow sha256 for emsa-pss?

We do.  I already added that for v14.

David

