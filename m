Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0392C4361B
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 12:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7357323B77
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgLIMAI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 07:00:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730657AbgLIMAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 07:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607515121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OLi6xw6A05rVF+FY+DCz7u5b/15LezMPYjls9q2mPE=;
        b=C2vBz6moCKhm9SwCq6jA08Cvn7rCiX4RPKiNmnD8uMKkPY3G0wiBaFIx5fG52QPMLPFEpA
        rsS4biE4Pe0IOOGb3aq3Rg0KMnfwh36/7PFnGtk6s7Bf1/ydUOKw8ckkxelLM3X/s1f3OS
        Khu/KzKAc2nilJuVuYfY8pKrwYR+Ew0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-B7C-5k_CNgGhnwgKwhTXzg-1; Wed, 09 Dec 2020 06:58:39 -0500
X-MC-Unique: B7C-5k_CNgGhnwgKwhTXzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A43F4612A2;
        Wed,  9 Dec 2020 11:58:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C798919C78;
        Wed,  9 Dec 2020 11:58:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201120180426.922572-5-mic@digikod.net>
References: <20201120180426.922572-5-mic@digikod.net> <20201120180426.922572-1-mic@digikod.net>
To:     =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl=3D20Sala=3DC3=3DBCn=3F?=
         =?us-ascii?Q?=3D?= <mic@digikod.net>
Cc:     dhowells@redhat.com, David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl?=
         =?us-ascii?Q?=3D20Sala=3DC3=3DBCn=3F=3D?= 
        <mic@linux.microsoft.com>, Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v1 4/9] certs: Check that builtin blacklist hashes are valid
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 09 Dec 2020 11:58:31 +0000
Message-ID: <1221725.1607515111@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:

> +      cmd_check_blacklist_hashes =3D $(AWK) -f scripts/check-blacklist-h=
ashes.awk $(2); touch $@

The script name needs prefixing with $(srctree)/ so that it can be used with
alternative build directories.

Note that doesn't apply to scripts/extract-cert in the same makefile as tha=
t's
a built program and is to be found in the build dir, not the sources.

Btw, I'm pulling some of your cleanups/fixes into my fixes branch.

David

