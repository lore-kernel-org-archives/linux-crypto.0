Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74E2F25FE
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 10:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956540; cv=none; b=pG1SCtnPg2d2PKbF1sbiw4rqrg8gm760Hs5VnM6xPW7PuKImrPJbZQJMMGKDxAgvlkw5P7SpXt6HJvXzFqKz2CQm/vJs1Jxleckej32027VKzHjw/QLTtOjqUspYQCoUIhNTf9QgBV56KkWh/6W7dS4rv62xqhoVFMynTQYBW9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956540; c=relaxed/simple;
	bh=d6xOn+OgWXQb76sNinZ8VoFwbnnrNk5YxBP2M1Z16Rw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=iTxkaxlrStZd9dEOCG4biYghsRvLHQWj+8lZpj956gPXvX44xFs2yu8gu9+rVuZVq6WvS6H33SQrGL8rOrJwmbNE5yE17HKa08B5TWP5HcqJfhcP7zEPBSXAVX9uuOCxgAoOI4tkK2l313m7jnm0j8q40I91LD0+neeZXf5NnN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKdtV9U7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKdtV9U7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760956538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d6xOn+OgWXQb76sNinZ8VoFwbnnrNk5YxBP2M1Z16Rw=;
	b=QKdtV9U7F44nzWM1/OMmdsP43cPkI0OQJ5LOyjd59//z1VribOOQTifOjmRihwXjDdwhk5
	AKfgziNiz3ftcV5bh3tPiDEg4U8cJscXcYrbeqFFgoUUNGRuF7hdDM/WLHVAQOdVwqXBX1
	iVvhTY3Eag1hwiR0qGnpjO4XsbYeZ9I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-v350hqWrNxSXvlNLKw2vdQ-1; Mon,
 20 Oct 2025 06:35:35 -0400
X-MC-Unique: v350hqWrNxSXvlNLKw2vdQ-1
X-Mimecast-MFC-AGG-ID: v350hqWrNxSXvlNLKw2vdQ_1760956533
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0B011800657;
	Mon, 20 Oct 2025 10:35:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC77A18003FC;
	Mon, 20 Oct 2025 10:35:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251020005038.661542-17-ebiggers@kernel.org>
References: <20251020005038.661542-17-ebiggers@kernel.org> <20251020005038.661542-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    Ard Biesheuvel <ardb@kernel.org>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
    linux-s390@vger.kernel.org
Subject: Re: [PATCH 16/17] crypto: jitterentropy - use default sha3 implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1062227.1760956530.1@warthog.procyon.org.uk>
Date: Mon, 20 Oct 2025 11:35:30 +0100
Message-ID: <1062228.1760956530@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Why don't you take my approach and just call lib/crypto/sha3 directly rather
than using a crypto/ object as an intermediary if that crypto/ object is just
going to wrap lib/crypto?

David

