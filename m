Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3DB33F8BC
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763716376; cv=none; b=ppQ23qs/1Q4IkEKgn5iLOiIRc72W9h3FvabtXWiCAaK1AyiHzqRAz8tv3GR0N/U1tiC/oneGBaQyXHCkhgwXTCY59+8B0Gjmab4atoRU7wcwt9tCzJ1HHtP9YToZcovDemr9jIwHSpyR68x14sRcHYK/rRBNEP2Zi8ieIStrDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763716376; c=relaxed/simple;
	bh=AhavRC6EmF0l6ir8nwoVV3cT0z3jLuMizuyIOWnWASU=;
	h=In-Reply-To:References:To:Cc:Subject:MIME-Version:Content-Type:
	 From:Date:Message-ID; b=Qj2pPxxJKbbj6Bck0Xq/hxV+RjFyShfcxMtzJ5OyzexFY4Igp8NxOAPIXHE6Fpv1hBu4TRKaYojn9xO/BhtQor43Xd9/n1l9aqTVzUvz/l9Qx0zFXZIpAmZeZFI09hfibJXJW6LgMtbRrY6PTz7wZgHEtNuACDzNfiOUAdSm/JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DjmoYtiD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DjmoYtiD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763716373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uL89+rBjjVV4/LzkRs7OQb+350Kendo1iKi6sy4qmcI=;
	b=DjmoYtiDAm9/9fZEbNvVUJaZfusHhV69t3y8Z1cwnGKQj55FnXgcXwijeNtABQAV61XY8Q
	e685oN/n3wJRuwcPW9CYBgZqbAt9/Y1V+1VpUfgeK3WqOyBYKxFWOzPlUeope+0k+dH3Yl
	CeWeP+qUR8byEL47VsuU8qYv6hci8Xk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-BLC0BZtkMpixwl1Fe7e0uA-1; Fri,
 21 Nov 2025 04:12:49 -0500
X-MC-Unique: BLC0BZtkMpixwl1Fe7e0uA-1
X-Mimecast-MFC-AGG-ID: BLC0BZtkMpixwl1Fe7e0uA_1763716368
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33413195608A;
	Fri, 21 Nov 2025 09:12:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C82A330044DB;
	Fri, 21 Nov 2025 09:12:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <aR_spUmU7FswxA2Q@gondor.apana.org.au>
References: <aR_spUmU7FswxA2Q@gondor.apana.org.au>
To: Joep Duin <joepduin12@gmail.com>,
    Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, davem@davemloft.net,
    linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix MIC buffer sizing in selftest
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2735293.1763716310.1@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
Date: Fri, 21 Nov 2025 09:12:45 +0000
Message-ID: <2735328.1763716365@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> >        /* Generate a MIC generation request. */
> > -       sg_init_one(sg, buf, 1024);
> > +       sg_init_one(sg, buf, message_len);
> > 
> > -       ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, 1024,
> > -                                 krb5->cksum_len, plain.len);
> > +       ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, message_len,
> > +                   krb5->cksum_len, plain.len);

The buffer doesn't need to fit exactly, it just needs to be big enough to hold
the output produced, but it can be bigger.

David

