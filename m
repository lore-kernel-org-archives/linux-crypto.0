Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88D7C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 18:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiCWSFA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 14:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242820AbiCWSE5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 14:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFEF26AD4
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 11:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE503612D6
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 18:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C119EC340E8;
        Wed, 23 Mar 2022 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648058605;
        bh=EW4AB6xPTi40ANVZMlu7Sat4T8RvhWvsc+5fxPd45SY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4ybcsa7vXc14Dyxl5fgbNolkDLm6G9cBknp39APgL9rnbwfWprQa54cS+tnex7wq
         tMPv7FKeIfQsSUUJNva322spB+3Q6IwKJv2GsTNMKoxGU0oYrCkUBe3BRJ0kZzimDG
         XcIzE/mUiPXAVzvDXfHfdEXf3vcxLJCFnDUxerGRE69PRLcgNH54k4Teh4MZnvwms9
         7O9u9loWFJV1wMBh38iTVcESVRlOxst/YbtYaxMDCnxnZZcdKRyLq/AKKsH4YaV50+
         WafbaJZTbHa3P5TJX/sKhy586N12/4dZo+YPTqab6rHxhx6jSa0LAlFqfSJ68/o0Z4
         eace91XFYZ6xg==
Date:   Wed, 23 Mar 2022 11:03:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>
Subject: Re: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Message-ID: <Yjtg65rsnrzgyS5a@sol.localdomain>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <YjqtXFvfDq0kELl7@sol.localdomain>
 <f806c17c-cc7e-e2eb-e187-e83148160322@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f806c17c-cc7e-e2eb-e187-e83148160322@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 03:32:37PM +0800, zhenwei pi wrote:
> 
> On 3/23/22 13:17, Eric Biggers wrote:
> > On Wed, Mar 23, 2022 at 10:49:06AM +0800, zhenwei pi wrote:
> > > v2 -> v3:
> > > - Introduce akcipher types to qapi
> > > - Add test/benchmark suite for akcipher class
> > > - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
> > >    - crypto: Introduce akcipher crypto class
> > >    - virtio-crypto: Introduce RSA algorithm
> > > 
> > > v1 -> v2:
> > > - Update virtio_crypto.h from v2 version of related kernel patch.
> > > 
> > > v1:
> > > - Support akcipher for virtio-crypto.
> > > - Introduce akcipher class.
> > > - Introduce ASN1 decoder into QEMU.
> > > - Implement RSA backend by nettle/hogweed.
> > > 
> > > Lei He (3):
> > >    crypto-akcipher: Introduce akcipher types to qapi
> > >    crypto: Implement RSA algorithm by hogweed
> > >    tests/crypto: Add test suite for crypto akcipher
> > > 
> > > Zhenwei Pi (3):
> > >    virtio-crypto: header update
> > >    crypto: Introduce akcipher crypto class
> > >    virtio-crypto: Introduce RSA algorithm
> > 
> > You forgot to describe the point of this patchset and what its use case is.
> > Like any other Linux kernel patchset, that needs to be in the cover letter.
> > 
> > - Eric
> Thanks Eric for pointing this missing part.
> 
> This feature provides akcipher service offloading capability. QEMU side
> handles asymmetric requests via virtio-crypto devices from guest side, do
> encrypt/decrypt/sign/verify operations on host side, and return the result
> to guest.
> 
> This patchset implements a RSA backend by hogweed from nettle, it works
> together with guest patch:
> https://lkml.org/lkml/2022/3/1/1425

So what is the use case?

- Eric
