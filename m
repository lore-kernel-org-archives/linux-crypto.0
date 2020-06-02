Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B166C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 16:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DDB420757
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591114002;
	bh=wjtmv9QCtJiRhP4f4+U8/quPDtCpWpm/uUdkL5CaPQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PeGc1G6MHpt+4djx4eHUAaIbL8PYovtmWQvkkk9uUt7A6KOCQjRvdUoa5k4p7jqy5
	 RME2EyQoXcxJa/TrF+97PqfnKzLIyw2fpoNAC2haUQTpdz4LsybWjs/mHzVY+ypWA7
	 U3qzusfmqnnnIy4e+Ks3VK9SL+8/qbl63YKzpvwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgFBQGl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgFBQGl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 12:06:41 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2150C206E2;
        Tue,  2 Jun 2020 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591114001;
        bh=wjtmv9QCtJiRhP4f4+U8/quPDtCpWpm/uUdkL5CaPQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ByjK+rgPedpouIYA5oVhAqTmnxSigh1nVMIwebqPzV11yQqX3wHdPPzD72cUyOCSI
         vV9+NTt1vgeu6u2GJzPZmewrpFma7aHn5lvSrA8bwx/P67zAWPPSE3ZGuqh5cK2Ccg
         mnysIBFfTxZhvdGB0WlfOKnJsTEuzA0o8YZbc2Zc=
Date:   Tue, 2 Jun 2020 09:06:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastien Buisson <sbuisson@ddn.com>
Cc:     Sebastien Buisson <sbuisson.ddn@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: add adler32 to CryptoAPI
Message-ID: <20200602160639.GA85856@gmail.com>
References: <20200528170051.7361-1-sbuisson@whamcloud.com>
 <20200601071320.GE11054@sol.localdomain>
 <B28A02E7-BE74-4ACE-981F-0CE47AC80CFE@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B28A02E7-BE74-4ACE-981F-0CE47AC80CFE@ddn.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 02, 2020 at 03:59:40PM +0000, Sebastien Buisson wrote:
> 
> > Le 1 juin 2020 à 09:13, Eric Biggers <ebiggers@kernel.org> a écrit :
> > 
> > On Thu, May 28, 2020 at 07:00:51PM +0200, sbuisson.ddn@gmail.com wrote:
> >> From: Sebastien Buisson <sbuisson@whamcloud.com>
> >> 
> >> Add adler32 to CryptoAPI so that it can be used with the normal kernel
> >> API, and potentially accelerated if architecture-specific
> >> optimizations are available.
> >> 
> >> Signed-off-by: Sebastien Buisson <sbuisson@whamcloud.com>
> >> ---
> >> crypto/Kconfig        |   7 +
> >> crypto/Makefile       |   1 +
> >> crypto/adler32_zlib.c | 117 ++++++++++++++++
> >> crypto/testmgr.c      |   7 +
> >> crypto/testmgr.h      | 362 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >> 5 files changed, 494 insertions(+)
> >> create mode 100644 crypto/adler32_zlib.c
> > 
> > Did you actually run the self-tests for this?  They fail for me.
> 
> I was wondering how to run testmgr tests alone?

Just boot with:

	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

Then check dmesg or /proc/crypto.

- Eric
