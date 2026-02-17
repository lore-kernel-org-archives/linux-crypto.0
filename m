Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74EC2EAB8E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771317358; cv=none; b=OSF+UCu3tLSPknmi9QPTZbQXnVK6m0WVo3ugIcYUVd+l9KrQ/7ZCXWFmNWB7WA4lftX26mrFabvS7b9M6PKhxsctPGN32neHTCwZ0oXgbK7+5hRKM4iO6fY03D0IPUAr5gE13PDLyWatHLx5+bH0MAsNGZEWvqX23EODOVeejew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771317358; c=relaxed/simple;
	bh=GsPH1it93cBSSaSMcft/eEKKpedOcCglhw3uxqFZpEE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UDJUPpePj3H1LN4CLZm19y4D29avJ6rfxKzKuuRkDu/If8hj0Fz7khDlBjYlUowpSpVygF6s04/KvcB7sMbZfZQBzLJIgjc3sTnJtQSixktl8EmZbzUAAW2fhLuoBYz8HCE5nR/ZTFrsaDFO5Sa1r+uZJa0anUzVklSbnHBM1Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZoqX9iA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZoqX9iA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771317356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9grVDW8AZxJbfIkeJFe8IQduDAoxBnE9/JhYwG+hwok=;
	b=SZoqX9iAxPytCP3GAwFdKzZrRA9ddpSHP2BTpmMOKEB4rbURx7NWJfDCbFUlE2H1E3/J2v
	mQNnPeYfF0vtNviIrqAYnY31YWbvY5D+Mg2FhYt4klhseC/wzqhNkREy+33NH+ymo+b2I7
	dgVqt89mO+8bFcG74HQIvt2SjSfHJl4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-9c_sTZ-MMDaMFhu7z8Pw1A-1; Tue,
 17 Feb 2026 03:35:52 -0500
X-MC-Unique: 9c_sTZ-MMDaMFhu7z8Pw1A-1
X-Mimecast-MFC-AGG-ID: 9c_sTZ-MMDaMFhu7z8Pw1A_1771317350
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A14F31956060;
	Tue, 17 Feb 2026 08:35:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.45.225.173])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 931861800666;
	Tue, 17 Feb 2026 08:35:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1015832.1771316809@warthog.procyon.org.uk>
References: <1015832.1771316809@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Arnd Bergmann <arnd@kernel.org>,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David S. Miller" <davem@davemloft.net>,
    Jarkko Sakkinen <jarkko@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
    keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x509: select CONFIG_CRYPTO_LIB_SHA256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1017226.1771317344.1@warthog.procyon.org.uk>
Date: Tue, 17 Feb 2026 08:35:44 +0000
Message-ID: <1017227.1771317344@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Apologies, I forgot the:

From: Arnd Bergmann <arnd@kernel.org>

at the beginning.  Do you want me to resend the patch?

David

