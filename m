Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D176C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422DE218DE
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rgnOU8GR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391240AbfIGRzk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 13:55:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56132 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391150AbfIGRzk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 13:55:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id g207so9528272wmg.5;
        Sat, 07 Sep 2019 10:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3wpNe8V3UrhAI6XklnxJ3sJ6UGQlN9isQ2mYokQ0hG8=;
        b=rgnOU8GR1wP/gPWZ9q1A7NP1pe8gXPcpsG3QiGf8k3zTaO8laKW5QM1WujYDqhAETc
         1FYvt4fQ80P4SmepTW8Bop8cNdYYBt811EWdn3CJRAJJA1K0FaM4TdCL4YFtvmZZLqSo
         wZzqTQN1VQa0nKp/cGU5fotA70aHocW31OR574oEMX5mrVjyaVSf1HQ6wKYj+NGEhReC
         3gNlQc9aWhmoKuR82NrxMcmkbmz+ua7b1tkJOgbGPKmjUHIqJUgdxoF4zCgoXfygb2ua
         Bi+FX9zk9t6xmDb061ZRtPHE17vqXtIhuZh8dXSMZnT8u6mhMlbIzvsy9ZWCoOGc5TEW
         MXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3wpNe8V3UrhAI6XklnxJ3sJ6UGQlN9isQ2mYokQ0hG8=;
        b=W5+3ovBmVxcMq8RtVEUMku8r8Mphner3nhVY1JzHhIlm5oxGuwb1xqDJ8d+OYMiyCm
         1jJed4JxsvoSwVpZp8AfScdMGPc2TxFa+0SxFH/rte4YQvO/AV/QKRpF2TrPrZf9INLd
         b68+FrQRs6t3FBtmXZESpB85XG1ZF3pFkbtQZQpBO2cGzU0Myql2xM9MdUnYOoE20T4G
         6uZlVZ0lpLauadQ8EVG19t0XqJokntoHB4Wb2gSGxl03vkMoTLaJgvJduUHGvjDC/gB5
         dqJ9EL/d/TQqRkyUChqVAFjGCmxUqhcUXC0Gr8oUsFMkOwFaLTrLJYYURw/pGpz6S0Hr
         ZTmg==
X-Gm-Message-State: APjAAAVSl7cyq5sdrmH1d3kqXoKwq1oXBbt7lAz9RwE15+Vo3mf7jnR4
        zOCoJ4fMcngykhl1QYZSobA=
X-Google-Smtp-Source: APXvYqwlrwfx0Is+/JNRJMqvpbryoTm/JZ4/crdni7AQFg+tmOyjJefUlXUedDWZ9ZJEL2WOztVGTg==
X-Received: by 2002:a7b:ca50:: with SMTP id m16mr11529116wml.158.1567878938197;
        Sat, 07 Sep 2019 10:55:38 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id e15sm7279930wru.93.2019.09.07.10.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:55:37 -0700 (PDT)
Date:   Sat, 7 Sep 2019 19:55:35 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 9/9] sunxi_defconfig: add new crypto options
Message-ID: <20190907175535.GD2628@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-10-clabbe.montjoie@gmail.com>
 <20190907040353.hrz7gmqgzpfpo4xj@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907040353.hrz7gmqgzpfpo4xj@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 07:03:53AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:51PM +0200, Corentin Labbe wrote:
> > This patch adds the new allwinner crypto configs to sunxi_defconfig
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/configs/sunxi_defconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Can you also enable it in arm64's defconfig as a module?
> 

Will do.

Regards
