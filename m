Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8195C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 16:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7996622CE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 16:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHSQyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:54:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:40558 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfHSQyN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 12:54:13 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 09:54:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="261894927"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2019 09:54:00 -0700
Date:   Mon, 19 Aug 2019 19:54:00 +0300
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
Subject: Re: [RFC/RFT v4 0/5] Add generic trusted keys framework/subsystem
Message-ID: <20190819165400.xsgpbtbj26y7d2wb@linux.intel.com>
References: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 13, 2019 at 01:22:59PM +0530, Sumit Garg wrote:
> This patch-set is an outcome of discussion here [1]. It has evolved very
> much since v1 to create, consolidate and generalize trusted keys
> subsystem.
> 
> This framework has been tested with trusted keys support provided via TEE
> but I wasn't able to test it with a TPM device as I don't possess one. It
> would be really helpful if others could test this patch-set using a TPM
> device.

I think 1/5-4/5 make up a non-RFC patch set that needs to reviewed,
tested and merged as a separate entity.

On the other hand 5/5 cannot be merged even if I fully agreed on
the code change as without TEE patch it does not add any value for
Linux.

To straighten up thing I would suggest that the next patch set
version would only consists of the first four patches and we meld
them to the shape so that we can land them to the mainline. Then
it should be way more easier to concentrate the actual problem you
are trying to resolve.

/Jarkko
