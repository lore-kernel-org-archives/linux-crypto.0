Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BC2BE64C
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758264113; cv=none; b=rV6riC557l1lT1FnQ2if4ycrWQFI5t6d5jlf0/4rKAbBE9oyT154CUT+wgKGJzhqFVT5pT+f0bRPG+b3cxsfGpag+7nBfAn+fNq2EhK6xt6V6tBP9SGwGjWVgtdQU0ms9sRT304uw2SJ6dRVRC20Mmh1N/c89qh2gVt/Ey5ZHfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758264113; c=relaxed/simple;
	bh=s2rdono/3DbgOoms+X4wh3Ts6y0yWfwYHo8BmK/NO+U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LuEfUBYXx7sLQBIpDfX5umPypF9YWnK1Q8Bu1yFUiPxmFKjq4D5mXnFa9WE3hHvuXTX7Y5CELWWkN8d5GstUGrqIIxTorLhjh0gq+PUmpcFDJfcplS4WcduNmIto+dvWwSMLGKvwaFCFDTQiANjXCSIg2W6we82QP2a6UPvV2w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYz2OTsu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYz2OTsu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758264110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7/E6DgjcRa4WSI0uW8+A9RGbvBI5JspSJUs0+h9SSIg=;
	b=CYz2OTsuU9HV0Ql4jCg8EDLB2OppNGSpqd5s75M2/pQbxSai4R+FVCBWv6bnU/6v5y245Z
	G22CqM1OCLw2LKcsVGl78RZeG71gNpmEj2niKQOEmBkC7HfRAKWxV9yVfEWNlPGOeuPD8i
	UFxrNs/8qR8eOjANLl3a83/RRs9mRWA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-0PYr2VMtPtuFDqFgmDFsXg-1; Fri,
 19 Sep 2025 02:41:48 -0400
X-MC-Unique: 0PYr2VMtPtuFDqFgmDFsXg-1
X-Mimecast-MFC-AGG-ID: 0PYr2VMtPtuFDqFgmDFsXg_1758264107
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 406AE180034C;
	Fri, 19 Sep 2025 06:41:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CB21119560BB;
	Fri, 19 Sep 2025 06:41:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aMf_0xkJtcPQlYiI@gondor.apana.org.au>
References: <aMf_0xkJtcPQlYiI@gondor.apana.org.au> <2552917.1757925000@warthog.procyon.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, Stephan Mueller <smueller@chronox.de>,
    linux-crypto@vger.kernel.org
Subject: Re: Adding SHAKE hash algorithms to SHA-3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3790488.1758264104.1@warthog.procyon.org.uk>
Date: Fri, 19 Sep 2025 07:41:44 +0100
Message-ID: <3790489.1758264104@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> I presume the algorithm choice is fixed, right? If so you should be
> using lib/crypto.

Actually...  Having dug into the dilithium code some more, the answer appears
to be both yes _and_ no.

It's quite complicated, and in some places it uses both SHAKE128 and SHAKE256
fixedly, but I think it can also change the pre-hash between a bunch of
different algorithms, including SHA-512, SHA3-* and SHAKE*.  At least, I think
it can.

David

