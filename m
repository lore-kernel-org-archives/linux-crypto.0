Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EA6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 18:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhKWSXJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 13:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232326AbhKWSXJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 13:23:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C53C660F6E;
        Tue, 23 Nov 2021 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637691601;
        bh=/oGeobPgKEELQ9jR8Tid54S7CEBgVi/4RdF59awrB6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOfhWqjGTMY5cSS2hechhcQTagHANlBU6FDHuZ2Gx3PVuM29N1MzlIItLdulSljk6
         AEmseKxSX1kUPxFkzDtwbVA8y3Do5Vi7QLPh5Mh5oQ1YQytBuo/AWn0y/czdQ5xg+s
         jQvU64VrSM1KEl7bS/z/hVnHOdyAe6mUzjLPkMvK85xRmDgjlrnFEkp/2hyPNF79ig
         o0AbmsZ++TXC356q4reWTN4DLbPUWamUR/JrWFN7BujPlpgK4ivzEz9raSeP8gH8/4
         tNfFVGgAp/z5DiSWE9KxaFIJqs22D0cZ+qoqmQQ7VKJje2RvzN04jVKtq5dbFHe/Ys
         A3VjoccNiSyXQ==
Date:   Tue, 23 Nov 2021 10:19:59 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
Message-ID: <YZ0wz+4uA4Nk+aVQ@gmail.com>
References: <20211123123801.73197-1-hare@suse.de>
 <20211123123801.73197-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123123801.73197-5-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 23, 2021 at 01:37:53PM +0100, Hannes Reinecke wrote:
> + * Return: the length of the resulting base64url-encoded string in bytes.

As I mentioned on a previous version, this is base64, not base64url.

> + * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding"

Likewise here.

- Eric
