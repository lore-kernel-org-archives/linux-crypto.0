Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915ABC3B184
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 06:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E26320870
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 06:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581315057;
	bh=8g0hKppIhVXqTMKuYFDl3Cie2wyh70mX7s8ucWyEmP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=bN4ykMqpwiD3sHnRnHdLyiHRGrXIBfIgmtlV8BI9G9YvathX3qetHRDSA/8a4UJF5
	 5EZpnm0Wb5at2fPc+bnHXQAYkFegE7sUqOY949R7TS6mB0q8eHqHXav0XlmLx+Ddgp
	 1eQaGhcKu892YrXx8jffqFpCL3Ded8FwxMaV14qU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgBJGKz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 01:10:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgBJGKz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 01:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=goUY2avRCYVAek7mCPEP6D9VvLCgLAVwzsr5XSoA9jI=; b=fCcxVNrKPFdXDSKhgC67R9+Gay
        OPRuRD3lNe+D7m3D1M+6TCJG3HdpOC960ObyRUJghTHBcs5tnFLz3O3/jHYR58G9IoCl4NUTrYzkL
        f9Bzz+TWoY6hibjVzfc0OrEeUBOQDYobAQ80+PaPp4ySQ4ZJi/pHVF41MjEumEU3UJhTSvbqkxG5H
        Qsg89Z+AqdUEBI5FLIfdYeG3X4IXYyjk1HBc78/GYWhQuV/tS0R+PGWaXofxlkWEBkCmOpC81/JPR
        CEGJjzOxoijWHqxapJT/aEva0/UljFlkYIhiPL/QsDJ0p0W3I2vCUdwYQLF0EJ5LA6v/qFPPpnSF1
        kdMGLLbw==;
Received: from [80.156.29.194] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12HT-0000wc-Dz; Mon, 10 Feb 2020 06:10:52 +0000
Date:   Mon, 10 Feb 2020 07:10:47 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Ben Boeckel <mathstuf@gmail.com>
Cc:     list.lkml.keyrings@me.benboeckel.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 02/11] docs: crypto: convert asymmetric-keys.txt to ReST
Message-ID: <20200210071047.0db3f3a6@kernel.org>
In-Reply-To: <20200206200911.GA2830394@erythro.kitware.com>
References: <cover.1581001737.git.mchehab+huawei@kernel.org>
        <1b6cd1da02dda27a725a6c4214019a1e306a7927.1581001737.git.mchehab+huawei@kernel.org>
        <20200206200911.GA2830394@erythro.kitware.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Em Thu, 6 Feb 2020 15:09:11 -0500
Ben Boeckel <mathstuf@gmail.com> escreveu:

> On Thu, Feb 06, 2020 at 16:11:21 +0100, Mauro Carvalho Chehab wrote:
> > - (1) If the criterion string is of the form "id:<hexdigits>" then the =
match
> > +  1) If the criterion string is of the form "id:<hexdigits>" then the =
match =20
>=20
> This update was followed in all the enumeration changes except=E2=80=A6
>=20
> > - (2) If the criterion string is of the form "<subtype>:<hexdigits>" th=
en the
> > + 2) If the criterion string is of the form "<subtype>:<hexdigits>" the=
n the =20
>=20
> The whitespace here doesn't match up. Which is preferred?

That was a mistake.

>=20
> > - (1) Signature verification.
> > +1) Signature verification. =20
>=20
> Here, the indentation was lost too. Is this intentional?

Both ways would work. I'll keep the original indentation for the next
version. Thanks for pointing it.

Cheers,
Mauro
