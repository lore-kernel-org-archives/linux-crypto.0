Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4097FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 02:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiGUCej (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 22:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUCei (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 22:34:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DBA774A7
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 19:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6688ECE2336
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 02:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4219CC3411E;
        Thu, 21 Jul 2022 02:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658370874;
        bh=N4b5H7bsYZVAjTDde4MhRJd56uCFvrh0A1BWavAr9yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIpzdB0t8zEEhNAyqbmng2pzWyM98VK5wlPs07qs8d13rxScwoKT4KtCSmVmMxmDS
         dR+AVN+7OoI5cFrh7N5OREid4nLyETaJk7mV5Gwzj0oB5ib1x80iXIFsnjkEDdIBop
         tMIoeHovoF17w5X2CSgPAY2PjDRwJXisHijC/jJwglkNsv2HTM8uRzokVacdop2Nhm
         kpXqSaqZ8qmyS5ehfaCLfvKRRk7uyVjSttSUnV2QstB/mURZviIA+CaLCwVVyNs/Ou
         by+SeiIj0Err73ary+4ltfMQoVwfZ2eVHF/7inkPylgeWk1AoSjyriP51alOflcRSC
         3jW1OLBovLADw==
Date:   Wed, 20 Jul 2022 19:34:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Message-ID: <Yti7KsIsyRU/+N7w@sol.localdomain>
References: <20220712075031.29061-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712075031.29061-1-guozihua@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 12, 2022 at 03:50:31PM +0800, GUO Zihua wrote:
> int init(void)
> {
> 	struct crypto_shash *tfm = NULL;
> 	struct shash_desc *desc = NULL;
> 	char *data = NULL;
> 
> 	tfm = crypto_alloc_shash("poly1305", 0, 0);
> 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
> 	desc->tfm = tfm;
> 
> 	data = kmalloc(POLY1305_KEY_SIZE - 1, GFP_KERNEL);
> 	memcpy(data, test_data, POLY1305_KEY_SIZE - 1);
> 	crypto_shash_update(desc, data, POLY1305_KEY_SIZE - 1);
> 	crypto_shash_final(desc, data);
> 	kfree(data);
> 	return 0;
> }

This isn't actually a valid test case since it never calls crypto_shash_init().
So the behavior of this test is undefined both before and after this patch.  The
simplest way to write a correct test would be to use crypto_shash_tfm_digest().

Anyway, the bug is still real and this patch is still the correct fix, so it's
good enough to add my reviewed-by:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
