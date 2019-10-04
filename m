Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347ACC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 18:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9912053B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 18:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfJDStL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 14:49:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:38274 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfJDStK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 14:49:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 11:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="191670432"
Received: from nzaki1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.57])
  by fmsmga008.fm.intel.com with ESMTP; 04 Oct 2019 11:49:03 -0700
Date:   Fri, 4 Oct 2019 21:49:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     dhowells@redhat.com, peterhuewe@gmx.de, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        jgg@ziepe.ca, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jejb@linux.ibm.com, Mimi Zohar <zohar@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [Patch v6 4/4] KEYS: trusted: Move TPM2 trusted keys code
Message-ID: <20191004184902.GG6945@linux.intel.com>
References: <1568630064-14887-1-git-send-email-sumit.garg@linaro.org>
 <1568630064-14887-5-git-send-email-sumit.garg@linaro.org>
 <20190917181415.GA8472@linux.intel.com>
 <20190917181507.GB8472@linux.intel.com>
 <CAFA6WYMbUGQ6+-XvR9_qSc=oVe1QSTg4kB-+y6rBmQLq+B6skg@mail.gmail.com>
 <20190925011115.GA3503@linux.intel.com>
 <CAFA6WYObsZnTptYg1Qorxt0FMaxHKoZ6D53Wjsj05OEGNhpckg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYObsZnTptYg1Qorxt0FMaxHKoZ6D53Wjsj05OEGNhpckg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 04, 2019 at 11:35:29AM +0530, Sumit Garg wrote:
> Hi Jarkko,
> 
> On Wed, 25 Sep 2019 at 06:41, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Wed, Sep 18, 2019 at 11:53:08AM +0530, Sumit Garg wrote:
> > > No worries :). I will send next version of patch-set.
> > >
> > > FYI, I will be travelling for Linaro Connect next week so you could
> > > expect some delays in my responses.
> >
> > These patches will go to v5.5. There is nothing to rush.
> 
> I am back now on my regular schedule after Linaro Connect. And I see
> your patch-set [1] to detach page allocation from tpm_buf. It seems
> like either this patch-set needs rebase over yours or vice-versa.
> 
> So should I wait to send next version of this patch-set until your
> patch-set arrives in tpmdd master/next branch or would you like to
> rebase your patch-set over this?

For me either way works. If you patch set is earlier ready for
merge I'll rework mine. Doing it otherwise would be unnecessary
micromanagement.

/Jarkko
