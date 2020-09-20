Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6008C43465
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 14:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7269C21531
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 14:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="Tv6jedMR";
	dkim=temperror (0-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="G5WvkymR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgITOBV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 10:01:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56823 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726311AbgITOBV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 10:01:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EF1F35C0065;
        Sun, 20 Sep 2020 10:01:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 20 Sep 2020 10:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=A/ZjnwvXqRqqm+QgiPPmKStHh/4
        JwIXaKDmYW+WEZVI=; b=Tv6jedMRKhwNpGlOhrdkmsHUsL7R233wB2kNUVkTzNZ
        ncNIAnTgWuGMV0mbSeoxaULjMEI/L8Uwp/6iy5fYr5yb/1kM5Jwf/JKNycMkTIEC
        Pa3G9N6PRSixSNgIz/xOAZtKPnDCLLD1PrLi9JnU9v64DbEeNa+pv753yqZXE9fr
        JvyZhN2qld5vKxmmPz7+9shaXIG0uBCRuHBG91KXCW51l0sO0PEe82Eh3FL8bRzR
        3XE0gE0OS5Jwte7vgFlZ0E156hQ6RrR8YNk/f+DUr22QT5OGoVEF72WGVYw04cqj
        //hDgmqV+9GJP2830lQgaDn9YicBWcRU+biSf8IZsKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A/Zjnw
        vXqRqqm+QgiPPmKStHh/4JwIXaKDmYW+WEZVI=; b=G5WvkymRwyYFntEqpm9vQ/
        UplUMvaCfZiECsCrA03wXsp2ahfu4NYhf8zRcPSHxyou+nCs/VhQtl/iEihMWhia
        ZzYUDqGiokGu1UvK/+9s6heBSqqyBU2hYdVN8ykH8TAUb+K2zU+/nP5yFk130IpN
        9Y4kVAaaoNaNRtnFYvTPv1uwM+H7OPPn8T67wmNwOr1kwkxMzOVAUcXWsubAM3Es
        bn32N1aJsktNHX2GsfgHf3TO/UVMGgDaze/+7YqFZ3wXH1vYffLEXf71JTYPd3M8
        uXZHyqe24jYWCuH5vEofL9JK0T8guJl8ZhdAiDPqpV2oeGuKfRsENLICey9KP28Q
        ==
X-ME-Sender: <xms:rmBnX5YQSMUgNgZvgOA3ObGfJz7jrWLHoUtptZ6MRC_4KdTHt-5P-Q>
    <xme:rmBnXwbw02TIxPJUYFlHol_IvDNAPOjrXFn_aJ3HAfDIlS2SFR5how4Sg3k7pZMFC
    Nq3Dlb2O5x9Nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rmBnX7_uyshV2v7D72jpxmFEKuLzJ-ChQoZdyo8g-fTz7PRZr2U3lg>
    <xmx:rmBnX3qt3s8BdL4DlIBUbxHvi6PnrAJai1RadIiGmM1SK_5x2onhTw>
    <xmx:rmBnX0o9Z4ZpNkb7avo0qQ9T5ELogtun1f99eY6frv5VfWxOzj8TWg>
    <xmx:r2BnX9lRnSq1k_hy9fPewKqmU3ew_E5TyQ-ZyZWv-vatirvMUqgquw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59A70328005E;
        Sun, 20 Sep 2020 10:01:18 -0400 (EDT)
Date:   Sun, 20 Sep 2020 16:01:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the crypto tree
Message-ID: <20200920140143.GB2886633@kroah.com>
References: <20200918152127.4414b524@canb.auug.org.au>
 <20200918054134.GA9252@gondor.apana.org.au>
 <20200918074911.GA987884@kroah.com>
 <20200918075036.GA24315@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918075036.GA24315@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 05:50:36PM +1000, Herbert Xu wrote:
> On Fri, Sep 18, 2020 at 09:49:11AM +0200, Greg KH wrote:
> >
> > Ok, I'll go revert these.
> 
> Thanks!
> 
> > > As the driver has been converted over to the lib arc4 API, it
> > > does not need to select CRYPTO at all.
> > 
> > Is it converted in your tree?  If so, have a branch/tag I can pull in to
> > prevent merge issues in the future?
> 
> It's in the cryptodev tree, but unfortunately it's not in a
> topic branch so you'd be pulling all other crypto changes along
> with it.

Sorry for the delay, this is now fixed up in my tree.

greg k-h
