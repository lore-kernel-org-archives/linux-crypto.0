Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310A305064
	for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769005294; cv=none; b=uz85wf7bBb/vcZVeA1eOREWC5+PciHHJd/bll7S8UiST4KTdOQ8Cmm070+LiUxODM6jzt3bAuAzQeRVZW5A5PNRNuxA4EIgHMSD05DBqQ4mICovlNC52BNiYUFUI5ayaMwJeI/VP98WfOznTTxQS3x2wfJ8s04v5en+kRUeJwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769005294; c=relaxed/simple;
	bh=SKkxHr/4Y20TrGGrhUHMZ8TfhmW/auFLQlevZ9nME78=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ILKfowXCp0yD25Yx5tOKmEzR51rbkiDIm7vyI7UrB5WkRTLlF48SPGkrM12hxnKNM7GasxbGmZTis/F8ZMMR1lwzGwDE2oL8ShpPNgP1Rmcht28jvITgG1tabhcgVg0MRVqYMcFzlxc695Hs4XLGCOj0bjdUgPrFAL7ybJzDVFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NlFhWgwn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NlFhWgwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769005292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9J0yNk9gQUKqagsXpBx9lwE8Dd54ncS4Pt3VeCsioE=;
	b=NlFhWgwnaC0WRpyaltVbBaFrUIjHc62752kGCgCLqdMZpEYKlWCt+EWHcE38vqfJ9N6TS/
	6R2groQUH45lxFNKb30JL3CIeEvHnJQehgTp/DHmdw6EYtZD3AoqWMyMNizhdDvS++awSk
	5V0vroIe6Rh8gHsBLnXJLXfpRSoJO4c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-iJeA0WS6MHa0uBqGFEzEJQ-1; Wed,
 21 Jan 2026 09:21:29 -0500
X-MC-Unique: iJeA0WS6MHa0uBqGFEzEJQ-1
X-Mimecast-MFC-AGG-ID: iJeA0WS6MHa0uBqGFEzEJQ_1769005287
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21E7219560A6;
	Wed, 21 Jan 2026 14:21:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B821C1800240;
	Wed, 21 Jan 2026 14:21:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120213820.GD2657@quark>
References: <20260120213820.GD2657@quark> <20260120145103.1176337-1-dhowells@redhat.com> <20260120145103.1176337-6-dhowells@redhat.com>
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
Subject: Re: [PATCH v13 05/12] modsign: Enable ML-DSA module signing
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1551501.1769005280.1@warthog.procyon.org.uk>
Date: Wed, 21 Jan 2026 14:21:20 +0000
Message-ID: <1551502.1769005280@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> If OpenSSL 3.5 is the last version that doesn't support the noattr case,
> that would mean that OpenSSL 3.6 does support it, right?  OpenSSL 3.6
> was released several months ago.  Yet the above code requires version 4.

3.5 and 3.6 support ML-DSA, but not with CMS_NOATTR, so I need to update this.
Version 4 will support ML-DSA with CMS_NOATTR, but that's not yet tagged.

> How about we just support the new way only?  That would be simpler, and
> it sounds like it's already supported by the latest OpenSSL.

Depends what you mean by "latest OpenSSL".  Latest in git, yes; latest in
distributions that people can simply install as an rpm/deb/etc., no.

Now, assuming OpenSSL releases v4 sometime in the spring, I would probably be
fine with saying you have to have OpenSSL v4 if you want ML-DSA; but others
might have a different opinion.

David

