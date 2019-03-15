Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE32C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 16:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5DE218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552666425;
	bh=reQyTHZwM4Y9KktK1ht8e2adzVEXBHMtrKNobmABwm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aAxG9+bx0sa1lNkZXScHPMkBUbq7UqL8D15LV4+3w2W7tKf3E36aipsXfQLfRvNTv
	 Snvdsx0Bj2AYoUWo3j+PIsS+1C4bVfqCqfVkg0C8D9BcExD0AGH1H0322R+DU1t1jX
	 hkSbmz8W2Iw2VbMrZYS5dfzb1IHjOz4QmX8ocqhM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfCOQNp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbfCOQNo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 12:13:44 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4651121871;
        Fri, 15 Mar 2019 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552666424;
        bh=reQyTHZwM4Y9KktK1ht8e2adzVEXBHMtrKNobmABwm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+zAfURDW3Ym1hJNvI1F3IcWKvxUoDhv1I3KP/DP4tBHxJ80paovn1J2kYWpi8X7v
         cgVIRLTlIbEMDUTcZqIdsHDM/I60j6PA5DpoHkgh2QC3CwY5BB/5t9fB4bvd+59Ixq
         TQM/Hgls/bopwOrMS4OnxmYNoQqVYRTUGySvgecc=
Date:   Fri, 15 Mar 2019 09:13:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 4/6] crypto/af_alg03: new regression test for
 rfc7539 hash alg validation
Message-ID: <20190315161341.GA77949@gmail.com>
References: <20190221053026.18489-1-ebiggers@kernel.org>
 <20190221053026.18489-5-ebiggers@kernel.org>
 <20190315092952.GA4990@dell5510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315092952.GA4990@dell5510>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Petr,

On Fri, Mar 15, 2019 at 10:29:53AM +0100, Petr Vorel wrote:
> Hi Eric,
> 
> you forget to add af_alg03 into runtest/cve.
> The same applies to af_alg0{4,5}.
> 
> 
> Kind regards,
> Petr

As far as I know, there are no CVEs assigned for those bugs.

- Eric
