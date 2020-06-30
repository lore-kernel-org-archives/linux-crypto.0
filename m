Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75E1C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 06:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBC7207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 06:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="JyQ9AdqB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgF3G6U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 02:58:20 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:24605
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730386AbgF3G6T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 02:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl16OSJutlk6UFhPW0jVN3DmQZCViJ3vA7wIvrJnAtEryTvyP4s7l0G9aWT/uaCX9S+XGURIupYx3C9aI7K5pN2zBRfODuUTUo4sdA9R1RgMVJ9Xd9zF28AI+Kp5+47+hkO9V5E0ysZVTF1U9wHfrIRDq61G4u4Cj26ZTm8z8JE/rO1Wy3fYVO5g5YCk5Dg3hT4qFFSc7XFlkCMwhj7Qic7/KARp3cRzQbUa+meFtx24otenT+XHtnKCnVvCTmUNJIYEuiH20zXQxNj+ZsWtQMFkuwHA4kfXLA7/b6pagJ4h+mN3ZFCwViw8gbO79fvOuAnvC+gzc5EvhlO8NcFWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=So5LTOQWHW4mhODsziNwdLa5IzAtubQ3gozwzNfdUjo=;
 b=WezUQOZYMLUc5Ml8ogZ5UX0/EVH7roSjY74rUhbgNpeS7rPW5MBx2hu0/mY4YZt2ejRpvAHPgaQydc7QFYB8fq8y6lUNPN4dP1N12LP8IGRHqt7ZxRWak/4Ie1skXNxED7S8cV38KSD5SuqgZyruf+sNKa1JVTgiJOiCOzsRzKpDN+A6IDVbP0T2ID3nXCZbsex3ks0UH4aPkdl1Q0gAn9TWuHdZIHfYpuNYJ42u4+huU73wmjlXJjaS+mMWFpuFTueI+8tTYF+oRpFq5TZXrf0mne5Oqs6AIGU3tiHRF32UadPvK8jYBV3szT5YBf9AA0LqfJJTUCGVzn26miYjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=So5LTOQWHW4mhODsziNwdLa5IzAtubQ3gozwzNfdUjo=;
 b=JyQ9AdqB9TlUiCU01xW+OvB/FKmLYltemdqUTL/vwFjylYIZ8W1dppxdsNkyyqvWnu2r22oNbL1Z1sy3Lqwm4A4UAS4YZ7EZ88hngNFcFBfgejYBAJIgh0U+UbrsQ7gTTK29TYv/gYdIvkBM/GKantInu/meMBv3Ji1QCuavl2Q=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=silexinsight.com;
Received: from DB8PR09MB3625.eurprd09.prod.outlook.com (2603:10a6:10:11a::18)
 by DB7PR09MB2569.eurprd09.prod.outlook.com (2603:10a6:10:48::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 06:58:15 +0000
Received: from DB8PR09MB3625.eurprd09.prod.outlook.com
 ([fe80::d4e7:621c:f9e9:55c4]) by DB8PR09MB3625.eurprd09.prod.outlook.com
 ([fe80::d4e7:621c:f9e9:55c4%4]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 06:58:15 +0000
Date:   Tue, 30 Jun 2020 08:58:13 +0200
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Waleed Ziad <waleed94ziad@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hwrng: ba431 - Add dependency on HAS_IOMEM
Message-ID: <20200630065813.GA1578816@ultraoso.localdomain>
References: <202006292036.INytijnT%lkp@intel.com>
 <20200630042037.GA22429@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630042037.GA22429@gondor.apana.org.au>
X-ClientProxiedBy: AM3PR05CA0151.eurprd05.prod.outlook.com
 (2603:10a6:207:3::29) To DB8PR09MB3625.eurprd09.prod.outlook.com
 (2603:10a6:10:11a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:f120:e291:cab8:eeed) by AM3PR05CA0151.eurprd05.prod.outlook.com (2603:10a6:207:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 06:58:14 +0000
X-Originating-IP: [2a02:a03f:a7df:f300:f120:e291:cab8:eeed]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cba67845-2a65-448d-729b-08d81cc2f5f7
X-MS-TrafficTypeDiagnostic: DB7PR09MB2569:
X-Microsoft-Antispam-PRVS: <DB7PR09MB25694D5D3B79D8943BB296AAF46F0@DB7PR09MB2569.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9WLpIBxLeYLWckk0dCgp7QTWUwABfpnk0F4wUP8OcmLiczPpuZzJtshKda1Gn45O31F2CDUbsUF/tQnR3yyyB6FKFHljdZNhzyKdY0hQ5uKvGS6yCKtfdyUm4Luv7NjR6SoK/ja0COo+OM3TqBWeFgdilf8+CnIQf+NCsQ4sDwnXteZDqJVmurUppFPyFgL6/qu8hFAH+SIL1PS1LGtaFWR/adjv3CwVSJGBhIDqUEDYtDgi+4XdNn+rr/f6/fZbSPXqnqtYit7LPBVLEQiir00kOoONr1jOztj7YNmgTZ0gzRyiFmsCKMISBPDjzuprzYIjOx7Fq7qA9tCotkgvDPWnnQkdrzYK/QOfhV1gHPXsFGDI8HRQe5n8V0cZQ+19D2evtL2DcxtltnbtG6WQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR09MB3625.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(346002)(39830400003)(366004)(136003)(54906003)(8676002)(5660300002)(1076003)(86362001)(8936002)(16526019)(83080400001)(186003)(66946007)(316002)(2906002)(44832011)(33656002)(966005)(66556008)(508600001)(4326008)(6916009)(9686003)(66476007)(6496006)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fdRWS/DOAkc4/hJMTKvnXPxVtTERqggaSRt+ncT0wWldnzwY0SgG4fGZ5xLc/kJ2oaxK9jL3q9B73nokmcbkcZaDW2Ma7BTrml0WgFlJp2r5QVoKrjzkBNYeR6zkShrJLzws9CNrFIIhf5wvjcDeTvKWZOGuRzwiPVVgcT/F1e9xi02d9DscIRQAfBiaM3uE/RBzrO1iHalm7hAJXufpQTlwQDQGLX9NQJEiC4/6uJPqWn2rXjKwfM0En2Jy9U5aRhr93xS8QMmgOZq//4uJw5bGuSCEZmy12eJe1FH7mC3IFaGNEOtyr1dTIfkyFtNKlrmtEOKb1JCiEjtIXCOGaZvG8F7fW/Y1mYFTaa+tBQOkXBNBcQnsv+IIOJsxgI7941gVU5kTp+nxPl2MkGGfLWZKn1rNE3DWNbt14K3wTN0gimTB4TATgSOr68+3pcCPHisEv627ZY4yPC9e/sIAnkBh0XrfH+Dy5VjaZNRC+9/cwCeH+orxTm8sCZNRKONtrflF4szAz3udmBu73otAaiayq/9gJyAa/y+or1+XA1nGQKSjC+BkUh6KMj6crYRk
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba67845-2a65-448d-729b-08d81cc2f5f7
X-MS-Exchange-CrossTenant-AuthSource: DB8PR09MB3625.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 06:58:15.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jiP0uK6f+g1QFXSmdMFqiGxK06ZF25SuRLJtveevglYK/nFNLNrdUt8/iMj74o1DKaCytu+MoF2uliv7rdroA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR09MB2569
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:20:37PM +1000, Herbert Xu wrote:
> On Mon, Jun 29, 2020 at 08:46:38PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   c28e58ee9dadc99f79cf16ca805221feddd432ad
> > commit: 0289e9be5dc26d84dda6fc5492f08ca1ff599744 [1846/4145] hwrng: ba431 - add support for BA431 hwrng
> > config: s390-zfcpdump_defconfig (attached as .config)
> > compiler: s390-linux-gcc (GCC) 9.3.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout 0289e9be5dc26d84dda6fc5492f08ca1ff599744
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    s390-linux-ld: drivers/char/hw_random/ba431-rng.o: in function `ba431_trng_probe':
> > >> ba431-rng.c:(.text+0xd4): undefined reference to `devm_ioremap_resource'
> 
> This patch should fix the problem:
> 
> ---8<---
> The ba431 driver depends on HAS_IOMEM and this was missing from
> the Kconfig file.

Indeed, it was missing. Sorry for that and thanks for the fix!

> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 7b876dfdbaaf..edbaf6154764 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -76,6 +76,7 @@ config HW_RANDOM_ATMEL
>  
>  config HW_RANDOM_BA431
>  	tristate "Silex Insight BA431 Random Number Generator support"
> +	depends on HAS_IOMEM
>  	default HW_RANDOM
>  	help
>  	  This driver provides kernel-side support for the Random Number
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
