Return-Path: <SRS0=DMoR=WX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B564C3A5A6
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Aug 2019 14:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13760214DA
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Aug 2019 14:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfH0ORv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:17:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:57443 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfH0ORv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Aug 2019 10:17:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="264283831"
Received: from jsakkine-mobl1.fi.intel.com (HELO localhost) ([10.237.66.169])
  by orsmga001.jf.intel.com with ESMTP; 27 Aug 2019 07:17:43 -0700
Date:   Tue, 27 Aug 2019 17:17:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        peterhuewe@gmx.de, jgg@ziepe.ca, jejb@linux.ibm.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, casey@schaufler-ca.com,
        ard.biesheuvel@linaro.org, daniel.thompson@linaro.org,
        linux-kernel@vger.kernel.org, tee-dev@lists.linaro.org
Subject: Re: [PATCH v5 4/4] KEYS: trusted: move tpm2 trusted keys code
Message-ID: <20190827141742.6qxowsigqolxaod4@linux.intel.com>
References: <1566392345-15419-1-git-send-email-sumit.garg@linaro.org>
 <1566392345-15419-5-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566392345-15419-5-git-send-email-sumit.garg@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 21, 2019 at 06:29:05PM +0530, Sumit Garg wrote:
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2004 IBM Corporation
> + * Copyright (C) 2014 Intel Corporation

Everything below can be dropped from this new file. Git has the most
accurate authority information.

I'm not sure why I added the authors-list in the first place to the
header when I implemented these functions as none of those folks have
contributed to this particular piece of work.

> + * Authors:
> + * Leendert van Doorn <leendert@watson.ibm.com>
> + * Dave Safford <safford@watson.ibm.com>
> + * Reiner Sailer <sailer@watson.ibm.com>
> + * Kylene Hall <kjhall@us.ibm.com>
> + *
> + * Maintained by: <tpmdd-devel@lists.sourceforge.net>
> + *
> + * Trusted Keys code for TCG/TCPA TPM2 (trusted platform module).
> + */

To summarize, I think this would be sufficient:

// SPDX-License-Identifier: GPL-2.0-only
/*
 * Copyright (C) 2004 IBM Corporation
 * Copyright (C) 2014 Intel Corporation
 */

I think there should never be such a rush that acronym could not be
written with the correct spelling. I'm referring to 'tpm2' in the short
summary. I'm sorry, I had to say it, just can't help myself with those
kind of details :-) I can take care of fixing those once I apply these
patches.

You've done an awesome job. Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Unfortunately I'm not yet sure if I have time to test these before going
to Linux Plumbers but these would be anyway too close to the next merge
window to be added to the v5.4 PR.

/Jarkko
