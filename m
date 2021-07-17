Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74202C636CA
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 16:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52CD561159
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 16:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhGQQxS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 12:53:18 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:34008 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhGQQxR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 12:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626540620;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=2R0vXTMKc6AYjXYRU1JuVsQ4yz/qAiQDIe8e879Vn/A=;
    b=Qv77EewXZXS1fe2K6dggAgUNj3D7ViEM2XZSWCzhKsvo8e43v6M2iOryovuAkMSSvM
    hvHS8Kk60NkbGXRuKF6aJ3wYKpuHPg0MvSg9MHoOZECDSq/cbIvSdH7qSy3Bxq9bgqWI
    qYVSLmq1mxaLYHRHvJTZu//1WNV0mrHNcl1f78kc7LkZfiAvytxDLYLzEqeAD6nd8Tbc
    mU2uu79tsfZzaTADzjAuDkcmzbCzasOQLCLDetI+lIM6a6TiUqWmoRuqdRRJtSoitmFH
    AnVMG/lnp+vhNm8FDZtj4IlZ9MPfvumH9JyHJYY9tCjeAedrZfa4M/1grKxIkhM/zjI+
    qUCQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZEqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6HGoJCKL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 17 Jul 2021 18:50:19 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/11] nvme: add non-standard ECDH and curve25517 algorithms
Date:   Sat, 17 Jul 2021 18:50:19 +0200
Message-ID: <2097520.Z47m7augs3@positron.chronox.de>
In-Reply-To: <20210716110428.9727-12-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de> <20210716110428.9727-12-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 16. Juli 2021, 13:04:28 CEST schrieb Hannes Reinecke:

Hi Hannes,

> TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE

curve25519?

> groups, and these are already implemented in the kernel.
> So add support for these non-standard groups for NVMe in-band
> authentication to validate the augmented challenge implementation.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/nvme/host/auth.c   | 38 +++++++++++++++++++++++++++++++++++++-
>  drivers/nvme/target/auth.c | 23 +++++++++++++++++++++++
>  include/linux/nvme.h       |  2 ++
>  3 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
> index 754343aced19..d0dd63b455ef 100644
> --- a/drivers/nvme/host/auth.c
> +++ b/drivers/nvme/host/auth.c
> @@ -10,6 +10,8 @@
>  #include <crypto/kpp.h>
>  #include <crypto/dh.h>
>  #include <crypto/ffdhe.h>
> +#include <crypto/ecdh.h>
> +#include <crypto/curve25519.h>
>  #include "nvme.h"
>  #include "fabrics.h"
>  #include "auth.h"
> @@ -67,6 +69,13 @@ struct nvme_auth_dhgroup_map {
>  	{ .id = NVME_AUTH_DHCHAP_DHGROUP_8192,
>  	  .name = "ffdhe8192", .kpp = "dh",
>  	  .privkey_size = 1024, .pubkey_size = 1024 },
> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_ECDH,
> +	  .name = "ecdh", .kpp = "ecdh-nist-p256",
> +	  .privkey_size = 32, .pubkey_size = 64 },
> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_25519,
> +	  .name = "curve25519", .kpp = "curve25519",
> +	  .privkey_size = CURVE25519_KEY_SIZE,
> +	  .pubkey_size = CURVE25519_KEY_SIZE },
>  };
> 
>  const char *nvme_auth_dhgroup_name(int dhgroup_id)
> @@ -337,7 +346,7 @@ static int nvme_auth_dhchap_negotiate(struct nvme_ctrl
> *ctrl, data->napd = 1;
>  	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
>  	data->auth_protocol[0].dhchap.halen = 3;
> -	data->auth_protocol[0].dhchap.dhlen = 6;
> +	data->auth_protocol[0].dhchap.dhlen = 8;
>  	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_HASH_SHA256;
>  	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_HASH_SHA384;
>  	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_HASH_SHA512;
> @@ -347,6 +356,8 @@ static int nvme_auth_dhchap_negotiate(struct nvme_ctrl
> *ctrl, data->auth_protocol[0].dhchap.idlist[6] =
> NVME_AUTH_DHCHAP_DHGROUP_4096; data->auth_protocol[0].dhchap.idlist[7] =
> NVME_AUTH_DHCHAP_DHGROUP_6144; data->auth_protocol[0].dhchap.idlist[8] =
> NVME_AUTH_DHCHAP_DHGROUP_8192; +	data->auth_protocol[0].dhchap.idlist[9] 
=
> NVME_AUTH_DHCHAP_DHGROUP_ECDH; +	data->auth_protocol[0].dhchap.idlist[10] 
=
> NVME_AUTH_DHCHAP_DHGROUP_25519;
> 
>  	return size;
>  }
> @@ -889,6 +900,31 @@ static int nvme_auth_dhchap_exponential(struct
> nvme_ctrl *ctrl, }
>  		chap->host_key_len = pubkey_size;
>  		chap->sess_key_len = pubkey_size;
> +	} else if (chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_ECDH) {
> +		struct ecdh p = {0};
> +
> +		pkey_len = crypto_ecdh_key_len(&p);
> +		pkey = kzalloc(pkey_len, GFP_KERNEL);
> +		if (!pkey)
> +			return -ENOMEM;
> +
> +		get_random_bytes(pkey, pkey_len);
> +		ret = crypto_ecdh_encode_key(pkey, pkey_len, &p);
> +		if (ret) {
> +			dev_dbg(ctrl->device,
> +				"failed to encode pkey, error %d\n", ret);
> +			kfree(pkey);
> +			return ret;
> +		}
> +		chap->host_key_len = 64;
> +		chap->sess_key_len = 32;
> +	} else if (chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_25519) {
> +		pkey_len = CURVE25519_KEY_SIZE;
> +		pkey = kzalloc(pkey_len, GFP_KERNEL);
> +		if (!pkey)
> +			return -ENOMEM;
> +		get_random_bytes(pkey, pkey_len);
> +		chap->host_key_len = chap->sess_key_len = CURVE25519_KEY_SIZE;
>  	} else {
>  		dev_warn(ctrl->device, "Invalid DH group id %d\n",
>  			 chap->dhgroup_id);
> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
> index cc7f12a7c8bf..7e3b613cb08b 100644
> --- a/drivers/nvme/target/auth.c
> +++ b/drivers/nvme/target/auth.c
> @@ -13,6 +13,8 @@
>  #include <crypto/kpp.h>
>  #include <crypto/dh.h>
>  #include <crypto/ffdhe.h>
> +#include <crypto/ecdh.h>
> +#include <crypto/curve25519.h>
>  #include <linux/crc32.h>
>  #include <linux/base64.h>
>  #include <linux/ctype.h>
> @@ -498,6 +500,27 @@ int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
>  				 ret);
>  			goto out;
>  		}
> +	} else if (ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_ECDH) {
> +		struct ecdh p = {0};
> +
> +		pkey_len = crypto_ecdh_key_len(&p);
> +		pkey = kmalloc(pkey_len, GFP_KERNEL);
> +		if (!pkey)
> +			return -ENOMEM;
> +
> +		get_random_bytes(pkey, pkey_len);
> +		ret = crypto_ecdh_encode_key(pkey, pkey_len, &p);
> +		if (ret) {
> +			pr_debug("failed to encode private key, error %d\n",
> +				 ret);
> +			goto out;
> +		}
> +	} else if (ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_25519) {
> +		pkey_len = CURVE25519_KEY_SIZE;
> +		pkey = kmalloc(pkey_len, GFP_KERNEL);
> +		if (!pkey)
> +			return -ENOMEM;
> +		get_random_bytes(pkey, pkey_len);
>  	} else {
>  		pr_warn("invalid dh group %d\n", ctrl->dh_gid);
>  		return -EINVAL;
> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
> index 7b94abacfd08..75b638adbca1 100644
> --- a/include/linux/nvme.h
> +++ b/include/linux/nvme.h
> @@ -1476,6 +1476,8 @@ enum {
>  	NVME_AUTH_DHCHAP_DHGROUP_4096	= 0x03,
>  	NVME_AUTH_DHCHAP_DHGROUP_6144	= 0x04,
>  	NVME_AUTH_DHCHAP_DHGROUP_8192	= 0x05,
> +	NVME_AUTH_DHCHAP_DHGROUP_ECDH   = 0x0e,
> +	NVME_AUTH_DHCHAP_DHGROUP_25519  = 0x0f,
>  };
> 
>  union nvmf_auth_protocol {


Ciao
Stephan


