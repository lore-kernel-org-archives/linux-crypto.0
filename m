Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A535C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 19:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6649222C2
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 19:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576782663;
	bh=BWLeO1fdKRdQ+v3HbRCyNs5cudQrIbteuiI5tEQRpic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2BAD2Gpc0VdkDuz7VNHjew7mGhsNm3mEfy+F6+GxXG79Pg4ZpFdNBOdNUleIU/ft7
	 IWx8zNN8206JmORvE+T8K9hCw3awB1g7ieLyzcwf34quWrb2+EL7AB+x9eFztiuX1j
	 l3FrjqAgcwfOgjlA2aDdNli8awI0i3o6cwf6V/HA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfLSSi6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfLSSi5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:57 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D38DE24679;
        Thu, 19 Dec 2019 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780737;
        bh=BWLeO1fdKRdQ+v3HbRCyNs5cudQrIbteuiI5tEQRpic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2O6vdy8N9yK49XNdWSDm72qrQpiUNBCNoc4Eh8Al5w+kNEDrbnW+5ik1mQt/YdLd
         9YhZK441tounFZWVFobf8mg3MFKRHCEvhbudJ5cRCROr6fBG96jUuvcqmihDrdzUp+
         w90LSpfgz2dn7TXT0+FFy2ZBRgsuxrYVQF0kO72I=
Date:   Thu, 19 Dec 2019 10:38:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr: allow building a copy as loadable
 module for testing.
Message-ID: <20191219183854.GA54076@gmail.com>
References: <20191219160636.26316-1-msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219160636.26316-1-msuchanek@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 19, 2019 at 05:06:36PM +0100, Michal Suchanek wrote:
> There is no way to just run the tests built into testmgr. Also it is
> rarely possible to build testmgr modular due to KConfig dependencies.
> 
> Add a module that does not provide infrastructure, just runs testmgr
> tests.
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Why does this need to be a kernel module?  Since the self-tests are already run
at algorithm registration time, it's already possible to use AF_ALG or
crypto_user to allocate all algorithms which have self-tests.

- Eric
