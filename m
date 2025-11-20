Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A32CDDC5
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 08:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763626293; cv=none; b=HCXaTQSaFK3MxP/iC941XltXLm4DMiBViX9ER4UIExdG0/Fmhyz5lEVLQ37t106pdMgvBzqfyMHbuNCy6us1J6/J2kHyL6ah+KgZYfQ7EY0zdgMhahLR324M4eroFxbnh5XJe52r/DEJTKRObOSseJ2rZo7DsTJkoOkAspwoK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763626293; c=relaxed/simple;
	bh=36D6gk2vyRTStjC34W/E7tLFGicdrezzKfue6iZCHNE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=aH2E/arIHUZVf111CUVcovYJV/vUZ6W92ksy993/wdBU2p2kUTLQT60AvQi87xZBFL8hnh64L+xA4hsnlIttEe/oE8yuGTflnQkBxxqI5l7z1F87zIOzT+3dzfzuQk18zPY2KY8TFJAqwS1S+3bILZApEM/z9DhAMxPMQA7x1NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KQtCGMxB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KQtCGMxB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763626291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=36D6gk2vyRTStjC34W/E7tLFGicdrezzKfue6iZCHNE=;
	b=KQtCGMxBmmTvgqttBLLLCgRoK92n08bWp0EIJSY4qDtEHpV6wb4ddNTmZQLVhomCWHk9L5
	DCT0d8EbEBshaXr5DcdGGRYcxKW8yeE08PxHMJqzK0tEGKMP3B+c29E3VP02KuIv6YvGER
	hvjQQGRLnyZAybwMxZY1TQ8MH37mBk0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-LwiNKzOpMqerqMuakPf5Mg-1; Thu,
 20 Nov 2025 03:11:26 -0500
X-MC-Unique: LwiNKzOpMqerqMuakPf5Mg-1
X-Mimecast-MFC-AGG-ID: LwiNKzOpMqerqMuakPf5Mg_1763626284
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 801DD180048E;
	Thu, 20 Nov 2025 08:11:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B9163003E40;
	Thu, 20 Nov 2025 08:11:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251120003653.335863-1-ebiggers@kernel.org>
References: <20251120003653.335863-1-ebiggers@kernel.org>
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
Subject: Re: [PATCH 0/4] lib/crypto: ML-DSA verification support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2528922.1763626276.1@warthog.procyon.org.uk>
Date: Thu, 20 Nov 2025 08:11:16 +0000
Message-ID: <2528923.1763626276@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Note that your emailed patches seem corrupt somehow, but I can fetch the git
branch.

David

