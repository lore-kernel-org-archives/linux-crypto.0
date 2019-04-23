Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC0AC282E1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 15:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40437218D2
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 15:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfDWPns (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:43:48 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:55466 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfDWPns (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 11:43:48 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 76CFD72CC58;
        Tue, 23 Apr 2019 18:43:45 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 30DD04A4A29;
        Tue, 23 Apr 2019 18:43:45 +0300 (MSK)
Date:   Tue, 23 Apr 2019 18:43:44 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 23 (crypto/ecrdsa)
Message-ID: <20190423154343.xvubeub3ejhikfcn@altlinux.org>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20190423202832.49cdf5bc@canb.auug.org.au>
 <ea752c71-b41f-47f5-290b-3a31bb0e96df@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <ea752c71-b41f-47f5-290b-3a31bb0e96df@infradead.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Randy,

On Tue, Apr 23, 2019 at 08:22:40AM -0700, Randy Dunlap wrote:
> On 4/23/19 3:28 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > News: there will be no linux-next release on Thursday April 25.
> > 
> > Changes since 20190418:
> > 
> 
> on i386 or x86_64:
> 
> ERROR: "asn1_ber_decoder" [crypto/ecrdsa_generic.ko] undefined!
> ERROR: "look_up_OID" [crypto/ecrdsa_generic.ko] undefined!
> 
> 
> Do you need a failing config file?

I will send a patch soon. Thanks!

> 
> thanks.
> -- 
> ~Randy
