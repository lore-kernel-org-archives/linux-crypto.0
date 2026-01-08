Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEFE434888
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767873228; cv=none; b=HoaI8s7cU0fGudSMrVVDhfe9/XQtJkuQeGuUTGvRMSn/43NyyvpPKOnP8wSy+fmxYUv5d9vCuNxbykBgZFmymsEqWYmElK8fSIkyrQTFkGWk8rcExyyT42mlHDaYy8ERPZ+8r0Gj3tFtHN4xSy0bJMR2dpao+FJXxegIhS9xigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767873228; c=relaxed/simple;
	bh=iFCG7cUXp5lgrTaa1rFHALg5zWZCz3Ir9J5mhxvVhGU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=c89VHQ6Ubww6mhz4RFpFkF/Y4OWQR/VxyURheMStPgTdM+OB7RVDe1r+5few+RfditkcIE+uff40Zp0P2Yw+KyJX/rySlYPUKAeBfUxATnBD4ebqEQFTqMZNMfGGRRsXZHrex+9288NXLjgHm8BKca07JIYGgXhRijudWnFkOBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FsUitO0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FsUitO0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767873222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R0I495xTJzwmy9iUkDFB4XYvwVDzM06omcaB5Fshsr4=;
	b=FsUitO0YHVxHumXCXJ/gEA34q4Ids9t+Zg8halqIFmAWKmv9uVeh198FsoNAyj1x6c4p08
	WogfNH6gynpGT6WzWFpQTssPx7LF9m0tdgVI9QfgsVEJdX732QIvmsTFZmK+Lm1NipPucJ
	1SxFMGvrhgpZFbFWxOpj4uD80+zottQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-j17384aYN-mkzy7pjJ8o3w-1; Thu,
 08 Jan 2026 06:53:39 -0500
X-MC-Unique: j17384aYN-mkzy7pjJ8o3w-1
X-Mimecast-MFC-AGG-ID: j17384aYN-mkzy7pjJ8o3w_1767873217
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E680518003FD;
	Thu,  8 Jan 2026 11:53:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D65730002D1;
	Thu,  8 Jan 2026 11:53:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALrw=nHMm0Br9iaMyCQwbujb-vus3nsA-__1Nw=UG-an=B_jtg@mail.gmail.com>
References: <CALrw=nHMm0Br9iaMyCQwbujb-vus3nsA-__1Nw=UG-an=B_jtg@mail.gmail.com> <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-8-dhowells@redhat.com>
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
Subject: Re: [PATCH v11 7/8] pkcs7, x509: Add RSASSA-PSS support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2719441.1767873207.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Jan 2026 11:53:27 +0000
Message-ID: <2719442.1767873207@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Ignat Korchagin <ignat@cloudflare.com> wrote:

> > +       case OID_id_rsassa_pss:
> > +               goto rsassa_pss;
> ...
> > +rsassa_pss:
> > +       if (!ctx->algo_params || !ctx->algo_params_size) {
> > +               pr_debug("RSASSA-PSS sig algo without parameters\n");
> > +               return -EBADMSG;
> > +       }
> > +
> > +       err =3D rsassa_parse_sig_params(sig, ctx->algo_params, ctx->al=
go_params_size);
> > +       if (err < 0)
> > +               return err;
> > +
> > +       sig->pkey_algo =3D "rsa";
> > +       sig->encoding =3D "emsa-pss";
> > +       goto out;
> >  }
> =

> I really don't like this. Is it possible to factor this out to a
> separate function and just call here? Should the factored function
> even be part of the implementation somehow?

I'll move the check into rsassa_parse_sig_params() and then move the remai=
ning
code back into the switch case.  That also means that x509_note_sig_algo()
doesn't need the check either.  It does change the pr_fmt value seen by th=
e
pr_debug(), but that's probably fine.

> >         ctx->last_oid =3D look_up_OID(value, vlen);
> >         if (ctx->last_oid =3D=3D OID__NR) {
> > -               char buffer[50];
> > +               char buffer[56];
> >                 sprint_oid(value, vlen, buffer, sizeof(buffer));
> =

> I've seen this elsewhere in the crypto code (namely in ECC) but is it
> generally a good idea to declare long buffers on the stack?

It's not all that long (7 words on a 64-bit machine - similarish to a func=
tion
call), and the output of sprint_oid() is limited to it.

David

