Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BA02550A4
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409961; cv=none; b=Q9rOZse60t4DqB5IuZvzdVotinqQYh1TihZxO3ObWUAQQd3tTWs1+djOR1WQdF11L7hZwGtDXgZedRnswAmZmnHsVfXJlV2QXZWQTvre2l0udb0ljQ2fPV8mGR8Ami0tx3p3Uy224xfX7ssy99CVwVFJK7hBoerUz5uu0kyqKec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409961; c=relaxed/simple;
	bh=WzqzfWGUrf811a74YIw3NeM5bLcQdbwj7XGDri7DLIE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=sLFWUhEQ2Ffmuagh53ictK8xu0W00nyOUNoDAwtDvorMUJjgekYlUnOE24OtRX64C46nwjrX1x+l268DkFHLPBqqQumYolth8Q3nSByWtRDxHCsx2iMS+3U5AvGxmWwkQClMpwqPLokIxl0d/iHHqhAHnnO0pYYoukh1GsuDXSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BvJoXPYp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvJoXPYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763409958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gk1A7WAVLacyqtUo+UN7TCmmst81dLSvI7tZqiv/zqU=;
	b=BvJoXPYpxBnWRe85DO0W1oIevWiDN9c14eeO0OmP+DggroqzuJc7YK0WXCYZkiU2Ht5FQ0
	36fBeBexLzhHxWt7xR7cy2CwX5rKo08b52CVuavY2t+18Js57pAtyAIo/6yhJsIHZZY0+t
	+AmuaVRnv3YExe9m/0YzT4Ye+gbyIl0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-bRxPBrVSOcOw7NmUdswN5Q-1; Mon,
 17 Nov 2025 15:05:56 -0500
X-MC-Unique: bRxPBrVSOcOw7NmUdswN5Q-1
X-Mimecast-MFC-AGG-ID: bRxPBrVSOcOw7NmUdswN5Q_1763409954
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0366619373D8;
	Mon, 17 Nov 2025 20:05:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 01ACD195608E;
	Mon, 17 Nov 2025 20:05:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2165074.1763409175@warthog.procyon.org.uk>
References: <2165074.1763409175@warthog.procyon.org.uk> <20251117171003.GC1584@sol> <20251117145606.2155773-1-dhowells@redhat.com> <20251117145606.2155773-3-dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason
 A . Donenfeld" <Jason@zx2c4.com>,
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
Content-ID: <2165357.1763409948.1@warthog.procyon.org.uk>
Date: Mon, 17 Nov 2025 20:05:48 +0000
Message-ID: <2165358.1763409948@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > In comparison, BoringSSL has an entire implementation of ML-DSA, ...
> 
> ... which cannot be used in the kernel due to the licence.

... and it's written in C++.  Now, whilst I'm in favour generally of moving
the kernel to C++, it could be a hard sell.

David

