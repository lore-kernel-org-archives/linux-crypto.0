Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD5CC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 04:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782A32070C
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 04:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgFPEGn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:06:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:40006 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgFPEGm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 00:06:42 -0400
IronPort-SDR: puXLyySm9QSp17u6iadahGKiDVBfVxIaoBQJ77jM0lZ8VFRTRz3shqjSaFAWKeqi0l8tfiZYkw
 NUwrqn4IjONw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 21:06:42 -0700
IronPort-SDR: MIIvnD102MDN9s0bZ67NOn1YIW7aWVAYOO9Z9hr/zSf5OJ8LQ9CZ2czJZz11gbDvznseT5c1XE
 EcgnpZfg90OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,517,1583222400"; 
   d="scan'208";a="476266542"
Received: from unknown (HELO intel.com) ([10.223.74.178])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jun 2020 21:06:40 -0700
Date:   Tue, 16 Jun 2020 09:26:04 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [Query] RSA SHA-384 signature verification
Message-ID: <20200616035603.GG14085@intel.com>
References: <20200615170413.GF14085@intel.com>
 <1730161.mygNopSbl3@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1730161.mygNopSbl3@tauon.chronox.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-15 at 21:25:58 +0200, Stephan Mueller wrote:
> Am Montag, 15. Juni 2020, 19:04:14 CEST schrieb Anshuman Gupta:
> 
> Hi Anshuman,
> 
> > Hi ,
> > I wanted to verify a RSA SHA-384 signature.
> > I am using crypto_alloc_shash(), crypto_shash_digest() API to extract
> > the SHA-384 digest.
> > I am having public key along with the sha-384 digest extracted from raw data
> > and signature. AFAIU understand from crypto documentation that i need to
> > verify the signature by importing public key to akcipher/skcipher API.
> > Here i am not sure which cipher API to prefer symmetric key cipher or
> > asymmetric key cipher API.
> > 
> > There are two types of API to import the key.
> > crypto_skcipher_setkey()
> > crypto_akcipher_set_pub_key()
> > 
> > Also i am not sure exactly which algo to use for RSA-SHA384 signature
> > verification.
> > 
> > Any help or inputs from crypto community will highly appreciated.
> 
> akcipher: asymmetric key crypto
> 
> skcipher: symmetric key crypto
Many thanks for your input, based upon your inputs i should use
akcipher.
Actually tried to grep crypto_akcipher_set_pub_key() but there are not any
usages of this API in Linux drivers.
What is the preferred method to verify a RSA signature inside any Linux
GPL driver, is there any standard interface API to verify RSA signature
by importing input of raw data and public key or else
it is recommended method to use below set low level of API 
crypto_alloc_akcipher(), akcipher_request_alloc(),
akcipher_request_set_crypt(), crypto_akcipher_verify().
Thanks,
Anshuman.

> > 
> > Thanks ,
> > Anshuman Gupta.
> 
> 
> Ciao
> Stephan
> 
> 
