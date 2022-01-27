Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC962C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 19:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245410AbiA0TId (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 14:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiA0TIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 14:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9392C061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B80261DA1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 19:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7EEC340E4;
        Thu, 27 Jan 2022 19:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643310511;
        bh=5kqWoAmlJfPg69e6lBs1tqaVjvbcOmnI2o8rQ+u4OpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9aQjv8bUW9e1zMOZDHPN2FrcJlRGCd0Wpz4sjQf8baqwBV55zNzvLh3J33k19MzU
         zMk5ScDrVjWPFSMSNjHm+fk77eNUSdZGQ4sJnxTZdKl5xN6T2/I1ZUq8j7XEGJPGVO
         T444N9/Y3Z9NtwmIOfMLpYEApCdopaxDGlRh2NNHge7RxBcYqGWwtS1yGCfmr59aug
         8rdVYVeRXT8StvnBUYL3OFGZ/2St2bl5GwdRQsvVCf6HWpszNl2cLyTQiEwAeUrZUB
         IXaBSezL0AtF38GjnR/SsbKfeu5LWYsFMR+2E/fJJMoF6mPxZ788Pka+xIvDrPHM1l
         ILr5GUaI4buHw==
Date:   Thu, 27 Jan 2022 11:08:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Denker <jsd@av8n.com>
Subject: Re: RFC random(4) We don't need no steenking ...
Message-ID: <YfLtrrB+140KkiN0@sol.localdomain>
References: <CACXcFmkhWDwJ2AwpBFnyYrM-YXDgBfFyCeJsmMux3gM8G+Gveg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmkhWDwJ2AwpBFnyYrM-YXDgBfFyCeJsmMux3gM8G+Gveg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 05:04:07PM +0800, Sandy Harris wrote:
> Current code in extract_buf() declares a local struct blake2s_state,
> calls blake2s_init() which uses initialisation constants

Which is good, because BLAKE2s is defined to use certain constants.  If
different constants were used, then it wouldn't be BLAKE2s anymore, but rather
some homebrew crypto with unknown security properties (like the old "SHA-1" that
wasn't really SHA-1).

> and moves data into the chacha state with memcpy().

It's actually XOR'd in.  Please take a closer look at crng_reseed().

- Eric
