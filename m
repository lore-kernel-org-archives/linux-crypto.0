Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EA6C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 20:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A4B620C09
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 20:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbgFSUEB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jun 2020 16:04:01 -0400
Received: from ms.lwn.net ([45.79.88.28]:55534 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389021AbgFSUEB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jun 2020 16:04:01 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 888B02CD;
        Fri, 19 Jun 2020 20:04:00 +0000 (UTC)
Date:   Fri, 19 Jun 2020 14:03:59 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 03/22] docs: crypto: convert asymmetric-keys.txt to ReST
Message-ID: <20200619140359.47a45e6b@lwn.net>
In-Reply-To: <c2275ea94e0507a01b020ab66dfa824d8b1c2545.1592203650.git.mchehab+huawei@kernel.org>
References: <cover.1592203650.git.mchehab+huawei@kernel.org>
        <c2275ea94e0507a01b020ab66dfa824d8b1c2545.1592203650.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 15 Jun 2020 08:50:08 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This file is almost compatible with ReST. Just minor changes
> were needed:
> 
> - Adjust document and titles markups;
> - Adjust numbered list markups;
> - Add a comments markup for the Contents section;
> - Add markups for literal blocks.
> 
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Applied, thanks.

jon
