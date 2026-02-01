Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828FFA59
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769964297; cv=none; b=BYT/iNmFu79qgL8ieAGrRCdCJ+I+lcJOCsMb9VbKXOdKlzGYfYFS5jyvOYbiLFD7yAuSoSgIVxAnynrrxal6OAFSypgHY9fixd2ft4MjRsCz576h8UzND7RuJhgyxMEG5rrfhFnR131O4sdIWHoKXTr38jGcPzzeJ4OlDhZxi2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769964297; c=relaxed/simple;
	bh=giD2F5UNmFMG6o6l+i3XLP9MRphNPKugSUu8GN9qHPs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=n/OOj5FG091xHxi1GnuPRPxKWk1Di8ZzmrCfvyiZybnokWtUcoyYzmDykBm61KcjTz7S8DGGsDXbiV2jN5l7RqFGbqwiduNoNjV0i+cm6vhJ+Af0CDMQgBPYzxkh+x45KqPJDHvMO3yd6QBL6x0bnAlgvNGljCpBiMH4GJmktfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QM5EXaUD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QM5EXaUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769964295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gbjcDMK0rcsgbZ0bOwqzZviKflLW8sOigcLXjjdEPsU=;
	b=QM5EXaUDPSfk9JZ0odX+l8dnbMGgMOifCyy20SNIaNEukcrYhzhY2rv5/UNPsIZ01EVSC+
	2GdbCGhv+qEuyelX5zJvFo+YvV29Br+cr6wL0WAmV33SGw+DAUtDT/GLR5zIjfKX9zMBUf
	Erocqe28omEQRQjUid+//g4EOZ9tUy8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-zX-rT8bBOY-cMQsxbWZZig-1; Sun,
 01 Feb 2026 11:44:52 -0500
X-MC-Unique: zX-rT8bBOY-cMQsxbWZZig-1
X-Mimecast-MFC-AGG-ID: zX-rT8bBOY-cMQsxbWZZig_1769964290
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F2321956094;
	Sun,  1 Feb 2026 16:44:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D556E30001A7;
	Sun,  1 Feb 2026 16:44:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <SN6PR02MB415708C0A6E2EB1B5C7BBFB0D49CA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <SN6PR02MB415708C0A6E2EB1B5C7BBFB0D49CA@SN6PR02MB4157.namprd02.prod.outlook.com> <20260126142931.1940586-1-dhowells@redhat.com> <20260126142931.1940586-7-dhowells@redhat.com>
To: Michael Kelley <mhklinux@outlook.com>,
    Sami Tolvanen <samitolvanen@google.com>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    Jarkko Sakkinen <jarkko@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Eric Biggers <ebiggers@kernel.org>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    "Jason
 A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>,
    "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
    "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
    "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 6/7] modsign: Enable ML-DSA module signing
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2315763.1769964282.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Feb 2026 16:44:42 +0000
Message-ID: <2315764.1769964282@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Michael Kelley <mhklinux@outlook.com> wrote:

> I'm building linux-next20260130, which has this patch, and get the follo=
wing errors:
> =

>   HOSTCC  scripts/sign-file
> scripts/sign-file.c: In function 'main':
> scripts/sign-file.c:282:25: error: 'CMS_NO_SIGNING_TIME' undeclared (fir=
st use in this function)
> ...
> The problem is that I'm running on Ubuntu 20.04, with this openssl:
> =

> # openssl version
> OpenSSL 1.1.1f  31 Mar 2020 =


The problem probably isn't this patch, it's almost certainly due to:

  d7afd65b4acc7 ("sign-file: Use only the OpenSSL CMS API for signing")

in the modules tree.  It removes support for PKCS#7 signature generation.

Were you using PKCS#7 with SHA1?

David

