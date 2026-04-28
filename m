Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853EA175A72
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777357994; cv=none; b=CobZquedw4nBgC9qhXJeyx2ZTp85yoDjxZc9t7Xwx9ohkKM/JAwxrzduu3Nnm/wr8ao196iXOPyzLGC5jUJBpQtdVOGAZIiOEolO/CU7IBRLWJN6iyD+NIYv3l2DO5P5T16H4JV6pYZV5CJ1I2cbQILLW946kUknLAJR1LO+7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777357994; c=relaxed/simple;
	bh=CW3hcoza33JhAerj71GDszs36sHy/B91Rs6gy9U47ps=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jvDDOnsQjDqN2JE1kRQksZkoBMcxf3/H4o4Ce5ppc2PDMRGgx6Q98skaRuJxmm1CK08rFwpvRApg4pxP0D1ALqnH3njPN9G+Y++sGGJFMCYDjBTjJX8fjzezoJdTKikbgiuavGb6qlUonU9Q197XFjHX0ohoCCsMscmBoal42Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=azjFM9u5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="azjFM9u5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777357992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CW3hcoza33JhAerj71GDszs36sHy/B91Rs6gy9U47ps=;
	b=azjFM9u5vlDEB4PsSPYlw5AwaTC0Sn0t8SRoaRmmaWM679JhwPEmg2b8ks2SPyMAye0yS8
	dGnANHkZNF+FC5SuHvtxwaNBQdR8p5tZwKMvl2GbCXOMsbZEHJcuM3YVxHR9uchybumQYX
	m5fj/4LZURJrh0AqSLxVkd9tAdbVcqU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-XW9q4rQFOhObT0R2jxJKHQ-1; Tue,
 28 Apr 2026 02:33:08 -0400
X-MC-Unique: XW9q4rQFOhObT0R2jxJKHQ-1
X-Mimecast-MFC-AGG-ID: XW9q4rQFOhObT0R2jxJKHQ_1777357987
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33DC818002C6;
	Tue, 28 Apr 2026 06:33:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9FF019560AB;
	Tue, 28 Apr 2026 06:33:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260428024400.123337-2-ebiggers@kernel.org>
References: <20260428024400.123337-2-ebiggers@kernel.org> <20260428024400.123337-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    linux-afs@lists.infradead.org,
    Marc Dionne <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    "David S . Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 1/5] net/rxrpc: Add local FCrypt-PCBC implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <758508.1777357982.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Apr 2026 07:33:02 +0100
Message-ID: <758509.1777357982@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Eric Biggers <ebiggers@kernel.org> wrote:

> +void fcrypt_preparekey(struct fcrypt_key *key, const u8 raw_key[FCRYPT_=
BSIZE])

Needs exporting.

David

