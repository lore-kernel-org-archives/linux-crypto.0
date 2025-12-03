Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E4E2FFF83
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772846; cv=none; b=DkrhhmxZCqpvAK4RS6AEmdQUxnQGx9kLD7GusUm3nI99PaTB/vU531VU+czO660ow4zNt9WmNgKdf3aZCnKGjiZD5FyG03EcCrs5wvpa5pawvNhDAqDAJwH5HjYkMDcNEAiOe85pvDted25urc6EzfoOExvkziLP5PnLYwB14Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772846; c=relaxed/simple;
	bh=sni84eXEYd+de2L/vVmmutjA/aIPRSlalbCS50kC3+w=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=mV5wL6/yMcx4Svzf3y/Ra/9tmp+s3s77uZC34PyZzKuwh7h5kS2KkPQTOFJAxehBEj+PTq4LM/ytbgJHMjloLulr4rTzBe7N6RkZUqViMwgmS3urmmY2PV+3GHsXifRgsMaQIuKa1B6zjOK+OMrAtctw5GzRPB7/pHA8vvyGPek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R6jnDYim; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R6jnDYim"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764772844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sni84eXEYd+de2L/vVmmutjA/aIPRSlalbCS50kC3+w=;
	b=R6jnDYimBpSMe+aUM7h6uIsgOyK6JHCVzazw3qD7ubc6xZY3FJprPib47N8R6LAk/jVaJm
	vJx1RNurwvaXGwftPrYQTJU6cbvI8gtsyIdQGprq+ruRgX/iqh8qZUsj15tOOYkCckP60B
	N7eletx2kpG1llmH5G1AtMeyyMeymOE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-t8h2yfuzPCq4fDB4xJVCDw-1; Wed,
 03 Dec 2025 09:40:37 -0500
X-MC-Unique: t8h2yfuzPCq4fDB4xJVCDw-1
X-Mimecast-MFC-AGG-ID: t8h2yfuzPCq4fDB4xJVCDw_1764772835
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 300BF1800358;
	Wed,  3 Dec 2025 14:40:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B001530001A2;
	Wed,  3 Dec 2025 14:40:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <94cb715bd8782b93e10a285c6dc6ec58@linux.ibm.com>
References: <94cb715bd8782b93e10a285c6dc6ec58@linux.ibm.com> <20251203072844.484893-1-ebiggers@kernel.org>
To: freude@linux.ibm.com
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    linux-crypto@vger.kernel.org,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>, keyrings@vger.kernel.org,
    linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] lib/crypto: ML-DSA verification support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1937479.1764772829.1@warthog.procyon.org.uk>
Date: Wed, 03 Dec 2025 14:40:29 +0000
Message-ID: <1937480.1764772829@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Harald Freudenberger <freude@linux.ibm.com> wrote:

> ERROR: modpost: module mldsa_kunit uses symbol mldsa_use_hint from namespace
> EXPORTED_FOR_KUNIT_TESTING, but does not import it.

Change EXPORT_SYMBOL_FOR_KUNIT() in patch 1 to EXPORT_SYMBOL_GPL().

David

