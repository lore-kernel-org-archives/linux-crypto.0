Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA049EC8741
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Sep 2023 15:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbjIGPrf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Sep 2023 11:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbjIGPf1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2023 11:35:27 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A4199
        for <linux-crypto@vger.kernel.org>; Thu,  7 Sep 2023 08:34:58 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso18598491fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Sep 2023 08:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694100874; x=1694705674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JnMGoGgKemb+DDrSQzPTABi+a718THu1rk85qOkvFQg=;
        b=KZvML9EI4cmssrKbZTMiSwslTIFSGNg2WzfmYWQn3hTFuMMqGYWSYQncfn59e6yx2u
         VwMq4H42H7gza7HGMGHeQOViFNOx2T3yUk8qJVGI/p1gPsnott7XPs9Opdk9MhtZyJpW
         y5BroRrAoE2LL2/Bb9FSgIURKETSzn31XQ5U9aZ4zyTgSA90yfyqPSHGFbcAztT0TOAg
         JSXa4gorKepiB6Hgae4cb7gAk/JaYahVera7mN6YMAcXbmTWtfgflY/oQfqAD8sRg1Ga
         g624rIWobsMGFn4Z4ICs6HjoWWEJYJToDEqHk0c5b+BCuGoL4WP1zr2Ton23MGv/u1BO
         kvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100874; x=1694705674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnMGoGgKemb+DDrSQzPTABi+a718THu1rk85qOkvFQg=;
        b=DWjV8INS05YAIX8bCksnii+UA56aiZBvYhUBoOs0KQp+fk5fxP1l6vBIBt39ozfkzP
         9oTTHzU6DDdnvjAX2dU4vuBC3AtS2urDGOxruRXyl5ihicGJa9RmEUaE9YVeRsLL5G1P
         LHXIeZ0LV4tP2eiPIKfMFSGOcbgb2bsyfukPxPTL86Lzl6vjWbOOSaER1FF1LUTBbyrn
         sbdWjE8hQgd6ZJj9UIn1NRfVioYYCzOCCkzi5iWfdf5i/NAgZvjNlZBLzXilWkf23Lgt
         ezaXBxRdBz+ZEeTFB0pLsS0TAszK5z6qE0fpC/KirJrct4vgWJUePDHckBP5HPURL6bP
         W1cg==
X-Gm-Message-State: AOJu0Yy6qx6rR0GADzzSpx/ub+9eELmaX017quf1pqv9jZu1FAN294fE
        Cxkm/T6sZZVlieH/i9DyA7fkN0evWCjDVxIDbtw=
X-Google-Smtp-Source: AGHT+IGyPStu/4bGX3A398E8xixDQaUmGkOmIW0jf0T9gkQFvDYPcLVleJrm+vURQhH+rA2UwXThOQ==
X-Received: by 2002:a05:600c:2246:b0:401:c297:affb with SMTP id a6-20020a05600c224600b00401c297affbmr4284944wmm.37.1694085336903;
        Thu, 07 Sep 2023 04:15:36 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y10-20020a05600c364a00b00401b242e2e6sm2208451wmq.47.2023.09.07.04.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 04:15:36 -0700 (PDT)
Date:   Thu, 7 Sep 2023 14:15:33 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Longfang Liu <liulongfang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - Fix a erroneous check after
 snprintf()
Message-ID: <71bf9b84-462f-405e-91aa-fb21fc6ffbd5@moroto.mountain>
References: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
 <ZPaSCOX1F9b36rxV@gondor.apana.org.au>
 <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 05, 2023 at 07:27:47AM +0200, Marion & Christophe JAILLET wrote:
> > 
> > The other snprintf in the same file also looks suspect.
> 
> It looks correct to me.
> 
> And HPRE_DBGFS_VAL_MAX_LEN being 20, it doesn't really matter. The string
> can't be truncated with just a "%u\n".
> 

drivers/crypto/hisilicon/hpre/hpre_main.c
   884          ret = snprintf(tbuf, HPRE_DBGFS_VAL_MAX_LEN, "%u\n", val);
   885          return simple_read_from_buffer(buf, count, pos, tbuf, ret);

You can't pass the return value from snprintf() to simple_read_from_buffer().
Otherwise the snprintf() checking turned a sprintf() write overflow into
a read overflow, which is less bad but not ideal.  It needs to be
scnprintf().

regards,
dan carpenter

