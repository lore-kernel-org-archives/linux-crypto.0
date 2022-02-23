Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F0C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 03:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiBWDaN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiBWDaM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 22:30:12 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE3E39141;
        Tue, 22 Feb 2022 19:29:45 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nMhqf-0006CX-PL; Wed, 23 Feb 2022 13:57:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Feb 2022 14:57:49 +1200
Date:   Wed, 23 Feb 2022 14:57:49 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        leitao@debian.org, Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: vmx - merge CRYPTO_DEV_VMX_ENCRYPT into
 CRYPTO_DEV_VMX
Message-ID: <YhWirRLlQNs3jha/@gondor.apana.org.au>
References: <20220217105751.6330-1-pvorel@suse.cz>
 <20220217105751.6330-2-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217105751.6330-2-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 17, 2022 at 11:57:50AM +0100, Petr Vorel wrote:
> CRYPTO_DEV_VMX_ENCRYPT is redundant with CRYPTO_DEV_VMX.
> 
> And it also forces CRYPTO_GHASH to be builtin even
> CRYPTO_DEV_VMX_ENCRYPT was configured as module.

Just because a tristate sits under a bool, it does not force
the options that it selects to y/n.  The select still operates
on the basis of the tristate.

So I don't see the point to this code churn unless the powerpc
folks want to move in this direction.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
