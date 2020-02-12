Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3761BC352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1189E20848
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjRmc/Pl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgBLS5z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 13:57:55 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41487 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgBLS5z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 13:57:55 -0500
Received: by mail-wr1-f49.google.com with SMTP id c9so3703280wrw.8;
        Wed, 12 Feb 2020 10:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+tUlCThn63nr8AX9IVogsM4cgL01ILS5Tg3/pn6+WnE=;
        b=RjRmc/Pl3zK7Yh9wm/vPuSHThzncjj/DsaY1ohBtIYudX7FTrMhAkB996DjAnlihAk
         FKBg4xx1NKj2nC+auvtdmurlVDtIMc+N4hjNyVI0GegjEv6Uaqq1xwjl4aynK0xb7CFQ
         qmRsdiMKBhTFHrudyDG9iS5afr4JvRCI1mZGxn65I4Txq6BIwd1OfgPix8HC9Sv/vgbX
         tYD6pq8PljW2DQoLcARcbhOcAnuW4LfuEy0izMWTitEYwoWQ4FW7HWAIQk1k86/kvMH9
         H1R/v/Ri3IDeJqnSs/Tvn+LfMeqkf44YfOC24rkxMp7/I4qDoWlbmJzE0+pQxg+isKTk
         QnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+tUlCThn63nr8AX9IVogsM4cgL01ILS5Tg3/pn6+WnE=;
        b=PQ0LCsOI2ElyGIxrK0cdbJA1IMomS0Fp5BztRFV8MjGVBnr8MLG1MrHepI6zMNhenR
         HAF+R5t7QrfAcoqksOMMv/d4F+zeJp7QLMwafF3puNWzK3uHl75x4XIWfPilfb3QjC+T
         chQoFQNc2IvvjB4+FG0r71Y6xrkNAbdMJj9DXOIKmbM93lE4GsKp0B25AcvvBjnqJM2v
         ukKbzq7FxgAoFKomEABz9N8vqY05FkSzqiaF4gGn2cBcNxIeEuDzK5Eq3TYwtZV8nqSs
         8X/vXVD/dc2I7mMS+7lh6B5kv1t7nvoYgn+KTOKkXnDoG6rtjzQGvFxnEVsZoaPaqKCL
         4Xlg==
X-Gm-Message-State: APjAAAXUzc/DQhfGk1YVuc1v9FdnrUeDTu9JsmbMUTVMuShNMlgjv5gX
        1b8XKLXrZiup0jM5c9JNzfE=
X-Google-Smtp-Source: APXvYqwdIoxkvWUPnZ7sFgFGzvxj/339f/O0B+D9d5wOSbNRbj+Q7lVLjw4ya/GBgLIGYg7pPWRJeA==
X-Received: by 2002:adf:b254:: with SMTP id y20mr16323536wra.362.1581533871856;
        Wed, 12 Feb 2020 10:57:51 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n10sm1623957wrt.14.2020.02.12.10.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 10:57:51 -0800 (PST)
Date:   Wed, 12 Feb 2020 19:57:49 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200212185749.GA9886@Red>
References: <20200206085442.GA5585@Red>
 <20200207065719.GA8284@sol.localdomain>
 <20200207104659.GA10979@Red>
 <20200208085713.ftuqxhatk6iioz7e@gondor.apana.org.au>
 <20200211192118.GA24059@Red>
 <20200212020628.7grnopgwm6shn3hi@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212020628.7grnopgwm6shn3hi@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 10:06:28AM +0800, Herbert Xu wrote:
> On Tue, Feb 11, 2020 at 08:21:18PM +0100, Corentin Labbe wrote:
> > 
> > Do you mean that I should abandon ahash as a fallback ?
> 
> Perhaps switching to shash is not as straightforward because of
> SG handling.  But if you're getting problems with statesize
> perhaps at least force a sync ahash algorithm might be a good
> idea.
> 

I just found the problem, it happen with ARM CE which has a bigger state_size (sha256_ce_state) of 4bytes.

Since my driver didnt use statesize at all, I detect this on cra_init() like this:
if (algt->alg.hash.halg.statesize < crypto_ahash_statesize(op->fallback_tfm))
	algt->alg.hash.halg.statesize = crypto_ahash_statesize(op->fallback_tfm);

Regards
