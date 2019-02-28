Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00AEC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 18:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD942084D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 18:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbfB1SS7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:18:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfB1SS7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 13:18:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00C64315C9E7;
        Thu, 28 Feb 2019 18:18:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-129.rdu2.redhat.com [10.10.121.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B42B60BE6;
        Thu, 28 Feb 2019 18:18:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190224060828.2527-5-vt@altlinux.org>
References: <20190224060828.2527-5-vt@altlinux.org> <20190224060828.2527-1-vt@altlinux.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public key algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14842.1551377934.1@warthog.procyon.org.uk>
Date:   Thu, 28 Feb 2019 18:18:54 +0000
Message-ID: <14843.1551377934@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 28 Feb 2019 18:18:59 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Vitaly Chikunov <vt@altlinux.org> wrote:

> +	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
> +	if (!digest)

You shouldn't need to copy the digest.  It's being passed in to the crypto
algorithm, not extracted out.

> +		if (memcmp(c, outbuf_enc, c_size)) {

Please use == 0 and != 0 with memcmp() and strcmp().  Their return values are
kind of inverted in sense if you treat them as boolean.

David
