Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AAEC3DA7A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Jan 2023 23:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjABXDp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Jan 2023 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjABXDo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2023 18:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9092ADB
        for <linux-crypto@vger.kernel.org>; Mon,  2 Jan 2023 15:03:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3221561133
        for <linux-crypto@vger.kernel.org>; Mon,  2 Jan 2023 23:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687C8C433D2;
        Mon,  2 Jan 2023 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672700622;
        bh=rmpZSqBeydYPmOfYdtaHXGU6tk3QdqLm4wRRYorlwEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HN1j2lr0Uj5Ctr2FeCQ8/Bwq8ez/QynvNXHcnOB8yt1NMuo4IlqiuI3tO/qb8v51x
         1TTDuEnO6sff953TIK2nWXsUtPweL3rIKZ2CpRc0QIygLN9uyMdgfOhJUOaEz27MNR
         q19qEGavSV8ubWUAO8VycW1MPFXDKkCIOc2/P6Kqk6uljuysQWP+IVrDDDV/3aVjxJ
         LODWsHopBcnA8K6Ytysqi97Bu7JS5oEdpj3nuXxT+4ZaPOBEvHNaQoL7CbZ6zhfiRX
         fKZxW6aOm4OFm5edASjU5n1dRXU7Sw3OnUZREpDgZ+r3jYOoJvmKhCDF71pS2NRvdZ
         rt4KfQsL4JgZQ==
Date:   Mon, 2 Jan 2023 15:03:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: xor_blocks() assumptions
Message-ID: <Y7NizHFsWfMW/cC2@sol.localdomain>
References: <CGME20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532@eucas1p1.samsung.com>
 <dleftjk024o8to.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dleftjk024o8to.fsf%l.stelmach@samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 02, 2023 at 11:44:35PM +0100, Lukasz Stelmach wrote:
> Hi,
> 
> I am researching possibility to use xor_blocks() in crypto_xor() and
> crypto_xor_cpy(). What I've found already is that different architecture
> dependent xor functions work on different blocks between 16 and 512
> (Intel AVX) bytes long. There is a hint in the comment for
> async_xor_offs() that src_cnt (as passed to do_sync_xor_offs()) counts
> pages. Thus, it is assumed, that the smallest chunk xor_blocks() gets is
> a single page. Am I right?
> 
> Do you think adding block_len field to struct xor_block_template (and
> maybe some information about required alignment) and using it to call
> do_2 from crypto_xor() may work? I am thinking especially about disk
> encryption where sectors of 512~4096 are handled.
> 

Taking a step back, it sounds like you think the word-at-a-time XOR in
crypto_xor() is not performant enough, so you want to use a SIMD (e.g. NEON,
SSE, or AVX) implementation instead.  Have you tested that this would actually
give a benefit on the input sizes in question, especially considering that SIMD
can only be used in the kernel if kernel_fpu_begin() is executed first?

It also would be worth considering just optimizing crypto_xor() by unrolling the
word-at-a-time loop to 4x or so.

- Eric
