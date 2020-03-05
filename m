Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDC0C3F2CD
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 10:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36FB62073D
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 10:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="I6t8BP1I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgCEKds (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 05:33:48 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:30904 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCEKds (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 05:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583404423;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=lAG5oOfZYa0ZZc4Uadd+FIbLaL5zY+h9aowSlE+qW80=;
        b=I6t8BP1IPJ3h9bCv7LpRYMsWcdlrGwdeQ0+FB1a/YD0i1Ntw4idL1lr4HDQrQViawh
        WuWwFztUCYKkZlWAhi+UCa8HYJHkIMvVoJQS2Yo7KMBVpT/wxSaywaAOqY7Qbo67Jlv+
        JsXhnH6p3b0EMjQwchGC8P1Ls7WSb0p5Fh7e7i9EGeoXyoldH8W6g9mQo+20Cma++Gme
        AT+t8Ad6T3uyh4gutgLJ2fc+9E76sSwSNm/Ib/88Kpi7R5oRWlOfF00cPRHFvra/Sgis
        2UEN1FkLkwOT0TVKSDGv5RlSOchcSg7N7Chb5SKR46wN1C6G59ijRCxWxcjtg//qFc6+
        jaoQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDaJfScGJUh"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id Q01030w25AXfWvr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 5 Mar 2020 11:33:41 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] crypto: xts - add check for input length equal to zero
Date:   Thu, 05 Mar 2020 11:33:40 +0100
Message-ID: <4145904.A5P2xsN9yQ@tauon.chronox.de>
In-Reply-To: <20200305102255.12548-1-andrei.botila@oss.nxp.com>
References: <20200305102255.12548-1-andrei.botila@oss.nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 5. M=E4rz 2020, 11:22:55 CET schrieb Andrei Botila:

Hi Andrei,

> From: Andrei Botila <andrei.botila@nxp.com>
>=20
> Through this RFC we try to standardize the way input lengths equal to 0
> are handled in all skcipher algorithms. Currently, in xts when an input
> has a length smaller than XTS_BLOCK_SIZE it returns -EINVAL while the
> other algorithms return 0 for input lengths equal to zero.
> The algorithms that implement this check are CBC, ARC4, CFB, OFB, SALSA20,
> CTR, ECB and PCBC, XTS being the outlier here. All of them call
> skcipher_walk_virt() which returns 0 if skcipher_walk_skcipher() finds
> that input length is equal to 0.
> This case was discovered when fuzz testing was enabled since it generates
> this input length.
> This RFC wants to find out if the approach is ok before updating the
> other xts implementations.

It may be a good idea to consolidate that. However, changing only one=20
implementation is not good.

All XTS implementations would need to be converted then.

Ciao
Stephan


