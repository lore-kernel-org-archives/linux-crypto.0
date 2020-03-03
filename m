Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F16DC3F2CD
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B63620863
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ESw9VRPz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgCCM3V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 07:29:21 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:49319
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727961AbgCCM3V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 07:29:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MA+aJ7wcAD9le7ZyXH9I1bt0N6bzqAWijO/lBY+F6p/zLMC2pGAb5bxub50TXojWDf8urYwkXx4xFbBlKK7BGSGFlFyRY9HILksKo9Ymu1n4wFx5paNY0VnOayAxgUDLdlyCCfcwMI5zbMJCVItMseIWXbHjK7e+qiw4LFoJvJ68PmYNminwKLDtKpAJ34Vph6/3OwO+59XBQAJNpV8uEV1rYNQFpjEUckVRMzoPDInv5oSkddiDYe/W+Ir6zjf9LM1gJgyF+hWP/36luTIQJAZ5C4SHVgtPIhyD8d5K0kK97Zms3csvijvL5+zu4wP42Kw1FcZsXw5ITw8A977Crw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsfxtGDV8B/b1TW5cDoes0QLlVOTRIFlyejpIhxREBE=;
 b=dTnMYN5L+VVaX2+vA0cUSwgHHl77lFUNWaYgI3IV+9Ez3viMRw3loXCa9aSdVcetroH4IcGESOULpKmANHstGl4Y6QuwMn+01nehu/TMY1t6PE2pT+cQ3keTlft3thHxS/fkiVnkkAR09n7qLslU+ytdRwmGQLtfYocky7qVV8B4CKdjg/etOMwGB1ATrY8JsG/8vsmW3WCXcMPdy7nc4zg5sA/IhWPg0ycX+wHxTQCoqeXRkRbyK21Fowfy9QlXR4vnzOiw2vejhkU159aLLKdseqFSaayGT/SpwDJ3sKNRCz2VlR6M9O3AAHaNpHCqlUDsL4jBEICWV2EiQjSILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsfxtGDV8B/b1TW5cDoes0QLlVOTRIFlyejpIhxREBE=;
 b=ESw9VRPzcNEFW3Fcqpjf+A0BKdgSknwq2NA1km00eAQts1a1yxC4hPyn67sYvYa1XrkK6IBRxbjt9kO+dGCYIyXBQuVsBONZRNY+CsZkNooNusVctJUV6cDmIg+o/GEzFNZy2VJsvxyQRi1CHtvyuFhmWlA2U193X6VtDDHMsqY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com (20.178.92.210) by
 AM6PR04MB5414.eurprd04.prod.outlook.com (20.178.95.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 12:29:15 +0000
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e]) by AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e%3]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 12:29:15 +0000
Subject: Re: [RFC] crypto: xts - limit accepted key length
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Andrei Botila <andrei.botila@oss.nxp.com>
Message-ID: <8e562721-c713-34ef-6201-a662fce0bead@oss.nxp.com>
Date:   Tue, 3 Mar 2020 14:29:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0034.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::47) To AM6PR04MB5430.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.171.72.203] (212.146.100.6) by AM0PR01CA0034.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 12:29:14 +0000
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca09df89-5f93-41b2-2c1d-08d7bf6e7c5e
X-MS-TrafficTypeDiagnostic: AM6PR04MB5414:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB54144BC5DBBFCE19079D4DF1B4E40@AM6PR04MB5414.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(6486002)(52116002)(44832011)(2616005)(5660300002)(956004)(31686004)(54906003)(66476007)(66556008)(31696002)(16526019)(478600001)(316002)(110136005)(16576012)(8676002)(186003)(8936002)(4326008)(81156014)(81166006)(86362001)(26005)(2906002)(66946007)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5414;H:AM6PR04MB5430.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwm5qUZwkDKlDFnx9i5NAPEVGySApH+yOpfE48VBKUPdlKF+4ZbLrNgiTJd5HDyVLgQDTux9I/xh69T5fDpf5R+57eEh794+MP5N8sYMd1rXhz+945LPRfSUKQSm7FOiJjEXZJB54F+VUsusk9HcpLx9nQ2qzLuY7ip3Me5RuP/2C3O/BskMLFyoVL3nahZXhSXO6PCi4LeL5ZavLHKrKKi2nMiAI3MMhSuB1uZiYY2x2y2pFSrpskoo1y7y7MuLkRFbLyD7QYNBDsL87pylJIZ8+Ths+W7wSsevCTaEdL+2c0r+2QSb5I5ZZrf8zI3UVL7sikyDg/IuSD4G9rd6A+d9iJiNdrdicX663Wt4nGfPniFwJYnrJd689oAFi0gc+ytvCd1kWYXbK2oZ876gblws3HUkqZmFPfDAWZZXURXvl+7TJk6inyZVgl3PoVYmjKLYUrWhLZ1BfvKh3S9ansCimV2WNPmhB45xAKZV8ctoqE+iYKlBe0+jJ7BsoQ1TikcJHPDF/Mu9RMZTEcHQjw==
X-MS-Exchange-AntiSpam-MessageData: zmMzi0Owyadp7d5u7GSId5zuL9rYYMTlkN+Wf2PAfaf334ybD5CRXy+ca/sPQa6E8Jt+EzuXvhF7peuLs9XS5g9fOGw8QmFrAcwiCnph60tfLAEkmSjRSNxmB4/l6V0vJ0fqkM6xKE/QnB185Po/Og==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca09df89-5f93-41b2-2c1d-08d7bf6e7c5e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 12:29:15.1777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2HHDDg5FSYi0eDuiVKXDvr9xxe2cs9iWZ7PstTNanHGDpc1qYzr0dYzEumLB02MvdSNLPBZGt0kC9V35HElRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5414
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/2/2020 10:33 AM, Van Leeuwen, Pascal wrote:
>> -----Original Message-----
>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Andrei Botila
>> Sent: Monday, March 2, 2020 9:16 AM
>> To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>
>> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [RFC] crypto: xts - limit accepted key length
>>
>> <<< External Email >>>
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the
>> sender/sender address and know the content is safe.
>>
>>
>> From: Andrei Botila <andrei.botila@nxp.com>
>>
>> Currently in XTS generic implementation the valid key length is
>> repesented by any length which is even. This is a deviation from
>> the XTS-AES standard (IEEE 1619-2007) which allows keys equal
>> to {2 x 16B, 2 x 32B} that correspond to underlying XTS-AES-{128, 256}
>> algorithm. XTS-AES-192 is not supported as mentioned in commit
>> b66ad0b7aa92 ("crypto: tcrypt - remove AES-XTS-192 speed tests")) or
>> any other length beside these two specified.
>>
>> If this modification is accepted then other ciphers that use XTS mode
>> will have to be modified (camellia, cast6, serpent, twofish).
>>
>> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
>> ---
>>   include/crypto/xts.h | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/crypto/xts.h b/include/crypto/xts.h
>> index 0f8dba69feb4..26e764a5ae46 100644
>> --- a/include/crypto/xts.h
>> +++ b/include/crypto/xts.h
>> @@ -4,6 +4,7 @@
>>
>>   #include <crypto/b128ops.h>
>>   #include <crypto/internal/skcipher.h>
>> +#include <crypto/aes.h>
>>   #include <linux/fips.h>
>>
>>   #define XTS_BLOCK_SIZE 16
>> @@ -12,10 +13,10 @@ static inline int xts_check_key(struct crypto_tfm *tfm,
>>                                  const u8 *key, unsigned int keylen)
>>   {
>>          /*
>> -        * key consists of keys of equal size concatenated, therefore
>> -        * the length must be even.
>> +        * key consists of keys of equal size concatenated, possible
>> +        * values are 32 or 64 bytes.
>>           */
>> -       if (keylen % 2)
>> +       if (keylen != 2 * AES_MIN_KEY_SIZE && keylen != 2 * AES_MAX_KEY_SIZE)
>>                  return -EINVAL;
>>
>>          /* ensure that the AES and tweak key are not identical */
>> @@ -29,10 +30,10 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
>>                                   const u8 *key, unsigned int keylen)
>>   {
>>          /*
>> -        * key consists of keys of equal size concatenated, therefore
>> -        * the length must be even.
>> +        * key consists of keys of equal size concatenated, possible
>> +        * values are 32 or 64 bytes.
>>           */
>> -       if (keylen % 2)
>> +       if (keylen != 2 * AES_MIN_KEY_SIZE && keylen != 2 * AES_MAX_KEY_SIZE)
>>                  return -EINVAL;
>>
>>          /* ensure that the AES and tweak key are not identical */
>> --
>> 2.17.1
> 
> Hmm ... in principle IEEE-1619 also defines XTS *only* for AES. So by that  same
> reasoning, you should also not allow any usage of XTS beyond AES. Yet it is
> actually being actively used(?) with other ciphers in the Linux kernel. Which is
> not wrong perse, as the construct works with any block cipher with a 128 bit
> block size. And is secure as long as that blockcipher is secure.
> 
> So why not allow 192 bit AES keys? Or some keysize that some other algorithm
> may require, as I'm not sure all ciphers it is used with have 128 or 256 bit keys.
> 
> The modulo 2 check was just to ensure you indeed provided 2 full cipher keys,
> any other error checking was deferred to the cipher algorithm's setkey.
> 
> Note that such a change would also allow all hardware drivers implementing
> xts to follow suit and report an error, otherwise they will fail the selftests ...
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
> 
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail address.
> 
> 
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
> 
> Rambus Inc.<http://www.rambus.com>
> 
Hi,

The problem here is that implementations adhering strictly to
the IEEE 1619-2007 standard will have problems when receiving
key sizes different than 256/512 bit. Currently in crypto/testmgr.c
when fuzz testing is enabled it generates random keys with sizes
such as 192 bits. This is a problem because it will check the
XTS SW implementation result with the one generated by the hardware
implementations and the test will fail if the hardware is adhering
strictly to the standard.
This is also the case for our CAAM accelerator which is accepting
only XTS-AES-{128, 256} and currently fails when fuzz testing is
enabled and it receives 192 bit keys.
Maybe we can find a solution to limit this key size check only for AES.

Regards,
Andrei
