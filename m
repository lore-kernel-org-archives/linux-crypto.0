Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AC6C38142
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 04:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjASEpQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Jan 2023 23:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjASEnU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2023 23:43:20 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286076FFA8
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 20:40:47 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 6248F3200934;
        Wed, 18 Jan 2023 23:39:04 -0500 (EST)
Received: from imap50 ([10.202.2.100])
  by compute6.internal (MEProxy); Wed, 18 Jan 2023 23:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674103143; x=1674189543; bh=G/hJoNUFWj
        tKbalV91EsTE4kaSD2XXRJqsp9xGH9tiw=; b=wtktud6v0QuSAM++KqtlJ9JymT
        urABw/YuHkM2OhkzRthap85AiAieCN54YO4ZtQsZCxfSmI2o/AF2MAkBePGO2+de
        pwC9ioWzW1H98M+gbRDrVeLuwzSI3fcNpAhtlLWjbcWTQ5/BdMiENx9nArF2rsBm
        Ijmm8KYhTrBEFmGoT29s/qgbjRIT4SZy2+pFk+M8Q2dt/L2rJ21QLqrMPm288IPz
        d8eRT9ApF31BGh4q+EjPKJstxMBCSBTobxHzxgGN/pQd5y202e6MUe3WxEbsxsvF
        +Gn6bbhTx2mgBJ1nCSebTM1m0DUiDrRQjE4AwHmf9yZfQ2Q2bvqaEBvzObiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674103143; x=1674189543; bh=G/hJoNUFWjtKbalV91EsTE4kaSD2
        XXRJqsp9xGH9tiw=; b=B7iVNBklJB13VVobFHkHlDLx1pqF+CQFpIgiNTJxnekV
        bCCITs7+Q+QuTUrfIYxrQyhSY7uuj7BS0/mWQdimNfijRjPbXUCg35hab6qsta7Z
        4raBCnnYZVirIEZpAYDV1qGaTfY7zUHWUDE3SDaDgY1UiNTWxwa2SSyRCBzD8zj8
        1SYAQxqsav/FlQNy49DX5xzpuA30Rn2YSFNOrns7HvYC1pSF4AGdJFFZTEA08qd/
        M/dKMzb+0/btvCc3xe5JxqWZnuY6O+lXMcQIda2oo6E/RDnsyoQc/Cmpnyzzlu1g
        2PxlzbOkHfb0+Jh7Di5FrD7Xx8epIzNwaQZRdUE9LQ==
X-ME-Sender: <xms:ZsnIY6Td5QBJTyIjLl35IK4HLl7nZIJbXDfwns4EAz9VAarYaIYUjQ>
    <xme:ZsnIY_zSJrpf_Xu3v6QlGJRgwFepOUrDThb0ELSAXKS1NYkwutUjr4oHwo8bXTJ5D
    TOwXaSIpdhlMF2URg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtledgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehn
    ughrvgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucggtf
    frrghtthgvrhhnpeekvdekjeekgfejudffteetgeejkeetteduvedtffdtledutdfhheev
    feetkeeiteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvfiesrghjrdhiugdrrghu
X-ME-Proxy: <xmx:ZsnIY32VxiOVv7Z9qwJZwy5AfFAnF0_kTfLJtinqJSCYGEG4Q39rlA>
    <xmx:ZsnIY2Bg-x94GPXSajk-r9GO2IEBPOaStSeoHSQbsNFRXCZAuhFg7w>
    <xmx:ZsnIYzgNYsvzR2WJWh532vdSoXEZBm1H1QIxkWlHIICjgS5ipycuEQ>
    <xmx:Z8nIY2uJvIvhRZy6F3nSJJkzebeJ4rjJU5YTELdMq4AhBOYzJxXMbA>
Feedback-ID: idfb84289:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 742831700089; Wed, 18 Jan 2023 23:39:02 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <e4832133-962b-4825-83ac-d99e26a8bdd5@app.fastmail.com>
In-Reply-To: <20230119014859.1900136-1-yangyingliang@huawei.com>
References: <20230119014859.1900136-1-yangyingliang@huawei.com>
Date:   Thu, 19 Jan 2023 15:08:42 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Yang Yingliang" <yangyingliang@huawei.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org
Cc:     neal_liu@aspeedtech.com, "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: aspeed: change aspeed_acry_akcipher_algs to static
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Thu, 19 Jan 2023, at 12:18, Yang Yingliang wrote:
> aspeed_acry_akcipher_algs is only used in aspeed-acry.c now,
> change it to static.

Acked-by: Andrew Jeffery <andrew@aj.id.au>
