Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649F9EAC7
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757969305; cv=none; b=K2/47dPACGbAC8IlvWb9cwlgBcGPD7GAZ6l/ZRvY2ajMZsCuB8u/R/xsRG1dHYgk6vRcV7d40ThLl+YUCExmh8wsjEkOtCOn/MP/8JcqL5TjkfzVaK0wSgka8lAp9OxaFlafPRYO2Z5BQH2ebo9L6flUTTBhlahOaWmX8wRAFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757969305; c=relaxed/simple;
	bh=wZSl5s8fmWFNvlmOaBeDn77E8Lb/THdWbXDu9Gttew0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=fWFFFEcwrSED/AKWJRHEhLZCCLlxZ3d681XOI86RtJnC++1yPfhPgP3gPNso4cdO7UFeh9T/SFT+h8PSSLrE4F/2qSfop9eQlqbRodV6KmokfMzuMiKvTuPNzvsodXEJG2gr2gHaAPCo7KrmXb/yrs1T88drQjO9DJNei8zSJbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNXtmHsD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNXtmHsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757969302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jEwxOkoJSJLNtHFeqRXzGgQ6PFGPRRqIWHEFFXTsfY0=;
	b=FNXtmHsDg+2Q0wE+C4fcZvIoa9H8Z8hVV14tH01yMqUXB6+gdptZsT4C3q6peEJm2xLip0
	EcX8cufDVjnsvScA26r4jHVgYvXSYfdkQ3MepHFI77FoU7GD569PwK5VVzVpW7ONDal5YU
	D4CTVY8ZljIdvX71lTz8gZu3xhnt4Xo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-m8zK1Jm0OyeJk1OFHjfSPw-1; Mon,
 15 Sep 2025 16:48:19 -0400
X-MC-Unique: m8zK1Jm0OyeJk1OFHjfSPw-1
X-Mimecast-MFC-AGG-ID: m8zK1Jm0OyeJk1OFHjfSPw_1757969298
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84C051800378;
	Mon, 15 Sep 2025 20:48:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C03719560A2;
	Mon, 15 Sep 2025 20:48:15 +0000 (UTC)
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
Content-ID: <2767451.1757969294.1@warthog.procyon.org.uk>
Date: Mon, 15 Sep 2025 21:48:14 +0100
Message-ID: <2767452.1757969294@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> I presume the algorithm choice is fixed, right?

I think so.

> If so you should be using lib/crypto.

Okay.  That will automatically use CPU-optimised versions if available?

Btw, are the algorithms under crypto/ going to be switched to use the
implementations under lib/crypto/?

David

