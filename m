Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3843C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 05:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C6520679
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 05:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Bgt4JASD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfE1F7a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 01:59:30 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:13617 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfE1F7a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 01:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1559023166;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=imAG4ejJDRvwNixqNMdCZDap4QOQARpTgOEJueravn4=;
        b=Bgt4JASDPFLD6Ghy8vyRDFOrY2GDs9CkLH5TkBmK5zTjOsQe/ke8/G8Q08/zFesmv2
        KSVk/lBP7auzJPjOqL4ceFHVWUIqIE1gR3SJ8s9ir+Z9Z1D9z0U9NEjSoJ2zcPEbe++c
        85Cwg7FiuPktADx49MGIb8u2xXr8gWIzTi9zgjLCQIa0nss0SWWWU/uG8yGO1ajivoMg
        sfSZTQ4HWbr+/1/H+G0Mp6VbVKW5v5YBdzOY4rJMQAagfddZBGV+mQJIhjZi8MZMAt5c
        QSKkozy+hgzDdFo2Y+WN274qP+r2dhkTJ+J5VAzzXeFp/Vr0NF5lg90s7ggDffhuX8Io
        rqmQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvSfTerW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv4S5xHl6d
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 28 May 2019 07:59:17 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, terrelln@fb.com,
        jthumshirn@suse.de
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
Date:   Tue, 28 May 2019 07:59:17 +0200
Message-ID: <2084703.uDJgg2HtUG@tauon.chronox.de>
In-Reply-To: <b9311cb4-3d59-1e97-4967-2f430c4918ad@suse.com>
References: <20190527142810.31472-1-nborisov@suse.com> <1778879.ZR4uXBBfnJ@tauon.chronox.de> <b9311cb4-3d59-1e97-4967-2f430c4918ad@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 28. Mai 2019, 07:58:19 CEST schrieb Nikolay Borisov:

Hi Nikolay,

> On 28.05.19 =D0=B3. 7:58 =D1=87., Stephan Mueller wrote:
> > Please correct me if I am wrong, but as far as I see, however, xxhash
> > seems to be a cryptographic hash function.
>=20
> No, xxhash is non-cryptographic. THe official description from
> xxhash.com states:
>=20
> xxHash is an extremely fast non-cryptographic hash algorithm, working at
> speeds close to RAM limits. It is proposed in two flavors, 32 and 64 bits.

I see, then please disregard my comment on the FIPS flag then.

Ciao
Stephan


