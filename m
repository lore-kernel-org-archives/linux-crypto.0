Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0149CC35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0B1C21A4C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570026717;
	bh=irKMua+MAMQ0DTEZEguuqGCv18ZUXVtsRW+7GCyG05U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TRVPw02p00vjwiwXxuhvKlvb16t5OTjDRaXafd7RTiAGL+isMyiM8YeI80ZTZEtq9
	 lBHcSZoljnlbRcDbEqzg4GtBTHbY9S6h5AoACyT4nUS4Mj4nOGsOYEDaXCuSTu7k43
	 6EFrs3ugqestT7JefuqivYWLaQ3J8OAxYpLR7NEA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfJBOb5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfJBOb5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E7A21783;
        Wed,  2 Oct 2019 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570026716;
        bh=irKMua+MAMQ0DTEZEguuqGCv18ZUXVtsRW+7GCyG05U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1vOIRqAQ6AplzjZkRJRC7qedEHSPAvfFL7eItJi3/Ig9yKNVPfrEAwmB5OwbbMheg
         vVFUUdcnOsW97p9XNfyspST8CwVyzqcjhjo4BOGfRNNwcSwb17iOW5K+5jLxG8k9Sp
         +0AbL70lqPyw5/iSpmfklRrQDl2qFzYNfbOPZ6+U=
Date:   Wed, 2 Oct 2019 16:31:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 03/20] crypto: arm64/chacha - expose arm64 ChaCha
 routine as library function
Message-ID: <20191002143154.GC1743118@kroah.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-4-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-4-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:16:56PM +0200, Ard Biesheuvel wrote:
> Expose the accelerated NEON ChaCha routine directly as a symbol
> export so that users of the ChaCha library can use it directly.

See, you got it right here!  :)

