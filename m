Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5872EDD63
	for <linux-crypto@vger.kernel.org>; Mon, 25 Aug 2025 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756131852; cv=none; b=o54KKVir60MbY5UAgQ4YZQhSo4VUPaJocW7wqPp7mZYNZ3IwVlJwcpNKzovfCZHHswkoQEzSFfbmW/inbqRZpkLzVmF9ap7oNwfaMQa/US+FRzWxIb8gCeP8q7+HurCHj7eXslCHqjbvv+xQxrYxOhmvJGYSYUAEznTRxinubtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756131852; c=relaxed/simple;
	bh=WPBddgLey9pT/GRLVVYQv6CKwTpR05IvPRR6tDEm754=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=NhqnoyRWRe8WkHZ94egwMnYULYFuOF7gDniyZ9O1YYGCb+HNDPo1GSO+DfVu4aIVL9X6SwNl7glX8hY93TSOwxg6TpAiNI1H9N05YlCrxciicry+DlmqnqKZf6nB55KvetDHAn52zmXjhmWuYt0qJ3a9bF4zkiPJpEgO/tInQ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DT/Yy9xN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DT/Yy9xN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756131849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hbi+N9tPCrSZAWCYN1lvYMMlCjbhpcnbqzeTr5r1hDA=;
	b=DT/Yy9xNY5kPx4wTwaHHrDv1PpGcXQLeOK4EYcsp0qyibl1CBEeSxt+kwZnnUQd48tlcdZ
	kl0Rw3yV8N1bwYgkXJQyNhuW+xRwtbrMWW/4nL7vgmbp3vj3LlHNgZ2BTwPdxNPCFzNUnm
	1OYlm/vlqPVtj6wPmE5uUYsyRcGlIko=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-PU-9G2edNou1F9Ni7AJpyw-1; Mon,
 25 Aug 2025 10:24:05 -0400
X-MC-Unique: PU-9G2edNou1F9Ni7AJpyw-1
X-Mimecast-MFC-AGG-ID: PU-9G2edNou1F9Ni7AJpyw_1756131844
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71309180034A;
	Mon, 25 Aug 2025 14:24:04 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71BDE1800290;
	Mon, 25 Aug 2025 14:24:02 +0000 (UTC)
Date: Mon, 25 Aug 2025 16:23:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>
cc: Harald Freudenberger <freude@linux.ibm.com>, linux-crypto@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: crypto ahash requests on the stack
Message-ID: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi

I'd like to ask about this condition in crypto_ahash_digest:
	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
		return -EAGAIN;

Can it be removed? Or, is there some reason why you can't have 
asynchronous requests on the stack (such as inability of doing DMA to 
virtually mapped stack)?

Or, should I just clear the flag CRYPTO_TFM_REQ_ON_STACK in my code?

I'm modifying dm-integrity to use asynchronous API so that Harald 
Freudenberger can use it on mainframes (the reason is that his 
implementation only provides asynchronous API) and I would prefer to place 
ahash requests on the stack (and wait for them before the function exits).

The commit 04bfa4c7d5119ca38f8133bfdae7957a60c8b221 says that we should 
clone the request with HASH_REQUEST_CLONE, but that is not usable in 
dm-integrity, because dm-integrity must work even when the system is out 
of memory.

Mikulas

