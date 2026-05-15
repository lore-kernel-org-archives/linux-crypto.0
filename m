Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB13A961B
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 20:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778878700; cv=none; b=ICQQMT4u52LXYQFPhWLvOtLLW7FnuXkxylEwRQWQbJI2TbyUiI0FXkBF2RHdNDnd1qFmkVJXn66lQZZZyTTo1X7PGIj5eO2qfGG+f/1qw90ShO0ADPpXmlIE+U9eCIqHMTMsw9oDc3+06ug2KPoSBhPnsSqqdwfsrZh7KksYxhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778878700; c=relaxed/simple;
	bh=qoIdKi3EBZW/eOldO5hee96vIJOQaNLXmYonDVJE700=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=mXCBglrMoQ+nTRhS7K0oFuDAficEw2Qw72vyhUcNmXaR5+RPstdOhmv4TPnwmjKQLHnafCajzBf8lz83hiT+AgLOvrFdGKN2tQ1VoU2NX5tzyyNJnN15jyge1VstdFBBKMPZkEmeorGK4TS+ByNUZy7R3E/xAbq7kIn/HBRiYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+viHLWg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+viHLWg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778878698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zNN6VmRPbN6JATFiof7VWl17ex7Nku19+5A2NoErxNY=;
	b=B+viHLWgAcw9byIItevthIiVUXeK9tMKmvpH6gHv+a2RP1Z2dIU2jwNb/A4YoF3Orb4PX9
	DD70kAPHswMJZEcZcf3IIXQs6HtCNo1xztSSqr5gjWrgAmbVQmJ4fTz9WjJYrf2ZE1fVsK
	VwZMGcNAayFakYlNSdpvX80vJJxKuOc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-KV87kLXOOwyAAvK4XRLgAQ-1; Fri,
 15 May 2026 16:58:12 -0400
X-MC-Unique: KV87kLXOOwyAAvK4XRLgAQ-1
X-Mimecast-MFC-AGG-ID: KV87kLXOOwyAAvK4XRLgAQ_1778878691
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BB991956060;
	Fri, 15 May 2026 20:58:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EE371956053;
	Fri, 15 May 2026 20:58:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260515201416.GA3484095@google.com>
References: <20260515201416.GA3484095@google.com> <20260508182318.GA4145640@google.com> <20260428024400.123337-3-ebiggers@kernel.org> <20260428024400.123337-1-ebiggers@kernel.org> <286248.1778263325@warthog.procyon.org.uk> <287476.1778266603@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    linux-afs@lists.infradead.org,
    Marc Dionne <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    "David S . Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2658458.1778878685.1@warthog.procyon.org.uk>
Date: Fri, 15 May 2026 21:58:05 +0100
Message-ID: <2658459.1778878685@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Eric Biggers <ebiggers@kernel.org> wrote:

> Seems that the latest is now
> https://lore.kernel.org/netdev/20260514155304.2249591-4-dhowells@redhat.com/
> which is back to just using a linear buffer unconditionally.  I'll
> resend this series after that goes in.

Sounds good.  It turned out to be a bit faster just extracting the data into a
flat buffer in recvmsg.

I wonder about modifying the crypto/krb5/ code to use lib/crypto/ instead, but
that might be a little trickier as Chuck has patches to make NFS use it.

David

