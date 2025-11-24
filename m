Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56540339A8
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005111; cv=none; b=CkBn19/WsiCMIxhyuxaUKeBA/IqHGvYXdw/F1tHErEvad69dZeJwMCOFE1GHIzJ2m0PePQ9K6qntW5PrS6HmNhjxOv17n6HcekWLMh8KKJE3mRdq2ubav2KLf0wMw47YrREIjEHVrxDL09vQ4QKao0N3od1sTutw6IGpaxVE76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005111; c=relaxed/simple;
	bh=rog8izTyZItSq8AecdTwrKCqAbyTtcvKQrxRHZK0WUk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=txYqQPPKk7ZoO98ZB++597xuC07+9O/h3Em96Nt+DH2io3G3RzRBdX7lI43ix9bgsp/JW0vPLSqB/Qxmt10LdDIV99W3dBmeM3LtunkNJ2RoBRRlsFZFRuB5eqn0W6rT8yCvvWdh0HM+Y+jJTUScGFw6b2byZ37byMqTcPbh+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/Pd4IBl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/Pd4IBl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764005099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7jKcLo/G749CIiVMd6W/VrR6NKwjPFRBAsvLqGgVpw=;
	b=Z/Pd4IBlh+QAxpIHspuntwrwYC2NxXXQc0r/1mbHHbS11UpORdX1mPuh9aFZwVy2oTX1Dd
	B9BQyXpyMzTw7jxrdzXIBod2DL47MsxOyPhxi1Uig1zrjfc1ZbtIheKFV4RPNwRfMgKWqT
	BhGF7f0MNrqbePpPNrVf+QBxxuYt4vw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-V31kd6lmNtqOWu5fF7i6CA-1; Mon,
 24 Nov 2025 12:24:56 -0500
X-MC-Unique: V31kd6lmNtqOWu5fF7i6CA-1
X-Mimecast-MFC-AGG-ID: V31kd6lmNtqOWu5fF7i6CA_1764005093
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65D3D1954234;
	Mon, 24 Nov 2025 17:24:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 619F73003761;
	Mon, 24 Nov 2025 17:24:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251124164914.GA6186@sol>
References: <20251124164914.GA6186@sol> <20251120104439.2620205-6-dhowells@redhat.com> <20251120104439.2620205-1-dhowells@redhat.com> <3374841.1763975577@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A .
 Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 5/8] crypto: Add ML-DSA crypto_sig support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3647620.1764005088.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2025 17:24:48 +0000
Message-ID: <3647621.1764005088@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Eric Biggers <ebiggers@kernel.org> wrote:

> Still not really sure what the point is.  There's only one user of
> crypto_sig, and it could just call the ML-DSA functions directly.

Is it your aim to kill off the crypto/ dir and all the (old) crypto API?

Someone (not me) thought it worthwhile removing the akcipher algorithms out of
crypto/asymmetric_keys/ and interfacing to them inside crypto_akcipher and
crypto_sig.

Anyway, I'll continue using crypto_sig as that provides module autoload
capabilities - meaning we don't have to build all the algorithms into the base
kernel.

David

