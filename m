Return-Path: <SRS0=FTK2=EP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF10C388F7
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 10:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125FA207BC
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 10:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DkqJWn72";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kBMeCola"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgKIK3N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 05:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgKIK3N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 05:29:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F4C0613CF;
        Mon,  9 Nov 2020 02:29:12 -0800 (PST)
Date:   Mon, 9 Nov 2020 11:29:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604917750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXSfGPHblcxD6fRoSPhPSSHFsJUTblx0RZ8tFRLfhus=;
        b=DkqJWn72jRCdyw9uxzDjB+Lsv1iGa/AL0tJGQT51XDOa5/yv0Yo0PSxn+RprFoHPXenYs4
        7tEF4j+WmF92KO/7HTNbU3GnE/EhopTRrvoUYqZAmdY4pTMrG1JFoB/Q8vKTZN6ECiqzRL
        L0cuipHHmQQl/cu9Cn9bMGO8MvzzCxdCx1hfzMdH+/dwYmZN4aKgPynNFgcAJVaSPxa8VX
        TsNl8rniTpK0Fuoj94OjtxaxpNv/A0WNqIamWtanr1dVKJ6cX2e3DFTpJip73BpEz4TkoB
        Qt1x7N/ImlN/ZlK1QVSZTZ9aqaN+j2Jp2sXMULM9PzGaKIk1BfkVtj8R7EwtpA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604917750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXSfGPHblcxD6fRoSPhPSSHFsJUTblx0RZ8tFRLfhus=;
        b=kBMeColad+U3332dzsE7I9XTLjw2q7CtyaCiVgwtRZW/gmgaf4NNwhDqeGpOvZEl4sVt5L
        oqT22564Yk3ngPDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        akpm@linux-foundation.org, linuxarm@huawei.com,
        fanghao11@huawei.com, linux-kernel@vger.kernel.org,
        Vitaly Wool <vitalywool@gmail.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v7] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20201109102909.u34zzudqqng6nhg6@linutronix.de>
References: <20201107065332.26992-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201107065332.26992-1-song.bao.hua@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've been looking at the patch and it looks like it should work. Having
numbers to backup the performance in the pure-software version and with
HW acceleration would _very_ nice to have.

On 2020-11-07 19:53:32 [+1300], Barry Song wrote:
> index fbb7829..73f04de 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -415,30 +445,54 @@ static int zswap_dstmem_dead(unsigned int cpu)
=E2=80=A6
> +	acomp_ctx->req =3D req;
> +
> +	crypto_init_wait(&acomp_ctx->wait);
> +	/*
> +	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
> +	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> +	 * won't be called, crypto_wait_req() will return without blocking.
> +	 */
> +	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				   crypto_req_done, &acomp_ctx->wait);
> +
> +	acomp_ctx->mutex =3D per_cpu(zswap_mutex, cpu);
> +	acomp_ctx->dstmem =3D per_cpu(zswap_dstmem, cpu);

You added a comment here and there you never mentioned that this single
per-CPU mutex protects the per-CPU context (which you can have more than
one on a single CPU) and the scratch/dstmem which is one per-CPU. Of
course if you read the code you figure it out.
I still think that you should have a pool of memory and crypto contexts
which you can use instead of having them strictly per-CPU. The code is
fully preemptible and you may have multiple requests on the same CPU.
Yes, locking works but at the same you block processing while waiting on
a lock and the "reserved memory" on other CPUs remains unused.

Sebastian
