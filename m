Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E978C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 10:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381654AbiFQKKo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381655AbiFQKKn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 06:10:43 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B94A6A053;
        Fri, 17 Jun 2022 03:10:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E485812FC;
        Fri, 17 Jun 2022 03:10:37 -0700 (PDT)
Received: from [10.57.70.15] (unknown [10.57.70.15])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DB673F73B;
        Fri, 17 Jun 2022 03:10:36 -0700 (PDT)
Message-ID: <a048a5ae-5f1e-d2ea-8152-09de4b6e420e@foss.arm.com>
Date:   Fri, 17 Jun 2022 11:10:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     yoan.picchi@arm.com, andre.przywara@arm.com, ardb@kernel.org,
        davem@davemloft.net, giovanni.cabiddu@intel.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, qat-linux@intel.com
References: <20220617095548.436758-1-yoan.picchi@arm.com>
Subject: Re: [PATCH 0/2] Crypto: Remove x86 dependency on QAT drivers
Reply-To: yoan.picchi@arm.com
Content-Language: en-CA
From:   Yoan Picchi <yoan.picchi@foss.arm.com>
In-Reply-To: <20220617095548.436758-1-yoan.picchi@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Please disregard this post, I sent the wrong patch by mistake. Please 
look at the [PATCH v3 0/2] instead.

