Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64AF3002B5
	for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 08:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455172; cv=none; b=Ljn/L6EiT57HJnl+O6zeaSx0gxUI5jikdzY0652lNdyUXl+Ks3JSPNhgo3pQeyqCVtYyjBJL1AHwcWuUWLcy32grXnO8w9FjILyKOFylQy5pC44dPM/5v88dMbl5N804n0OdAXLYa7FBfb0XU7uzXhBPNN8wWMP5wy7RkcdF5Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455172; c=relaxed/simple;
	bh=EczDlkyDRFeAv68Aop81/CjtdTFYJJsFwEwAecerlBc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=hB3OBIfOSsrUb9YL5wudfIaziyvw5DF8yX63fvKYtfdjYz5TP7/CjLe6w9/bwq+bR0LxjF6kyVqqxBq08QwLw1r4VGAwFY5ArZLUuJOIijLJjccuC1Oa3fjrg1Q0ikunVTKWSCu+c0xt0lVRzRUdBfovLPaBCbM+CVBjB9x4Fio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z3/gGUFo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3/gGUFo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763455169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7FL0nv8u6A7f3to0nc11pn91OMRRKpxQEVPN+kjD6Sw=;
	b=Z3/gGUFoQkPjkRdqcAwFdXTd6J1xFRy5NR+wGarPb/3C+I4J5AgZQVNP+LC2o9Af0HK+Wy
	O6Dvfqb3Zl7cF9EEVZ6dy4Onk9MZfDs2asQrwzGo92NFUANaeL5BsfiU3Y3WggpPcuHG2Q
	nSr2MDUD+Yn8ReFp/eHxim3nNr+0Mn4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-140-gwAfvOgXMwiscJTRXIZsHA-1; Tue,
 18 Nov 2025 03:39:24 -0500
X-MC-Unique: gwAfvOgXMwiscJTRXIZsHA-1
X-Mimecast-MFC-AGG-ID: gwAfvOgXMwiscJTRXIZsHA_1763455161
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FAC418AB30C;
	Tue, 18 Nov 2025 08:39:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25879180047F;
	Tue, 18 Nov 2025 08:39:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <13213304ac049113655ab8fe1bae76cc84a3330e.camel@HansenPartnership.com>
References: <13213304ac049113655ab8fe1bae76cc84a3330e.camel@HansenPartnership.com> <20251117171003.GC1584@sol> <20251117145606.2155773-1-dhowells@redhat.com> <20251117145606.2155773-3-dhowells@redhat.com> <2165074.1763409175@warthog.procyon.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH v9 2/9] crypto: Add ML-DSA/Dilithium verify support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2187236.1763455154.1@warthog.procyon.org.uk>
Date: Tue, 18 Nov 2025 08:39:14 +0000
Message-ID: <2187237.1763455154@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> But even if you don't accept that, Google keeps effective joint
> ownership of the code through their CLA and so could grant a dual
> licence to the kernel anyway without needing to refer to any
> contributors.

Actually, the fact that BoringSSL's ML-DSA implementation uses C++ with heavy
use of integer-parametered templating is more insurmountable for borrowing
their code.  Yes, it does allow them to reduce their LoC to ~3000 and is much
more readable, but I can't do that in C.  Now, if we want to work on
persuading Linus to allow C++ into the kernel...

David

