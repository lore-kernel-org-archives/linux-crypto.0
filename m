Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB36FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F2CD2168B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390970AbfJPQZt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 12:25:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:12345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733056AbfJPQZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 12:25:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="202116161"
Received: from hagarwal-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.5.165])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Oct 2019 09:25:44 -0700
Date:   Wed, 16 Oct 2019 19:25:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191016162543.GB6279@linux.intel.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
 <20191014190033.GA15552@linux.intel.com>
 <1571081397.3728.9.camel@HansenPartnership.com>
 <20191016110031.GE10184@linux.intel.com>
 <1571229252.3477.7.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571229252.3477.7.camel@HansenPartnership.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 16, 2019 at 08:34:12AM -0400, James Bottomley wrote:
> reversible ciphers are generally frowned upon in random number
> generation, that's why the krng uses chacha20.  In general I think we
> shouldn't try to code our own mixing and instead should get the krng to
> do it for us using whatever the algorithm du jour that the crypto guys
> have blessed is.  That's why I proposed adding the TPM output to the
> krng as entropy input and then taking the output of the krng.

It is already registered as hwrng. What else? Was the issue that
it is only used as seed when the rng is init'd first? I haven't
at this point gone to the internals of krng.

/Jarkko
