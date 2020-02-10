Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E10C352A3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 16:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819622085B
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 16:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q3VdF09J";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="DDfFm1y9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBJQjm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:39:42 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50684 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbgBJQjl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 11:39:41 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 134008EE148;
        Mon, 10 Feb 2020 08:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1581352779;
        bh=20ByqU+EizZKPkqUhbomHgMziFBgl9Chtb+YLWGYMEw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q3VdF09JPkw71oPfj98KbAz9vHSixoqSDip4T7BUFweZnM12+eCwloi0OcSRjKjfk
         UFowq9cYBFr0qjW6ryK3MF5CZS5hKcgMq+XpcFeHNA7FrHhdMnnXai5bdjq1TrTwYt
         Zs9LTdhUV8TAmfM5XA0MTxaHqSzjdTQXSyDFgUhw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7MM38oVuwc0s; Mon, 10 Feb 2020 08:39:38 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4A8708EE0F5;
        Mon, 10 Feb 2020 08:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1581352778;
        bh=20ByqU+EizZKPkqUhbomHgMziFBgl9Chtb+YLWGYMEw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DDfFm1y9ihG79RS5aghuMMGO+CFvgxOdbG/KL8HDQ064rToO51sk13jMOEiHj0QUu
         x1tJyPbVldcTQ6mtyI9w5ajMvSmfRK4Ta6aJ/I70N/F5U/5hKNK+QizLMAXB6hfHBh
         OiPfXTsDIjLNHFXzqT+TS4IqHW1faZt5onRcWZVY=
Message-ID: <1581352777.3526.17.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/2] crypto: sm3 - add a new alias name sm3-256
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Ken Goldman <kgold@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 10 Feb 2020 08:39:37 -0800
In-Reply-To: <1a623251-e83a-3b70-9fbd-8e929a23f7d8@linux.ibm.com>
References: <20200207092219.115056-1-tianjia.zhang@linux.alibaba.com>
         <20200207092219.115056-2-tianjia.zhang@linux.alibaba.com>
         <20200210031717.GA5198@sol.localdomain>
         <1a623251-e83a-3b70-9fbd-8e929a23f7d8@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-02-10 at 11:30 -0500, Ken Goldman wrote:
> On 2/9/2020 10:17 PM, Eric Biggers wrote:
> > According to https://tools.ietf.org/id/draft-oscca-cfrg-sm3-01.html
> > ,
> > SM3 always produces a 256-bit hash value.  E.g., it says:
> > 
> > 	"SM3 produces an output hash value of 256 bits long"
> > 
> > and
> > 
> > 	"SM3 is a hash function that generates a 256-bit hash value."
> > 
> > I don't see any mention of "SM3-256".
> > 
> > So why not just keep it as "sm3" and change hash_info.c instead?
> > Since the name there is currently wrong, no one can be using it
> > yet.
> 
> Question:  Is 256 bits fundamental to SM3?

No.

>   Could there ever be a 
> variant in the future that's e.g., 512 bits?

Yes, SM3 like SHA-3 is based on a 512  bit input blocks.  However,
what's left of the standard:

https://www.ietf.org/archive/id/draft-sca-cfrg-sm3-02.txt

Currently only defines a 256 output (via compression from the final 512
bit output).  In theory, like SHA-3, SM3 could support 384 and 512
output variants.  However, there's no evidence anyone is working on
adding this.

James

