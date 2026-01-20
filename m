Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EB14418C9
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921251; cv=none; b=JhErKnOBRZNVjkB30+8+TzZmLAscdr4nzdvHNiZDUour1LHu0NCo6kZAw0Ak06RXuKnSY5i9h4IrH6BKYYs9CK7Lx7xt3Aw404CtC7AIS0xsDqwgSX6V3ADuJvyrHwHvbeuiOCgc78WDy2FvKxkXCIHum0GG9yud/snT+D+151s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921251; c=relaxed/simple;
	bh=TemsTHioIY5WLiygAw5nKUzfFVYRIp94NhL76tksVpg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=G8uxQWysLa/p5Eha2ZUz8P+Z+uLSfK0t3egXr6JG4XctRDu7Gt9oHPiB/x3HNXHjr7pMJ/nMDwX+xBjVYh/UqdIv9Oiv70EkfndD5Pv6jRWh7v9uUabFEUtd9QplyRDcNCbD56wYyELg5ZklOPP3TDlV9Pzg9OSXxzrWwuP4e6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gU/DzTwl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gU/DzTwl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768921248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EjFdRA3SqjnApn12sdGYpetFrYJP2kwbu9n6JNTKMtk=;
	b=gU/DzTwlZUEWTnbwu2mA0xtDK1rtMxUAcIeNZu4Y2gdWMDfr43mUNs3UejZEE3H1KgoB2b
	D2TAcQh138QB7cZiVpIn95trnU0RWP7dxp9tuyZeJgpj5gxWAsAQiW71qst9scDbWVazNx
	o67v+QNyCyO9J2FgsYFiZDpPyAd/V0A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-2w0E1mfVNx2Edq0k-LCm7Q-1; Tue,
 20 Jan 2026 10:00:44 -0500
X-MC-Unique: 2w0E1mfVNx2Edq0k-LCm7Q-1
X-Mimecast-MFC-AGG-ID: 2w0E1mfVNx2Edq0k-LCm7Q_1768921243
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AB4F19541BB;
	Tue, 20 Jan 2026 15:00:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8196730001A8;
	Tue, 20 Jan 2026 15:00:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260119185125.GA11957@sol>
References: <20260119185125.GA11957@sol> <1010414.1768841311@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: NIST FIPS test vector failures
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1176723.1768921240.1@warthog.procyon.org.uk>
Date: Tue, 20 Jan 2026 15:00:40 +0000
Message-ID: <1176724.1768921240@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Actually, one external test (tcId 35) does actually work.  It turns out that
that's the only expected-to-pass test with an empty context string that
doesn't have an external mu or prehashing.  So I've taken that one as a test
case.

David

