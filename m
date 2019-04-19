Return-Path: <SRS0=LFue=SV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733C8C282DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A06020449
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfDSSiA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:38:00 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38234 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728381AbfDSSiA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Apr 2019 14:38:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hHMT5-000424-Hq; Fri, 19 Apr 2019 13:53:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hHMT5-0005Qc-8g; Fri, 19 Apr 2019 13:53:47 +0800
Date:   Fri, 19 Apr 2019 13:53:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] crypto: gcm - fix incompatibility between "gcm" and
 "gcm_base"
Message-ID: <20190419055347.geolvnydnzyzbp3i@gondor.apana.org.au>
References: <20190418214302.137478-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418214302.137478-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 02:43:02PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> GCM instances can be created by either the "gcm" template, which only
> allows choosing the block cipher, e.g. "gcm(aes)"; or by "gcm_base",
> which allows choosing the ctr and ghash implementations, e.g.
> "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> However, a "gcm_base" instance prevents a "gcm" instance from being
> registered using the same implementations.  Nor will the instance be
> found by lookups of "gcm".  This can be used as a denial of service.
> Moreover, "gcm_base" instances are never tested by the crypto
> self-tests, even if there are compatible "gcm" tests.
> 
> The root cause of these problems is that instances of the two templates
> use different cra_names.  Therefore, fix these problems by making
> "gcm_base" instances set the same cra_name as "gcm" instances, e.g.
> "gcm(aes)" instead of "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> This requires extracting the block cipher name from the name of the ctr
> algorithm.  It also requires starting to verify that the algorithms are
> really ctr and ghash, not something else entirely.  But it would be
> bizarre if anyone were actually using non-gcm-compatible algorithms with
> gcm_base, so this shouldn't break anyone in practice.
> 
> Fixes: d00aa19b507b ("[CRYPTO] gcm: Allow block cipher parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Changed since v2:
> 	- Leave checks for ctr cra_blocksize == 1 and ghash digestsize == 16.
> 
> Changed since v1:
> 	- Verify that ghash is really ghash (based on name).
> 	- Improved commit message.
> 
>  crypto/gcm.c | 34 +++++++++++-----------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
