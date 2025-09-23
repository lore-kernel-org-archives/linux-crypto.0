Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9E93277B4
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644765; cv=none; b=kv7Ba5yt70GjMGOFxIXkK9rM4Vou4oq2PwnEfXb3kIlw7lsUAk89w4A05TZI5kcpI1mt9qCLYeMh7+lfCE17DMzy6jd5wpttEOVXxaPIxWuCn0ZYLFO78Aqthq8cA0pNpUVehsDh7l6dMlPNnCMPwJWFD2MbHx8dTFKbkkveY4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644765; c=relaxed/simple;
	bh=4Mc9Q6PQylD2t0RKa4Q4f8xnlX/14BtbSBzktsM+ZOg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DM9/CNsb2q2288qnvkmE1Z/jYwK4f4ZxeNDnbJi/xAABPJYb1IB0Ram/EcJeCuGtRrkej+UYtL6LxqSCaBkymNAgWGT1G3by1+TKDClVUolp3fpa78zdfJBkCYtSqs2k34I/8F5+UUZ8A0vWPBtjTKUu/hlrG1p6hh6FNVX27iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f2EUQBel; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f2EUQBel"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758644763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzZvjXc/oWUBSY20iVnbRYYeB0xoWq970oaHaOnshgA=;
	b=f2EUQBelBImHtm2CKckO+x/vEmiuAQ/mH3+wnIKnuRygTMjhZ4mULyQNjp+vuknhwyhzgn
	1SqwxEwVbAVXFeuHGBC7S4IU2XHt7sRVU3kEKbYCT0FKwlgctqouE8Qbw4dDXZCloO6GGG
	RlBfH1JDWhNOxvBxMG0FEr0c0TpaknU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-ZbBLqFZFMzuS3pTKtgLbqw-1; Tue,
 23 Sep 2025 12:25:59 -0400
X-MC-Unique: ZbBLqFZFMzuS3pTKtgLbqw-1
X-Mimecast-MFC-AGG-ID: ZbBLqFZFMzuS3pTKtgLbqw_1758644758
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8150019560B2;
	Tue, 23 Sep 2025 16:25:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B26C41800451;
	Tue, 23 Sep 2025 16:25:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250923153228.GA1570@sol>
References: <20250923153228.GA1570@sol> <20250921192757.GB22468@sol> <3936580.1758299519@warthog.procyon.org.uk> <506171.1758637355@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, "Jason A. Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Harald Freudenberger <freude@linux.ibm.com>,
    Holger Dengler <dengler@linux.ibm.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, Simo Sorce <simo@redhat.com>,
    linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
    keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA-512, SHAKE128, SHAKE256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <529580.1758644752.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Sep 2025 17:25:52 +0100
Message-ID: <529581.1758644752@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> > I assume that pertains to the comment about inlining in some way.  Thi=
s is as
> > is in sha3_generic.c.  I can move it into the round function if you li=
ke, but
> > can you tell me what the effect will be?
> =

> The effect will be that the code will align more closely with how the
> algorithm is described in the SHA-3 spec and other publications.

I meant on the code produced and the stack consumed.  It may align with ot=
her
code, but if it runs off of the end of the stack then alignment is irrelev=
ant.

David

