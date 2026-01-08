Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154324F49B4
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883184; cv=none; b=EciTXF3Tw7GMJQPZpBilfLzTQtiEhpu+PIUTwTL1rbL2ibmthC0CligrWXWKl4hFHI0wwgBlCimgJDlw1vhd6qib1x2sgPof28LHT0eAVKYDWIWirMxE17Gmxtq97MIpx9fGB8CvaqlXo6Ff3Y+hb73TlR5V9Q9rVKDrDZfRPZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883184; c=relaxed/simple;
	bh=zqlpV6DbTKoCGK9NC+KbLnPIVMlnijqGp9q56WaghPU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=XUdXG+PyzyGcuJ5swecNNegZ6VM8uiNm1LjEb04vUc26aqR9yLDliA7uRzJmpUhfh7FzSG/pJUnk7Rrtcm8+vbswKi0/FUMwprDRIeXo0VuC5jADeQFrO87F1D5VpIwlDiI0y/64So/IcDsbUlPnyOvFzhtmton5Qb+2+5zkoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sp2KudkH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sp2KudkH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767883182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xavvcy3ylIyhXK0YnQ/tlLr+yZsLJAzxUsW092yA/h4=;
	b=Sp2KudkH5kUKQ2b33xXpRKKTAyhse6e8eYtlfdoCaO5iilR1rYNr/ausTcF67NraXUZl5A
	B5qmPM8w/3xCjPcd7F+kBlbq9cXR0Jw3uGzytQNXtVyal9aGYqnUwj/yghdl+ldVlRNbPR
	XEv5OvZog68PxrewgFDcAHU4hvbKHOQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-T0-hkGQwNvOxYkaU7lh8-A-1; Thu,
 08 Jan 2026 09:39:37 -0500
X-MC-Unique: T0-hkGQwNvOxYkaU7lh8-A-1
X-Mimecast-MFC-AGG-ID: T0-hkGQwNvOxYkaU7lh8-A_1767883174
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 191D01956095;
	Thu,  8 Jan 2026 14:39:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2679E1800109;
	Thu,  8 Jan 2026 14:39:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aV-t3m-ZxAcEqZmq@kernel.org>
References: <aV-t3m-ZxAcEqZmq@kernel.org> <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-7-dhowells@redhat.com>
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
    linux-kernel@vger.kernel.org,
    Tadeusz Struk <tadeusz.struk@intel.com>,
    "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v11 6/8] crypto: Add RSASSA-PSS support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2745023.1767883164.1@warthog.procyon.org.uk>
Date: Thu, 08 Jan 2026 14:39:24 +0000
Message-ID: <2745024.1767883164@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> > +struct rsassa_pss_ctx {
> > +	struct crypto_akcipher *rsa;
> > +	unsigned int	key_size;
> > +	unsigned int	salt_len;
> > +	char		*pss_hash;
> > +	char		*mgf1_hash;
> > +};
> 
> Just a nit but I would not align these fields as it does not serve any
> purpose here.

It makes them easier to read.

David

