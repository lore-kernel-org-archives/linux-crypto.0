Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083BDC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 13:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB1820B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 13:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfJJN4j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 09:56:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:46282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfJJN4j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 09:56:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 826A5AEF6;
        Thu, 10 Oct 2019 13:56:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9764DA7E3; Thu, 10 Oct 2019 15:56:51 +0200 (CEST)
Date:   Thu, 10 Oct 2019 15:56:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: add blake2b generic implementation
Message-ID: <20191010135651.GS2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
References: <e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com>
 <CAKv+Gu9ccLRt-g-3WipF2rc5zXSVVounj8cDqAGS730kqH6vdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ccLRt-g-3WipF2rc5zXSVVounj8cDqAGS730kqH6vdw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Wed, Oct 09, 2019 at 03:47:09PM +0200, Ard Biesheuvel wrote:
> I have a couple more comments - apologies for not spotting these the
> first time around.

No problem, there was a lot of churn since v1.

> > +enum {
> > +       BLAKE2_DUMMY_2 = 1 / (sizeof(struct blake2b_param) == BLAKE2B_OUTBYTES)
> > +};
> > +
> 
> Please use BUILD_BUG_ON(<condition>) to do compile time sanity checks.
> (You'll have to move it into a C function though)

Fixed.

> > +int blake2b_init_key(struct blake2b_state *S, size_t outlen, const void *key,
> 
> This should be static, and given that it is not used anywhere, you
> should either remove it or wire it up.
> 
> Given that blake2 can be used as a keyed hash as well as an unkeyed
> hash, I propose that you implement the setkey() hook, and add
> CRYPTO_ALG_OPTIONAL_KEY to the cra_flags to convey that setkey() is
> optional.

Ok, setkey will be in v3.

> > +int blake2b_init(struct blake2b_state *S, size_t outlen);
> > +int blake2b_init_key(struct blake2b_state *S, size_t outlen, const void *key, size_t keylen);
> > +int blake2b_update(struct blake2b_state *S, const void *in, size_t inlen);
> > +int blake2b_final(struct blake2b_state *S, void *out, size_t outlen);
> 
> Drop these please.

Done, with the additional 'static' fixups.
