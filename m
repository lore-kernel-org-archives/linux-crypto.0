Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE2FC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 18:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 378D7218D0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 18:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfCOSkV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 14:40:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:36222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbfCOSkV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 14:40:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F9B2AF92;
        Fri, 15 Mar 2019 18:40:20 +0000 (UTC)
Date:   Fri, 15 Mar 2019 19:40:18 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 4/6] crypto/af_alg03: new regression test for
 rfc7539 hash alg validation
Message-ID: <20190315184018.GA3112@x230>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190221053026.18489-1-ebiggers@kernel.org>
 <20190221053026.18489-5-ebiggers@kernel.org>
 <20190315092952.GA4990@dell5510>
 <20190315161341.GA77949@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315161341.GA77949@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> > you forget to add af_alg03 into runtest/cve.
> > The same applies to af_alg0{4,5}.

> As far as I know, there are no CVEs assigned for those bugs.
Wouldn't be better to add them to runtest/cve (or other runtest file) just with
filename? And rename them in runtest file once the CVEs are assigned?

> - Eric

Kind regards,
Petr
