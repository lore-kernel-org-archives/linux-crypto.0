Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1807CC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 04:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F762086A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 04:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfBVEhO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 23:37:14 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:52946 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfBVEhO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 23:37:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx2aF-0002kn-Sf; Fri, 22 Feb 2019 12:37:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx2aB-0005Jj-LM; Fri, 22 Feb 2019 12:37:07 +0800
Date:   Fri, 22 Feb 2019 12:37:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
Message-ID: <20190222043707.6kzqeztgx3rvv3a4@gondor.apana.org.au>
References: <20190213192329.680-1-brijesh.singh@amd.com>
 <CAOASepMn-r+2fQjDxP3yM=JuM-YDXNiAZWOo2x0OdTQBj4pdYA@mail.gmail.com>
 <a38e8f14-0ee1-f3ba-fda0-c6eff88c71a8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a38e8f14-0ee1-f3ba-fda0-c6eff88c71a8@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 14, 2019 at 07:33:29PM +0000, Singh, Brijesh wrote:
> 
> 
> On 2/14/19 10:57 AM, Nathaniel McCallum wrote:
> > I'm a little concerned that this immediately disables SEV_GET_ID.
> > IMHO, we should continue to support both for a period of time. One
> > justification for immediate disablement would be that if keeping it
> > around is likely to enabled incorrect or insecure userspace behavior
> > with a firmware change. 
> 
> 
> There are not many programs using the GET_ID today, my preference
> is to force userspace running on a kernel which supports the GET_ID2
> to use GET_ID2 and not fallback to GET_ID.
> 
> The current GET_ID is *broken*.
> 
> Here is one case I am trying to navigate:
> - AMD releases a new CPU
> - The kernel used in your distro does not support this CPU yet.
>    You updated the kernel to get the CPU support.
> - The GET_ID on this CPU returned a 10 bytes (instead of 64)
> - You gave the 64-bytes of data to AMD to get the certificate.
>    AMD server rejects the request because ID given to it does not
>    exist in its database.
> 
> If we drop the support for GET_ID in kernel, then GET_ID will fail and
> user will required to take action.

Sorry, but we can't drop a kernel API just to force userspace
to upgrade to a new one.

So I agree with Nathaniel that we should keep compatibility until
such a time when user-space is no longer using the old API.

You can use other mechanisms to encourage user-space to switch
over to the new API, e.g., a once-only warning if the old API
is used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
