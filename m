Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1023C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 19:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31154217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 19:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Cs0qK8vK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfEUTPl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 15:15:41 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:14238 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfEUTPl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 15:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558466139;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=kCFO7SFB1HIUkXfd5v11/uS2m0Wg3ahQcV3NTGljcV4=;
        b=Cs0qK8vKj2ekolMKQpcUyL0N9eRfBjYUhREmVhIXKkDykrTdUKxC0hwYG91JKke7hN
        bbmuM0N8NRmdxUAC0frCW0Q0Id4WffscMxrZ3L1dWv3AzYy7CT0NgFp/+G6Ej2jIsdg2
        Ys6pw3pd2hQPFoCjpEDD0VHPBS4mE1ecL4FpWn8NI3dgcQOVwf16BaW64phUk69u3fTW
        vIzhKOL0Jp5ir1E5iR46QsLlhfswYlBRzD9jVU40YXtbsJaywtTSCnVb3AfngI/i9lH1
        s61MOO0bEUteZ+Kw29GEsguv6eePQsDQx3UTdhJaIGxads8TQTn8AAf6C1lQVSEqJz5f
        s/KA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIvSffTKU"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv4LJFTCQs
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 21 May 2019 21:15:29 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ondrej Kozina <okozina@redhat.com>,
        Daniel Zatovic <dzatovic@redhat.com>
Subject: Re: [PATCH] crypto: af_alg - implement keyring support
Date:   Tue, 21 May 2019 21:15:29 +0200
Message-ID: <8758550.T3OrFO1o5E@positron.chronox.de>
In-Reply-To: <20190521100034.9651-1-omosnace@redhat.com>
References: <20190521100034.9651-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 21. Mai 2019, 12:00:34 CEST schrieb Ondrej Mosnacek:

Hi Ondrej,

> This patch adds new socket options to AF_ALG that allow setting key from
> kernel keyring. For simplicity, each keyring key type (logon, user,
> trusted, encrypted) has its own socket option name and the value is just
> the key description string that identifies the key to be used. The key
> description doesn't need to be NULL-terminated, but bytes after the
> first zero byte are ignored.
>=20
> Note that this patch also adds three socket option names that are
> already defined and used in libkcapi [1], but have never been added to
> the kernel...
>=20
> Tested via libkcapi with keyring patches [2] applied (user and logon key
> types only).
>=20
> [1] https://github.com/smuellerDD/libkcapi
> [2] https://github.com/WOnder93/libkcapi/compare/f283458...1fb501c
>=20
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Thank you!

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

If the patch goes in, I will merge the libkcapi patch set and create a new=
=20
release.

Ciao
Stephan


