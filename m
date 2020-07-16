Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FEEC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F84F2074B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MuEkxenW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGPKF6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:05:58 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:7800
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgGPKF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 06:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0Q9jvH2XCnoeYfpasCAdNRl9ZEB0hr7E99RPifFPRUcktThbS+2yJ7LCTpbP+GvzA7Re9sBqjMvGwlZqvFID4jhCZti5hsXR/YPzUhMzg9NkNDZKNwEaqn+8gfOC1pfyhx8QadYZSpHmBkW7XC6cDNIslUgY6hQdpOuHaFUEcOZHcpWPjTgsJfkqrteG8A/SoS2iPt9gWMevkXI5Ax1Acs70fRXp6kUQXlszB4XbF3Sh/xLojfaNI6XXSYPFwXX9uaYXz9veTfKFPiPh+6I7ZwgZEhh92qyLsbpWh+SXEvGDDlZnFUMK3eiZ5HZokpnuXjOpi9hipzXKzt2DU87sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNJIO8obVeIJrzVT8KxU4oRrm/NP91BnlUcEZNKcIHQ=;
 b=NvC2lk8d5fA2/OzZ0Qzp4tfVTYuKGtV5g7iMOXY/nyqf+fIMrF3Ih4oi45ybihkAIgp2G9oYPMWlQ+1NlN2tKiO25DJYmuY5yGVdckC6tYnZhU7ieJiaFo5dd8roTgru208W7V1xFPcPDwYjnM4TI5p+q0udmySba3cAjFKUoosuSbsT6VctMmBFxr8zn0l9uxTb0zfvRaa0TNI31M7uuN1IN+Sfjj8skfMDkhqTCFfEY1CeMbLLkZp4hUACEVLaNSxwylOUvArQ9wxBwsCVnidw1NIhKN2CXRsItapS9u2QZ4ItppCFOvPNtfu6WEi/XJ+V/J82BE3w/v2XDbtXAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNJIO8obVeIJrzVT8KxU4oRrm/NP91BnlUcEZNKcIHQ=;
 b=MuEkxenWsAZPZfTqivb5qtZQXzV2XyU8UOynxuzUONaoVyc+wKVyPuyT3vNqnCqtQsDqI6uYea/h1gXT9P05bMxfSB5FPa/dfG0gBhnIagEy3XREyhyW3OToJAeJDiiicBxosy6iPB14XGnSPLenk8XMgomdrspfz73CkQ2PJRQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4237.eurprd04.prod.outlook.com (2603:10a6:803:3e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 10:05:50 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3195.018; Thu, 16 Jul 2020
 10:05:50 +0000
Subject: Re: [PATCH 1/2] crypto: caam - add tag object functionality
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-2-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <5eb48d36-e5b2-ef54-572c-76ccd601bf47@nxp.com>
Date:   Thu, 16 Jul 2020 13:05:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1594591536-531-2-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 10:05:49 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08dcd1ea-b3b9-4c50-6368-08d8296fd162
X-MS-TrafficTypeDiagnostic: VI1PR04MB4237:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42372754A83A4E96C17030D1987F0@VI1PR04MB4237.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biK/CmYkKGHY7L/VhpDlLmuu7m2m6t2WjmbmYr6/ZT9b7HAQuP/PrKrlv5InpgxIi96RO1u34m3BQOShVbxQ17GjoODnraR1jaA3T1csJKa5Armyarfqd6zp7ljXobcLWjEn0vUjEbFbvdx3B65n7M3pc9sTF5wu2dZ4ih+vZT/8o9nCkvbqG1+46sb8mzmM7M2m3E5UrdFqeMm7i4XmxI9GmIpHfhPDR79QjiqjLiGhOMo3GmxPC1nAKQAi//S0pmgUW0++wCDvDn4XBKvR57KW5YVjnhEOKq+OCgMB3d13/WI282ct0uezzXhics6tnnUyuTyi0sCgiCdiDKESm+aFQ3IZMHwnqUR7lh/LyQRZLT9frBA+kC8Lc5iVdphL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(186003)(53546011)(2906002)(52116002)(478600001)(956004)(4326008)(66946007)(31686004)(66476007)(66556008)(8936002)(2616005)(6486002)(26005)(8676002)(110136005)(6636002)(36756003)(83380400001)(5660300002)(16576012)(31696002)(316002)(16526019)(86362001)(30864003)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dJrblsUCHPNg0rZ0pnDcaVnw+k6rMQxZNEHyqwj3+DgGzHKPDKOgMShSgV5cJOHvsEvdD/Psk7LGkT7RmcZxJxpOUz+Ueg9moIVE1K041yNZ/6GuuTV3urXYfu9d5pOQgdK+7gxCjLdzL2t06ALI0QJe5Xqv4oU2YaZMmLyIEs4Fxfc1m3g59r4J7O3LOoLpb/FFdfh3edxUI8COmU5VCANwshpck6pN2SydQr+SsSTmbgTvMCUkIIEFHLrzOHIx+qUjKfH73P9b12wmtw4flzboHvnNclVYSw4rQgCi7Do6WlMPySQEm1NPJ12UIggsa4E6FqnyEFKQ4Kx/8lvnDO4DWzyiNsNIXBgQouyJUTvBwyWfXxCDmMpGT2+Kf98gcFnF8QVb6g7OU20Ae1LYaTlk0bLhyJEbwhpLDF99ADoCIg3L3K2O5oxhtCjaTyq1FZuZRNMAnegkkLho8bn5vJyPeAFojEP2JkrhTWzYqRvJYkSIg9/Rs2BHeCeBWROr
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dcd1ea-b3b9-4c50-6368-08d8296fd162
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:05:50.6358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+hH8atYtqkQrR2Dis1/MVP7TroBLPLwQBo2+ZbsbLx3dwk2ftdXlePiJ1BamkvfkbEadepmdcm8VEN5VOjs7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4237
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/13/2020 1:05 AM, Iuliana Prodan wrote:
> A tag object represents the metadata (or simply a header/configuration)
> and the actual data (e.g. black key) obtained from hardware.
> Add functionality to tag an object with metadata:
> - validate metadata: check tag object header;
> - retrieve metadata: get tag object header configuration, black key
> configuration or tag object data.
> 
> This API expects that the object (the actual data) from a tag object
> to be a buffer (defined by address and size).
> 
> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig      |   9 +++
>  drivers/crypto/caam/Makefile     |   1 +
>  drivers/crypto/caam/desc.h       |   4 +-
>  drivers/crypto/caam/tag_object.c | 129 +++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/caam/tag_object.h |  99 ++++++++++++++++++++++++++++++
>  5 files changed, 241 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/caam/tag_object.c
>  create mode 100644 drivers/crypto/caam/tag_object.h
> 
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> index bc35aa0..73368d8 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -149,6 +149,15 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
>  	  Selecting this will register the SEC4 hardware rng to
>  	  the hw_random API for supplying the kernel entropy pool.
>  
> +config CRYPTO_DEV_FSL_CAAM_TK_API
> +	bool "Register tagged key cryptography implementations with Crypto API"
> +	depends on CRYPTO_DEV_FSL_CAAM_CRYPTO_API
> +	help
> +	  Selecting this will register algorithms supporting tagged key.
> +
> +	  Tagged keys are keys that contain metadata indicating what
> +	  they are and how to handle them.
> +
Let's keep config options at minimum, we've got plenty of them already.

Please get rid of this entry (and the associated ifdeffery etc.).

>  endif # CRYPTO_DEV_FSL_CAAM_JR
>  
>  endif # CRYPTO_DEV_FSL_CAAM
> diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
> index 68d5cc0..192a88e 100644
> --- a/drivers/crypto/caam/Makefile
> +++ b/drivers/crypto/caam/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC) += caamhash_desc.o
>  
>  caam-y := ctrl.o
>  caam_jr-y := jr.o key_gen.o
> +caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API) += tag_object.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
> diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
> index e134709..3001a8d 100644
> --- a/drivers/crypto/caam/desc.h
> +++ b/drivers/crypto/caam/desc.h
> @@ -152,7 +152,7 @@
>   * with the TDKEK if TK is set
>   */
>  #define KEY_ENC			0x00400000
> -
> +#define KEY_ENC_OFFSET		22
Missing empty line b/w groups of defines.

>  /*
>   * No Write Back - Do not allow key to be FIFO STOREd
>   */
> @@ -162,11 +162,13 @@
>   * Enhanced Encryption of Key
>   */
>  #define KEY_EKT			0x00100000
> +#define KEY_EKT_OFFSET		20
>  
>  /*
>   * Encrypted with Trusted Key
>   */
>  #define KEY_TK			0x00008000
> +#define KEY_TK_OFFSET		15
>  
>  /*
>   * KDEST - Key Destination: 0 - class key register,
> diff --git a/drivers/crypto/caam/tag_object.c b/drivers/crypto/caam/tag_object.c
> new file mode 100644
> index 00000000..55f41e9
> --- /dev/null
> +++ b/drivers/crypto/caam/tag_object.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/*
> + * Copyright 2018-2020 NXP
> + */
> +
> +#include <linux/export.h>
> +#include <linux/string.h>
Why is this include needed?

> +#include <linux/errno.h>
> +
> +#include "tag_object.h"
> +#include "desc.h"
> +
> +/**
> + * is_black_key -	Check if the tag object header is a black key
> + * @header:		The tag object header configuration
> + *
> + * Return:		True if is a black key, false otherwise
> + */
> +bool is_black_key(const struct header_conf *header)
> +{
> +	u32 type = header->type;
> +	/* Check type and color bitfields from tag object type */
> +	return (type & (BIT(TAG_OBJ_COLOR_OFFSET) |
> +			BIT(TAG_OBJ_TYPE_OFFSET))) == BIT(TAG_OBJ_COLOR_OFFSET);
> +}
> +EXPORT_SYMBOL(is_black_key);
Exported symbols should be named such that the probability of
collision with others is neglijible.

> +
> +/**
> + * is_valid_header_conf - Check if the header configuration is valid
> + * @header:		The header configuration
> + *
> + * Return:		True if the header of the tag object configuration,
> + *			has the TAG_OBJECT_MAGIC number and a valid type,
> + *			false otherwise
> + */
> +bool is_valid_header_conf(const struct header_conf *header)
> +{
> +	return (header->_magic_number == TAG_OBJECT_MAGIC);
> +}
Let's not "publish" internal functions in tag_object.h.

> +
> +/**
> + * get_tag_object_header_conf - Retrieve the address of tag object
> + *				header configuration
> + * @buffer:			Buffer containing the tag object
> + * @size:			The size of buffer
> + * @header:			Returned tag object header configuration
> + *
> + * Return:			'0' on success, error code otherwise
> + */
> +int get_tag_object_header_conf(const void *buffer, size_t size,
> +			       struct header_conf **header)
> +{
> +	bool valid;
> +
> +	/* Retrieve the tag object */
> +	struct tagged_object *tag_obj = (struct tagged_object *)buffer;
> +
> +	/* Check if one can retrieve the tag object header configuration */
> +	if (size < TAG_OVERHEAD_SIZE)
> +		return -EINVAL;
> +
> +	/* Check tag object header configuration */
> +	valid = is_valid_header_conf(&tag_obj->header);
> +
> +	/* Retrieve the tag object header configuration address */
> +	*header = &tag_obj->header;
> +
> +	return valid ? 0 : -EINVAL;
> +}
> +EXPORT_SYMBOL(get_tag_object_header_conf);
> +
> +/**
> + * get_key_conf -	Retrieve the key configuration,
> + *			meaning the length of the black key and
> + *			the KEY command parameters needed for CAAM
> + * @header:		The tag object header configuration
> + * @real_len:		Key length
> + * @load_param:		Load parameters for KEY command:
> + *			- indicator for encrypted keys: plaintext or black
> + *			- indicator for encryption mode: AES-ECB or AES-CCM
> + *			- indicator for encryption keys: JDKEK or TDKEK
> + */
> +void get_key_conf(const struct header_conf *header,
> +		  u32 *real_len, u32 *load_param)
> +{
> +	*real_len = header->real_len;
> +	/* Based on the color of the key, set key encryption bit (ENC) */
> +	*load_param = ((header->type >> TAG_OBJ_COLOR_OFFSET) &
> +		       TAG_OBJ_COLOR_MASK) << KEY_ENC_OFFSET;
> +	/*
> +	 * For red keys, the TK and EKT bits are ignored.
> +	 * So we set them anyway, to be valid when the key is black.
> +	 */
> +	*load_param |= ((header->type >> TAG_OBJ_TK_OFFSET) &
> +			 TAG_OBJ_TK_MASK) << KEY_TK_OFFSET;
> +	*load_param |= ((header->type >> TAG_OBJ_EKT_OFFSET) &
> +			 TAG_OBJ_EKT_MASK) << KEY_EKT_OFFSET;
> +}
> +EXPORT_SYMBOL(get_key_conf);
> +
> +/**
> + * get_tagged_data -	Retrieve the address of the data and size
> + *			of the tagged object
> + * @tagged_object:		Pointer to tag object
> + * @tagged_object_size:		The tagged object size
> + * @data:			Returned the address of the data from
> + *				the tagged object
> + * @data_size:			Returned the size of the data from the
> + *				tagged object
> + *
> + * Return:			'0' on success, error code otherwise
> + */
> +int get_tagged_data(const void *tagged_object, size_t tagged_object_size,
> +		    const void **data, u32 *data_size)
> +{
> +	/* Retrieve the tag object */
> +	struct tagged_object *tag_obj = (struct tagged_object *)tagged_object;
> +	/* Check if one can retrieve the data from the tagged object */
> +	if (tagged_object_size < TAG_OVERHEAD_SIZE)
> +		return -EINVAL;
> +
> +	/* Retrieve the address of the data/object from the tagged object */
> +	*data = &tag_obj->object;
> +	/* Retrieve the size of the data from the tagged object */
> +	*data_size = tagged_object_size - TAG_OVERHEAD_SIZE;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(get_tagged_data);
> diff --git a/drivers/crypto/caam/tag_object.h b/drivers/crypto/caam/tag_object.h
> new file mode 100644
> index 00000000..9950c02
> --- /dev/null
> +++ b/drivers/crypto/caam/tag_object.h
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> +/*
> + * Copyright 2018-2020 NXP
> + */
> +
> +#ifndef _TAG_OBJECT_H_
> +#define _TAG_OBJECT_H_
> +
> +#include <linux/types.h>
> +#include <linux/bitops.h>
> +
> +/**
> + * Magic number to identify the tag object structure
> + * 0x54 = 'T'
> + * 0x61 = 'a'
> + * 0x67 = 'g'
> + * 0x4f = 'O'
> + */
> +#define TAG_OBJECT_MAGIC	0x5461674f
> +#define TAG_MIN_SIZE		(2 * sizeof(struct header_conf))
> +#define TAG_OVERHEAD_SIZE	sizeof(struct header_conf)
> +
> +/*
> + * Tag object type is a bitfield:
header_conf.type

> + *
> + * EKT:	Encrypted Key Type (AES-ECB or AES-CCM)
> + * TK:	Trusted Key (use Job Descriptor Key Encryption Key (JDKEK)
> + *	or Trusted Descriptor Key Encryption Key (TDKEK) to
> + *	decrypt the key to be loaded into a Key Register).
> + *
> + *| Denomination | Security state | Memory  | EKT | TK    | Type | Color |
> + *| ------------ | -------------- | ------- | --- | ----- | ---- | ----- |
> + *| bit(s)       | 5-6            | 4       | 3   | 2     | 1    | 0     |
> + *| option 0     | non-secure     | general | ECB | JDKEK | key  | red   |
> + *| option 1     | secure         | secure  | CCM | TDKEK | blob | black |
> + *| option 2     | trusted        |         |     |       |      |       |
> + *
> + * CAAM supports two different Black Key encapsulation schemes,
> + * one intended for quick decryption (uses AES-ECB encryption),
> + * and another intended for high assurance (uses AES-CCM encryption).
> + *
> + * CAAM implements both Trusted and normal (non-Trusted) Black Keys,
> + * which are encrypted with different key-encryption keys.
> + * Both Trusted and normal Descriptors are allowed to encrypt or decrypt
> + * normal Black Keys, but only Trusted Descriptors are allowed to
> + * encrypt or decrypt Trusted Black Keys.
> + */
> +#define TAG_OBJ_COLOR_OFFSET		0
> +#define TAG_OBJ_COLOR_MASK		0x1
> +#define TAG_OBJ_TYPE_OFFSET		1
> +#define TAG_OBJ_TK_OFFSET		2
> +#define TAG_OBJ_TK_MASK			0x1
> +#define TAG_OBJ_EKT_OFFSET		3
> +#define TAG_OBJ_EKT_MASK		0x1
> +#define TAG_OBJ_MEM_OFFSET		4
> +#define TAG_OBJ_SEC_STATE_OFFSET	5
Values for masks should be already shifted.
That's the idiom we use in the driver, and that's what's mostly used
throughout the kernel.

> +
> +/**
> + * struct header_conf - Header configuration structure, which represents
> + *			the metadata (or simply a header) applied to the
> + *			actual data (e.g. black key)
> + * @_magic_number     : A magic number to identify the structure
> + * @version           : The version of the data contained (e.g. tag object)
> + * @type              : The type of data contained (e.g. black key, blob, etc.)
> + * @real_len          : Length of the object to be loaded by CAAM
> + */
> +struct header_conf {
> +	u32 _magic_number;
> +	u32 version;
Version is currently not used in the implementation.
I assume this is intended for allowing a compatibility scheme.

Have you give it a thought how would it work?
For example, what happens in case a new field has to be added in the header?

> +	u32 type;
> +	u32 real_len;
> +};
> +
> +/**
> + * struct tagged_object - Tag object structure, which represents the metadata
> + *                        (or simply a header) and the actual data
> + *                        (e.g. black key) obtained from hardware
> + * @tag                 : The configuration of the data (e.g. header)
> + * @object              : The actual data (e.g. black key)
> + */
> +struct tagged_object {
> +	struct header_conf header;
> +	char object;
Should this be aligned?
In case the object is not copied, it will be DMA-read by the device
from this location.

Also let's make it clear this field is just a tag / alias
to the structure offset, and it's size is variable.

Horia
