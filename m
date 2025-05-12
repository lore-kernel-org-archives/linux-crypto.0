Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D454134AC
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747041570; cv=none; b=J0ldWzy2rfQeUQpwGYQQMx7sKerW9W5Kc10uw0Tjp48SdsnwHK9Jf8D4YDGeMoYU7kyczbTIzVANb+Q3949UeXfH+/Hl7jmJZ7qJM4T5/K4BtrDtnBPtugPtUL9Mti8BVdFmfngCJ7ezS1zPpewWULfIT00dhyNxHtMoCsP3aC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747041570; c=relaxed/simple;
	bh=YxLD1j4n3jsjoJWjaT3zn792WhB6FdopTXqDGpDpVcI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=K5W0CztBeS3/QVS+nEsKzOpk+wLPp7bCQmxBy+ETs1KJ5SzdLxfyn93cp2gNFob0FAW9+wHwEDhPUl1h64oS2/YRSLp0wGrtKRHGxfRv7UQuOS0wBCXs729dRcA+nk9zjkYTtpLvCWQ88rwj2QYr6UWNC5M723QXjF3/Dr9+wgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CwwTgN5l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwwTgN5l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747041567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7ANbHDvc+a0P3LueAyyoaMPrtCdaSJ4PfO4ZIxUKOQ=;
	b=CwwTgN5lk9iCBeaMHl2Za81aOcgGBxxiZcbnIO2+dBtwGUBptVzcsFH+arypYqpNWdlwfv
	Ew/EaxyAXFdxC9GmCCzdiOLOtb40NR4KVMjodHi+5iCwVabvqNVFfNS/fXzVq11oP+tVe9
	aW0lXbiyVHkCF2ANAPB/HMp5tLcETQo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-mu5ziLm7P4OARDt12UYFfg-1; Mon,
 12 May 2025 05:19:26 -0400
X-MC-Unique: mu5ziLm7P4OARDt12UYFfg-1
X-Mimecast-MFC-AGG-ID: mu5ziLm7P4OARDt12UYFfg_1747041564
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF0A118001CC;
	Mon, 12 May 2025 09:19:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.188])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3397F1800570;
	Mon, 12 May 2025 09:19:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aB3OsMWScE2I9DhG@gondor.apana.org.au>
References: <aB3OsMWScE2I9DhG@gondor.apana.org.au> <aBccz2nJs5Asg6cN@gondor.apana.org.au> <202505091721.245cbe78-lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, kernel test robot <oliver.sang@intel.com>,
    oe-lkp@lists.linux.dev, lkp@intel.com, keyrings@vger.kernel.org,
    Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    "David S.
 Miller" <davem@davemloft.net>,
    Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    James Bottomley <James.Bottomley@hansenpartnership.com>,
    Mimi Zohar <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
    linux-security-module@vger.kernel.org
Subject: Re: [v3 PATCH] KEYS: Invert FINAL_PUT bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1960112.1747041554.1@warthog.procyon.org.uk>
Date: Mon, 12 May 2025 10:19:14 +0100
Message-ID: <1960113.1747041554@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Invert the FINAL_PUT bit so that test_bit_acquire and clear_bit_unlock
> can be used instead of smp_mb.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David Howells <dhowells@redhat.com>

