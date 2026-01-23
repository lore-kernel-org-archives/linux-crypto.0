Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9903353EFF
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 11:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168246; cv=none; b=WaKp8HYHcELekjDfG3kOEpf5k+i0Psp9g7OTpgcNANRGcfJWfVhVJDu8ZK2billqhqPNf/hWeqXUR6xHpYBT2TXWS1zs2Sl9rTPVyaMXaztFinWFSH/iBWqZ112ORYSn09Aw1bsbbwl6qNbMg/UxNez24mb3JTRazH5PLX7X9tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168246; c=relaxed/simple;
	bh=+HSNHG9QzRgXKJEoItQv1Nc43cR0XweN2kAYE+SyNMU=;
	h=In-Reply-To:References:To:Cc:Subject:From:MIME-Version:
	 Content-Type:Date:Message-ID; b=qH+Rzg2imMBmQB6r4L5jODrv/1QYbhZ3U6XVXqO7rM3MQW38Q+b8jTM3kfHDCET1DDr6H2VfuPv4BobfsI2RIQ4VazzNRsKNckfZpNyUAT1k80wmOZZaEFpiiYxSpQXscU19e35yT2fyTrECJCmLbL7FV/pqYVN4xkINQYLZitw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ekNsQOv2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekNsQOv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769168241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NPTtO5YScyJb25eYSPVGgKr6h7EkN57q5AA+yKfP2kU=;
	b=ekNsQOv25CCNyJ76XVd03iWBf8vA/Sacp13vEdhTxOvL0YXox+Bjvm5Iy1znprBhwC6eQr
	eJTj4zEvs/gEDZkOVbNHIe/1ndODzWSRzrPAH24OYzuMxzAIZ6cQlzxKj7Yb4kVi5yMmtl
	dpTWJH3ywS3FEk3N1lnMW9Sm+H8smmA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-heqkEfZrOZuLmeJR6fihMQ-1; Fri,
 23 Jan 2026 06:37:17 -0500
X-MC-Unique: heqkEfZrOZuLmeJR6fihMQ-1
X-Mimecast-MFC-AGG-ID: heqkEfZrOZuLmeJR6fihMQ_1769168235
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB0941944EBB;
	Fri, 23 Jan 2026 11:37:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C60F1958DC1;
	Fri, 23 Jan 2026 11:37:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <20260120211232.GB2657@quark>
References: <20260120211232.GB2657@quark> <20260120145103.1176337-1-dhowells@redhat.com> <20260120145103.1176337-3-dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    Jarkko Sakkinen <jarkko@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 02/12] pkcs7: Allow the signing algo to calculate the digest itself
From: David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1754463.1769168229.1@warthog.procyon.org.uk>
Date: Fri, 23 Jan 2026 11:37:09 +0000
Message-ID: <1754464.1769168229@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Eric Biggers <ebiggers@kernel.org> wrote:

> As I mentioned on v11, it's misleading to start using the term digest
> for something that isn't a digest.

I can call it 'm' if you like.  I don't want to call it 'message' as that is
overused here.

> Naturally, this confusing introduction of non-digest digests seems to
> have already caused a bug: IMA calls pkcs7_get_digest() to calculate the
> digest of the module.  But now that's no longer necessarily a digest.
> It could be the entire signed attributes.

The next patch deals with that, but I can move the error check forward...

> I'll also note that this commit doesn't fully implement "Allow the
> signing algo to calculate the digest itself" as claimed, since only the
> signed attributes case is handled.  It looks like the next patch is
> intended to handle the other case.  But it's not made clear at all that
> it's a two-part thing; this patch implies that it's complete.

... or just squash the two patches together.

David

