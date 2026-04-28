Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEB42D47E9
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 07:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777362833; cv=none; b=VOiJsWIkErQw+HEGz21uWZINDWGQrBmzAH0cgBeWYbd0spn/8/VoBtU8sGEojRq1WQ2VcuUvGMi2Iff9D8+B6y/xL6Dj0UKbS62lduoBLvtrNfNljwylbqVnS6jJxV8YTvsWBDrFvXQNHADTVbCTdy0BJMhIxnsLty6tjrFKiTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777362833; c=relaxed/simple;
	bh=W2ux99vm/YR+fWjrnwRiZup/PYxG31SHUrlOrY3Sk+k=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=aSKW/a5DWRuGjRpBa81gyec3DdOu5ogvzTYVnRvwcvXj6fVqpWY+6HBTtzWY7KXc7PSqp6kTuP+st1T9p5/+yJTcMF8bU1lsx2hYoT0cfH+NCqUBpSiIZXPnrFc8EJd1wNbUYgl8nR//y8V9eyaXJeWCpW/oJkJhBynkaLCWlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIr6eZqa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIr6eZqa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777362830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2t/FQHBc4YwiSUDHUyxx0oj6pNb+ROc36MbcJMBmi8w=;
	b=gIr6eZqaTDakBSI1tV/L9FJ8cHZvESjeMBobNcb0xbeONjQqeaH3rYyrTmL+JEFRc69nT8
	tnhXCE/ADr/+w0GNepB+7KkkRgrFoXc5T2YfHZ4gUZcgGO20wTtTSP1Me0Ynm7ivNU+hxE
	M82By7hWgNasWCupKi42JCnGBivxKrs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-qsX_92UiPIah9O2Y47wL1A-1; Tue,
 28 Apr 2026 03:53:49 -0400
X-MC-Unique: qsX_92UiPIah9O2Y47wL1A-1
X-Mimecast-MFC-AGG-ID: qsX_92UiPIah9O2Y47wL1A_1777362827
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07E78195609F;
	Tue, 28 Apr 2026 07:53:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.126])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 49B09195608E;
	Tue, 28 Apr 2026 07:53:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
References: <20260428024400.123337-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    linux-afs@lists.infradead.org,
    Marc Dionne <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    "David S . Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <772373.1777362820.1@warthog.procyon.org.uk>
Date: Tue, 28 Apr 2026 08:53:40 +0100
Message-ID: <772374.1777362820@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Eric Biggers <ebiggers@kernel.org> wrote:

> [This series applies to v7.1-rc1 and is intended to be taken via
> net-next.  Patches 4-5 could be left for later if desired.]
> 
> The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> and insecure.  Since their only user is net/rxrpc/, they belong there,
> not in the crypto API.
> 
> Therefore, this series removes these algorithms from the crypto API and
> replaces them with local implementations in net/rxrpc/.
> 
> The local implementations are simpler too, as they avoid the crypto API
> boilerplate.
> 
> I don't know how to test all the code in net/rxrpc/, but everything
> should still work.  I added a KUnit test for the crypto functions.

It seems to work, so apart from the two points I noted, you can add:

	Acked-by: David Howells <dhowells@redhat.com>

It looks like it might be slightly faster, but I think the overhead reduction
is not that visible with all the other things the filesystem and protocol do
plus I/O overhead.  RxGK is a lot faster and more secure, so we should be
moving that way anyway.

David

