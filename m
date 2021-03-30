Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9708C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 04:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A158D61982
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 04:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhC3EMA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 00:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhC3ELX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 00:11:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AA7C061762;
        Mon, 29 Mar 2021 21:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IVE4irMscxIaX1ei8Xhx0PZoGGf4Ym7nGhKHPK+v64w=; b=kg8MHga/+eI72+8dQXwAfDh360
        o1U4WDxiorCM+6mIZ8UoCEg++ap37eynnHUcpTaVKTyHsIGW2hl2Pc+1LhjRCtfE0TSg2ID5RAm7f
        Xq70X33bkfZs0DGtimWHz6zr2I8mqAmCJ5GaI7p/U7JYcA2TYjgNAxY3dLZSMChLS/kTKQF9/v5bW
        W/VVkeEwpIsPzrfYdvnYTiUGlniX7L1mu981o1hbOXZBiVjOxG6dB3N5R23i3Hj+OBkhHGfO9IU2K
        EF0+QHwHk0waLs1RwnHkJsHjBadrjK1duMZs6CdAjQRxRmq6IGl3Jxk5xLQ1fVkAGS9n4J9PuJbMR
        dEX7VUKg==;
Received: from [2601:1c0:6280:3f0::4557]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lR5ir-002ero-1E; Tue, 30 Mar 2021 04:11:21 +0000
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: crypto: possible NULL reference
Message-ID: <08384a82-8b41-69e0-ad04-705f011ed92a@infradead.org>
Date:   Mon, 29 Mar 2021 21:11:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As I was trying to document "fips=<integer", I noticed this.

In crypto/ecc.c, ecc_get_curve() can return NULL:

const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
{
	switch (curve_id) {
	/* In FIPS mode only allow P256 and higher */
	case ECC_CURVE_NIST_P192:
		return fips_enabled ? NULL : &nist_p192;
	case ECC_CURVE_NIST_P256:
		return &nist_p256;
	case ECC_CURVE_NIST_P384:
		return &nist_p384;
	default:
		return NULL;
	}
}

but when its return value is passed to
static int __ecc_is_key_valid(const struct ecc_curve *curve,
			      const u64 *private_key, unsigned int ndigits)

the use of <curve> here is not checked for NULL or not NULL
before it is used. Nor is the use of <curve> in most other functions
in ecc.c.


Is there something else protecting the improper use of <curve>
in these cases?  or is a patch warranted?


thanks.
-- 
~Randy

