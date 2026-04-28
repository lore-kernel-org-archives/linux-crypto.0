Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559735898
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 06:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777357469; cv=none; b=aLP8mEE7u9lslbchoS5jX+/BkWNBfDh1/398zWuW2E2DHjTQrw+mGJdrT94wgtNmfW01szb6eG7oVXXp0lClms/aQFekcb4jVPm7Y86xDLrjHrdcgmgyQGFzsM+CLCjJqOcIJnWluthbUok55oM7EwiiQ07xIEv96qDyXZwh8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777357469; c=relaxed/simple;
	bh=gpvaJa3EDIh4Rbzk+4FqyiGMM54LZx/wqMrcj8IPT2I=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZIIxcu5xoDrusW2zu+bjmVR3GJd9MzW3GKu/Rltw0FEAUR3VDeeO3zDa/xKqZ7XeD+sJTaZ4mbbE6j3jZUaUuTWDbX7NkvSQG4qd+JyiqK01WHO1/ag9pONmMNGEhm8/Gx8fP4NkQ7yBPQdl6oKeq+lyPPjDd9zP9mgB/Ph2CPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bw2pZlla; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bw2pZlla"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777357467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dWxJ6iKAXxdVvuoeOB4go4oBPwLfaddH3kafQhnJCYU=;
	b=bw2pZlla660MhaM0r/nA2QwE0EPJFULCVm5wF94CO6ll3VmgtpaEMZu4OOGPuYcizRQL4a
	ESIOtFB/sk3H/j0718VR5EIiNgEkuZN8LvK06pCYIX3RMkokBtvixs+AU9RxuuApjHJtBY
	aJWKhAuEEOeSSblumWFIdkU3ts6fo4A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-2jG5OGQNPlC33gdxYcopeQ-1; Tue,
 28 Apr 2026 02:24:23 -0400
X-MC-Unique: 2jG5OGQNPlC33gdxYcopeQ-1
X-Mimecast-MFC-AGG-ID: 2jG5OGQNPlC33gdxYcopeQ_1777357462
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 706DB1956065;
	Tue, 28 Apr 2026 06:24:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.126])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0217E30078C0;
	Tue, 28 Apr 2026 06:24:16 +0000 (UTC)
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
Content-ID: <722879.1777357455.1@warthog.procyon.org.uk>
Date: Tue, 28 Apr 2026 07:24:15 +0100
Message-ID: <722882.1777357455@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Eric Biggers <ebiggers@kernel.org> wrote:

> +config AF_RXRPC_KUNIT_TEST
> +	tristate "RxRPC KUnit test" if !KUNIT_ALL_TESTS
> +	depends on KUNIT && RXKAD
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable the RxRPC KUnit test suite.

The description isn't really accurate.  It doesn't test rxrpc per se.  Can you
change it to "fcrypt kunit test" or "RxRPC fcrypt KUnit test"?

David

