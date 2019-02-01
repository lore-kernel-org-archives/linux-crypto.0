Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9B7C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FBF120B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549004434;
	bh=4KBQNtP4gWvqPzy5SBIA1LvXSJX9ECgaE0jAUF+VdcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=T0Ind33iwWGb0R+xTCc7z5HAM8yYo0KzFveitdUR049G4HhlYBYnTOEb5Vfk34loo
	 n4DYuOLLbC9ljsc+VzZSo0/UvlnRQefX9kKPSyg0gGJzNn80GoyzMcAeAtseNLWgVB
	 Y1qY+YtF8rnLrBJjHigVCN86MeaaUZgiVZcoFGQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfBAHAd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfBAHAd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:00:33 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DEB20869;
        Fri,  1 Feb 2019 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549004433;
        bh=4KBQNtP4gWvqPzy5SBIA1LvXSJX9ECgaE0jAUF+VdcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fIhZwanhYSgDHGc8KaeUX/AS0itQQyGFSRa2k0qX+SiwpQhZD3grZOKj+NM1FpMyt
         BUXd2c0Jpfk0BoHfEd9S29RSzsGEW6pMcpP5p427OopbEy038dobQSl38blK12ICJa
         agnC5cmIQcf+U48uNj6CnE5ZSQh3eWXtF3PzIv8A=
Date:   Thu, 31 Jan 2019 23:00:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC/RFT PATCH 09/15] crypto: testmgr - introduce
 CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
Message-ID: <20190201070030.GB765@sol.localdomain>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190123224926.250525-10-ebiggers@kernel.org>
 <20190201053146.mgswr6w7zktl7cet@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201053146.mgswr6w7zktl7cet@gondor.apana.org.au>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 01, 2019 at 01:31:46PM +0800, Herbert Xu wrote:
> On Wed, Jan 23, 2019 at 02:49:20PM -0800, Eric Biggers wrote:
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 86960aa53e0f..cbeba16fd8c1 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -168,6 +168,16 @@ config CRYPTO_MANAGER_DISABLE_TESTS
> >  	  Disable run-time self tests that normally take place at
> >  	  algorithm registration.
> >  
> > +config CRYPTO_MANAGER_EXTRA_TESTS
> > +	bool "Enable extra run-time crypto self tests"
> > +	depends on !CRYPTO_MANAGER_DISABLE_TESTS
> 
> Perhaps add a dependency on DEBUG_KERNEL so we don't bother people
> who don't care?
> 

Yes, I'll do that.

- Eric
