Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5779FA372B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FE1C2082C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbfJPLAg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 07:00:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:3400 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfJPLAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 07:00:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 04:00:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="225749572"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by fmsmga002.fm.intel.com with ESMTP; 16 Oct 2019 04:00:32 -0700
Date:   Wed, 16 Oct 2019 14:00:31 +0300
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
Message-ID: <20191016110031.GE10184@linux.intel.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
 <20191014190033.GA15552@linux.intel.com>
 <1571081397.3728.9.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571081397.3728.9.camel@HansenPartnership.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 12:29:57PM -0700, James Bottomley wrote:
> The job of the in-kernel rng is simply to produce a mixed entropy pool
> from which we can draw random numbers.  The idea is that quite a few
> attackers have identified the rng as being a weak point in the security
> architecture of the kernel, so if we mix entropy from all the sources
> we have, you have to compromise most of them to gain some predictive
> power over the rng sequence.

The documentation says that krng is suitable for key generation.
Should the documentation changed to state that it is unsuitable?

> The point is not how certified the TPM RNG is, the point is that it's a
> single source and if we rely on it solely for some applications, like
> trusted keys, then it gives the attackers a single known point to go
> after.  This may be impossible for script kiddies, but it won't be for
> nation states ... are you going to exclusively trust the random number
> you got from your chinese certified TPM?

I'd suggest approach where TPM RNG result is xored with krng result.

> Remember also that the attack doesn't have to be to the TPM only, it
> could be the pathway by which we get the random number, which involves
> components outside of the TPM certification.

Yeah, I do get this.

/Jarkko
