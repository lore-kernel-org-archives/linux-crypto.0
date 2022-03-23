Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5F6C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 05:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiCWFSs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 01:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCWFSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 01:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428C46E2A8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 22:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA4D615C0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 05:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3BBC340E8;
        Wed, 23 Mar 2022 05:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648012638;
        bh=hWV7WPxG+2ZGxja3LKM0OHYGVJ2ahN4nlybJUl5BMHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3XH7/7994YkqMJmgz1L6t/vZMI6iEzWgHmeX5pBiS8xE/Le5DdCQauB8x5GhFI5y
         IwV9M/rGJv9m/AKH/r2SX7KEyEmCn1l6pADPsJm1YU4tESaQejlk4tsFULSTFktNn9
         rNnjwafQs7aZGTJbAxLA7F77DTKdzxZAMXjTyZPFy1kXYUdvdKPK4SiprCT6ZSdp0n
         2X1k+skAcRqHD9AliTTODJzVIvNkqbqQkDCqNix/dprqwZ54UY9TA/TD3onsfYr+SC
         5N6oOUoGBtQouBinR+TXFm/FoBy58suXx3E5gbmFSEl6Qh7BOys7NfODR4bY2zU9gS
         ojDmEBg4D7T6g==
Date:   Tue, 22 Mar 2022 22:17:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Message-ID: <YjqtXFvfDq0kELl7@sol.localdomain>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:06AM +0800, zhenwei pi wrote:
> v2 -> v3:
> - Introduce akcipher types to qapi
> - Add test/benchmark suite for akcipher class
> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>   - crypto: Introduce akcipher crypto class
>   - virtio-crypto: Introduce RSA algorithm
> 
> v1 -> v2:
> - Update virtio_crypto.h from v2 version of related kernel patch.
> 
> v1:
> - Support akcipher for virtio-crypto.
> - Introduce akcipher class.
> - Introduce ASN1 decoder into QEMU.
> - Implement RSA backend by nettle/hogweed.
> 
> Lei He (3):
>   crypto-akcipher: Introduce akcipher types to qapi
>   crypto: Implement RSA algorithm by hogweed
>   tests/crypto: Add test suite for crypto akcipher
> 
> Zhenwei Pi (3):
>   virtio-crypto: header update
>   crypto: Introduce akcipher crypto class
>   virtio-crypto: Introduce RSA algorithm

You forgot to describe the point of this patchset and what its use case is.
Like any other Linux kernel patchset, that needs to be in the cover letter.

- Eric
