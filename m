Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92283345CAB
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778266616; cv=none; b=MdNEDdWKNix8xd2mXaugOIO32tTW7sMbtAToygfuy843CH3def6MD9R8ZQk95kGN3oyEKhX4j7dPGjlQc7aFNO17l+pVYe3p17bXfkZSy2dWXyEcL7b25pTVQO6jCpURhM3srLETEhKMlNhl/dp1LNQw/9wA3iO1XBHOiFyZ2jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778266616; c=relaxed/simple;
	bh=Cach13ED73zPiICpXNRYlpotEgcVawUBhgeetNazzG4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Uubxscstmbe/+a+C+nvBLbfybWPdluVldP68yQNjR03io0ZUpXTZCoUPPeVR9SBfdnezdDGMUysqBECXv9tywiF+FMMxAMtjtfs/1TUxbVyNVHo1qoHXjyXmn7RHdqBND3fWnX2MXGLuKq/wDprwnkTCAilaxzg5+nApnY082pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YG8vCFmi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YG8vCFmi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778266614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmkPjGRkulFnPfA8e1AK3LO/LMLtU89tzBUqK2/8QOs=;
	b=YG8vCFmiHvMFd9hMeC64iSXgrAEG4GVqZ8boQRq0IStRO0F3WSAEMR408wmkTS7JtveRRT
	HbP5bSbjb8WF6tmzyvXZoHFr/dVZSwoyAtwMP8LUO4siP36KXKZv1My3Wu+nhI44ivY0s2
	89WYg/1vyj40X8Lou4RamDUuRGVeY88=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-N0qOMcncO0aGMKAlLd35XQ-1; Fri,
 08 May 2026 14:56:51 -0400
X-MC-Unique: N0qOMcncO0aGMKAlLd35XQ-1
X-Mimecast-MFC-AGG-ID: N0qOMcncO0aGMKAlLd35XQ_1778266609
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFE3B195606F;
	Fri,  8 May 2026 18:56:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.83])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7F0C33002D2F;
	Fri,  8 May 2026 18:56:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260508182318.GA4145640@google.com>
References: <20260508182318.GA4145640@google.com> <20260428024400.123337-3-ebiggers@kernel.org> <20260428024400.123337-1-ebiggers@kernel.org> <286248.1778263325@warthog.procyon.org.uk>
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
Content-ID: <287475.1778266603.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 08 May 2026 19:56:43 +0100
Message-ID: <287476.1778266603@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Eric Biggers <ebiggers@kernel.org> wrote:

> Also I'm waiting to see if the following patch gets merged:
> https://lore.kernel.org/netdev/20260502211340.446927-1-n7l8m4@u.northwes=
tern.edu/

This is the favoured solution:

	https://lore.kernel.org/netdev/af2kdW2F1gJ9U-Gg@v4bel/

The problem with the one you mentioned is that it does a mandatory copy, e=
ven
when it doesn't need to, for rxgk.  I can benchmark that to see what the
performance impact it has.

David

