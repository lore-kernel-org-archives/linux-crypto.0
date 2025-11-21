Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95A340A49
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763746898; cv=none; b=esXNvwGR/4sygceZnlfTNsSHEo7ZZW+Ks27StjPNkvckVrEal9hKX3txEDHEeeayikUdWO4cnRlD//ZazIMqpsSdWcsdksdpnCKd4KUQN2W5Pakg09uJapfytwE12t+Q0eZuUaaMfX2PmLcPHao+aJpidmHuOkH4ER4ByzHQhCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763746898; c=relaxed/simple;
	bh=Hr0jEcRhdkLIIYgRig4jVVH0qfASNwYnKxYMauD9L7g=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=go0GbkjDfq1F95leKqpqZzvcQ1IRgvYlLhCT7EsygODpL+fCAUSmifvPSaN+94gl88kM9WvO7N2JozmX8wyGryTLrzcydRParTFqSaWTKjGKsfXrWgQPFiWSzeO43sQQy2gtxxQR1rAREqRuHh88nzQjxr2yjH0gD3BcQ90BLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BTWPWwx1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTWPWwx1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763746896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hr0jEcRhdkLIIYgRig4jVVH0qfASNwYnKxYMauD9L7g=;
	b=BTWPWwx1OPcY234PdkIZmPG4n4DffMwt9c83+mUWYo5OwurSHV5kSOfSxlNvt/jhdDEtn6
	r8cWxQGro6OTrNB6Xl/9iiDLBxv23NS9wUiZddYkImFJAn6vc5a5ZYh/dwbzYD1+oYyB1W
	1tQ/C1k+8bWST3hVftlgqm+HGc63IKw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-e8P11Z0mMvKXmHXx4Gzk9A-1; Fri,
 21 Nov 2025 12:41:31 -0500
X-MC-Unique: e8P11Z0mMvKXmHXx4Gzk9A-1
X-Mimecast-MFC-AGG-ID: e8P11Z0mMvKXmHXx4Gzk9A_1763746889
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE08B1956094;
	Fri, 21 Nov 2025 17:41:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE8401956045;
	Fri, 21 Nov 2025 17:41:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251121171421.GA1737@sol>
References: <20251121171421.GA1737@sol> <20251121005017.GD3532564@google.com> <20251120003653.335863-2-ebiggers@kernel.org> <20251120003653.335863-1-ebiggers@kernel.org> <2624664.1763646918@warthog.procyon.org.uk> <2755899.1763728901@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
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
Subject: Re: [PATCH 1/4] lib/crypto: Add ML-DSA verification support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3042396.1763746883.1@warthog.procyon.org.uk>
Date: Fri, 21 Nov 2025 17:41:23 +0000
Message-ID: <3042397.1763746883@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Eric Biggers <ebiggers@kernel.org> wrote:

> I could write it another way that wouldn't assume familiarity with open
> interval notation, like [0, q - 1] or 0 <= val < q.

"[0, q-1]" would be less prone to confusion, thanks - and editors flagging the
bracket mismatch.

David

