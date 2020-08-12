Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E674AC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 16:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B4F207DA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 16:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgHLQiF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 12:38:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:64274 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbgHLQiE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 12:38:04 -0400
IronPort-SDR: 6XblZFf3JnuSl4GDovexY3pUSa5iELEWrP4fWQhffo8dp25MT+xJToNGVdEnUjyh/u0Xo9bfXF
 XIPINRU/An3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="151658785"
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="151658785"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 09:38:03 -0700
IronPort-SDR: a390YBMeuM5i7xZAbQQ4UhnPUKERJ52ao3wjAL93JZmEVD0Y3/1HI2hkINV5yYgfYpn2Zk9z+6
 rEDR8xVfFhQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="495572232"
Received: from marshy.an.intel.com (HELO [10.122.105.159]) ([10.122.105.159])
  by fmsmga005.fm.intel.com with ESMTP; 12 Aug 2020 09:38:02 -0700
Subject: Re: [PATCHv1 2/2] crypto: add Intel SoCFPGA crypto service driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@kernel.org, richard.gong@intel.com
References: <1597154182-26970-1-git-send-email-richard.gong@linux.intel.com>
 <1597154182-26970-3-git-send-email-richard.gong@linux.intel.com>
 <20200812003418.GA4166@gondor.apana.org.au>
From:   Richard Gong <richard.gong@linux.intel.com>
Message-ID: <7850a3e6-1ac2-c13e-94cb-64adfb6c6898@linux.intel.com>
Date:   Wed, 12 Aug 2020 11:52:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812003418.GA4166@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


I will move them to drivers/misc.

Regards,
Richard

On 8/11/20 7:34 PM, Herbert Xu wrote:
> On Tue, Aug 11, 2020 at 08:56:22AM -0500, richard.gong@linux.intel.com wrote:
>> From: Richard Gong <richard.gong@intel.com>
>>
>> Add Intel FPGA crypto service (FCS) driver to support new crypto services
>> on Intel SoCFPGA platforms.
>>
>> The crypto services include security certificate, image boot validation,
>> security key cancellation, get provision data, random number generation,
>> advance encrtption standard (AES) encryption and decryption services.
>>
>> To perform supporting crypto features on Intel SoCFPGA platforms, Linux
>> user-space application interacts with FPGA crypto service (FCS) driver via
>> structures defined in include/uapi/linux/intel_fcs-ioctl.h.
>>
>> The application allocates spaces for IOCTL structure to hold the contents
>> or points to the data that FCS driver needs, uses IOCTL calls to passes
>> data to kernel FCS driver for processing at low level firmware and get
>> processed data or status back form the low level firmware via FCS driver.
>>
>> The user-space application named as fcs_client is at
>> https://github.com/altera-opensource/fcs_apps/tree/fcs_client.
>>
>> Signed-off-by: Richard Gong <richard.gong@intel.com>
> 
> Nack.  This driver has nothing to do with the Crypto API.
> 
