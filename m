Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB16C2D0E3
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 00:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79FFF20770
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 00:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KfmuBDn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIPAck (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:32:40 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:47328
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726692AbgIONnM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 09:43:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anjLg2mCVIkBhCubO1KYQi+TQGlENzx87L3AcATvMl1s0Ryou9nKtkZyX+OXoNM4k3duyGgLazmsgv09EUs4AqGPcHbeA+i8rjMpw3DGdtziqrEU0JL9SOOoZ6ws+UGX1nMBZreSYG/FGu7HSxxErBDg+SFfsFw+1+4XJWThoyYyofyFAfWl7P0S9K+0sVlyWI8Jn1Mtlyl+1Gabywgr0W6GMJ8O1Fkxpbzz+ZX3yBnXBQAzwOraQc82JFFiJ6FYc7mu+Q8hj734mVCJEbaj+pi1wKzSqKJAqp0a2unSXQv5kxvI1EclS7dBz/14VThapHbQFWExbBKIL2BxjjGodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfIzzJfnlwzS1O6KF15C/nM836f8X4rxAxNIEtRdRGs=;
 b=StTZ+Xt7IjmgmzE1DEtAQmA0DcWOAoawMDHn2fWC/50urI7J+RVZoSRIxvy2TUDn535TgxdH2kY7cfqkxIQrKvNBgPKu69CXxeQ6JJuDSdHlZAQPcNIRC2iOqB/wcjC9nhdk9L9I6YGgjKB8kBrcXqqvNgvYfvd6tae71yNvGLhGj+muARtUEWitTkg612F5Y8V+uloYbLqhmueyY6JXjw+F7HkEJ/W3gl6/U7/aMj5XeoDhzpE2d4KQfbaWFB8fK0YyohEDujUUXwdRZctYiKAdonGmdcBNjjc/wQ7evvtm8JBTBhLItdNDPNhNUj2Xh5fqEneQfu/Rd1CNO9RFQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfIzzJfnlwzS1O6KF15C/nM836f8X4rxAxNIEtRdRGs=;
 b=KfmuBDn04tCrelWEpKVRmXG7ZWFfpzNb/ObKET8AQCV2p6BAoU9Nw/kmNpNXL4UgSzXPY8OL2PDICP02TuaCQHFHqiKhPjBDa2S0Z/bfkSIrpQxxYIvdE865cuXf4jwK8w0EncfHWN5sdG0feLdbHA9r8PsdQHXnYenfwpmrBZw=
Authentication-Results: sigma-star.at; dkim=none (message not signed)
 header.d=none;sigma-star.at; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7118.eurprd04.prod.outlook.com (2603:10a6:800:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 13:42:51 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 13:42:51 +0000
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
To:     Richard Weinberger <richard.weinberger@gmail.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        David Gstir <david@sigma-star.at>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
 <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com>
 <CAFLxGvw4zvL0N5+wChKq3=_xLuuCYLKDOyKKnKFy3UiWMUwf-g@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <ffc5254a-cecb-20b8-fca3-d2cd8486362d@nxp.com>
Date:   Tue, 15 Sep 2020 16:42:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAFLxGvw4zvL0N5+wChKq3=_xLuuCYLKDOyKKnKFy3UiWMUwf-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0061.eurprd03.prod.outlook.com (2603:10a6:208::38)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR03CA0061.eurprd03.prod.outlook.com (2603:10a6:208::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 13:42:50 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e76d6ce7-fa85-48d1-60d7-08d8597d3daf
X-MS-TrafficTypeDiagnostic: VI1PR04MB7118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7118516BD925A430810F6C8D98200@VI1PR04MB7118.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13z60fXiYNRHP1dRenz9ABmUcOVhcnzU6kSqwNOpdPGdfnm9rrM6Cu1mvcXAMZWVG3HJ0X6al+tmp1mWUMFrlEMx/jW0+TiddaDURjMlkU/c8o+fqe9lp6NJT3G+EVP8kR6T1djqv6Tqqxt8Be/svfEkyOP0H0LMBfOtOvSxsEoJTmEOgAsqLbBWYmltLsXkbSdoLKFJOs2U0HYI/QyCCGA1waXscGXHjJJ60HgTFCPck7DAIk5bizpi+0E4HDXVsg6bbQq+XpzF8CncfbbQ6srMUPpKQNVMua+zxyruvey3nyi6t+C6Ihfaz5PC0wFage+xQB0ATtM6gu5n71FsOsitJOSWncj5fs4ZLHQTp8vMgAmYzt021nkU9j63/UoKOrzstUjDggVHQRsRB11CHevK4ayApM9lwf/Rgyn8opNERWMlw6RgCShq9xRysJ+vKA6iIubPFVMWUfSsveAXvDuJphDSAHJVeJ+hye2waJNlQuQg0ljjXkg71/WeUOKx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(186003)(66946007)(66476007)(66556008)(52116002)(86362001)(31696002)(36756003)(5660300002)(53546011)(2906002)(8676002)(83380400001)(6636002)(26005)(2616005)(956004)(16526019)(478600001)(16576012)(316002)(54906003)(8936002)(110136005)(6486002)(966005)(31686004)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z1tnUoOXTUlJe0gXCzRnUijcxakwrX/zysRx1I/3fwlNy1ktkG2ISRw4w1ny/ELvZlNgzlNHGii07NTuEgVQdhBW6oUSSK6viB0LvCCUVBFsXxSbfJygGqNODr5XMav6eBRJEbnVPblYxGRsug0bKpBgi0FteNx3XNvdSaaGn2ZQ9iSK05pHRiZn2gnIlNZNICKkcRZU0ES0eotCoAoLn5WB3Ug1utyKAIe/C8NwF6PCmw416X7MbAaYRvCZyM9cozBlDrDpZopLywi1BD9OTJeWn9fzq4+HdOaLULeaKwZQQiSVp0N0EY8veW7x/hbvBwMGZ+3N/szPttRhqxWZ2zsYuid8qOW1f3q9IXp80aIl2lk00ZvZebNwx2ztnfh9zRJM01zKB/LvctoKl1fdPZLrIdHWDttnin3zgNbGATQqMk1e938ZlR8D8N3cUgkz/Uyp91lz+7nKHKEN/BC2jiru7dB1CalW8827RKhReB0a9iSKSPgcANgmNEqWKPe35xGli2ZsyEww+p+NlXmA5IOOzGjgG1tvCL0Oa/EzI+rHS00vYNOKJPoxfdnxzbEFST2YV4ova+BzzFzXIJPAAtOdl/EUl/vDADc81mQrro43UYboxxRjmIRXLT/XbRSfSljMCe4idvAw9o+RMnQcvQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e76d6ce7-fa85-48d1-60d7-08d8597d3daf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 13:42:51.5591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzRjcukLNCEaHB3zEZ455aHVfPcZSp6ICyQbXmc8UIhBFs5DZzAwBGiMOMBzuSP5aW5qpE8ChoUu6PN6WYiPLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7118
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/14/2020 9:38 AM, Richard Weinberger wrote:
> On Thu, Jul 16, 2020 at 4:12 PM Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>>
>> On Mon, Jul 13, 2020 at 12:09 AM Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>>>
>>> Tagged keys are keys that contain metadata indicating what
>>> they are and how to handle them using tag_object API.
>>>
>>> Add support, for tagged keys, to skcipher algorithms by
>>> adding new transformations, with _tk_ prefix to distinguish
>>> between plaintext and tagged keys.
>>>
>>> For job descriptors a new option (key_cmd_opt) was added for KEY command.
>>> Tagged keys can be loaded using only a KEY command with ENC=1
>>> and the proper setting of the EKT bit. The EKT bit in the
>>> KEY command indicates which encryption algorithm (AES-ECB or
>>> AES-CCM) should be used to decrypt the key. These options will be kept in
>>> key_cmd_opt.
>>>
>>> The tk_ transformations can be used directly by their name:
>>> struct sockaddr_alg sa = {
>>>     .salg_family = AF_ALG,
>>>     .salg_type = "skcipher", /* this selects the symmetric cipher */
>>>     .salg_name = "tk(cbc(aes))" /* this is the cipher name */
>>> };
>>> or for dm-crypt, e.g. using dmsetup:
>>> dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
>>> crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
>>> sector_size:512".
>>
>> How to use it with cryptsetup?
>> I'm asking because it is not clear to me why you are not implementing
>> a new kernel key type (KEYS subsystem)
>> to utilize tagged keys.
>> Many tools already support the keyctl userspace interface (cryptsetup,
>> fscrypt, ...).
> 
> *friendly ping*
> 
We didn't include the key management part in this series,
just the crypto API support for algorithms with protected keys,
to get early feedback.

Wrt. key management:
The NXP vendor / downstream kernel (to be included in i.MX BSP Q3 release)
will have support for protected keys generation.
Besides this, a dedicated ioctl-based interface will allow userspace to
generate and export these keys. After this, user can use standard keyctl
to add a key (as user / logon type) in the keyring, such that it would be
available to dm-crypt.

We know that adding new ioctls is frowned upon, so before trying to upstream
the ioctl-based solution the plan is checking the feasibility of
extending keyctl as David Howells suggested:
https://lore.kernel.org/lkml/8060.1533226481@warthog.procyon.org.uk
(Note the difference b/w adding new key type - which was rejected -
and a key "subtype extension".)

Horia
