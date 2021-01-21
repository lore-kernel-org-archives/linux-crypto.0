Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BB8C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 20:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4407C23A5D
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 20:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAUUEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 15:04:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51784 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbhAUUEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 15:04:00 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l2gAT-0007bn-Je; Fri, 22 Jan 2021 07:02:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jan 2021 07:02:57 +1100
Date:   Fri, 22 Jan 2021 07:02:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
Cc:     "ardb@kernel.org" <ardb@kernel.org>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Message-ID: <20210121200257.GB27184@gondor.apana.org.au>
References: <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au>
 <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
 <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
 <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
 <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
 <711536383d5e829bd128a41e1a56ae50399b6c26.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <711536383d5e829bd128a41e1a56ae50399b6c26.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21, 2021 at 04:13:51PM +0000, Alessandrelli, Daniele wrote:
>
> As expected, the second implementation does not pass self-tests and
> crypto_alloc_kpp() returns -ELIBBAD when trying to allocate it, but
> I've seen that I can avoid the error (and have it allocated properly)
> by passing the CRYPTO_ALG_TESTED flag in the 'type' argument, like
> below:

Did you set your algorithm's name to ecdh? I think Ard was suggesting
you to not do that.  As long as you're not using the same name as a
recognised algorithm, then you won't need to pass any self-tests at
all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
