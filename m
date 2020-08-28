Return-Path: <SRS0=6Tes=CG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D321C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 09:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7787D208CA
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 09:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgH1JYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Aug 2020 05:24:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:27139 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgH1JYJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Aug 2020 05:24:09 -0400
IronPort-SDR: EF+ZDrteYkofyfdRvSVB1tn9RP8PO900mwCLXXsOkvUTCi/8rt+96zwF2F1Bdvp1ZfuSsIUvoe
 LxaFPUVAWW0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156640753"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156640753"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 02:24:08 -0700
IronPort-SDR: kGYpc7iKBlLVuT30qtPuLV2opAuMqwLzP0vMF4NW9HJuUL7fepk04oQOYa6/Q/rHR8x3eXbWWU
 HnAuW7Q7vY4Q==
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="475606774"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 02:24:07 -0700
Date:   Fri, 28 Aug 2020 10:23:59 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Przychodni, Dominik" <dominik.przychodni@intel.com>
Subject: Re: [PATCH] crypto: qat - aead cipher length should be block multiple
Message-ID: <20200828092359.GA62902@silpixa00400314>
References: <20200822072934.4394-1-giovanni.cabiddu@intel.com>
 <1cffce42de2f4e7b84514a27bd9a889d@irsmsx602.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cffce42de2f4e7b84514a27bd9a889d@irsmsx602.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 22, 2020 at 02:04:10PM +0100, Ard Biesheuvel wrote:
> On Sat, 22 Aug 2020 at 09:29, Giovanni Cabiddu
> <giovanni.cabiddu@intel.com> wrote:
> >
> > From: Dominik Przychodni <dominik.przychodni@intel.com>
> >
> > Include an additional check on the cipher length to prevent undefined
> > behaviour from occurring upon submitting requests which are not a
> > multiple of AES_BLOCK_SIZE.
> >
> > Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
> > Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> 
> I only looked at the patch, and not at the entire file, but could you
> explain which AES based AEAD implementations require the input length
> to be a multiple of the block size? CCM and GCM are both CTR based,
> and so any input length should be supported for at least those modes.
This is only for AES CBC as the qat driver supports only
authenc(hmac(sha1),cbc(aes)), authenc(hmac(sha256),cbc(aes)) and
authenc(hmac(sha512),cbc(aes)).

Regards,

-- 
Giovanni
