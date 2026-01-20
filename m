Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE6743D4EB
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922922; cv=none; b=Ipnv7ht+tePT1Vd/maopTTuDl5xOMGQKa+snGR/L2zfui+pGPBpF7Iknbm7oVYAB/jaj/uITUqYWJEDX4Zz59i3gwXwh9kF1KP6uaSxqwJ+HyZ2VCRMWvo18QUklUvqQraqAIjW+cPHtKTD7qlhIwpYjPfzbhw+gAZPVTIP5kJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922922; c=relaxed/simple;
	bh=0sMmu5gg8UFyAWe/IH29MMMVB58NdXu2+b0v3ORUzhg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=MRoJaXsbIubwPgoEyJxZp1bYEd587+Y5p/NO/O/0GqIDzWj2OcByh9QT+ImHKPlNzm7nILG2SCDQyyP3w9meWDMUbIkdnI4SVJFx6ZL8Ne/OWpiM/1a8h4TLnzGZA6jcJ7RMFeFeiMJjAO45f+ZqgPOaJKh/hvwHZ4toXD2Abuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zjr7DH8x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zjr7DH8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768922919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/unPafAPOoP3LjRvac8Gzs8rjFGIe5eacRzIB3ctjc=;
	b=Zjr7DH8xZPp0/taJr2uqn+F0wiZ6VGzTVE76H05ljGqEgFRljcjj6T3+bkguCjGrUSqnoo
	zadG3e6k319st9AX22ZgXAyQCvsQwjNI10FXUx3OAFx0IZzdDV8H80ERQ2v0RqGxd3/MGI
	sxFLnTkgfboGQ3TLuxYcdsqOEYp28yI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-wc0lwKm0NwWG-NM39PZcOQ-1; Tue,
 20 Jan 2026 10:28:35 -0500
X-MC-Unique: wc0lwKm0NwWG-NM39PZcOQ-1
X-Mimecast-MFC-AGG-ID: wc0lwKm0NwWG-NM39PZcOQ_1768922913
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 507351955F45;
	Tue, 20 Jan 2026 15:28:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF570180049F;
	Tue, 20 Jan 2026 15:28:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALrw=nENf3T=8MHPpt-wdneLupkzADpgDuHA6Gni_=C5-o_MjQ@mail.gmail.com>
References: <CALrw=nENf3T=8MHPpt-wdneLupkzADpgDuHA6Gni_=C5-o_MjQ@mail.gmail.com> <20260115215100.312611-1-dhowells@redhat.com> <20260115215100.312611-9-dhowells@redhat.com>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>,
    Jarkko Sakkinen <jarkko@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Eric Biggers <ebiggers@kernel.org>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 08/10] pkcs7, x509: Add RSASSA-PSS support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1177987.1768922903.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Jan 2026 15:28:23 +0000
Message-ID: <1177988.1768922903@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Ignat Korchagin <ignat@cloudflare.com> wrote:

> > +       struct rsassa_parameters *rsassa __free(kfree) =3D
> =

> Did you mean to use the newly added rsassa_params_free() here?

Err, yes, I should have done.

> > +DEFINE_FREE(rsassa_params_free,  struct rsassa_parameters*, rsassa_pa=
rams_free(_T))
> =

> So you use plain kfree() in one instance and this custom free definition=
 in
> another.  We should probably pick one.

Yeah, both should have used the custom one.

> What is the idea behind this custom rsassa_params_free(), if it just cal=
ls
> into kfree()?

In case in future something freeable is added to it, it seems like a good =
idea
to have a destructor[*].  Other mask functions are theoretically possible,=
 for
example.

[*] (Since we seem to be reinventing C++ ;-)

David

