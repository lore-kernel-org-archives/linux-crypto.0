Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A04DC04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 21:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39EA22082E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558129336;
	bh=QBwVcrPHf5DzWZX3n7Xvd3K3qOgGi6ytpBDnqSCRT9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RAR83qyDOV9zB4uMOZhk7MBtXo4DyEO8ZIcLk36zcWleVyvDaGDRA/Ipdmn3cuDrd
	 UNm+Lsc+Z70uLqUA6AngICOxJvuTkHlI4trAd59qLbofVXh4nsS3eY2Yk66qPA0SEK
	 zKDfzm9zUwahtu1ud6mah6cGgs9VzF28R7r7OIZk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfEQVmP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 17:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfEQVmP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 17:42:15 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287C6206A3;
        Fri, 17 May 2019 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558129334;
        bh=QBwVcrPHf5DzWZX3n7Xvd3K3qOgGi6ytpBDnqSCRT9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bf48I/P4Iqmr3zsotgxE/tOgDis65ag4NyEYqUCuBGKBQ4xq5FLvrzImKyeL0d8u7
         7ACDrBr2VRNFIfX4Wu59pZbsSLyD7h4RejZMpKd5m/p/AUUMK6RY8Ay4mq0XkOy1P3
         onj0YNY8mwomxHlf61lXavlDtaA/kIJb8oPn2Vx4=
Date:   Fri, 17 May 2019 14:42:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crypto4xx - fix AES CTR blocksize value
Message-ID: <20190517214203.GA153555@gmail.com>
References: <20190517211557.25815-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517211557.25815-1-chunkeey@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christian,

On Fri, May 17, 2019 at 11:15:57PM +0200, Christian Lamparter wrote:
> This patch fixes a issue with crypto4xx's ctr(aes) that was
> discovered by libcapi's kcapi-enc-test.sh test.
> 
> The some of the ctr(aes) encryptions test were failing on the
> non-power-of-two test:
> 
> kcapi-enc - Error: encryption failed with error 0
> kcapi-enc - Error: decryption failed with error 0
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits):
> original file (1d100e..cc96184c) and generated file (e3b0c442..1b7852b855)
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
> (openssl generated CT): original file (e3b0..5) and generated file (3..8e)
> [PASSED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
> (openssl generated PT)
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (password):
> original file (1d1..84c) and generated file (e3b..852b855)
> 
> But the 16, 32, 512, 65536 tests always worked.
> 
> Thankfully, this isn't a hidden hardware problem like previously,
> instead this turned out to be a copy and paste issue.
> 
> With this patch, all the tests are passing with and
> kcapi-enc-test.sh gives crypto4xx's a clean bill of health:
>  "Number of failures: 0" :).
> 
> Cc: stable@vger.kernel.org
> Fixes: 98e87e3d933b ("crypto: crypto4xx - add aes-ctr support")
> Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

With this patch applied to the latest mainline kernel, did you check whether
this driver also passes the in-kernel crypto self-tests when
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y is set?  Those should have detected this bug
too, maybe even without EXTRA_TESTS.

- Eric
