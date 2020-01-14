Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E18DC33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 13:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB82214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 13:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="veQmBW9B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgANNx7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 08:53:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51933 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgANNx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 08:53:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so13861523wmd.1;
        Tue, 14 Jan 2020 05:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NG+zhbtnS25eEsQP2J1dL+HmOFUEElVQuvgkp4X4amQ=;
        b=veQmBW9BNI/uYnVnWk17UlaI7mThr5G1v8/RHR8cRChG9cNml5/AY2gRiy70xmgWWP
         ref+SQ1wixocTc0F0pIe0wBqJswcI4w13RqumQW59cFgOIMrG9lrXk4+sI5x7HGmG74H
         lFfM+QUyOzlGEcRsDN8TXNpt3DXrEg1yspZ8lGyomiY1Q11tqt4n7u1sns7A1P2MLlhg
         MIvVehDYRKfT3vAgG3VI7ZmjOcohxHFqbbmozYl6owCqSbyG3ck4doGgT81Lp+N3rjMT
         A1QN/4YwDb4ngtP/J7s9SFlREEo9uZA+AZM4dnE9nOQ9RVUxJs9GcI7eocT/cOs/M0yU
         jzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NG+zhbtnS25eEsQP2J1dL+HmOFUEElVQuvgkp4X4amQ=;
        b=b+BPK6LYv/8ohrC1fE0g8kWUFEnWSUzsQDcbWDsXAZDqhBNNFHwlLV8s2avgbLtZou
         Tsxe8M9qnhV1PT2UAgAAX//+F3LsXAmCSUBXddLWckslxZhWTsVIErh3wapwN40xYPEY
         1esSYyZ/6WP7BBB1zFewwZ6gnvYJmFEmHanye7iD7a3aqf04/4kOIpbPd5qovHnUvabh
         e4Aj2bDHeNDttRYr8FOFT/H70FwG4EecDFBaOhG5gE8eNYLfXHwlzCXNbyb9af7NOXrd
         wv4T0WHPEJLEq1YYKE3U+/FziEUfOPeUxTvibJ2bzHGWbB/wH/8mK3dIvtY8sXGOTu1M
         jWJg==
X-Gm-Message-State: APjAAAV4Z0Euq07xb8YAA+7eDAhoDj9ML7iXWcYgL1nI/ezZDFQyG3RC
        WKlpJ8BZQ3rS4QOOsFfV4znqJQ2t
X-Google-Smtp-Source: APXvYqwvBkG3giMIZMH3MRxfPsfX+B/DQjAwIiobVKBYBt9W1qAo4mYCcKKF5NhZNJ2HNpDms63rxA==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr28002839wmc.9.1579010037888;
        Tue, 14 Jan 2020 05:53:57 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id o1sm19708771wrn.84.2020.01.14.05.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:53:57 -0800 (PST)
Date:   Tue, 14 Jan 2020 14:53:54 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "baolin.wang@linaro.org" <baolin.wang@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>
Subject: Re: [PATCH v2 09/10] crypto: caam - add crypto_engine support for
 RSA algorithms
Message-ID: <20200114135354.GA3088@Red>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44452FF06F35075413CF87F88C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20200114001440.baeadihvlqiucw63@gondor.apana.org.au>
 <VI1PR04MB4445E44C69277F17CFBDB9128C340@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4445E44C69277F17CFBDB9128C340@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 14, 2020 at 10:40:53AM +0000, Iuliana Prodan wrote:
> On 1/14/2020 2:14 AM, Herbert Xu wrote:
> > On Mon, Jan 13, 2020 at 09:48:11AM +0000, Iuliana Prodan wrote:
> >>
> >> Regarding the transfer request to crypto-engine: if sending all requests
> >> to crypto-engine, multibuffer tests, for non-backlogging requests fail
> >> after only 10 requests, since crypto-engine queue has 10 entries.
> > 
> > That isn't right.  The crypto engine should never refuse to accept
> > a request 
> Crypto-engine accepts all request that have the backlog flag, the 
> non-backlog are accepted till the configured limit (of 10).
> 
> > unless the hardware queue is really full.  
> Crypto-engine doesn't check the status of hardware queue.
> The non-backlog requests are dropped after 10 entries.
> 
> > Perhaps the
> > crypto engine code needs to be fixed?
> To me, crypto-engine seems to be made for backlogged request, that's why 
> I'm sending the non-backlog directly to CAAM. The implicit serialization 
> of request in crypto-engine is the bottleneck.
> 
> But, as I said before, I want to update crypto-engine to set queue 
> length when initialize crypto-engine, and remove serialization of 
> requests in crypto-engine by adding knowledge about the underlying hw 
> accelerator (number of request that can be processed in parallel).
> I'll send a RFC with my proposal for crypto-engine enhancements.
> 
> But, until then, I would like to have a backlogging solution in CAAM driver.
> 

Hello

I have already something for queue length and processing in parallel.
I will send it soon.

Regards
