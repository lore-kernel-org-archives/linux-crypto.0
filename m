From: srikanth jampala <jsrikanth@caviumnetworks.com>
Subject: Re: [PATCH 1/1] cavium: Add firmware for CNN55XX crypto driver.
Date: Fri, 23 Jun 2017 15:47:09 +0530
Message-ID: <7199698d-883b-358d-a867-9c50559f70e5@caviumnetworks.com>
References: <20170616142226.3950-1-Jampala.Srikanth@cavium.com>
 <20170616142226.3950-2-Jampala.Srikanth@cavium.com>
 <20170622190936.GL13400@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Sreerama.Gadam@cavium.com, linux-firmware@kernel.org
To: Kyle McMartin <kyle@infradead.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0063.outbound.protection.outlook.com ([104.47.42.63]:37120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754621AbdFWKRd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 06:17:33 -0400
In-Reply-To: <20170622190936.GL13400@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sure kyle, I will work on this.

Thanks.

On Friday 23 June 2017 12:39 AM, Kyle McMartin wrote:
> On Fri, Jun 16, 2017 at 07:52:26PM +0530, Srikanth Jampala wrote:
>> This patchset adds the firmware for CNN55XX cryto driver,
>> supports Symmetric crypto operations.
>>
>> The version of the firmware is v07.
>>
>> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
>> ---
>>  WHENCE        |   9 +++++++++
>>  cnn55xx_se.fw | Bin 0 -> 27698 bytes
> 
> any chance i could convince you to put this in a cavium/ subdirectory?
> 
> --kyle
> 
