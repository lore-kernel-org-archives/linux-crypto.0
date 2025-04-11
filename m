Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248A72036FD
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357608; cv=none; b=f7BvtpMmEdYqto2I8W1W8xbT2oXMPtWEEdTNg6vg1zXj3rO5yJP3m7wVAuXP4iOW0b+A/FFkMTpiWAb9oDo1SOGHH+Q+c3fzG0fBKSsmiR2a3KBKIahSdU+YmeukUMXTD3jL5UaQdeAZDi37KW8HvjA/yWmSuGd4b2ghibVEYrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357608; c=relaxed/simple;
	bh=G4RjzkyNZnUpOccB2xpI6l0l5VfYV/D/abt4SSB02zc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=g6Nx0RAlk0EEhxToCnG7qIGp50a03GQx9+aGlWhipFiMUcaHP9fRrT/qfpsu0zv3HvtXhBSDv+kdIlpDqglRlJ2Ef/lraPN/1lHO+gw7ghKp0oy/b+VZ9zXCrNACOipjWw2OgFwpt6jwShwktH5uHEMX2AIqNZu5eWhZSXxUMaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfgQV8G+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfgQV8G+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744357606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=16/lvzu2DyIa/AEpNIH9/VI98I48LJB90EPEiuPKhu4=;
	b=BfgQV8G+6jGu3NXqRo0Y9iDbcXUyeObZk/+ScWRL5StAlkbOsmupYqHLl6Kf00Dz28HezZ
	nA0gogue7MvxG8xHQVtfMNNUU3wT96YiT2Erp1BThE4GP6rW6r780sRPgMSvpt49GTue6n
	wiaLECA2/phd0i3sV+ItgMrHGeOhccI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-8Ll0UaXQPhOe7WG0xA9cMg-1; Fri,
 11 Apr 2025 03:46:42 -0400
X-MC-Unique: 8Ll0UaXQPhOe7WG0xA9cMg-1
X-Mimecast-MFC-AGG-ID: 8Ll0UaXQPhOe7WG0xA9cMg_1744357601
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EF1B1800EC5;
	Fri, 11 Apr 2025 07:46:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4C871808882;
	Fri, 11 Apr 2025 07:46:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250410163121.04d56770@kernel.org>
References: <20250410163121.04d56770@kernel.org> <20250409190335.3858426f@kernel.org> <20250407161130.1349147-1-dhowells@redhat.com> <20250407161130.1349147-7-dhowells@redhat.com> <2099212.1744268049@warthog.procyon.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Marc Dionne <marc.dionne@auristor.com>,
    "David S.
 Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Simon Horman <horms@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, linux-afs@lists.infradead.org,
    linux-kernel@vger.kernel.org,
    Herbert Xu <herbert@gondor.apana.org.au>,
    linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/13] rxrpc: rxgk: Provide infrastructure and key derivation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2132930.1744357595.1@warthog.procyon.org.uk>
Date: Fri, 11 Apr 2025 08:46:35 +0100
Message-ID: <2132931.1744357595@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Jakub Kicinski <kuba@kernel.org> wrote:

> Sorry for the delay. I was hoping you could respin and maybe fix/give
> up on the annotation in patch 3? Right now patch 3 gets flagged as 
> a build warning which terminates the CI processing before we get to
> make htmldocs. And it would be nice to get that run given patch 1.

I can remove the annotation, but it may just move the warning to a different
place.

David

