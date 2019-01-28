Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA841C282C8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 10:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FAD2087F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 10:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="LbWGj7P0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfA1KH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 05:07:59 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:18426 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfA1KH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 05:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1548670074;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=dc+ZrSqlUl7D/bBzIUOTHMKLL7WN1ThWTOPPPpFUIFk=;
        b=LbWGj7P0q2402lyeN/NJymCfwu0cqKw4cadslpmcrD6QELkA4u+mqs0qqt9Acuvlbx
        feG6lIM9tnUXvmFBdOGuWMyO6fGG15QO5K9VphfNutq7npjzDtGmqtDwH75+YvFMwhh2
        OUwxTGKOjH5j78khPyKkvishUhKa4oJlCPCLQ6ak7j/t/jDcg2wYtXEZ+WcRYAYrv4DS
        8vRIRQOSG9rMVkwkoN/6jUScfyYAt34//5Jt/Pgx8DqJzBuYR1sLcMbVwh/JKsTXkMBl
        kdUXmSMJeGyG51WSxVg49OrUycSWDFTlUTV3dxVWguGdKcAEBmT6vXudGtwisMWfZKXs
        MghA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIfSf89Ln"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.9 DYNA|AUTH)
        with ESMTPSA id 309bcfv0SA7S4NJ
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 28 Jan 2019 11:07:28 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/6] General Key Derivation Function Support
Date:   Mon, 28 Jan 2019 11:07:28 +0100
Message-ID: <5418064.ltLFQScYi2@tauon.chronox.de>
In-Reply-To: <2082192.jPI8ve1O8G@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com> <9733066.Vrs4h5eWcW@positron.chronox.de> <2082192.jPI8ve1O8G@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 16. Januar 2019, 12:06:54 CET schrieb Stephan M=FCller:

Hi Herbert,

> Changes v2:
> * Incorporation of all comments from Eric Biggers
>=20
> Stephan Mueller (6):
>   crypto: add template handling for RNGs
>   crypto: kdf - SP800-108 Key Derivation Function
>   crypto: kdf - add known answer tests
>   crypto: hkdf - HMAC-based Extract-and-Expand KDF
>   crypto: hkdf - add known answer tests
>   crypto: tcrypt - add KDF test invocation
>=20
>  crypto/Kconfig                |  13 +
>  crypto/Makefile               |   2 +
>  crypto/hkdf.c                 | 272 +++++++++++++++++++
>  crypto/kdf_sp800108.c         | 491 ++++++++++++++++++++++++++++++++++
>  crypto/rng.c                  |  44 +++
>  crypto/tcrypt.c               |   8 +
>  crypto/testmgr.c              | 245 +++++++++++++++++
>  crypto/testmgr.h              | 198 ++++++++++++++
>  include/crypto/internal/rng.h |  26 ++
>  9 files changed, 1299 insertions(+)
>  create mode 100644 crypto/hkdf.c
>  create mode 100644 crypto/kdf_sp800108.c

Do you happen to have any comments on this patch set?

Ciao
Stephan


