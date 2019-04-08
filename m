Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738B7C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406F02084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfDHGb7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:31:59 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:44218 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfDHGb7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:31:59 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNoz-0007xX-Ox; Mon, 08 Apr 2019 14:31:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNow-0003Pt-Ho; Mon, 08 Apr 2019 14:31:54 +0800
Date:   Mon, 8 Apr 2019 14:31:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hwrng: core - don't block in add_early_randomness()
Message-ID: <20190408063154.7bnt6puawoqtwlgo@gondor.apana.org.au>
References: <20190329163011.7370-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329163011.7370-1-lvivier@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 29, 2019 at 05:30:11PM +0100, Laurent Vivier wrote:
> If the device is not ready to provide data the kernel will
> be stuck indefinitely in the init function.
> 
> This is not a problem if the device is driven using a module,
> but if the driver is linked directly into the kernel then the
> kernel boot sequence hangs.
> 
> This can happen with virtio-rng device with rng-egd backend
> with no data provider, for instance with QEMU command line parameters:
> 
> ...
>     -chardev socket,id=charrng0,host=localhost,port=2345,server,nowait \
>     -object rng-egd,id=objrng0,chardev=charrng0 \
>     -device virtio-rng-pci,rng=objrng0,id=rng0
> 
> To avoid that, we can call rng_get_data() in non blocking mode because
> the function already manages the case where byte_read is
> 0 (if the device is not already initialized).
> 
> See also commit d3cc7996473a
> ("hwrng: fetch randomness only after device init")
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

I think this is either not a bug (make sure that the user supplies
a RNG source) or it should be addressed in virtio-rng.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
