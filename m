Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71097C3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 05:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4120322CF5
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 05:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567055013;
	bh=aE6er4y3r7Fc/e1Xvy8t2OaC98kF0hANW5EmPqEpe6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uHrFl1SDWe5hj79AXsnmSmSFwgT7uEaaXeZ28sPRnnZe8aaNeqNKZCFmxT3T2RjLb
	 Xf6tphl4RZEhGZTBlZ6L8itPFaJ/TTMt9YLCjg8gDC1drFi4h3MgAv51nrey50OkGd
	 PPOSyzS2WcJjJ6eubcCNaYEj8gCzvUcWo95/RppU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfH2FDc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 01:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfH2FDc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 01:03:32 -0400
Received: from zzz.localdomain (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BFC22CF5;
        Thu, 29 Aug 2019 05:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567055011;
        bh=aE6er4y3r7Fc/e1Xvy8t2OaC98kF0hANW5EmPqEpe6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QS7l6Cq6Ds3mrw5b7I54Qixe1c7+UJ/vJbgbzo340Gzhl+piEMaPAGcTDlbPDNLxW
         xi9XcYvG5oE+X5pE0QQ5A49SAJMS5oO3vFC6UKlceqJnhMxFK2blQ+n+Heb14sFg8B
         bmne6LSG+4GzbW8tDbY9lHI6oNMSRBjb+82fkmTQ=
Date:   Thu, 29 Aug 2019 00:03:28 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: net/tls(TLS_SW): double free in tls_tx_records
Message-ID: <20190829050328.GA3307@zzz.localdomain>
Mail-Followup-To: Pooja Trivedi <poojatrivedi@gmail.com>,
        linux-crypto@vger.kernel.org
References: <CAOrEdsmpHT-=zH9zyHv=pLX2ENb1S0AnkrcWVgMxqWrxKsF3yw@mail.gmail.com>
 <CAOrEdsnpQ+e5rWKxrr4vXH6_4CeESSE27GRcQd4TuXDe72MVmQ@mail.gmail.com>
 <CAOrEds=P2nBHa+rqx3SC6fZ97rRCdBWgXkg2N8yYLP8-knfxpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrEds=P2nBHa+rqx3SC6fZ97rRCdBWgXkg2N8yYLP8-knfxpw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 28, 2019 at 11:41:25AM -0400, Pooja Trivedi wrote:
> TLS module crash while running SSL record encryption using
> klts_send_[file] using crypto accelerator (Nitrox).

Does the Nitrox crypto driver pass the extra crypto self-tests, which were added
in v5.1 and v5.2?  I.e. boot a kernel configured with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.  I'm asking in case this is a bug that's
already detected by the tests, as that could be an easier way for someone to
start fixing this driver... And if you're actually using this driver for
something important, you may want to look into making sure it passes the tests
anyway, as I haven't seen anyone else do so yet.

Otherwise, it could also be a bug in net/tls/ (in which case you'd need to
report it to the maintainers for that), or it could be a bug that only shows up
with multiple concurrent requests, which isn't yet covered by the self-tests.

- Eric
