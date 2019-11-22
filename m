Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D252C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 10:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539A020718
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 10:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfKVKnD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 05:43:03 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51570 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfKVKnC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY6Oz-0002gj-Oq; Fri, 22 Nov 2019 18:43:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY6Ox-0005Bf-UX; Fri, 22 Nov 2019 18:42:59 +0800
Date:   Fri, 22 Nov 2019 18:42:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH 2/3] s390/crypto: Rework on paes implementation
Message-ID: <20191122104259.ofodwadrgszdxuto@gondor.apana.org.au>
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-3-freude@linux.ibm.com>
 <20191122081338.6bdjevtyttpdzzwl@gondor.apana.org.au>
 <87e9dbee-4024-602c-7717-051df3ac644d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87e9dbee-4024-602c-7717-051df3ac644d@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 22, 2019 at 10:54:50AM +0100, Harald Freudenberger wrote:
> The setkey() sets the base key material (usually a secure key) to an
> tfm instance. From this key a 'protected key' (pkey) is derived which
> may get invalid at any time and may need to get re-derived from the
> base key material.
> An tfm instance may be shared, so the context where the pkey is
> stored into is also shared. So when a pkey gets invalid there is a need
> to update the pkey value within the context struct. This update needs
> to be done atomic as another thread may concurrently use this pkey
> value. That's all what this spinlock does. Make sure read and write
> operations on the pkey within the context are atomic.
> It is still possible that two threads copy the pkey, try to use it, find out
> that it is invalid and needs refresh, re-derive and both update the pkey
> memory serialized by the spinlock. But this is no issue. The spinlock
> makes sure the stored pkey is always a consistent pkey (which may
> be valid or invalid but not corrupted).

OK.  Can you give me a bit more background info on how often
this is likely to happen? I mean it happened every time you
might as well not store the protected key in the tfm at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
