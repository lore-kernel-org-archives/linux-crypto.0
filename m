Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C549CC63777
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 22:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F0BF22242
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 22:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ez2ydQvA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbgK0Wfv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 17:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731562AbgK0Wdx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 17:33:53 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8884A22228;
        Fri, 27 Nov 2020 22:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606516428;
        bh=aMsFZyFhIuhw17uktvxqyJW0qWEVfE491c/upB9gTE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ez2ydQvAv4pkEt31bLoHbWIFdaH8KE07dw0pgIJo9gpmB5Qb2IWJo29RJWqVGZahB
         +3D1unPTY+OKcQVvzD47eLFJhb/aAX6g5MiSTHkNe6HnrG7piMiPE9SXB9gUEKPY/j
         6aQhq8H9SHlGobNNZZKkbvuUQxCOGQMUar4tZOKI=
Date:   Fri, 27 Nov 2020 14:33:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [net-next v2 0/5] Add CHACHA20-POLY1305 cipher to Kernel TLS
Message-ID: <20201127143347.77459193@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 24 Nov 2020 18:24:45 +0300 Vadim Fedorenko wrote:
> RFC 7905 defines usage of ChaCha20-Poly1305 in TLS connections. This
> cipher is widely used nowadays and it's good to have a support for it
> in TLS connections in kernel.
> Changes v2: 
>   nit fixes suggested by Jakub Kicinski
>   add linux-crypto to review patch set

Applied, thank you!
