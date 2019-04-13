Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3531C10F11
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 13:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1272073F
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 13:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfDMNvD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Apr 2019 09:51:03 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:42614 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfDMNvD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Apr 2019 09:51:03 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFJ3d-0001NT-73; Sat, 13 Apr 2019 21:51:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFJ3a-0001PH-NE; Sat, 13 Apr 2019 21:50:58 +0800
Date:   Sat, 13 Apr 2019 21:50:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lionel DEBIEVE <lionel.debieve@st.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
Message-ID: <20190413135058.el26hvw7y7bcldm3@gondor.apana.org.au>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQU-0006oc-Sr@gondobar>
 <a0be98ce-da8e-8b86-59a3-4fc837496f9b@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0be98ce-da8e-8b86-59a3-4fc837496f9b@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 01:36:44PM +0000, Lionel DEBIEVE wrote:
>
> I was currently going to send patches around des and tdes key verification. Is there any plan
> to do the same factorization on des key check?

If you have the time please do because I think some single DES
drivers are missing the weak key check.  The existing des_ekey
function should be sufficient for the check.

> Acked-by: Lionel Debieve<lionel.debieve@st.com>
> Tested-by: Lionel Debieve<lionel.debieve@st.com>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
