Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B723C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D8561157
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhI1G0N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239064AbhI1GZ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5738961157;
        Tue, 28 Sep 2021 06:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632810257;
        bh=0+fm8nJsYppz796moPgEvC4ALZD05CQCvZuU4dzfISo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mT48iX93w7d0SztBr8/OOD9UiRU9fj1Fl4ao9SAlM8lIk2HbvJARq9xYK3+VJeJ8K
         VUExRvmeJ4Jnx+UDLP5TIkwoEt8AmmhCn0tJqTrvKmfuiYH6CJf3PDHb1u4vqgEBKQ
         +F5hcYISK83oHyr85XiBKCQR31XeTqWOlpnQ5C8UtyTuwfXtJ33Kfs/tY8jMDlxqsU
         AuU7zYXYP6/Jx/z0y6j6kVcbM7QLFFKel12NQ4/wazeAVCdUVj4ULgb6imQKh5HSQf
         vg3/5AdoGc7D8phCKl/jnB1XiYcsbYkNGuvme/Vxn8tzBUUlkd4uUjz6wbQDl4iPIk
         wsYtZn5OvjXBg==
Date:   Mon, 27 Sep 2021 23:24:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
Message-ID: <YVK1D+GZgdFPRsaS@sol.localdomain>
References: <20210928060356.27338-1-hare@suse.de>
 <20210928060356.27338-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928060356.27338-5-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 28, 2021 at 08:03:48AM +0200, Hannes Reinecke wrote:
> + * Return: the length of the resulting base64url-encoded string in bytes.

base64, not base64url.

> + * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding"
> + * specified by RFC 4648, including the  '='-padding.

base64, not base64url.

- Eric
