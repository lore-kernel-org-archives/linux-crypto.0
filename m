Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FC8C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 11:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2AF2225E
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 11:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbhADLcn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 06:32:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbhADLcm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 06:32:42 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kwO5U-0005wX-Ds; Mon, 04 Jan 2021 22:31:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 04 Jan 2021 22:31:48 +1100
Date:   Mon, 4 Jan 2021 22:31:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Reshetova, Elena" <elena.reshetova@intel.com>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Message-ID: <20210104113148.GA20575@gondor.apana.org.au>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 08:04:15AM +0000, Reshetova, Elena wrote:
> > 2. The OCS ECC HW does not support the NIST P-192 curve. We were planning to
> >    add SW fallback for P-192 in the driver, but the Intel Crypto team
> >    (which, internally, has to approve any code involving cryptography)
> >    advised against it, because they consider P-192 weak. As a result, the
> >    driver is not passing crypto self-tests. Is there any possible solution
> >    to this? Is it reasonable to change the self-tests to only test the
> >    curves actually supported by the tested driver? (not fully sure how to do
> >    that).
> 
> An additional reason against the P-192 SW fallback is the fact that it can 
> potentially trigger unsafe behavior which is not even "visible" to the end user
> of the ECC functionality. If I request (by my developer mistake) a P-192 
> weaker curve from ECC Keem Bay HW driver, it is much safer to return a
> "not supported" error that proceed behind my back with a SW code
> implementation making me believe that I am actually getting a HW-backed up
> functionality (since I don't think there is a way for me to check that I am using
> SW fallback). 

Sorry, but if you break the Crypto API requirement then your driver
isn't getting merged.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
