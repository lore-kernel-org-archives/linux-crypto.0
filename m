Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33472FFF8D
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 08:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770107868; cv=none; b=QurAhdRWrTJ9++WDurcMbmsUaeeGoF8s+lNayKYDrmi4eGQAylnw7dwziTn2AWh0kXu9Qtoiwke6aJQY+NCWsEhqFmLj9blOScAuyFkSHRvYyPgeobhw4KxcP/GuBcYg7m/snIXyaEgwJYqhY09bkqxu3090Mh1kTunGW1iojgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770107868; c=relaxed/simple;
	bh=fhHFRlG3WCN2W/+rRzgUganS8d2ZUMiekULHR4bbk1U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Sm9RzLh5FP5Iu9EPToTaMzquhn5XPPm8C72aLFGDZYimQzbgT7GXJszxjVC7DNbfcpFDOZeiHnsfCBQv94y4CGw0OZ9aINEH1nbAHQ7ibQivq33EOrm0HO6AejoAIjVv8yadkYaHr/zLBYLZNwbvJWpGCWKZixxtJeFIgvnTI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iN6YdBIH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iN6YdBIH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770107866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t011cPPxfFjL7A/dPlf694kTW9GQnC1PCROS07B/K/U=;
	b=iN6YdBIH3JXWMHBzvAw70L141sOVHKmHTO24VIWI9X5KDEfvL62d2/fJ4JccbiZNVU1gbx
	NmbGuSU1Qf+u+N9lYxJ25ovRANGZGp21Var2p2dyNzFo2KufYLMHp0ri5dvWxTxo9UHDKW
	VjrD700k4UFr+TJncmjotn2ud8S1tpY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-SBygyrJcOJKcJ7bPyQoI7Q-1; Tue,
 03 Feb 2026 03:37:42 -0500
X-MC-Unique: SBygyrJcOJKcJ7bPyQoI7Q-1
X-Mimecast-MFC-AGG-ID: SBygyrJcOJKcJ7bPyQoI7Q_1770107860
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 304C6195608F;
	Tue,  3 Feb 2026 08:37:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F71D30001A7;
	Tue,  3 Feb 2026 08:37:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aYFBbGmMTszT3ZRb@kernel.org>
References: <aYFBbGmMTszT3ZRb@kernel.org> <20260202170216.2467036-1-dhowells@redhat.com> <20260202170216.2467036-5-dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
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
Subject: Re: [PATCH v16 4/7] pkcs7: Allow the signing algo to do whatever digestion it wants itself
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2546580.1770107852.1@warthog.procyon.org.uk>
Date: Tue, 03 Feb 2026 08:37:32 +0000
Message-ID: <2546581.1770107852@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> > +	if (!sinfo->sig->m_free) {
> > +		pr_notice_once("%s: No digest available\n", __func__);
> > +		return -EINVAL; /* TODO: MLDSA doesn't necessarily calculate an
> > +				 * intermediate digest. */
> 
> Is this logic going to change in the foreseeable future?

This is only used by IMA to retrieve an intermediate digest, so something will
need to be fixed to support use of ML-DSA in IMA, but I don't know what yet.
It doesn't, however, preclude the use of the rest of the code for module or
kexec signature verification, so I think it's reasonable enough just to emit a
warning and return an error here for now.

David

