Return-Path: <SRS0=o6su=76=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D1BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 10:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D308020CC7
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 10:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFQKTy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jun 2020 06:19:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:36103 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgFQKTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jun 2020 06:19:53 -0400
IronPort-SDR: IQa4HZp6RM4au2o30ucrJqnv6PktUKaT0Vr9DFAjDODgVpzkGqEuG+33j5MG4OQ3yWThjwEuvv
 GVwaj6GU614A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 03:19:53 -0700
IronPort-SDR: 0PzzQQ7JshR4LKNt8drek/c5E036z27Fn8SBHg8wbndmFrd/E2M+EgjaEW5ytznQCjMmpapKp0
 9S2/whNh/pJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,522,1583222400"; 
   d="scan'208";a="262517253"
Received: from unknown (HELO intel.com) ([10.223.74.178])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2020 03:19:52 -0700
Date:   Wed, 17 Jun 2020 15:39:16 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [Query] RSA SHA-384 signature verification
Message-ID: <20200617100916.GL14085@intel.com>
References: <20200615170413.GF14085@intel.com>
 <1730161.mygNopSbl3@tauon.chronox.de>
 <20200616035603.GG14085@intel.com>
 <13970611.Hd4P73xESc@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13970611.Hd4P73xESc@tauon.chronox.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-16 at 07:03:28 +0200, Stephan Mueller wrote:
> Am Dienstag, 16. Juni 2020, 05:56:04 CEST schrieb Anshuman Gupta:
> 
> Hi Anshuman,
> 
> > On 2020-06-15 at 21:25:58 +0200, Stephan Mueller wrote:
> > > Am Montag, 15. Juni 2020, 19:04:14 CEST schrieb Anshuman Gupta:
> > > 
> > > Hi Anshuman,
> > > 
> > > > Hi ,
> > > > I wanted to verify a RSA SHA-384 signature.
> > > > I am using crypto_alloc_shash(), crypto_shash_digest() API to extract
> > > > the SHA-384 digest.
> > > > I am having public key along with the sha-384 digest extracted from raw
> > > > data and signature. AFAIU understand from crypto documentation that i
> > > > need to verify the signature by importing public key to
> > > > akcipher/skcipher API. Here i am not sure which cipher API to prefer
> > > > symmetric key cipher or asymmetric key cipher API.
> > > > 
> > > > There are two types of API to import the key.
> > > > crypto_skcipher_setkey()
> > > > crypto_akcipher_set_pub_key()
> > > > 
> > > > Also i am not sure exactly which algo to use for RSA-SHA384 signature
> > > > verification.
> > > > 
> > > > Any help or inputs from crypto community will highly appreciated.
> > > 
> > > akcipher: asymmetric key crypto
> > > 
> > > skcipher: symmetric key crypto
> > 
> > Many thanks for your input, based upon your inputs i should use
> > akcipher.
> > Actually tried to grep crypto_akcipher_set_pub_key() but there are not any
> > usages of this API in Linux drivers.
> > What is the preferred method to verify a RSA signature inside any Linux
> > GPL driver, is there any standard interface API to verify RSA signature
> > by importing input of raw data and public key or else
> > it is recommended method to use below set low level of API
> > crypto_alloc_akcipher(), akcipher_request_alloc(),
> > akcipher_request_set_crypt(), crypto_akcipher_verify().
> 
> You can use that API directly or you can go through the intermediary of the 
> crypto/asymmetric_keys API. One use case is the kernel signature verification 
> as implemented in kernel/module_signing.c
Thanks Stephan :)
> 
> > Thanks,
> > Anshuman.
> > 
> > > > Thanks ,
> > > > Anshuman Gupta.
> > > 
> > > Ciao
> > > Stephan
> 
> 
> Ciao
> Stephan
> 
> 
