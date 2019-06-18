Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5941C31E5E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 12:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF01E2084D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 12:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFRMfO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 08:35:14 -0400
Received: from ozlabs.org ([203.11.71.1]:33411 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfFRMfO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 08:35:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Snbh1HPKz9sDX;
        Tue, 18 Jun 2019 22:35:12 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Haren Myneni <haren@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
In-Reply-To: <1560587942.17547.18.camel@hbabu-laptop>
References: <1560587942.17547.18.camel@hbabu-laptop>
Date:   Tue, 18 Jun 2019 22:35:05 +1000
Message-ID: <87ef3royva.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Haren Myneni <haren@linux.vnet.ibm.com> writes:
>     
> System gets checkstop if RxFIFO overruns with more requests than the
> maximum possible number of CRBs in FIFO at the same time. So find max
> CRBs from FIFO size and set it to receive window credits.
>    
> CC: stable@vger.kernel.org # v4.14+
> Signed-off-by:Haren Myneni <haren@us.ibm.com>

It's helpful to mention the actual commit that's fixed, so that people
with backports can join things up, so should that be:

  Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")

???

cheers

> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index 4acbc47..e78ff5c 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -27,8 +27,6 @@
>  #define WORKMEM_ALIGN	(CRB_ALIGN)
>  #define CSB_WAIT_MAX	(5000) /* ms */
>  #define VAS_RETRIES	(10)
> -/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
> -#define MAX_CREDITS_PER_RXFIFO	(1024)
>  
>  struct nx842_workmem {
>  	/* Below fields must be properly aligned */
> @@ -812,7 +810,11 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
>  	rxattr.lnotify_lpid = lpid;
>  	rxattr.lnotify_pid = pid;
>  	rxattr.lnotify_tid = tid;
> -	rxattr.wcreds_max = MAX_CREDITS_PER_RXFIFO;
> +	/*
> +	 * Maximum RX window credits can not be more than #CRBs in
> +	 * RxFIFO. Otherwise, can get checkstop if RxFIFO overruns.
> +	 */
> +	rxattr.wcreds_max = fifo_size / CRB_SIZE;
>  
>  	/*
>  	 * Open a VAS receice window which is used to configure RxFIFO
