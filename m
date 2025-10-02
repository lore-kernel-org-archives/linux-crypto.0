Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D82F30E827
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759410894; cv=none; b=mttoEz5pJIcYYJVyGnjXJxkbSb7dZ6L2dJ5Umk5ygqz2j4eNn1W+cvaxWKvtEpcs016/nlrq4ze3RA8Nm0QN+2zNgHRbDiD/0HzVTEeDgRmdTOHHmA6SU84ypoOdAwzOmk4wVFicTG+ZgckhQNIL9JNinZZi3I2DlJ6McO+J6Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759410894; c=relaxed/simple;
	bh=EYGrnECQVOAY1pTpJfgX0z0ezPv4u4M6g0Lzj7HWenM=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ILq4SPDP8Hwnq0IzAnq+Lko+pTGmrPHJweGaRrL5tuJY9sBHjthlBY3Au9YqdlDTlGI/eYvOHjwvw5Mv4iiffngRPS1qY0E7Pp8duOKpfwxecXvL4Olq9iOoU75W6HNdXlFU136e/S74wd4AtStkj91VwzH0FLwOKxrT1HkKNYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ivn4VFcj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ivn4VFcj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759410892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxjtVoQA20xl51bQEMGbGBi8UuGbKSHmlD5xA73reLM=;
	b=Ivn4VFcjDvPLbcG0OeLBHTbJxqa1M1C/MNHttWkw4INwg2Ex1sOWm8n2xlr0z33P7Rbxr6
	ob7ZhtOA/KIzMQuiMAplrNHU4ubuyX/1wbvo9mcElqcxdyJW9JyfOUh/NDg7VUkrPPW9wD
	+bnRzWudX+NSIeEvIN5Wj5pOz1IRADo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-217-xdCrNtf4MZGnF8CaJ7mifg-1; Thu,
 02 Oct 2025 09:14:50 -0400
X-MC-Unique: xdCrNtf4MZGnF8CaJ7mifg-1
X-Mimecast-MFC-AGG-ID: xdCrNtf4MZGnF8CaJ7mifg_1759410888
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84999180034A;
	Thu,  2 Oct 2025 13:14:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32C2C19560BC;
	Thu,  2 Oct 2025 13:14:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251001152826.GB1592@sol>
References: <20251001152826.GB1592@sol> <20250926141959.1272455-1-dhowells@redhat.com> <20250926195958.GA2163@sol>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and move SHA3 to lib/crypto
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2636608.1759410884.1@warthog.procyon.org.uk>
Date: Thu, 02 Oct 2025 14:14:44 +0100
Message-ID: <2636609.1759410884@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Eric Biggers <ebiggers@kernel.org> wrote:

> Have you had a chance to read this reply?

I have.

You held up your implementation of sha256 and sha224 as an example of how it
perhaps should be implemented:

	It would be worth considering separating the APIs for the different
	algorithms that are part of SHA-3, similar to what I did with SHA-224
	and SHA-256.

so I have followed that.  That defines a type for each, so I'll leave it at
that.

> All I'm really requesting is that we don't create footguns, like the
> following that the API in the v2 patch permitted:

The way you did a separate type for each removed one more footgun - and
arguably a more important one - as the *type* enforces[1] the output buffer
size and the sha3_*_final() function has the same sized-array as the
convenience wrappers.

It also eliminates the need to store the digest size as this is only needed at
the final step for the digest variant algorithms.

David

[1] Inasmuch as this is effective in C.

