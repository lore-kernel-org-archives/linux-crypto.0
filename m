Return-Path: <SRS0=0P/0=DF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEFDC4346E
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 01:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEA023A34
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 01:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3emFgsM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgI1Bm2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Sep 2020 21:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgI1Bm2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Sep 2020 21:42:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19038C0613CE;
        Sun, 27 Sep 2020 18:42:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b17so2638410pji.1;
        Sun, 27 Sep 2020 18:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8dvvyKbSOAlgek5cc8aTLapz1pd13ZzkOFYmkcPpkd4=;
        b=h3emFgsM6piZBSbVf/atrjx/QFGhrpigxWKDnEpPikiSAGfjadQfqVz7D8L3eS1dIC
         Ey2CLiD8B6GZ5sHxpEL1WSHrTIxbPE6FF+kihoC4bFXe9pD0c7/xb81xoNcFQ7JWW43m
         k4RA027NJeoR4FN/o9aerkgGpOgzFUgLkpZsW9TWOqe/Er/dIfsJ/Bi0fzCzV0u6ITqj
         oGJGU8CGwncW7ZDruv3kVi7hd1P0n3LnyhvSO2SE2pJnBFgeo/InooYzPva5S7l0HDDU
         vI2xqbKA7vHhl00a6SHlCBComY5Ra+G2i8Dp4J8xPyo37v/2lOfdzwuqXUi+lbHMmCp/
         hpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8dvvyKbSOAlgek5cc8aTLapz1pd13ZzkOFYmkcPpkd4=;
        b=hBA37+ddGtNqTJGd6nctGw0M+vtUl/GcjUOzIGV5DfqyPKYBDXKcJrN4ag1Tleoikl
         X5RfJA52Qh56b0xo1btNQZL6lDJjvQty98cXFe41haPcbHytnsQxHD44Qi9pjpIkeVVq
         O1WtIethlTa7rJvVYKS8xw9DS4fMuGSh4D2dA/Kj8iSrhEr86agGrztvX19j/vd8y45b
         sqrqveyI9QL2XmvK9fyDhfzh4KLOLaYBiHuFtMnOILUy4dTBvgJDHLd+TL00QkG3bKlF
         zaznQ6yDhukI/CJ4+simNSBFbe9z/o6dTe/fg526UsfeNr0WguZQ/DsbqxHt0Few+Oix
         fVCA==
X-Gm-Message-State: AOAM533kvl66oVTb3ZBKuuHYk8wigcVC1pGuW5tow/bROrCL6e/yyJGs
        ipdA7yDElUQSO0FDu8vuj6IealVg7NAFKA==
X-Google-Smtp-Source: ABdhPJzygoBiYd6Buh+m4UHKonvhgMi2Rfn3a5kRAQQZ789YxIOvdyRD484gZNpKzOR92zhQM9IpKA==
X-Received: by 2002:a17:90a:ca03:: with SMTP id x3mr7366766pjt.92.1601257362214;
        Sun, 27 Sep 2020 18:42:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ev19sm4932293pjb.42.2020.09.27.18.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 18:42:41 -0700 (PDT)
Subject: Re: [PATCH 06/18] hwrng: iproc-rng200 - use semicolons rather than
 commas to separate statements
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Matt Mackall <mpm@selenic.com>
Cc:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
 <1601233948-11629-7-git-send-email-Julia.Lawall@inria.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <793939ba-520a-8041-b3c7-20900a21f308@gmail.com>
Date:   Sun, 27 Sep 2020 18:42:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1601233948-11629-7-git-send-email-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/27/2020 12:12 PM, Julia Lawall wrote:
> Replace commas with semicolons.  What is done is essentially described by
> the following Coccinelle semantic patch (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> @@ expression e1,e2; @@
> e1
> -,
> +;
> e2
> ... when any
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
