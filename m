Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3AAC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 16:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiI3Qke (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 12:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiI3Qkb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 12:40:31 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BACDAFA5D8
        for <linux-crypto@vger.kernel.org>; Fri, 30 Sep 2022 09:40:30 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id eIwYoMAPUr5PdeIwYoJg1U; Fri, 30 Sep 2022 18:32:58 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 30 Sep 2022 18:32:58 +0200
X-ME-IP: 86.243.100.34
Message-ID: <cecca972-33c8-03a9-d632-c85ed06dff8b@wanadoo.fr>
Date:   Fri, 30 Sep 2022 18:32:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] crypto: cavium - prevent integer overflow loading
 firmware
Content-Language: fr
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        George Cherian <gcherian@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YygPj8aYTvApOQFB@kili>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YygPj8aYTvApOQFB@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le 19/09/2022 à 08:43, Dan Carpenter a écrit :
> The "code_length" value comes from the firmware file.  If your firmware
> is untrusted realistically there is probably very little you can do to
> protect yourself.  Still we try to limit the damage as much as possible.
> Also Smatch marks any data read from the filesystem as untrusted and
> prints warnings if it not capped correctly.
> 
> The "ntohl(ucode->code_length) * 2" multiplication can have an
> integer overflow.
> 
> Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: The first code removed the " * 2" so it would have caused immediate
>      memory corruption and crashes.
> 
>      Also in version 2 I combine the "if (!mcode->code_size) {" check
>      with the overflow check for better readability.
> 
>   drivers/crypto/cavium/cpt/cptpf_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
> index 8c32d0eb8fcf..6872ac344001 100644
> --- a/drivers/crypto/cavium/cpt/cptpf_main.c
> +++ b/drivers/crypto/cavium/cpt/cptpf_main.c
> @@ -253,6 +253,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
>   	const struct firmware *fw_entry;
>   	struct device *dev = &cpt->pdev->dev;
>   	struct ucode_header *ucode;
> +	unsigned int code_length;
>   	struct microcode *mcode;
>   	int j, ret = 0;
>   
> @@ -263,11 +264,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
>   	ucode = (struct ucode_header *)fw_entry->data;
>   	mcode = &cpt->mcode[cpt->next_mc_idx];
>   	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
> -	mcode->code_size = ntohl(ucode->code_length) * 2;
> -	if (!mcode->code_size) {
> +	code_length = ntohl(ucode->code_length);
> +	if (code_length == 0 || code_length >= INT_MAX / 2) {

Hi,

out of curiosity,

'code_length' is 'unsigned int'
'mcode->code_size' is u32.

Why not UINT_MAX / 2?

CJ

>   		ret = -EINVAL;
>   		goto fw_release;
>   	}
> +	mcode->code_size = code_length * 2;
>   
>   	mcode->is_ae = is_ae;
>   	mcode->core_mask = 0ULL;

