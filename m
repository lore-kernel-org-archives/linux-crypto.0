Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA92DC78E
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 21:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757970021; cv=none; b=aEGIJNXv3Go7lhSDO/FM8bhUWcXbzV/tsHzyhWfHyX5i1NN8VZUyuvpnUIYuVS1TaD08mdtqskMFBe4Cdmw/Kfw2MurXQtXqfxmgRJQaybKxIVFKJWKyPb9C0vT6BQ9Gxvus9tU4w4EWVsT1LMODX2HOzRR/Riu1fsfrHR30wcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757970021; c=relaxed/simple;
	bh=fqdc2EFV86H/A95UsUPbKZnLUdXfMtMQtDfPyajjOqw=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=rDWifw2qNkBBcJsYF3NiiDYtFmha/ir0VRyyMzQmqrxnl44vHk0+An/ftxYFby410J/BnDYGC8oc55DJbB3QoHlToKNZgrvRhul1JxuSsarGzGA9KnDHyMiAHhlvStl2HRzblMIglr/j2jwJ5EENyjZjpTgtZTUHhEZA46NB53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPhFjKVM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPhFjKVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757970018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DtWps7cAiYSsFmoldNAmWgksz7e8574zj6HjeTlmwiM=;
	b=GPhFjKVMfwXbZ8qmMbsrLV4xzgbIbR5RlGPeEwoWdF4bwDGjAjrw7oLVG2ITa9D8mcrSWO
	+zuncOYd0gO23ea4nYK7sHaaJEirNrpoE9YNtqYFI7yoLXzfQNVdNn8hA3Bn57G5hvaIYE
	trHPzJmBWjIWGG6VaV1kVZIqdHeCSGk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-Ce0LpF8gNE-tI9hsDqBHpg-1; Mon,
 15 Sep 2025 17:00:16 -0400
X-MC-Unique: Ce0LpF8gNE-tI9hsDqBHpg-1
X-Mimecast-MFC-AGG-ID: Ce0LpF8gNE-tI9hsDqBHpg_1757970016
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9F291800451;
	Mon, 15 Sep 2025 21:00:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F29BA1800451;
	Mon, 15 Sep 2025 21:00:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2767539.1757969506@warthog.procyon.org.uk>
References: <2767539.1757969506@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2768234.1757970013.1@warthog.procyon.org.uk>
Date: Mon, 15 Sep 2025 22:00:13 +0100
Message-ID: <2768235.1757970013@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

David Howells <dhowells@redhat.com> wrote:

> I don't suppose you happen to have SHAKE128 and SHAKE256 support lurking up
> your sleeve for lib/crypto/sha512.c?

Actually, I assuming that lib/crypto/sha512.c is SHA-3, but I guess it might
actually be SHA-2.  I don't think it actually says in the file.

David

