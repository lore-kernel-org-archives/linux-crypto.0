Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D863EC432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 13:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46562075E
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 13:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qvnz8pZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfKRN3W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:29:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44044 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfKRN3W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 08:29:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id f2so19480077wrs.11;
        Mon, 18 Nov 2019 05:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8osjcwWvY0zz86UuIZgqqzTKQwU2ZYyVR7mUngwKghg=;
        b=Qvnz8pZ2bxDTMmqMrE3YbOjWBOqm2MbW3GQpr+XGbQ3E9ly0apG4Yj+hflOiKaxefW
         KfGPpldOW3h/gAuo5YlW6q+FM4j1e2sFbaKpRuWIEi/ETtz/X4MuSgTuksT1EHoxgtQ5
         X11dWzLKPoZ29Ei3YlSB0uOmkbrA1+A/dbitCmH5vWsI9r//L1D9C4xH4sbTiA9UwBit
         DgwoxdBCQW+ssdpVizk6HJxkbhXnkvfKyBHdb5hBQlb8zFlZ+7dBpSsuJf01iaZ4Tt0y
         uNw5sHslRr4dri61Q/MtzABRO8OS0RuaFzhOx6m9rA4v5tQdFKeCPBrQQgCmM6f1sRUS
         V19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8osjcwWvY0zz86UuIZgqqzTKQwU2ZYyVR7mUngwKghg=;
        b=oNC78U4w0MjUqUETQScMILwI5qZANJE5+/3k5QY1Qhi3+xWIv/pqJcRWosEP96juiT
         mOfCd8f2AJpTsi+OKJiOBQb7M7FpegvrqXrr6yVnMy9IjNe6bBXWM1zYv+SzOab5U7KB
         Xx5MBhmdxLbwDMlhMA6LgoBnqPPFIurUNyr3NUwkjOEFEMSgCjYZDF/6BRX/8kMYxLTA
         Q+jXff2572181iVK8WPxaoWhjOCbH+V+zCA1cyvyjKXQLLrnUpuKKGB7f0io3InaLhqW
         LawlasvvdtLYfoXVcaYK9kz/mkHTjWMIexGWH/COQfgXFz3zhp3inpAjPvdc1kNchOib
         /dSA==
X-Gm-Message-State: APjAAAUcdZRgzBcVFXCBdpLw71O76UmF6Q6X67cX189ju6MSwLHHdmwd
        BygQ4gz237zJyTnllZqziIs=
X-Google-Smtp-Source: APXvYqxNYppGHBpjJP8qEkiGIMD1UizcuydpS5llBmTrRKOHE+SftKv0mF/fIrbx/brH9a0/+5/m6A==
X-Received: by 2002:adf:ab41:: with SMTP id r1mr32266347wrc.281.1574083760440;
        Mon, 18 Nov 2019 05:29:20 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 16sm24326334wmf.0.2019.11.18.05.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:29:19 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:29:17 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 01/12] crypto: add helper function for akcipher_request
Message-ID: <20191118132917.GA831@Red>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 18, 2019 at 12:30:34AM +0200, Iuliana Prodan wrote:
> Add akcipher_request_cast function to get an akcipher_request struct from
> a crypto_async_request struct.
> 
> Remove this function from ccp driver.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-rsa.c | 6 ------
>  include/crypto/akcipher.h           | 6 ++++++
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 

I need (and did) the same for future sun8i-ss/sun8i-ce RSA support.
Thanks

Reviewed-by: Corentin Labbe <clabbe.montjoie@gmail.com>
