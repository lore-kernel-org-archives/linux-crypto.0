Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E69C4360C
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 12:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DECB920673
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 12:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfIYMfB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 08:35:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:40044 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfIYMfB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 08:35:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 05:35:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="203602442"
Received: from kmakows-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.225])
  by fmsmga001.fm.intel.com with ESMTP; 25 Sep 2019 05:34:58 -0700
Date:   Wed, 25 Sep 2019 15:34:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 02/12] tpm-buf: add handling for TPM2B types
Message-ID: <20190925123457.GB24028@linux.intel.com>
References: <1568031408.6613.29.camel@HansenPartnership.com>
 <1568031515.6613.31.camel@HansenPartnership.com>
 <20190920141826.GC9578@linux.intel.com>
 <1569323560.24519.6.camel@HansenPartnership.com>
 <20190925123401.GA24028@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925123401.GA24028@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 25, 2019 at 03:34:01PM +0300, Jarkko Sakkinen wrote:
> On Tue, Sep 24, 2019 at 07:12:40AM -0400, James Bottomley wrote:
> > I thought about that.  The main problem is that most of the
> > construct/append functions use the header, and these are the functions
> > most useful to the TPM2B operation.
> > 
> > The other thing that argues against this is that the TPM2B case would
> > save nothing if we eliminated the header, because we allocate a page
> > for all the data regardless.
> 
> It would be way more clean. There is absolutely nothing TPM2B specific.

Given the recent regression I'm detaching allocation from tpm_buf and
make it purely a decorator (sending patch today).

/Jarkko
