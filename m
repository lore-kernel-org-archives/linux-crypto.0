Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BDAC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1264F20650
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rXxBW2sQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKLJfc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 04:35:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42932 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLJfc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 04:35:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so17655103wrf.9
        for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2019 01:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oaj1E/kv5TLb76cZYS6U6PoCB07whC/O3d8mIn1w4YM=;
        b=rXxBW2sQnIxizld2YMECZrm2rE70o/bvTIHFjYU75H1Tf3xMwvv5w0HkpEfNcSW32a
         /kngm3doeVG7wlCsenPhbJ7VzKjXkypsxJ/M5Bg8zYbcgMvpt0/o+m0sNfxkoRJh5zUO
         AGoA/nmBNaKx0iXXpTFFEMCY+2/nzkMgACWLk7y9lBXNjqrpNaXXPZSFsi8ZodZm6Wk4
         r1rVzzfESgLtXUGoySVnXt/fnZ1bc9sdZ6pm5Z/lfvzhQolKVqsSx/+VaG5SbSxgq898
         RDbb6wjCg4PDyDPul0XU7syFSLM8PvzrjMZ1kSvJPEHaPxS8FdNFMvi9b2L91jpyoKP9
         WFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oaj1E/kv5TLb76cZYS6U6PoCB07whC/O3d8mIn1w4YM=;
        b=ILxWmeTv87QstWN90kJn1KNj1ZACL6FAVVNO7wejgEQh/xLTTsccX24O9NiMitd48j
         L2tr6RP33eQCwKVwqeROnjnr0CGA8vb+45dKFuNcUKCi+yt6hDMrT6HwNWbfFWVCHEad
         4XjHwHbY8z42O6/EMxuyCKM7J2TTW361L54R0vUKAOxpLCOkyMHRJFvHWU3TDGYGDMVz
         q9OIfmdFlx5T7xbirl698+6HgAO7MGovFsadNOU5aTQae+S0JAnJrolQDMBpxMjtJMpe
         nS3kRZSUWB/AtBW4XJwGr2ykBNjmTm8lN/7QNPMhsDz19jeYoEywuDCUkwJL3asXWWFr
         mYTw==
X-Gm-Message-State: APjAAAWguPlWvM1li+mtxkY+5ArP788uyZeKdTItvqwFU/av0BSFMcxU
        82iuThbWcmI7c0U1QMIwd8jDb5iV
X-Google-Smtp-Source: APXvYqyZnGyXGi7XWpW5elk2WbW/BxrbjoB5cyIhArY3V8BC6SR0DlFIx4MS1SQ8Yf3gVLzgFQRlng==
X-Received: by 2002:adf:9323:: with SMTP id 32mr24361690wro.15.1573551329995;
        Tue, 12 Nov 2019 01:35:29 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u16sm19626625wrr.65.2019.11.12.01.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 01:35:29 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:35:27 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: sun4i-ss - Fix 64-bit size_t warnings
Message-ID: <20191112093527.GB18647@Red>
References: <20191112023834.l7mbyrlhhaxgpbdp@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112023834.l7mbyrlhhaxgpbdp@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 10:38:34AM +0800, Herbert Xu wrote:
> If you try to compile this driver on a 64-bit platform then you
> will get warnings because it mixes size_t with unsigned int which
> only works on 32-bit.
> 
> This patch fixes all of the warnings.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Hello

Note that the driver is within !64BIT, so that compiling on 64-bit should not be doable/an issue, but removing this conditionnal could be a good point.
Furthermore, I just tested compiling on 64BIT and there are the same warnings on sun4i-ss-hash.c.
I will send a subsequent patch for it.

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun7i-a20-cubieboard2
Tested-on: sun8i-a33-olinuxino
