Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DD1C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 17:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F6F6214C6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554744460;
	bh=mkEGvTz8lwiQGqVoIJvTiclWouDM8S84NLh2sszfuO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m+I0NL4T5S7maq9ZdMRWSYTCxaBWtLhEHLtIgjLtDXkUI4wkRC1S3qSRhYLAGjs+2
	 i4RJzqcAgPjtuMQmoX3fR/qERVAz3YXrsTMR+GtWRsnEAPtENGKfZDY7nCzmPUQE1j
	 JTq/pcRxitxXyH95od/kKHtfcJIxafFb9ezylftk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfDHR1j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 13:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfDHR1j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 13:27:39 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F4A20870;
        Mon,  8 Apr 2019 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554744458;
        bh=mkEGvTz8lwiQGqVoIJvTiclWouDM8S84NLh2sszfuO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoR86g30ZQlP9whNl0Cm2RXrYN0hbTJJGjToi8IA2tsxEY+RN/+fi/U2guEBqO8g0
         EQs3Go5qWWQmAr37VMR4Xet+FaFXGPJ3XAU6KGZgn7emcqgLTwdB7ZJi/KKz+4qSSC
         uPUujdMswNmIRLVYsPHtjZmA74PZIqFB+tCl8zlg=
Date:   Mon, 8 Apr 2019 10:27:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 04/18] crypto: skcipher - restore default
 skcipher_walk::iv on error
Message-ID: <20190408172736.GA9145@gmail.com>
References: <20190331200428.26597-5-ebiggers@kernel.org>
 <20190408062354.nfxkxj333ocrs52z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408062354.nfxkxj333ocrs52z@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 02:23:54PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > When the user-provided IV buffer is not aligned to the algorithm's
> > alignmask, skcipher_walk_virt() allocates an aligned buffer and copies
> > the IV into it.  However, skcipher_walk_virt() can fail after that
> > point, and in this case the buffer will be freed.
> > 
> > This causes a use-after-free read in callers that read from walk->iv
> > unconditionally, e.g. the LRW template.  For example, this can be
> > reproduced by trying to encrypt fewer than 16 bytes using "lrw(aes)".
> 
> This looks like a bug in LRW.  Relying on walk->iv to be set to
> anything after a failed skcipher_walk_virt call is wrong.  So we
> should fix it there instead.
> 
> Cheers,
> -- 

It's not just LRW though.  It's actually 7 places:

	arch/arm/crypto/aes-neonbs-glue.c
	arch/arm/crypto/chacha-neon-glue.c
	arch/arm64/crypto/aes-neonbs-glue.c
	arch/arm64/crypto/chacha-neon-glue.c
	crypto/chacha-generic.c
	crypto/lrw.c
	crypto/salsa20-generic.c

Do you prefer that all those be updated?

- Eric
