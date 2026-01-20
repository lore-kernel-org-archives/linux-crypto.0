Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AD33ED10B
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 23:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768952401; cv=none; b=BWLOCGrCKzduRSe2+dkF8kcGdqEsGjmeCg6uY1JlWvJQ9u8xH5RhbkzkVKCUB87Uj4Z6C8mmLh2aISB5hqhCMQ+XGgEWO8jOjS7EQJRcNIBbDMAt/zE2bcXDwMW/iBu6TXMjWbLS+L2Us0WgC8VcdAXMIV67p3G1S7ddnjPNlHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768952401; c=relaxed/simple;
	bh=8PRyOYCD5eYQzR+cQnyDeO0Q8ZZ5M54SdFDosc3Mtd8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=b//3vT40p2zFNQ1MtcPVj85ZKVf8GceL3SXiinv59JY/ZHBCfp7Q/PtfXzTwSNAJDEoMhlqBTzMn5WUWbSHjjhGkQL42rmpGQScG2kKUui1x15dLWMRL/RVxE82bORUax2P2XzyyA/12rhLoKe8Zo9DehyZLeWzjFRzuWwCjo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z5nnxKHr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z5nnxKHr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768952398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4K6PuA+VwcYOVzfCFue8DjJCoVb1ol6gggBxb6ae3yw=;
	b=Z5nnxKHrFyJAyKNMJWphaJzw6UyZE0DDELb++hSEN2ExgI/6sKdV3Fh32qndG8HpoL30Jv
	lA3HJeW/HM1LjKtfhQiT/l3C8TMixU3Ha06+aHSQZrHsVV6ldzcTEyADcU6Efhhuwc4wEU
	cFwUja3bGW37/B+yd1XQPslGbllCm5M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-oVbVS3WiMEOYyM0E1b6dzA-1; Tue,
 20 Jan 2026 18:39:54 -0500
X-MC-Unique: oVbVS3WiMEOYyM0E1b6dzA-1
X-Mimecast-MFC-AGG-ID: oVbVS3WiMEOYyM0E1b6dzA_1768952392
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2CF2180035C;
	Tue, 20 Jan 2026 23:39:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F4C81800240;
	Tue, 20 Jan 2026 23:39:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120220321.GA6191@quark>
References: <20260120220321.GA6191@quark> <20260115215100.312611-1-dhowells@redhat.com> <20260115215100.312611-7-dhowells@redhat.com>
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
    linux-kernel@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v12 06/10] crypto: Add supplementary info param to asymmetric key signature verification
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1418294.1768952386.1@warthog.procyon.org.uk>
Date: Tue, 20 Jan 2026 23:39:46 +0000
Message-ID: <1418295.1768952386@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> As I'm sure you're aware, C has native support for function parameters.

And we have a syscall interface to honour that takes a parameter string *for
this very purpose*.  It just wasn't threaded into the akcipher API.

> This is yet another example of a case where trying to fit different
> algorithms into a generic API doesn't work well.

Well enough.

> We should just have a library API for each signature algorithm, with
> each algorithm taking the parameters it needs.

No, we shouldn't.  We have a library that allows demand loadable modules.  We
should use that.

David

