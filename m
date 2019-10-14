Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D46C47404
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 04:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FC120873
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 04:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfJNEr3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 00:47:29 -0400
Received: from audible.transient.net ([24.143.126.66]:56476 "HELO
        audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725554AbfJNEr3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 00:47:29 -0400
Received: (qmail 28518 invoked from network); 14 Oct 2019 04:47:27 -0000
Received: from cucamonga.audible.transient.net (192.168.2.5)
  by canarsie.audible.transient.net with QMQP; 14 Oct 2019 04:47:27 -0000
Received: (nullmailer pid 5717 invoked by uid 1000);
        Mon, 14 Oct 2019 04:47:27 -0000
Date:   Mon, 14 Oct 2019 04:47:27 +0000
From:   Jamie Heilman <jamie@audible.transient.net>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - convert to skcipher API
Message-ID: <20191014044726.GB3266@audible.transient.net>
References: <20191013041741.265150-1-ebiggers@kernel.org>
 <20191013232050.GA3266@audible.transient.net>
 <20191014031222.GC10007@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014031222.GC10007@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers wrote:
> > I built a patched 5.3.6 with none of the crypto bits modularized
> > and you can find that dmesg and config at:
> > 
> > http://audible.transient.net/~jamie/k/skcipher.config-5.3.6
> > http://audible.transient.net/~jamie/k/skcipher.dmesg
> > 
> 
> Great, I don't see any test failures in the log.  Just to double
> check, you had applied both Ard's patch and this one, right?:
> 
> 	crypto: geode-aes - switch to skcipher for cbc(aes) fallback
> 	crypto: geode-aes - convert to skcipher API and make thread-safe

Er, no?  Just the VIA padlock-aes.c change from you on top of a stock
5.3.6 tree, nothing from Ard.  No geode here.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
