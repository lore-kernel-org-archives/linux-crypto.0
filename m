Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AD878F54
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763629814; cv=none; b=AowE7D8d9r0lFa4NxAEuPc28Cd86nqnzFtTSP638Oil5/MzKPB95knAm4+rSPXWvgv3sc2v53g7roPNl+aJBrygGe5lS8gYjP238DLfKJ+TK0Lt79fsPbs9/PjBl0Ir8wAQSZ6wS8QxUeGSFfDsUjPBafYfxIDCkMU8D/z8DlX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763629814; c=relaxed/simple;
	bh=ZdQcOdc7gCABHJOdZ40aULWk4ET7OGHhGZClDWDgjBk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=As/ZY6Ud9F5TIcfYyZOZ9NfpO/+TFSv4ZSgJjIgmyWmRjpVW1zyscG2PJhKS7sxRRbED+qOYnIP8JhagqH9LhO+tHFavjOSwO/NygQdsWMYnyf58dHwYURdZgUsoTmgkb4DLtqiD/YEwIJACWcXfOCDafC3LZOEXX46bGILwZNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1EndEw9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1EndEw9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763629811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xQO1fZFPrOhkdsyZjdLmzQ+Mgobs3gJJ1WmIDYIAKQA=;
	b=U1EndEw9FKG7oqHKy270CrnTt2w6Zo6FLgQoS+pIK6ZXdK9iDM0FxgJvFFWMB3LTsDrx/a
	V2HPuxrYbSt0K9luAyIQkcHD1iMZotV6S8+s9hn3mm7b4bQscn6aRfhRLhw4+LR4AkndDr
	81eNLaSaUzcTpfRLy+QRI3sRd02JDEk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-LkhFORreN5SdLYfztd7_gg-1; Thu,
 20 Nov 2025 04:10:09 -0500
X-MC-Unique: LkhFORreN5SdLYfztd7_gg-1
X-Mimecast-MFC-AGG-ID: LkhFORreN5SdLYfztd7_gg_1763629807
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B04ED1800EF6;
	Thu, 20 Nov 2025 09:10:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DB193001E83;
	Thu, 20 Nov 2025 09:10:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251120003653.335863-2-ebiggers@kernel.org>
References: <20251120003653.335863-2-ebiggers@kernel.org> <20251120003653.335863-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>, keyrings@vger.kernel.org,
    linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] lib/crypto: Add ML-DSA verification support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2590972.1763629800.1@warthog.procyon.org.uk>
Date: Thu, 20 Nov 2025 09:10:00 +0000
Message-ID: <2590973.1763629800@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Eric Biggers <ebiggers@kernel.org> wrote:

>   - Is about 600 lines of source code instead of 4800.

There's less shareable code for other algos that I'm sure people are going to
ask for, but that's probably fine.

>   - Generates about 4 KB of object code instead of 28 KB.
>   - Uses 9-13 KB of memory to verify a signature instead of 31-84 KB.

That's definitely good.

>   - Is 3-5% faster, depending on the ML-DSA parameter set.

That's not quite what I see.  For Leancrypto:

    # benchmark_mldsa44: 8672 ops/s
    # benchmark_mldsa65: 5470 ops/s
    # benchmark_mldsa87: 3350 ops/s

For your implementation:

    # benchmark_mldsa44: 8707 ops/s
    # benchmark_mldsa65: 5423 ops/s
    # benchmark_mldsa87: 3352 ops/s

This may reflect differences in CPU (mine's an i3-4170).

The numbers are pretty stable with the cpu frequency governor set to
performance and without rebooting betweentimes.

Interesting that your mldsa44 is consistently faster, but your mldsa65 is
consistently slower.  mldsa87 is consistently about the same.

I don't think the time differences are particularly significant.

David

