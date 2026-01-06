Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586A53126DF
	for <linux-crypto@vger.kernel.org>; Tue,  6 Jan 2026 09:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767692269; cv=none; b=b5E2bPiiP1ccYVHYYhwMdVG8No+N0/7WjvIdhNw3aGa/V1ox7TYSxRYCAyI+tbIEPpu5V1gOSVJAq3+HzbM0UIuPrdS9AQMYhIf+v9rqvI4BtteiDZLu2oxFrHDhpJpu6zwvl9q4IX0oBk8tkSmuoV2JhEf8AOMoKwSmySg0IkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767692269; c=relaxed/simple;
	bh=N7uAYbVpKybj/kxqV2hwnieEyXuUnlhLWKSb0QwFbn0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bkeayBfG7uac6JCvIkHTb4e5hLvYGQmli40LCZpyCrMvLnKyDEc0hbHuIb0OmW8LXNjQbIglFF7FkvU+BmbZUUo1LOBE9bVb9KJvFnXTmb5n0YL7dQkpwpIVqjacVifK/nXMyf1aqF0VbZkL7PXjTpL15FQ0UELF0fhBMSOiTaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i1w/RVoV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i1w/RVoV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767692265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MDANCi/532bShCCLptsPqiZizaA/KMJpZpqXSVA2mvA=;
	b=i1w/RVoV8qg8Gz2YjPBG8exhwiMbm36LIAd8UAwKcsqUcAm0ux5FCvZBybzfxtsT1orqSn
	E4/XsB5egcmsdhiRGz4b3RQaH0RvFrRaUJjQPZ1oMnTdigBGyHui1K+rHyUoBwxoKx+4wc
	jdQamlhqb2VWiIJAgbRe3It/RW6kJtg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-HuW2W3u6OaKQKMA4jjUmVw-1; Tue,
 06 Jan 2026 04:37:41 -0500
X-MC-Unique: HuW2W3u6OaKQKMA4jjUmVw-1
X-Mimecast-MFC-AGG-ID: HuW2W3u6OaKQKMA4jjUmVw_1767692258
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372001800343;
	Tue,  6 Jan 2026 09:37:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0649F18004D8;
	Tue,  6 Jan 2026 09:37:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260106080251.GD2630@sol>
References: <20260106080251.GD2630@sol> <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-4-dhowells@redhat.com>
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
Subject: Re: [PATCH v11 3/8] pkcs7, x509: Add ML-DSA support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1837725.1767692252.1@warthog.procyon.org.uk>
Date: Tue, 06 Jan 2026 09:37:32 +0000
Message-ID: <1837726.1767692252@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Eric Biggers <ebiggers@kernel.org> wrote:

> This "PKCS#7" (really CMS -- the kernel misleadingly uses the old name)

I implemented PKCS#7 first and then added CMS on top of that.

> That needs to either be implemented correctly, or not at all.  (If only
> (2) is actually needed, then "not at all" probably would be preferable.)

At the time of writing, openssl didn't fully support CMS with ML-DSA, and that
limited things.

David

