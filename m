Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3799EC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 21:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0924A20C01
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 21:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfHEVAJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 17:00:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:45420 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730036AbfHEVAJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 17:00:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 13:59:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="181782659"
Received: from unknown (HELO localhost) ([10.252.52.83])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Aug 2019 13:59:15 -0700
Date:   Mon, 5 Aug 2019 23:59:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        jejb@linux.ibm.com, Mimi Zohar <zohar@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>
Subject: Re: [RFC/RFT v2 1/2] KEYS: trusted: create trusted keys subsystem
Message-ID: <20190805205915.k5enrfob2cocqyff@linux.intel.com>
References: <1563449086-13183-1-git-send-email-sumit.garg@linaro.org>
 <1563449086-13183-2-git-send-email-sumit.garg@linaro.org>
 <20190801172310.cldcftfdoh5vyfjg@linux.intel.com>
 <CAFA6WYM+FQuXA9Saj5+ffOGsc-shhiF5Uos4g14Qndvu6w97Sg@mail.gmail.com>
 <20190802193802.jn56jhoz5crebggt@linux.intel.com>
 <CAFA6WYOMXc2y=vXOwRv+PYyF8oBV70G7CrJ81jvD5yJT41zLZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYOMXc2y=vXOwRv+PYyF8oBV70G7CrJ81jvD5yJT41zLZw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 05, 2019 at 10:32:59AM +0530, Sumit Garg wrote:
> Okay, I will try to move TPM2 trusted keys code also.

I'm definitely for extending trusted keys beyond TPMs. Before that can be
done, however, the current mess needs to be cleaned up.

I did a lot of work recently [1] to clean up TPM transmit code to better
suited to be used outside of the TPM drivers (remove recursive calls,
put the whole stack use tpm_buf for everything).

What still needs to be done is to move tpm_buf stuff to include/linux in
order to be usable in the keyring code. Also for TPM 2.0 trusted keys,
TPM2 constants need to be moved to include/linux. For the latter, I'd
suggest to move all protocol constants there and not just what is
required for trusted keys. Better to have them in one place.

[1] https://lkml.org/lkml/2019/2/13/176

/Jarkko
