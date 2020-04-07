Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6EBC2BA16
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 04:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 803E220692
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 04:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586235519;
	bh=r91KxDKQs7nxeFamX6w+PiN3ptOt9aVDPR9VN1EabDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yhT1nb9PYT0SyV8HyaFGUYnN3kinjGRPZtBZJDYfK5rQ1ZVoatg0eGG1thcqHLQhS
	 VWhhL87wTJ6kah17s+8UhgRN9HcLVhlbdoC6SZ9z+DYDAVsugCVwQdGM7HAhgucDg6
	 pPj86UOU/Ra22H9Z/lKdaNwMGSS1s1CwcjSJzGzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgDGE6i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 00:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgDGE6i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 00:58:38 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 680BB206BE;
        Tue,  7 Apr 2020 04:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586235517;
        bh=r91KxDKQs7nxeFamX6w+PiN3ptOt9aVDPR9VN1EabDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRqJTyxiMJ+05naBx89XSeDwh4lmJVRQEZUCcJEa6S8KWz3rZ+6kzgxhqct5bBY1s
         mNPtV5s5VRPSCyHpdpwOAhXMEUJfhOCs9KmHg9Yf/mGfY1gnaQLR6ea2PLQp5GTR9E
         JIMODJDLJIOV8OHCL+3ObUUeDvkk3WuMqmkm/X8s=
Date:   Mon, 6 Apr 2020 21:58:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: crypto: algboss - Avoid spurious modprobe on LOADED
Message-ID: <20200407045835.GA102437@sol.localdomain>
References: <20200407030003.GA12687@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407030003.GA12687@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 07, 2020 at 01:00:03PM +1000, Herbert Xu wrote:
> As it stands when any algorithm finishes testing a notification
> is generated which triggers an unnecessary modprobe because algboss
> returns NOTIFY_DONE instead of NOTIFY_OK (this denotes an event
> that is not handled properly).
> 
> This patch changes the return value in algboss so that we don't
> do an unnecessary modprobe.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Needs a Fixes tag?

Fixes: dd8b083f9a5e ("crypto: api - Introduce notifier for new crypto algorithms")
Cc: <stable@vger.kernel.org> # v4.20+

> 
> diff --git a/crypto/algboss.c b/crypto/algboss.c
> index 527b44d0af21..01feb8234053 100644
> --- a/crypto/algboss.c
> +++ b/crypto/algboss.c
> @@ -275,7 +275,7 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
>  	case CRYPTO_MSG_ALG_REGISTER:
>  		return cryptomgr_schedule_test(data);
>  	case CRYPTO_MSG_ALG_LOADED:
> -		break;
> +		return NOTIFY_OK;
>  	}
>  
>  	return NOTIFY_DONE;

It's hard to remember the difference between NOTIFY_OK and NOTIFY_DONE.  Isn't
it wrong to call request_module() in the first place for a message that
"cryptomgr" doesn't care about?  Wouldn't the following make more sense?:

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 69605e21af92..849254d7e627 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -403,7 +403,7 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
 	if (!err)
-		crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
+		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
 
 out:
 	crypto_larval_kill(&larval->alg);
