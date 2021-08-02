Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34080C4338F
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Aug 2021 18:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBBE610A8
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Aug 2021 18:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhHBS1W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhHBS1U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Aug 2021 14:27:20 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0731EC06175F;
        Mon,  2 Aug 2021 11:27:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so535080wmg.4;
        Mon, 02 Aug 2021 11:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DTKhTm7Ptg33LCmAo/w+iCwbuM4MPLTXMtIM7VJDESs=;
        b=XSipToRaSYK8r/yD7Y2zbkP6xbYJje+aooSF0mhT0oVLuyaMKIePaSg1zx3ZCe8RbB
         kS/zCjZ24853zmMTLuE+JMDuQ/seXGbLPh0BYIj1AbbbudTfAOnPO6ATTr7ruQfi+OuM
         harDKQpcKQdzKJlIfCjqbcDlDmVI84AYKvIHQ6fBG1BqnTk9jUMbtVQz8WKzaUCLLnS5
         nFZw1RzFeWCd7OfGppbdPpaBi5h2c7gjY6A8S8ngAC3APaD2+EAeXGDu/aZC/pgOSHhy
         rwdfCq5trcb1HvacEODObZ5X5WYYx3LmWsaJ+G/95MC4DAjT+LEDXrMOQNqVwTlJR9Dk
         mWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DTKhTm7Ptg33LCmAo/w+iCwbuM4MPLTXMtIM7VJDESs=;
        b=gXYOWXjju2U9okUmcWK0Rq/+GajPNVXpBSmQRNo1pF3fLJrA5RzZR/hy/2rET6ogdF
         iO0jQ8MDO4uQnfqccLYiTBQsVbbfHM0vOK7NwRiZE7G6F/LoRwMaATdP4eIWdQvCmCo5
         ORJbXURfxV4+4fSZuc5je/wgVoN3xuBGb1w1ku6Mv1tEVOfpT8R0CZLlTeq+mQ4Tm5X6
         TmIs6kiiR0SxWL6VhakQZlPxnVQjEtpyq4QKG5E/xNVAUm8iJDHiD3Uq0UlWeYUjnkbp
         oChG4Vj6Mu8P0YqCM/VNJGNzlcmDl3fxWZLIATOxXFdk7wHVMe1KL20gc5WZDDr88ekD
         zyIw==
X-Gm-Message-State: AOAM5305pnqaiP4T7tX+UHBjDmY4QXnub08fxf+rT3aDrwGyNNFDrpGz
        Ytt+GRo1oH3gQ04BGTHGVsg=
X-Google-Smtp-Source: ABdhPJymktIwUnfQLR4bmt28w5+VecVM+04e+/xdZY89WAq8zBoRUTO9t6fdiK4z/lEwUTGG2ZhK6A==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr18520297wmk.5.1627928828647;
        Mon, 02 Aug 2021 11:27:08 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id w5sm14025259wro.45.2021.08.02.11.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:27:08 -0700 (PDT)
Date:   Mon, 2 Aug 2021 20:27:06 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Eric Biggers <ebiggers@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: sun8i-ss: fix multiple memory leaks in
 sun8i_ss_hash_run
Message-ID: <YQg4+skrb9dxMgHw@Red>
References: <20210726152533.2281139-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726152533.2281139-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Jul 26, 2021 at 11:25:21PM +0800, Dongliang Mu a écrit :
> In sun8i_ss_hash_run, all the dma_mmap_sg/single will cause memory leak
> due to no corresponding unmap operation if errors happen.
> 
> Fix this by adding error handling part for all the dma_mmap_sg/single.
> 

Hello

I have nearly the same comment than on your sun8i-ce patch, (copy result only if err===0 and wording).

Regards
