Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599B8C73C56
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 20:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18188208C4
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562703018;
	bh=C2Qh9EeeUhrM/1fa+cpaXtK8WHXbqcHpSVD+ialRHTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cSpbwmDJ3HnhzBeXSAN6GbRA5s1cV1nczIEB1vo1q3Y1IqOuTop43Pl8zX+GbGJsE
	 vP3HHzfiEqX/MDmqUsOfX1ycoOqa+42i679VVtBRptbJfvgf79XZ1v9B8fbYFQo9b5
	 QU6HbEchYvmBcJdOOZkjv5xHG7MymvYlv8ncawY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfGIUKR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 16:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbfGIUKQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 16:10:16 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CB72073D;
        Tue,  9 Jul 2019 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562703015;
        bh=C2Qh9EeeUhrM/1fa+cpaXtK8WHXbqcHpSVD+ialRHTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zvxo/An+MlPtqSCOQ/U7InOBf1uYLDYp5mViU3NrJaZTeyBlmgMhJkPeea4RmAFK0
         CQg5qEQH+WACd6EPZScnlt1NYO0oh0j3Y4I29MkJ8owpkABXQWcbXMBDc5yoOL0FvN
         kd38fOsdohicn/XxN+y9TOsyf3kLea6B4EAmyfcI=
Date:   Tue, 9 Jul 2019 13:10:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190709201014.GH641@sol.localdomain>
Mail-Followup-To: Gary R Hook <ghook@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
 <20190705194028.GB4022@sol.localdomain>
 <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 08, 2019 at 05:08:09PM +0000, Gary R Hook wrote:
> On 7/5/19 2:40 PM, Eric Biggers wrote:
> > Hi Gary,
> > 
> > On Wed, Jul 03, 2019 at 07:21:26PM +0000, Hook, Gary wrote:
> >> The AES GCM function reuses an 'op' data structure, which members
> >> contain values that must be cleared for each (re)use.
> >>
> >> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> >>
> >> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> >> ---
> >>   drivers/crypto/ccp/ccp-ops.c |   12 +++++++++++-
> >>   1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > Is this patch meant to fix the gcm-aes-ccp self-tests failure?
> 
> Yessir, that is the intention. Apologies for not clarifying that point.
> 
> grh
> 
> 

Okay, it would be helpful if you'd explain that in the commit message.

Also, what branch does this patch apply to?  It doesn't apply to cryptodev.

- Eric
