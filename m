Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96978C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 06:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD982082E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 06:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="sgGW2m0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfDLGfV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 02:35:21 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1685 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726690AbfDLGfV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 02:35:21 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3C6SZm9008304;
        Fri, 12 Apr 2019 08:34:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=3E6lxmmL+ajK+PkqQYnkBr6M5CvcG1Gzx6458MHp/D4=;
 b=sgGW2m0g+OkAc06QwIMahbU0Y5P9cS/0t7RHlwBaxw5T1I9ioSTJOwZt8MNE8ghkghcy
 2ewVsLazhcEmFvWweOHukbObWQbU6QAAKJZ90iGmcfSxf03KEQpNTx1WaLTiSWCzhKwz
 aUrtr9K31LH3v5Q0jIY3qW+neGENEO1z6E0Ztef3bFAjKnFkQz8vtZb+Ukkv00PaxFb2
 Jj4QxSB6vNGzQa6CKC0q1LH4sO4mJThAJNemQrIQByxixPckYDpghWYhZVKbQp/r1LUK
 76PdBYx73lNp6Y4CnUMkQOEduXShPd8JCzmlR/I0A27UQYkb8YQpa+37yEVPwx1foHRA zg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rprcftrwk-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 12 Apr 2019 08:34:54 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id ADC4438;
        Fri, 12 Apr 2019 06:34:43 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4F6A211AD;
        Fri, 12 Apr 2019 06:34:43 +0000 (GMT)
Received: from SFHDAG7NODE2.st.com (10.75.127.20) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 12 Apr
 2019 08:34:43 +0200
Received: from SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090]) by
 SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090%20]) with mapi id
 15.00.1347.000; Fri, 12 Apr 2019 08:34:42 +0200
From:   Lionel DEBIEVE <lionel.debieve@st.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre TORGUE" <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Fabien DESSENNE <fabien.dessenne@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH 1/1] crypto: testmgr - call shash_init in crc32c algo
Thread-Topic: [PATCH 1/1] crypto: testmgr - call shash_init in crc32c algo
Thread-Index: AQHU6TRB39TFooeiy0SNdS6nTm4gO6Y3/68A
Date:   Fri, 12 Apr 2019 06:34:42 +0000
Message-ID: <58095a24-8d96-fe7e-0c99-461b015184e6@st.com>
References: <1554123264-24243-1-git-send-email-lionel.debieve@st.com>
 <20190401173056.GD131675@gmail.com>
 <e1f694bd-e0f7-a3f4-426a-894a45c88a30@st.com>
In-Reply-To: <e1f694bd-e0f7-a3f4-426a-894a45c88a30@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.46]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <7FB9AE74DCDC324F891EC099F642EC4F@st.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-12_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 4/1/19 7:30 PM, Eric Biggers wrote:

> Hi Lionel,
>
> On Mon, Apr 01, 2019 at 02:54:24PM +0200, Lionel Debieve wrote:
>> In case of device call required in low level driver,
>> the context must be initialized before calling the final
>> function.
>>
>> Signed-off-by: Lionel Debieve<lionel.debieve@st.com>
>> ---
>>   crypto/testmgr.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index 8386038..4a00d7c 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -2181,6 +2181,13 @@ static int alg_test_crc32c(const struct alg_test_=
desc *desc,
>>   		shash->tfm =3D tfm;
>>   		shash->flags =3D 0;
>>  =20
>> +		err =3D crypto_shash_init(shash);
>> +		if (err) {
>> +			printk(KERN_ERR "alg: crc32c: init failed for "
>> +			       "%s: %d\n", driver, err);
>> +			break;
>> +		}
>> +
>>   		*ctx =3D 420553207;
>>   		err =3D crypto_shash_final(shash, (u8 *)&val);
>>   		if (err) {
>> --=20
>> 2.7.4
>>
> This defeats the point of the test, which is that crc32c implementations =
are
> expected to use the same shash_desc context format and be usable by calli=
ng
> crypto_shash_update() directly after initializing the context manually, w=
ithout
> a prior crypto_shash_init().  See for example ext4_chksum() in fs/ext4/ex=
t4.h:
>
> 	static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
> 				      const void *address, unsigned int length)
> 	{
> 		struct {
> 			struct shash_desc shash;
> 			char ctx[4];
> 		} desc;
>
> 		BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=3Dsizeof(desc.ctx))=
;
>
> 		desc.shash.tfm =3D sbi->s_chksum_driver;
> 		desc.shash.flags =3D 0;
> 		*(u32 *)desc.ctx =3D crc;
>
> 		BUG_ON(crypto_shash_update(&desc.shash, address, length));
>
> 		return *(u32 *)desc.ctx;
> 	}
>
> I think you need to fix the stm32 crc32 driver to not store anything extr=
a in
> the shash_desc context, and only use hardware during ->update().
>
> - Eric
>
OK, catch your point but refering to the devel-algos.rst documentation, it =
seems that there is no way
to bypass the init part. I'm based on a hardware that need a clear initiali=
zation to be up and running.
Is the doc not updated? I'm working to optimized data transfer into my hard=
ware by pushing only 32 bits
datas and I'm saving the others to be pushed later.

If we assume that hardware must be only used in the update function, I've t=
o rework the driver as today,
HW init is made in the init function too.

BR
- Lionel
