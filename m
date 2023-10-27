Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5853FC25B47
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbjJ0KzP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345696AbjJ0KzO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:55:14 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9D69C
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:55:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKUd-00BebO-E5; Fri, 27 Oct 2023 18:55:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:55:13 +0800
Date:   Fri, 27 Oct 2023 18:55:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] crypto: qat - fix deadlock in backlog processing
Message-ID: <ZTuXERoS/ssVSth5@gondor.apana.org.au>
References: <20231020153330.70845-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020153330.70845-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 04:33:21PM +0100, Giovanni Cabiddu wrote:
> If a request has the flag CRYPTO_TFM_REQ_MAY_BACKLOG set, the function
> qat_alg_send_message_maybacklog(), enqueues it in a backlog list if
> either (1) there is already at least one request in the backlog list, or
> (2) the HW ring is nearly full or (3) the enqueue to the HW ring fails.
> If an interrupt occurs right before the lock in qat_alg_backlog_req() is
> taken and the backlog queue is being emptied, then there is no request
> in the HW queues that can trigger a subsequent interrupt that can clear
> the backlog queue. In addition subsequent requests are enqueued to the
> backlog list and not sent to the hardware.
> 
> Fix it by holding the lock while taking the decision if the request
> needs to be included in the backlog queue or not. This synchronizes the
> flow with the interrupt handler that drains the backlog queue.
> 
> For performance reasons, the logic has been changed to try to enqueue
> first without holding the lock.
> 
> Fixes: 386823839732 ("crypto: qat - add backlog mechanism")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com/T/
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_common/qat_algs_send.c      | 46 ++++++++++---------
>  1 file changed, 25 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
