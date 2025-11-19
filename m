Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39BE274B34
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763562031; cv=none; b=ZzeuT2pMhz4mutisx622SvwP0S+vmJgjs7g1wCA+Mrdb6ekT7cyExQ+BqDJFmbC9RJXUKYJ6RW1DJL6qXPyo+Grj1bDam6Xiqm7y/WXo4ruWibGndtaGGQCpdVBPgzH55ZtUzaxB7e8QtNwtpKzyiXeWZsTynTCUa47db8AOJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763562031; c=relaxed/simple;
	bh=XzRalQKs57czmv5x4N/a/52SISZhq2Nkv4q9UkJ+pyo=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Inf0WeNkDGcGthmQRpdtTmGEBZOOZ8Ww15MztnTphImxEWu0/NViFTkpbICG8Kxig6xHSlv3lMFD2OTEY2ww5xaIXLLSwa9Q+oTar7Cun3cT2rXGe632W7cxpPCgz0doq41ViyKHlh3Mt+7p5fgwnuvWwHiS3y6ETAaPzN7hruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hH49AX7l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hH49AX7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763562029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+eUfWZZGN6Clg4COI6/ZdHoTco2pZOYMsSV3TEOpY1Y=;
	b=hH49AX7lDqIj2WBB6ID4JyiiNEQ0mRASuXG9Yhqojc8hP0MqsiHAzLqJ3JBo4Zh0DoOkRc
	YBNbXt0ukIsEZgGhutF6Ia1xhG7lqAohugQvwsL0bTLIcViND2OSCrJWCbG5oSq8/riKy3
	MysEj+/EXFBBzXogkRMKFJyLHRAqNmM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-E_mdSrUXMpmGvhiu52itOA-1; Wed,
 19 Nov 2025 09:20:25 -0500
X-MC-Unique: E_mdSrUXMpmGvhiu52itOA-1
X-Mimecast-MFC-AGG-ID: E_mdSrUXMpmGvhiu52itOA_1763562023
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA6C818D95C7;
	Wed, 19 Nov 2025 14:20:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B14971800876;
	Wed, 19 Nov 2025 14:20:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251119035905.GA1743@sol>
References: <20251119035905.GA1743@sol> <20251117171003.GC1584@sol> <20251117145606.2155773-1-dhowells@redhat.com> <20251117145606.2155773-3-dhowells@redhat.com> <2165074.1763409175@warthog.procyon.org.uk> <20251117201233.GA3993@sol>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
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
Content-ID: <2450666.1763562016.1@warthog.procyon.org.uk>
Date: Wed, 19 Nov 2025 14:20:16 +0000
Message-ID: <2450667.1763562016@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Eric Biggers <ebiggers@kernel.org> wrote:

> I've written an implementation of ML-DSA verification in about 600
> lines.  It may grow slightly as I clean it up and test it, but we
> definitely don't need 4800 lines.  I'll send it out once it's ready.

Could you post what you have now so that I can have a look at it, please?  It
doesn't matter if it's fully tested, but I can at least compare the algorithm
to that of Leancrypto.

David

