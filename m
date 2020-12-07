Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC9FC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442AF2311B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLGJNw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:13:52 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:33358 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLGJNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:13:52 -0500
Received: by mail-wr1-f48.google.com with SMTP id u12so12030739wrt.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lkqy8OBKU5TGmxLdkN14Q8Ydlt7LpwL8CUzQTPTbOHs=;
        b=aiap2F5qwxTMxkw9im+t7dEbMDYnGcriMPqWcdyG8/MCa9ymOVBjwSeI5qAxzc3I6a
         9a4wUUNgfUaKFDZmjxsCJtYANc3ImwPXAEfTmbwrpjlGZEBiDqw8tzKYJoiXi5azB785
         /VGgpVb6Ds4Bj07OUhdpctqAjupdjnXKPsPgGuVCfjajdhfc7/y7Djureks209gkMAhJ
         nCqsjpIMSf/b5GmVniDxr0fdYu+2rC9CKYhfKBthfJLUOeS6mEsrL6DZO+OMX7RCWdHP
         fMuzjV8dh0tCwDBQPKvfi9y8c5dZC47pEPw+Tx53uYuzeztdHqYZ4Dd6CIOFDTP5bW/n
         SXGQ==
X-Gm-Message-State: AOAM530J4xXSSsxqD6dfn6Da0JRFsCuefwU06PD2oQj2RjE8IHcoI6hO
        vnu3fwMFMLbDCu9np6bd6TI=
X-Google-Smtp-Source: ABdhPJwbXp8yWVijnt7i4AFul4hP+s1MHCw4M5S9D65o7RuBZv+VFwM5vJE6pZA2ZQNvcxiBs1kHEg==
X-Received: by 2002:a05:6000:1088:: with SMTP id y8mr19168915wrw.251.1607332393287;
        Mon, 07 Dec 2020 01:13:13 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id a144sm14119020wmd.47.2020.12.07.01.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:13:12 -0800 (PST)
Date:   Mon, 7 Dec 2020 10:13:10 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, jesper.nilsson@axis.com,
        lars.persson@axis.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, heiko@sntech.de, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: Re: [RESEND 00/19] crypto: convert tasklets to use new tasklet_setup
 API()
Message-ID: <20201207091310.GA13333@kozik-lap>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 07, 2020 at 02:29:12PM +0530, Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the crypto modules to use the new tasklet_setup() API

Please use the scripts/get_maintainers.pl to get the list of necessary
discussion lists to Cc. You skipped several of them.

Best regards,
Krzysztof
