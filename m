Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA97C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 07:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 197A620781
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 07:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Cmq3OMHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgHKHch (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:32:37 -0400
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:55520
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727852AbgHKHch (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 03:32:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gf9j/2S+wlGeLe5JZw8WCC1eu+FV2dKDgAIys9nmcStl4sQ7gQ9RLa0nV4HeNm+fYcMBLq9tZt4egeFMYSFGNcHWxZOrpSPkRmoHVy6l/Wf+9Rnkv1BlpVGO1wZXffONcHqjY9BoSyIIzafNknqGdhT7gB/jMGj8CA/l9ns+tcbGuyDpCBYBDzeP53VOfBpKaoa7jvlZRAkDKEKhm2EBiaZpbc3cBedkiXcZc/MxvfNiR5PaR8UY5T36Q34CFDdZOAUFgP3nl2Wx4XmqVm8bUc7ZWvsZ9cBhYCjgJFO/8HR3yhSZStgm97kofPoTb3mJVcvp4d8yofiUc5sUoNhQfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9IrFBnsVd6Rmxbd1i+E8oETC7ZXL8lUvoxwH8odKkQ=;
 b=V6zN00xkZ9thxwjk44tpkepKF7UPQVpOVazId7LgSKjWsM8ALX8C2HUCvtC2v1YB0ikC7QbQq6CBAXzWW5+Wz3SJi3JqGOvNt90AjkQHRukt/mYwGbEaCfAGnNdwQbRvTVIk4SjhCdWgvym5TCHK8MzdwGhu1JH6fJDDgokycuu0tPdxap4BVJcPOKBjWE8OTX5goQqNbUOzS/oqWHqoToLoNIWfA3fNL38vOnuzt7oT8s6s8ugszLCuOiLClgHPvtEG1M5ZOwE9tUwa4lfDjpwNfePorO+08V8tW2YyN/RSqJrdWggqFNS2/tDpPPjd6FtPBZHuNdPZfQyCrvK+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9IrFBnsVd6Rmxbd1i+E8oETC7ZXL8lUvoxwH8odKkQ=;
 b=Cmq3OMHSzZnNlTkntK7xXbPaW23tBHgQVOS5AUYFoDDPwFlrrohX4DSNQ8L9HUJmOXGbXD2tZ8JvzvtVc6GnBQUa/Fo9YV64QmAZllAlnPxWZ6fEBd9xnzGU7zYT4me6Vkr9EqpcG1N6Q8csEoM08Ky2NVlSu3YtaDGyn7p/72c=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7085.eurprd04.prod.outlook.com (2603:10a6:800:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Tue, 11 Aug
 2020 07:32:31 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 07:32:31 +0000
Subject: Re: [v3 PATCH 19/31] crypto: caam - Remove rfc3686 implementations
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0JtR-0006Rx-Oq@fornost.hmeau.com>
 <92042403-0379-55ab-ccbc-4610555f0a93@nxp.com>
 <20200811005903.GB24901@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <f8fcd0d8-eabe-b27a-0c8b-a3cfb9f4ecef@nxp.com>
Date:   Tue, 11 Aug 2020 10:32:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200811005903.GB24901@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0005.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::18) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR02CA0005.eurprd02.prod.outlook.com (2603:10a6:208:3e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Tue, 11 Aug 2020 07:32:30 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17c0ad6d-be14-4af3-ebf9-08d83dc8b4cb
X-MS-TrafficTypeDiagnostic: VI1PR04MB7085:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7085CE8634ECCC19C576404498450@VI1PR04MB7085.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTUOhMgHWPrpvkQeTwxPnW1A2AgvSjQkB5Ufm8z3DvbdX+Ywwp4m6fo2e60FS9sbEAMyi8naArCTAl6MVMnLpyeSBiWbUqRj6ZG8OpTiEzl6qj9cfn8kdaWrOgUj6mQR35/ovSJLdIY2LaxquJDxxUGl7FycIJEdTH0GfGC4LdaysGBL1tYxx5VmqOEWxCEcDjSSs4ROwUfu4KNeMlY+gyNoyf16EZC4qPWr/tntw/J5BMUSUCRZHw4GyVSWaNWUcvba6Zj1U37aunAVCA14DR15LMPXEWwH5p0sXapPsc6lSYUTBxZIayz4gR1PitnY+TOP2OwHuAjDdSlGX/yUlFNsY3t2VQ2ibBbxJALffAlIjjQM37ZcMWu/ga9iIk9z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(2906002)(478600001)(31696002)(36756003)(2616005)(956004)(86362001)(6916009)(16576012)(54906003)(66556008)(66476007)(8676002)(31686004)(316002)(26005)(186003)(16526019)(53546011)(6486002)(52116002)(8936002)(66946007)(5660300002)(4326008)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bdxWEzZnpXqI3aSbxXi82vwuO3+5B49tJIQzq78i/wSqX4bulgGebPxAb/8upjYpXnkGLSlPjsqVli626Y7Z5oVo1y9oLF8927gfcVjFH4TOvNt7AOrwJ9PU3L8iMf73zBrJJlgYR0eGu/ppdCrydisrRXq4uh7OJBZboLmR17SnPAxXr4e/+v/xHxzzUbgwtTR9nIXv+oYIqWp4AsARIB9gJiWfJ485N7epAl+4wHJtf4/PiRv/NPezh3uXJlUYji6EDfUZF6CU/OM5I6FnxplqagGbgLJX6Rb6er0aph2BCLMUnOS0pHnDQbNGPd/XGr9BrkrPiDwXeDyNGBnur4I5k9Eboa2LC6ezuGP6ne6ZRpQA76l+CQjnpRTjprE05BvQk5E8iz4UeCJOuAtn2ch2CWyDbdGrp+kzVY7UEWsmMr5/iQhXTOqm1vfsbzCss1wiVlnUdBH3eR0AhBlw1EtWp1kJXT5Em1P9nKzNhgJX/UtJcAtRiTRnIOpDmzZesOkkFJt2kHziY62q4vH5Ahnsbg9UJIWoVMBNNbYEecVV+mzvKmAXPw1D1I54jR3XdBGZhIBLSuNf1qHX8Kc4VraMRSV/UocyY6ehM+9FEiiAK8BeCaI+GgTWANuHYxiInulWiM+x915SgKG41HfUiQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c0ad6d-be14-4af3-ebf9-08d83dc8b4cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 07:32:31.3659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKcZzpwxwMoruf4tFfl8HmpGYLHQYfvcpYdD7+eYZ3jodRotLrP/MqpYQM3L+H8XgSfRMwNUQtDlFkAh5DgbFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7085
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/11/2020 3:59 AM, Herbert Xu wrote:
> On Mon, Aug 10, 2020 at 07:47:40PM +0300, Horia Geantă wrote:
>>
>> I would prefer keeping the caam rfc3686(ctr(aes)) implementation.
>> It's almost cost-free when compared to ctr(aes), since:
>> -there are no (accelerator-)external DMAs generated
>> -shared descriptors are constructed at .setkey time
>> -code complexity is manageable
> 
> The reason I'm removing it is because it doesn't support chaining.
> We could keep it by adding chaining support which should be trivial
> but it's something that I can't test.
> 
Would it be possible in the meantime to set final_chunksize = -1,
then I'd follow-up with chaining support?

Thanks,
Horia
