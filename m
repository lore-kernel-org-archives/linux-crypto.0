Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0716CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 13:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCAB421872
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 13:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjeQJN5+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbfJVNWS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 09:22:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43104 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfJVNWS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 09:22:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so12814988wrr.10;
        Tue, 22 Oct 2019 06:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2fkOFNYm57+Sdwo0Ah8rCzDENCbmy1bQKtTOdjuKRbo=;
        b=KjeQJN5+15TjqUNjpLnGaTFqiE44NRgay2oSkXkt/cNofXfkuD33jYsk1EmeV4RRD6
         ET5KtpIwMagN+onrbT+TGylsbGwzhpY/jtsq+GxzN9mYDeaJO4IpSCqwv3pZdNZaWnzf
         ylG1BOUYOcvDhAyWJb8AQnbGJGGnrnB79CKqmHGo0D9H1IlJaBs9v6avY3gGznVBVrZP
         cI8YR+xt0Rmg8EEeEX7kUMOOGAtT+GRofZ98GHIkTlQgi3TCuRdkqFhSDhrIOAR0euzY
         XvDqSEASCICzYYxg4+rKne09K6u7Ji/ONmW6MJfNt5PmG7akTG3FqQH4rnl2BC/JRiyT
         9dhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2fkOFNYm57+Sdwo0Ah8rCzDENCbmy1bQKtTOdjuKRbo=;
        b=bLgxu/1dFKrUAWZYZxF6JtrUDQTDaGIXDhIWgTHJQy6vqbjDPhS7nARdzF4WC8T+3h
         zmNhGtLNSO1BF14r3AvtcDeps9xA7YlD8jgwO8ln8Efj3WiLf6b0rrhc/0EXru3av9Xl
         ip2TicJ4QGCfk5c0pl41Q5YuVt4KWr9iYfLIZAK5cNcRWWOP0LTqOTTAXPesvtyKAhYK
         Kjfl6ZdmyPwp3zckQei9MQfpV1PXlHOj4lYilsh81u/saOZvxQR0Edx933G+XgVQGCsl
         QqBih4V2Tftck90LmMp3OyK33oFI6nBSysgkk064k2kTzLRjHtjO8OE/58kshrXKk6s0
         l0RQ==
X-Gm-Message-State: APjAAAUC1yrJ9tMuKYvObCBNLSGHKsNOsesM4Aytqe8q2txRsyIGSTtB
        SKuDqO2SfnWmgE/7lMU3jpM=
X-Google-Smtp-Source: APXvYqw+Y61pf79cn2uA3pPa8HaYl+Fo6rfUnWH7IL7oi83j9v2VMO5HRwd8uenDTPCRfIrkqKNykg==
X-Received: by 2002:a5d:6785:: with SMTP id v5mr3490121wru.174.1571750535358;
        Tue, 22 Oct 2019 06:22:15 -0700 (PDT)
Received: from Red (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id p17sm14813947wrn.4.2019.10.22.06.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 06:22:14 -0700 (PDT)
Date:   Tue, 22 Oct 2019 15:22:12 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, kbuild-all@lists.01.org,
        catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 02/11] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20191022132212.GA28813@Red>
References: <20191012184852.28329-3-clabbe.montjoie@gmail.com>
 <20191022092312.GC10833@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022092312.GC10833@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 22, 2019 at 12:23:12PM +0300, Dan Carpenter wrote:
> Hi Corentin,
> 
> url:    https://github.com/0day-ci/linux/commits/Corentin-Labbe/crypto-add-sun8i-ce-driver-for-Allwinner-crypto-engine/20191014-104401
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:371 sun8i_ce_allocate_chanlist() error: uninitialized symbol 'err'.
> 
> # https://github.com/0day-ci/linux/commit/f113059e7b4f94c545994aeafdc809a3e4907ae4
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout f113059e7b4f94c545994aeafdc809a3e4907ae4
> vim +/err +371 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> 
> f113059e7b4f94 Corentin Labbe 2019-10-12  334  static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
> f113059e7b4f94 Corentin Labbe 2019-10-12  335  {
> f113059e7b4f94 Corentin Labbe 2019-10-12  336  	int i, err;
> f113059e7b4f94 Corentin Labbe 2019-10-12  337  
> f113059e7b4f94 Corentin Labbe 2019-10-12  338  	ce->chanlist = devm_kcalloc(ce->dev, MAXFLOW,
> f113059e7b4f94 Corentin Labbe 2019-10-12  339  				    sizeof(struct sun8i_ce_flow), GFP_KERNEL);
> f113059e7b4f94 Corentin Labbe 2019-10-12  340  	if (!ce->chanlist)
> f113059e7b4f94 Corentin Labbe 2019-10-12  341  		return -ENOMEM;
> f113059e7b4f94 Corentin Labbe 2019-10-12  342  
> f113059e7b4f94 Corentin Labbe 2019-10-12  343  	for (i = 0; i < MAXFLOW; i++) {
> f113059e7b4f94 Corentin Labbe 2019-10-12  344  		init_completion(&ce->chanlist[i].complete);
> f113059e7b4f94 Corentin Labbe 2019-10-12  345  
> f113059e7b4f94 Corentin Labbe 2019-10-12  346  		ce->chanlist[i].engine = crypto_engine_alloc_init(ce->dev, true);
> f113059e7b4f94 Corentin Labbe 2019-10-12  347  		if (!ce->chanlist[i].engine) {
> f113059e7b4f94 Corentin Labbe 2019-10-12  348  			dev_err(ce->dev, "Cannot allocate engine\n");
> f113059e7b4f94 Corentin Labbe 2019-10-12  349  			i--;
> f113059e7b4f94 Corentin Labbe 2019-10-12  350  			goto error_engine;
> 
> err = -ENOMEM;
> 
> f113059e7b4f94 Corentin Labbe 2019-10-12  351  		}
> f113059e7b4f94 Corentin Labbe 2019-10-12  352  		err = crypto_engine_start(ce->chanlist[i].engine);
> f113059e7b4f94 Corentin Labbe 2019-10-12  353  		if (err) {
> f113059e7b4f94 Corentin Labbe 2019-10-12  354  			dev_err(ce->dev, "Cannot start engine\n");
> f113059e7b4f94 Corentin Labbe 2019-10-12  355  			goto error_engine;
> f113059e7b4f94 Corentin Labbe 2019-10-12  356  		}
> f113059e7b4f94 Corentin Labbe 2019-10-12  357  		ce->chanlist[i].tl = dma_alloc_coherent(ce->dev,
> f113059e7b4f94 Corentin Labbe 2019-10-12  358  							sizeof(struct ce_task),
> f113059e7b4f94 Corentin Labbe 2019-10-12  359  							&ce->chanlist[i].t_phy,
> f113059e7b4f94 Corentin Labbe 2019-10-12  360  							GFP_KERNEL);
> f113059e7b4f94 Corentin Labbe 2019-10-12  361  		if (!ce->chanlist[i].tl) {
> f113059e7b4f94 Corentin Labbe 2019-10-12  362  			dev_err(ce->dev, "Cannot get DMA memory for task %d\n",
> f113059e7b4f94 Corentin Labbe 2019-10-12  363  				i);
> f113059e7b4f94 Corentin Labbe 2019-10-12  364  			err = -ENOMEM;
> f113059e7b4f94 Corentin Labbe 2019-10-12  365  			goto error_engine;
> f113059e7b4f94 Corentin Labbe 2019-10-12  366  		}
> f113059e7b4f94 Corentin Labbe 2019-10-12  367  	}
> f113059e7b4f94 Corentin Labbe 2019-10-12  368  	return 0;
> f113059e7b4f94 Corentin Labbe 2019-10-12  369  error_engine:
> f113059e7b4f94 Corentin Labbe 2019-10-12  370  	sun8i_ce_free_chanlist(ce, i);
> f113059e7b4f94 Corentin Labbe 2019-10-12 @371  	return err;
> f113059e7b4f94 Corentin Labbe 2019-10-12  372  }
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

fixed.

Thanks
