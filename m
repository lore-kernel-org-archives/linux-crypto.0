Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE25C636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A21613C4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGQGLn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 02:11:43 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45764 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhGQGLn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 02:11:43 -0400
Received: by mail-pg1-f182.google.com with SMTP id y17so12111910pgf.12
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 23:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7bkGk4qd8BNFUCpN1SnNG/l355L+MGvYUKumYDjE4Nc=;
        b=HxXDQkdXXdn4HO/lklNDU2L8Wg0HtEIJAINLw2EUtpndg3dBqXn69ll45QtNpFa+/X
         insKEkgKBOyZaEq8jIxLqHxUBYsB0jK5wmS15a7xjEEahZ2L2/vC0WjFSJXr9LhbhVWs
         d/AjkwIlSd4vNSPnv/qNdsm4TWq/pyjouK6YYPJr3H+EhY+eZGCo1alj6OUMxlrQ9VEo
         JuxEYVX09Us83e+pZ1ubO8oSvDUEuDr7aSy/qdjp4PH+/wHMaItAFHnecTuwdHtPaqmh
         iCrsGxjTy0kxEC2nkjrAEsMr5hGaKoW2kg14+II4yyD2pWkONxDSPQIbYBSc8ddNsbFW
         aVUw==
X-Gm-Message-State: AOAM533xgtN/fda5wBV3bHJgLERtp+xe3cy/cPgvBCUKenQc7cMdHM4V
        UkGljAZ8PtD7vwWyg1b8PUug9hxgbCw=
X-Google-Smtp-Source: ABdhPJzCaMC36xCcGaYRuo2yGZ1H6SVDV4ieMjYhkrLdDl/e4oTd6GzAYgTfBv1b1uPa+P+dmiZdLQ==
X-Received: by 2002:a63:5b51:: with SMTP id l17mr13439310pgm.408.1626502125967;
        Fri, 16 Jul 2021 23:08:45 -0700 (PDT)
Received: from [10.0.0.146] ([162.211.128.122])
        by smtp.gmail.com with ESMTPSA id u6sm11996770pfn.31.2021.07.16.23.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 23:08:45 -0700 (PDT)
Subject: Re: [PATCH 02/11] crypto: add crypto_has_kpp()
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-3-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f587a3f7-c516-9461-7cf9-2873fdb28029@grimberg.me>
Date:   Fri, 16 Jul 2021 23:08:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Add helper function to determine if a given key-agreement protocol primitive is supported.

Same comment.
