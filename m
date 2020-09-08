Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732C6C43461
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 10:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2320720759
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 10:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="D+RzrvrV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgIHKf6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:35:58 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:2080
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729600AbgIHKfK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 06:35:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6ri6EPGt7YWj2QSBGMAhxfSad22OtId1PKCSyZ3ByvHUHS1PYFoFrDhP1IE/MyBVshwyrmbIv7YGlvFV5fCvXF308If4Mx6Q3vm+56xt6DjvySE7rxN6KhlEMluNIkIBbc27BIDImVDLzJR2Tt2PlpKLYPobb73W3o24praHNd6eqJ1FLtwop4UtLBe1wCXdEsJSxw4B6pcJdhwIWrH2hAm12OfI1lv2jMULRl7wMHVcB/3iSg+k6apCuTWA3P58xzHRff/8ZWsqnroIGXWMuUGLPu86748bKsc6uMwcaVfrIGMWJFqmuM6LRCIwEaEYbX7ILupXKkfurizxXYI9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGtT2eaNTqnN9FbQuMB8Bw1+CUSikWZBhlBWY9yKaBo=;
 b=e+iYaLakCqKxQmfTrXL5or9Z7X3pl/7T7EJKbq89OWfNgSmU2RpH4CqVBK4twxWcJTp0UZssP8lj1K3/yeJNBIPHs6WaSkyzu+DwktyFL8gf66w5D4w4Qwnou8xECgiV9FyHyWhKqPQ0AY7DpkK8awG9Qq4EjCpCFFcoFoioRkTyo3T1pLDQisqyUG9+sq7J7TImdpYN8jpTgwV4vLtC6grpw1k0RfjfzeWHgl38DaFicqpgpeM3tOh5ZKRe/ziyOe6UaPF3ugyHKeFcnC/eSf8GqrbVHWNxnYk75+E4vhQ2u3OWW+RuJbTkXKzIofzH823YN+b3sWXP1F9PXvpmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGtT2eaNTqnN9FbQuMB8Bw1+CUSikWZBhlBWY9yKaBo=;
 b=D+RzrvrVv12jTTyxBUUzU5FTO1Z1gDc7IaCS7MUKM9BsBb4K2GKs3pHB4fvH15hrIQZvylNTy94en8U/3u7ox7v+8+zMwj+No73Cu4KuQdFXpx3Dt56IN6VXJAfHUGyhTx/kry5bbx2W1pgHntdcsd19zd/R5qS3le5GMFG7yOE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Tue, 8 Sep
 2020 10:35:07 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8ce:6a19:696b:4f11]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8ce:6a19:696b:4f11%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 10:35:07 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
 <20200821034651.GA25442@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com>
Date:   Tue, 8 Sep 2020 13:35:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200821034651.GA25442@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::43) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR01CA0102.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Tue, 8 Sep 2020 10:35:06 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93a57c35-2a0c-4a20-da7f-08d853e2daf5
X-MS-TrafficTypeDiagnostic: VI1PR04MB4046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4046B83A8294E6D1E58BD98E98290@VI1PR04MB4046.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwW31kmK9IlcezBoOEli38KbLEvFOsexCIH1IPUb7lsPu5dSwEhdHDzoWdTbApBSKlPYk4c3x3S09CedDcbdA8kwkKYOX8PtSq9r90XGiqynfzPGyHi61JQ56AF0uEKtbDnDAv4ayV+QmoC3v+7D8LD5At2pFF8qSc9DOlQfHBS+ZRFvHKQ6UGva0CkTg6qWGetASmjftCx9OWPaf2XONbv7t9n+xRqZvZU5OVMULu+Kua66fAdqb9vkQQCJ69B4S+zJnEqcERw/WaZyhVoPx0pVaczQ78Tip9FbIDi94RfLSUE5OHa0h8+r1Xc+hvwi2UoglWiq4YNyKFkYteMeBll/etDDEo7dGnuh6resOPwzrDWIHqZ1ReMQYDgj2MrpZSLkFiRkdcqPxGaEAXCH3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(316002)(31686004)(66556008)(53546011)(66476007)(16526019)(26005)(8676002)(36756003)(5660300002)(66946007)(52116002)(4744005)(186003)(4326008)(478600001)(956004)(2616005)(8936002)(86362001)(2906002)(54906003)(83380400001)(110136005)(6486002)(31696002)(16576012)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jSnuCNRl7g3RcRTMeRq/yT9JWAI9NTPdYR4sjg3JTURAG5TnXMShu6FZEeOmJSDW45owyeu4K6Lr60AVTX2+rme7UwPqiBCLJQ77xlh5HipJfJLaSovqkBT9Ex51X+tACUy78CxEsks4yVN6oC2r8djkqACko5dk5D12xFRsZpCScBcDrtWoAYLOHwPKAIHruggU38vjNP7Gt9izKNFMqardPG1cOx0pi1AUp9z6LjmmueItLr4naJhLFPNVC643ilgTAXTUjtN0PGlG6EgWbGSrNrs2KQ45VwdCR+BONa4ri9ea6CDlZCMOUGQpr3GFEZDX6DlqTChcriWvJ4wJZhE37XqFtziy+GCqCBFxzxrg4jc6bcpzuTqgUPD+JBo4PksjqT25Y/QQR8TR7Scuy4McyHd3xCnHhG2voNvQ9bj24h5sVMWvuuraTREVhpRfVWH64KYdHXmChb25MWEhuC6dUbCD58JjDe6O7TStGw/+R5rQLaX792SlBkUgPLcUKBixQPVrei8DV4hmDZoYpNfyoymqGy7ceQe+N+P1l9ZqNhet98oGiSsodoJPOSnYJXeswXID6ZeWgJ6oBjoAElFv6Ep0X1Nn/qlMs5Bo6WUNApy7teYY/Qy5Xp/RD8H9Dva1YXiq81D1ib36iWboQQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a57c35-2a0c-4a20-da7f-08d853e2daf5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 10:35:07.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QTL/BOPBsN16RdYUm8HPsQrpaGIfGpK7ATYVbfl5mTb/SUOJNbkV787xrQmMPF/3tFa0UFIID6ed/+4rSUbXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4046
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/21/2020 6:47 AM, Herbert Xu wrote:
> On Thu, Aug 06, 2020 at 07:35:43PM +0300, Andrei Botila wrote:
>>
>> +static bool xts_skcipher_ivsize(struct skcipher_request *req)
>> +{
>> +	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>> +	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
>> +	u64 size = 0;
>> +
>> +	if (IS_ALIGNED((unsigned long)req->iv, __alignof__(u64)))
>> +		size = *(u64 *)(req->iv + (ivsize / 2));
>> +	else
>> +		size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
>> +
>> +	return !!size;
>> +}
> 
> Just go with the get_unaligned unconditionally.
> 
Won't this lead to sub-optimal code for ARMv7
in case the IV is aligned?

Thanks,
Horia
