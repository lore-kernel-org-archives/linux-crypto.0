Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD55C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD91208FE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgGCEOn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:14:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40062 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEOn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 00:14:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jrD60-0007hS-S2; Fri, 03 Jul 2020 14:14:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2020 14:14:40 +1000
Date:   Fri, 3 Jul 2020 14:14:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/5] crypto:hisilicon/sec2 - update busy processing logic
Message-ID: <20200703041440.GA7858@gondor.apana.org.au>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
 <1593167529-22463-3-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593167529-22463-3-git-send-email-liulongfang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 26, 2020 at 06:32:06PM +0800, Longfang Liu wrote:
> From: Kai Ye <yekai13@huawei.com>
> 
> As before, if a SEC queue is at the 'fake busy' status,
> the request with a 'fake busy' flag will be sent into hardware
> and the sending function returns busy. After the request is
> finished, SEC driver's call back will identify the 'fake busy' flag,
> and notifies the user that hardware is not busy now by calling
> user's call back function.
> 
> Now, a request sent into busy hardware will be cached in the
> SEC queue's backlog, return '-EBUSY' to user.
> After the request being finished, the cached requests will
> be processed in the call back function. to notify the
> corresponding user that SEC queue can process more requests.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Why does this driver not take MAY_BACKLOG into account?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
