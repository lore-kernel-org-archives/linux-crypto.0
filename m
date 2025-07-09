Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670641BC41
	for <linux-crypto@vger.kernel.org>; Wed,  9 Jul 2025 10:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752056920; cv=none; b=dsvDjkEcChOWLnNfLLc7DD0Kb67+U/1l+jN/Ctrg8JqeYvbkJhLtovYgqpS/BM9cZ12uJykzyH9LITxRxsHCRuXF0EZkruUKmfrWmLFoO3p0gQqv67MeEjxVjAV1SM0uPkoMuGtE00jbRr5hXDAX75qdQG4m6gQiVYMgPTmB+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752056920; c=relaxed/simple;
	bh=AkfwzbXzQfAXsW7SwyuiRXK49Dtsr0H/Zdta1XDnGuI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=TpsF0OOAPfetlwsgkz7k/ek5ZzRJwb1glUMRQpgW8YqsHYYsZsvpgosWKtFErac/u2R03RfXCeb3QN4LW/CqI5O/pBvjbuV6MtoZiSTbdIxqHCAeQjzZCGdqNMslB/GkkvFXd1Ew1RgTXf8jBSjO6dLwvbK7dSF+VKTRm7IVJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TGCDJVK0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGCDJVK0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752056917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UPfT/80yQAK1NV+ddQxET2DiICWgTa0fvjoECxIz92M=;
	b=TGCDJVK0G0J1s0pRi6IqDkI07l3LIAaItnSIT0JBgaHValA3MSU8RL94Xpw5maT6jk2mfw
	ksqrb/qG+vOm8GbJUil+QnnlYH8flEyWOi1Z50qWYhNGiK8ZmFV4lVqWyEPDnRR5r5Wlm1
	A8j/A7bvS4SOrOhOk1MbZiNw0pua6BA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-En9MjsdWMLuEG60_hFMatw-1; Wed,
 09 Jul 2025 06:28:34 -0400
X-MC-Unique: En9MjsdWMLuEG60_hFMatw-1
X-Mimecast-MFC-AGG-ID: En9MjsdWMLuEG60_hFMatw_1752056913
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6035D1944A8C;
	Wed,  9 Jul 2025 10:28:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C74D180035C;
	Wed,  9 Jul 2025 10:28:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250709071140.99461-1-ebiggers@kernel.org>
References: <20250709071140.99461-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    netdev@vger.kernel.org
Subject: Re: [PATCH] crypto/krb5: Fix memory leak in krb5_test_one_prf()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2717584.1752056910.1@warthog.procyon.org.uk>
Date: Wed, 09 Jul 2025 11:28:30 +0100
Message-ID: <2717585.1752056910@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Herbert,

Can you pick this up?

Eric Biggers <ebiggers@kernel.org> wrote:

> Fix a leak reported by kmemleak:
> 
>     unreferenced object 0xffff8880093bf7a0 (size 32):
>       comm "swapper/0", pid 1, jiffies 4294877529
>       hex dump (first 32 bytes):
>         9d 18 86 16 f6 38 52 fe 86 91 5b b8 40 b4 a8 86  .....8R...[.@...
>         ff 3e 6b b0 f8 19 b4 9b 89 33 93 d3 93 85 42 95  .>k......3....B.
>       backtrace (crc 8ba12f3b):
>         kmemleak_alloc+0x8d/0xa0
>         __kmalloc_noprof+0x3cd/0x4d0
>         prep_buf+0x36/0x70
>         load_buf+0x10d/0x1c0
>         krb5_test_one_prf+0x1e1/0x3c0
>         krb5_selftest.cold+0x7c/0x54c
>         crypto_krb5_init+0xd/0x20
>         do_one_initcall+0xa5/0x230
>         do_initcalls+0x213/0x250
>         kernel_init_freeable+0x220/0x260
>         kernel_init+0x1d/0x170
>         ret_from_fork+0x301/0x410
>         ret_from_fork_asm+0x1a/0x30
> 
> Fixes: fc0cf10c04f4 ("crypto/krb5: Implement crypto self-testing")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: David Howells <dhowells@redhat.com>

