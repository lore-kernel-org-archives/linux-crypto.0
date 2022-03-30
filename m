Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B27C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Mar 2022 13:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbiC3NqZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Mar 2022 09:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346266AbiC3NqW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Mar 2022 09:46:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DF226FA0F
        for <linux-crypto@vger.kernel.org>; Wed, 30 Mar 2022 06:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648647875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F8QQxxoffEN8D0iWzQeDRqRj76sBJ6MkIp9Ef6hGM1Y=;
        b=fXA4PS/+MaXXYH5hubiYUTmerdgMylpyv2auaAkf8khlYSpkxrImEjhVRa3v10J7HgCpPe
        rOgxRwzSNgayFKzwh7vZ1DTuymLmxmZCyC/V8icAN5n1L3I+7LzhcXoar/G7XlpjaXm0Ya
        0xHMGqWZxPfnXlt3TLXWgJTuArtA+HE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-NtZGEiU0PnqW3s2Gsn_boQ-1; Wed, 30 Mar 2022 09:44:31 -0400
X-MC-Unique: NtZGEiU0PnqW3s2Gsn_boQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA68B899ED9;
        Wed, 30 Mar 2022 13:44:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF7B0400E545;
        Wed, 30 Mar 2022 13:44:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YidDznCPSmFmfNwE@iki.fi>
References: <YidDznCPSmFmfNwE@iki.fi> <20210712170313.884724-1-mic@digikod.net> <20210712170313.884724-6-mic@digikod.net>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     dhowells@redhat.com,
        =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FMicka=3DEBl?=
         =?us-ascii?Q?=5FSala=3DFCn=3F=3D?= <mic@digikod.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FMicka=3DEBl?=
         =?us-ascii?Q?=5FSala=3DFCn=3F=3D?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v8 5/5] certs: Allow root user to append signed hashes to the blacklist keyring
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 30 Mar 2022 14:44:00 +0100
Message-ID: <2937432.1648647840@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> >  /*
> >   * Initialise the blacklist
> >   */
> >  static int __init blacklist_init(void)
> >  {
> >  	const char *const *bl;
> > +	struct key_restriction *restriction;
> >=20=20
> >  	if (register_key_type(&key_type_blacklist) < 0)
> >  		panic("Can't allocate system blacklist key type\n");
> >=20=20
> > +	restriction =3D kzalloc(sizeof(*restriction), GFP_KERNEL);
> > +	if (!restriction)
> > +		panic("Can't allocate blacklist keyring restriction\n");
>=20
>=20
> This prevents me from taking this to my pull request. In moderns standard=
s,
> no new BUG_ON(), panic() etc. should never added to the kernel.

I would argue that in this case, though, it is reasonable.  This should only
be called during kernel initialisation and, as Micka=C3=ABl points out, if =
you
can't allocate that small amount of memory, the kernel isn't going to boot
much further.

> I missed this in my review.
>=20
> This should rather be e.g.
>=20
>         restriction =3D kzalloc(sizeof(*restriction), GFP_KERNEL);
> 	if (!restriction) {
> 		pr_err("Can't allocate blacklist keyring restriction\n");
>                 return 0;
>         }

You can't just return 0.  That indicates success - but if by some miracle, =
the
kernel actually gets to a point where userspace can happen, it could mean t=
hat
we're missing the security restrictions of the blacklist.

Now, we could defer the panic to add_key_to_revocation_list(), but if you
can't set in place the required security restrictions, I think it's arguable
that the kernel either needs to panic or it needs to blacklist everything.

David

