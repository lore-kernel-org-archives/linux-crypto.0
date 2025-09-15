Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCFA2EAB85
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925010; cv=none; b=g8w+nGyCVZ4jvuk0jiM9wAS/BK8TaR1BbUVe405Rz50dSlh3WCozyekC6wFOS89ZI+Sl6mrpXXGa/DeIdGQtgyhHx59i76/d5EXf9FlzFJk0QmP1MBjsozTFJ0m1RZ8QyhVZsq1n+dlUz44C3YFLkvUnz++T1IbEwvA4yuX4+Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925010; c=relaxed/simple;
	bh=Tjiax65yHRQtI+y/RjJwhhFwnnD4M63Mdb9FQe9DkNg=;
	h=To:cc:Subject:MIME-Version:Content-Type:From:Date:Message-ID; b=DIlY0Y22UY+EdLZaQsY4SaVz3txBtqHiRWXhBgnUsgtxi9PXVjO6+6pfHqs7ARjGSqXiF2RT0W4Ra1zjgJqddX1zqF0+4NXYO4brKzSwrgQQZrpbcYDoZOlmvHYgfkIdJNUeXeNHIWEsZ2Qk9tI6SEEPKT6SoRPFl/CPBL0iiW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNK2CAnm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNK2CAnm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757925007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=A2vDkw9Urb/1Q30+NYGEq8r/FazuI8Hg46rfiOybIGk=;
	b=HNK2CAnmQftx0qBZTXMAFyMg65GSgrXZXTgohUrdAM2XuzVuFwDBmo2Gm8AMTTyG0p758M
	byiMpTmUQ06QS+RVhZ3ckm/h3GRJdfbUndB0/Eir7aaMGJgBJpBw9DTYkobG/kCrAFK0PP
	B8dBapGS0yI9IIl7ogLaB5wrMRAOrEo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-f94jmkbJMfiB5UFB8PL9nQ-1; Mon,
 15 Sep 2025 04:30:04 -0400
X-MC-Unique: f94jmkbJMfiB5UFB8PL9nQ-1
X-Mimecast-MFC-AGG-ID: f94jmkbJMfiB5UFB8PL9nQ_1757925003
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 958D019774FA;
	Mon, 15 Sep 2025 08:30:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CED81800446;
	Mon, 15 Sep 2025 08:30:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: dhowells@redhat.com, Stephan Mueller <smueller@chronox.de>,
    linux-crypto@vger.kernel.org
Subject: Adding SHAKE hash algorithms to SHA-3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2552832.1757924968.1@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
Date: Mon, 15 Sep 2025 09:30:00 +0100
Message-ID: <2552917.1757925000@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Herbert,

I'm looking at adding ML-DSA from leancrypto to the kernel to support PQC
module signing.  This requires some SHAKE algorithms, however.  Leancrypto
comes with its own SHA-3 implementation that also implements these, but I'd
rather use the already existing kernel one.

The problem is that struct shash_alg expects the digestsize to be fixed - but
with SHAKE this isn't the case.  If it's okay with you, I'll replace the
digestsize field with a set_digestsize and a get_digestsize function as
leancrypto does.

David

