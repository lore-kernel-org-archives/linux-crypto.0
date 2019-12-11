Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C040C00454
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 13:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F89421556
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 13:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfLKNdt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 08:33:49 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37251 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729438AbfLKNdr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 08:33:47 -0500
Received: from erbse.hi.pengutronix.de ([2001:67c:670:100:9e5c:8eff:fece:cdfe])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <bst@pengutronix.de>)
        id 1if27d-0001zF-83; Wed, 11 Dec 2019 14:33:45 +0100
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
 <c0fa1e68-107d-f9ee-fbf2-0d0e6ef8d39d@pengutronix.de>
 <VI1PR04MB44458A1566067B5456337AEE8C5A0@VI1PR04MB4445.eurprd04.prod.outlook.com>
From:   Bastian Krause <bst@pengutronix.de>
Message-ID: <56aa6894-6df9-1ade-6c22-cccb99172d2a@pengutronix.de>
Date:   Wed, 11 Dec 2019 14:33:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB44458A1566067B5456337AEE8C5A0@VI1PR04MB4445.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:9e5c:8eff:fece:cdfe
X-SA-Exim-Mail-From: bst@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hi,

On 12/11/19 1:20 PM, Iuliana Prodan wrote:
> On 12/10/2019 5:27 PM, Bastian Krause wrote:
>> On 11/17/19 11:30 PM, Iuliana Prodan wrote:
>>> Integrate crypto_engine into CAAM, to make use of the engine queue.
>>> Add support for SKCIPHER algorithms.
>>>
>>> This is intended to be used for CAAM backlogging support.
>>> The requests, with backlog flag (e.g. from dm-crypt) will be listed
>>> into crypto-engine queue and processed by CAAM when free.
>>> This changes the return codes for caam_jr_enqueue:
>>> -EINPROGRESS if OK, -EBUSY if request is backlogged,
>>> -ENOSPC if the queue is full, -EIO if it cannot map the caller's
>>> descriptor, -EINVAL if crypto_tfm not supported by crypto_engine.
>>>
>>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
>>> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
>>> Reviewed-by: Horia Geantã <horia.geanta@nxp.com>
>>> ---
>>>   drivers/crypto/caam/Kconfig   |  1 +
>>>   drivers/crypto/caam/caamalg.c | 84 +++++++++++++++++++++++++++++++++++--------
>>>   drivers/crypto/caam/intern.h  |  2 ++
>>>   drivers/crypto/caam/jr.c      | 51 ++++++++++++++++++++++++--
>>>   4 files changed, 122 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
>>> index 87053e4..1930e19 100644
>>> --- a/drivers/crypto/caam/Kconfig
>>> +++ b/drivers/crypto/caam/Kconfig
>>> @@ -33,6 +33,7 @@ config CRYPTO_DEV_FSL_CAAM_DEBUG
>>>   
> ...
>>>   
>>> +static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
>>> +{
>>> +	struct skcipher_request *req = skcipher_request_cast(areq);
>>> +	struct caam_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
>>> +	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
>>> +	struct caam_jr_request_entry *jrentry;
>>> +	u32 *desc = rctx->edesc->hw_desc;
>>> +	int ret;
>>> +
>>> +	jrentry = &rctx->edesc->jrentry;
>>> +	jrentry->bklog = true;
>>> +
>>> +	ret = caam_jr_enqueue_no_bklog(ctx->jrdev, desc,
>>> +				       rctx->skcipher_op_done, jrentry);
>>> +
>>> +	if (ret != -EINPROGRESS) {
>>> +		skcipher_unmap(ctx->jrdev, rctx->edesc, req);
>>> +		kfree(rctx->edesc);
>>> +	} else {
>>> +		ret = 0;
>>> +	}
>>> +
>>> +	return ret;
>>
>> While testing this on a i.MX6 DualLite I see -ENOSPC being returned here
>> after a couple of GiB of data being encrypted (via dm-crypt with LUKS
>> extension). This results in these messages from crypto_engine:
>>
>>    caam_jr 2101000.jr0: Failed to do one request from queue: -28
>>
>> And later..
>>
>>    Buffer I/O error on device dm-0, logical block 59392
>>    JBD2: Detected IO errors while flushing file data on dm-0-8
>>
>> Reproducible with something like this:
>>
>>    echo "testkey" | cryptsetup luksFormat \
>>      --cipher=aes-cbc-essiv:sha256 \
>>      --key-file=- \
>>      --key-size=256 \
>>      /dev/mmcblk1p8
>>    echo "testkey" | cryptsetup open \
>>      --type luks \
>>      --key-file=- \
>>      /dev/mmcblk1p8 data
>>
>>    mkfs.ext4 /dev/mapper/data
>>    mount /dev/mapper/data /mnt
>>
>>    set -x
>>    while [ true ]; do
>>      dd if=/dev/zero of=/mnt/big_file bs=1M count=1024
>>      sync
>>    done
>>
>> Any ideas?
>>
> 
> Thanks for testing this!

Sure :)

> I reproduced this issue on imx6dl, _but_ only with the bypass sw queue 
> patch. It only reproduces on some targets, e.g. on imx7d I don't get the 
> -ENOSPC error. So, I believe there is a timing issue between 
> crypto-engine and CAAM driver, both sending requests to CAAM hw.
> I'm debugging this and I'll let you know my findings.

I can't even use this without the "crypto: caam - bypass crypto-engine
sw queue, if empty". The mkfs.ext4 command does not even finish and I
see hung task warnings. Am I holding it wrong?

Regards,
Bastian

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
