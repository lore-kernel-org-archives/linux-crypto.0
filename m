Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC58C282DD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CCA32084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfDHGlV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:41:21 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45960 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHGlU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:41:20 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNy3-0008C8-4E; Mon, 08 Apr 2019 14:41:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNy3-0005rV-0E; Mon, 08 Apr 2019 14:41:19 +0800
Date:   Mon, 8 Apr 2019 14:41:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - add panic_on_fail module parameter
Message-ID: <20190408064118.vmt5xtrqjewbzknc@gondor.apana.org.au>
References: <20190331200914.27341-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331200914.27341-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 31, 2019 at 01:09:14PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a module parameter cryptomgr.panic_on_fail which causes the kernel
> to panic if any crypto self-tests fail.
> 
> Use cases:
> 
> - More easily detect crypto self-test failures by boot testing,
>   e.g. on KernelCI.
> - Get a bug report if syzkaller manages to use the template system to
>   instantiate an algorithm that fails its self-tests.
> 
> The command-line option "fips=1" already does this, but it also makes
> other changes not wanted for general testing, such as disabling
> "unapproved" algorithms.  panic_on_fail just does what it says.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/testmgr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
