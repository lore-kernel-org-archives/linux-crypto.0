Return-Path: <SRS0=YBhh=TS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C33EC072A4
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 06:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF20216C4
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 06:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="RQtOR/ZL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oUpnUkOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfERG60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 May 2019 02:58:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41845 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfERG60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 May 2019 02:58:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 500B427EBC;
        Sat, 18 May 2019 02:58:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 18 May 2019 02:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=BDPgxHIkT02j4dOjiCn+sP7P8iy
        Uf/zHH9K+ayucwiY=; b=RQtOR/ZLOU4qjQX8Xz+XtQVgg66zwMumdFd/vRVIg3F
        SLsiO9FidnhtDkBVysmDtJgBBNLcWyimoBYxUDnqzufCq0++64ZESA9v1iZonFHp
        mMatSFp18zkppsmzj5RVbenR+ha3rmudYCySDyiwATAxdjyPmB342tuUUTuJG13n
        ajD7FrhLd8dJI+9nLFFfpnHxHBlb7ghQFpo8lIBNx9yHeYpZZBsxiVvit/cRt7zT
        74Sixv6vCGywDCoK7I2J1h1HYrCdXZqzDgvJizC1jRBlNAWjatuYyDBPKEgQJfyr
        4R9jIgnejLmSM07kw/l402qUVR+aNpWrTHlBoS/GXVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BDPgxH
        IkT02j4dOjiCn+sP7P8iyUf/zHH9K+ayucwiY=; b=oUpnUkOC2ATJ1ryMnBBQCo
        xiwpaKoft1tc1rG/+DmbO5FTQT4GM+FmVFKpbFQXL0JMR7wUefGnf9toxP/q36Bn
        taezOeQqfgy5eATySq2y7MndqVdwz+BNTda9sAsVs99Jddw1TMgkdtAo44rJcHU2
        /DamhUTelDPctOmptURadstMVDrGhbg9kH/nwxgfsjs4YFQbcFv/tnbS6V4vjHlJ
        HOVUXjs8na1RBX1zzDOxFnOBbQZ0TCB+s1GpZr/9dwuIH/1P5S8nGDUt4G5Lb86I
        cOOT6g9fxowEtYSx5P+sT+EdhslI2VRCGNll7CnmPh8lP1HRBjDsM05FWiyJWX2g
        ==
X-ME-Sender: <xms:Ea3fXKgjPyrwK6hFORzWJ7zG_3nDtJ7EqViOBkn9ZVSM0Qy2pnDQhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:Ea3fXEU5VXC4PwG8ObxpYXfayg-WvWmhpTjLyD0foo1WKpuHjCnC2Q>
    <xmx:Ea3fXOcfnweUDrOj3NlOSAt1z7m_J-qgwNER0n7PoYHw9B_tFI9HNg>
    <xmx:Ea3fXK0_JoxrlqmPfN__YO7EAmLXsRk3il6SXJAlH0xtNnFPWXaRIg>
    <xmx:Ea3fXMn_wyhn0UHyzTJBFg6yOMGKbirjOxh9DnwFxg1-scmIJnN_HA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A14A10378;
        Sat, 18 May 2019 02:58:24 -0400 (EDT)
Date:   Sat, 18 May 2019 08:58:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.14] crypto: arm64/aes-neonbs - don't access
 already-freed walk.iv
Message-ID: <20190518065822.GE28796@kroah.com>
References: <20190517172951.58312-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517172951.58312-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 17, 2019 at 10:29:51AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 4a8108b70508df0b6c4ffa4a3974dab93dcbe851 upstream.
> [Please apply to 4.14-stable.]

Now applied, thanks.

greg k-h
