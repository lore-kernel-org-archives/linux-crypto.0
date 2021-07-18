Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3D2C636CA
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E017D61026
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhGRM7t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:59:49 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:32805 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRM7s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626613009;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JgtNOF4dwdkPCPh/K19d1BYMZ8aCdfWRjdB+Jm/VNBA=;
    b=LaamL9/0K7wvp0L5rjuFgSAZvR5JwAD8aiaix3QdgHo1iyZ8nI8hUomRyr4ylfhQGQ
    Q7+SPadrAJ/jhhlTCxfrUU14R1B36ES10HDUXn0mEZcWpDhirY4bjMs0/C5W1yh9Kpq6
    HJ+xUiuy4YRRT0zZuodupOYlPA0x8TPabDF18TDxjofXWeH66a2pxg0FLlpXUf8sfy6i
    WaYEH+vLzVGS3soSWikmkIUBL40kbL11zt1sPPvMsm/CvV31vRv1wxh1wehiDD58DbYv
    6v092KRD8MPU9B2qINrRyF4KKgxHV82NqiEeGniAAZ6An2+9PyaMfF6bq4rVS13IzbB/
    zt9A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbLvSWMgk="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6ICumET4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 18 Jul 2021 14:56:48 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Date:   Sun, 18 Jul 2021 14:56:47 +0200
Message-ID: <6538288.aohFRl0Q45@positron.chronox.de>
In-Reply-To: <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
References: <20210716110428.9727-1-hare@suse.de> <2510347.locV8n3378@positron.chronox.de> <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:

Hi Hannes,

> On 7/17/21 6:49 PM, Stephan M=FCller wrote:
> > Am Freitag, 16. Juli 2021, 13:04:26 CEST schrieb Hannes Reinecke:
> >=20
> > Hi Hannes,
> >=20
> >> Implement support for NVMe-oF In-Band authentication. This patch
> >> adds two additional configfs entries 'dhchap_key' and 'dhchap_hash'
> >> to the 'host' configfs directory. The 'dhchap_key' needs to be
> >> specified in the format outlined in the base spec.
> >> Augmented challenge support is not implemented, and concatenation
> >> with TLS encryption is not supported.
> >>=20
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>=20
> >>   drivers/nvme/target/Kconfig            |  10 +
> >>   drivers/nvme/target/Makefile           |   1 +
> >>   drivers/nvme/target/admin-cmd.c        |   4 +
> >>   drivers/nvme/target/auth.c             | 352 +++++++++++++++++++
> >>   drivers/nvme/target/configfs.c         |  71 +++-
> >>   drivers/nvme/target/core.c             |   8 +
> >>   drivers/nvme/target/fabrics-cmd-auth.c | 460 +++++++++++++++++++++++=
++
> >>   drivers/nvme/target/fabrics-cmd.c      |  30 +-
> >>   drivers/nvme/target/nvmet.h            |  71 ++++
> >>   9 files changed, 1004 insertions(+), 3 deletions(-)
> >>   create mode 100644 drivers/nvme/target/auth.c
> >>   create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
> >>=20
> >> diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
> >> index 4be2ececbc45..d5656ef1559e 100644
> >> --- a/drivers/nvme/target/Kconfig
> >> +++ b/drivers/nvme/target/Kconfig
> >> @@ -85,3 +85,13 @@ config NVME_TARGET_TCP
> >>=20
> >>   	  devices over TCP.
> >>   	 =20
> >>   	  If unsure, say N.
> >>=20
> >> +
> >> +config NVME_TARGET_AUTH
> >> +	bool "NVMe over Fabrics In-band Authentication support"
> >> +	depends on NVME_TARGET
> >> +	select CRYPTO_SHA256
> >> +	select CRYPTO_SHA512
> >> +	help
> >> +	  This enables support for NVMe over Fabrics In-band Authentication
> >> +
> >> +	  If unsure, say N.
> >> diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefi=
le
> >> index 9837e580fa7e..c66820102493 100644
> >> --- a/drivers/nvme/target/Makefile
> >> +++ b/drivers/nvme/target/Makefile
> >> @@ -13,6 +13,7 @@ nvmet-y		+=3D core.o configfs.o admin-cmd.o
> >=20
> > fabrics-cmd.o \
> >=20
> >>   			discovery.o io-cmd-file.o io-cmd-bdev.o
> >>  =20
> >>   nvmet-$(CONFIG_NVME_TARGET_PASSTHRU)	+=3D passthru.o
> >>   nvmet-$(CONFIG_BLK_DEV_ZONED)		+=3D zns.o
> >>=20
> >> +nvmet-$(CONFIG_NVME_TARGET_AUTH)	+=3D fabrics-cmd-auth.o auth.o
> >>=20
> >>   nvme-loop-y	+=3D loop.o
> >>   nvmet-rdma-y	+=3D rdma.o
> >>   nvmet-fc-y	+=3D fc.o
> >>=20
> >> diff --git a/drivers/nvme/target/admin-cmd.c
> >> b/drivers/nvme/target/admin-cmd.c index 0cb98f2bbc8c..320cefc64ee0 100=
644
> >> --- a/drivers/nvme/target/admin-cmd.c
> >> +++ b/drivers/nvme/target/admin-cmd.c
> >> @@ -1008,6 +1008,10 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
> >>=20
> >>   	if (nvme_is_fabrics(cmd))
> >>   =09
> >>   		return nvmet_parse_fabrics_cmd(req);
> >>=20
> >> +
> >> +	if (unlikely(!nvmet_check_auth_status(req)))
> >> +		return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
> >> +
> >>=20
> >>   	if (nvmet_req_subsys(req)->type =3D=3D NVME_NQN_DISC)
> >>   =09
> >>   		return nvmet_parse_discovery_cmd(req);
> >>=20
> >> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
> >> new file mode 100644
> >> index 000000000000..00c7d051dfb1
> >> --- /dev/null
> >> +++ b/drivers/nvme/target/auth.c
> >> @@ -0,0 +1,352 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * NVMe over Fabrics DH-HMAC-CHAP authentication.
> >> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
> >> + * All rights reserved.
> >> + */
> >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> +#include <linux/module.h>
> >> +#include <linux/init.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/err.h>
> >> +#include <crypto/hash.h>
> >> +#include <crypto/kpp.h>
> >> +#include <crypto/dh.h>
> >> +#include <crypto/ffdhe.h>
> >> +#include <linux/crc32.h>
> >> +#include <linux/base64.h>
> >> +#include <linux/ctype.h>
> >> +#include <linux/random.h>
> >> +#include <asm/unaligned.h>
> >> +
> >> +#include "nvmet.h"
> >> +#include "../host/auth.h"
> >> +
> >> +int nvmet_auth_set_host_key(struct nvmet_host *host, const char *secr=
et)
> >> +{
> >> +	if (sscanf(secret, "DHHC-1:%hhd:%*s", &host->dhchap_key_hash) !=3D 1)
> >> +		return -EINVAL;
> >> +	if (host->dhchap_key_hash > 3) {
> >> +		pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
> >> +			 host->dhchap_key_hash);
> >> +		return -EINVAL;
> >> +	}
> >> +	if (host->dhchap_key_hash > 0) {
> >> +		/* Validate selected hash algorithm */
> >> +		const char *hmac =3D nvme_auth_hmac_name(host->dhchap_key_hash);
> >> +
> >> +		if (!crypto_has_shash(hmac, 0, 0)) {
> >> +			pr_warn("DH-HMAC-CHAP hash %s unsupported\n", hmac);
> >> +			host->dhchap_key_hash =3D -1;
> >> +			return -EAGAIN;
> >> +		}
> >> +		/* Use this hash as default */
> >> +		if (!host->dhchap_hash_id)
> >> +			host->dhchap_hash_id =3D host->dhchap_key_hash;
> >> +	}
> >> +	host->dhchap_secret =3D kstrdup(secret, GFP_KERNEL);
> >=20
> > Just like before - are you sure that the secret is an ASCII string and =
no
> > binary blob?
>=20
> That is ensured by the transport encoding (cf NVMe Base Specification
> version 2.0). Also, this information is being passed in via the configfs
> interface, so it's bounded by PAGE_SIZE. But yes, we should be inserting
> a terminating 'NULL' character at the end of the page to ensure we don't
> incur an buffer overrun. Any other failure will be checked for during
> base64 decoding.
>=20
> >> +	if (!host->dhchap_secret)
> >> +		return -ENOMEM;
> >> +	/* Default to SHA256 */
> >> +	if (!host->dhchap_hash_id)
> >> +		host->dhchap_hash_id =3D NVME_AUTH_DHCHAP_HASH_SHA256;
> >> +
> >> +	pr_debug("Using hash %s\n",
> >> +		 nvme_auth_hmac_name(host->dhchap_hash_id));
> >> +	return 0;
> >> +}
> >> +
> >> +int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id)
> >> +{
> >> +	int ret =3D -ENOTSUPP;
> >> +
> >> +	if (dhgroup_id =3D=3D NVME_AUTH_DHCHAP_DHGROUP_NULL)
> >> +		return 0;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
> >> +{
> >> +	int ret =3D 0;
> >> +	struct nvmet_host_link *p;
> >> +	struct nvmet_host *host =3D NULL;
> >> +	const char *hash_name;
> >> +
> >> +	down_read(&nvmet_config_sem);
> >> +	if (ctrl->subsys->type =3D=3D NVME_NQN_DISC)
> >> +		goto out_unlock;
> >> +
> >> +	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
> >> +		pr_debug("check %s\n", nvmet_host_name(p->host));
> >> +		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
> >> +			continue;
> >> +		host =3D p->host;
> >> +		break;
> >> +	}
> >> +	if (!host) {
> >> +		pr_debug("host %s not found\n", ctrl->hostnqn);
> >> +		ret =3D -EPERM;
> >> +		goto out_unlock;
> >> +	}
> >> +	if (!host->dhchap_secret) {
> >> +		pr_debug("No authentication provided\n");
> >> +		goto out_unlock;
> >> +	}
> >> +
> >> +	hash_name =3D nvme_auth_hmac_name(host->dhchap_hash_id);
> >> +	if (!hash_name) {
> >> +		pr_debug("Hash ID %d invalid\n", host->dhchap_hash_id);
> >> +		ret =3D -EINVAL;
> >> +		goto out_unlock;
> >> +	}
> >> +	ctrl->shash_tfm =3D crypto_alloc_shash(hash_name, 0,
> >> +					     CRYPTO_ALG_ALLOCATES_MEMORY);
> >> +	if (IS_ERR(ctrl->shash_tfm)) {
> >> +		pr_debug("failed to allocate shash %s\n", hash_name);
> >> +		ret =3D PTR_ERR(ctrl->shash_tfm);
> >> +		ctrl->shash_tfm =3D NULL;
> >> +		goto out_unlock;
> >> +	}
> >> +
> >> +	ctrl->dhchap_key =3D nvme_auth_extract_secret(host->dhchap_secret,
> >> +						    &ctrl->dhchap_key_len);
> >> +	if (IS_ERR(ctrl->dhchap_key)) {
> >> +		pr_debug("failed to extract host key, error %d\n", ret);
> >> +		ret =3D PTR_ERR(ctrl->dhchap_key);
> >> +		ctrl->dhchap_key =3D NULL;
> >> +		goto out_free_hash;
> >> +	}
> >> +	if (host->dhchap_key_hash) {
> >> +		struct crypto_shash *key_tfm;
> >> +
> >> +		hash_name =3D nvme_auth_hmac_name(host->dhchap_key_hash);
> >> +		key_tfm =3D crypto_alloc_shash(hash_name, 0, 0);
> >> +		if (IS_ERR(key_tfm)) {
> >> +			ret =3D PTR_ERR(key_tfm);
> >> +			goto out_free_hash;
> >> +		} else {
> >> +			SHASH_DESC_ON_STACK(shash, key_tfm);
> >> +
> >> +			shash->tfm =3D key_tfm;
> >> +			ret =3D crypto_shash_setkey(key_tfm, ctrl->dhchap_key,
> >> +						  ctrl->dhchap_key_len);
> >> +			crypto_shash_init(shash);
> >> +			crypto_shash_update(shash, ctrl->subsys->subsysnqn,
> >> +					    strlen(ctrl->subsys->subsysnqn));
> >> +			crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
> >> +			crypto_shash_final(shash, ctrl->dhchap_key);
> >> +			crypto_free_shash(key_tfm);
> >> +		}
> >> +	}
> >> +	pr_debug("%s: using key %*ph\n", __func__,
> >> +		 (int)ctrl->dhchap_key_len, ctrl->dhchap_key);
> >> +	ret =3D crypto_shash_setkey(ctrl->shash_tfm, ctrl->dhchap_key,
> >=20
> > Is it truly necessary to keep the key around in ctrl->dhchap_key? It lo=
oks
> > to me that this buffer is only used here and thus could be turned into a
> > local variable. Keys flying around in memory is not a good idea. :-)
>=20
> The key is also used when using the ffdhe algorithm.
> Note: I _think_ that I need to use this key for the ffdhe algorithm,
> because the implementation I came up with is essentially plain DH with
> pre-defined 'p', 'q' and 'g' values. But the DH implementation also
> requires a 'key', and for that I'm using this key here.
>=20
> It might be that I'm completely off, and don't need to use a key for our
> DH implementation. In that case you are correct.
> (And that's why I said I'll need a review of the FFDHE implementation).
> But for now I'll need the key for FFDHE.

Do I understand you correctly that the dhchap_key is used as the input to t=
he=20
DH - i.e. it is the remote public key then? It looks strange that this is u=
sed=20
for DH but then it is changed here by hashing it together with something el=
se=20
to form a new dhchap_key. Maybe that is what the protocol says. But it soun=
ds=20
strange to me, especially when you think that dhchap_key would be, say, 204=
8=20
bits if it is truly the remote public key and then after the hashing it is =
256=20
or 512 bits depending on the HMAC type. This means that after the hashing,=
=20
this dhchap_key cannot be used for FFC-DH.

Or are you using the dhchap_key for two different purposes?

It seems I miss something here.


> >> +	response =3D kmalloc(data->hl, GFP_KERNEL);
> >=20
> > Again, align to CRYPTO_MINALIGN_ATTR?
>=20
> Ah, _that_ alignment.
> Wasn't aware that I need to align to anything.
> But if that's required, sure, I'll be fixing it.

Again, that only saves you a memcpy in shash_final.

Ciao
Stephan


