Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B414EC4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Jan 2023 03:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjABDSg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Jan 2023 22:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjABDSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Jan 2023 22:18:35 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DA825C0
        for <linux-crypto@vger.kernel.org>; Sun,  1 Jan 2023 19:18:33 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so28841537pju.3
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jan 2023 19:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZvyGK6DxthGUsLi298pua96YvrjAlkyByXaysjEekY=;
        b=cmP6xJtkIhwQCGVKmCN7/xe+AvuuQgBdohmEnkVX+CVpTHLSR8dTK+JQUhhcXtpLJU
         AEn0zFdcJkcqb4sNjcnG8NibcBdmP8bO+j3hSaCZ4n1e2dkGVRabIqOK1vIG3mFXfey6
         xEakNadOxxIXiFplCpYQgxzkCK7RFA02Bv2ycqBbRRGJeKH/OV0Mwg+K4VztgRj7rg0e
         PbuEPtbNDqXpKbn8MZSNLoavsMXTqepweoq6QSd9evwACglxdbWRUG7hNy5XtY9KnZcE
         F2wZdxnq/Pow9BDLjsBjKfg+sWl7lgRSpoOEOdGy1QpHDK2gcmE/mBifXtL/E/7WDZl4
         om9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZvyGK6DxthGUsLi298pua96YvrjAlkyByXaysjEekY=;
        b=QtJLTGBoGRbmZ1J8KIHv6EOAcOPgypzSH6O1tUj9yRst2B2K13poZxtFyMi1bbau88
         JqVzRuH25+gyPvusZeBXSPFRf6+ij2Eg9BVhVj8Q5a2HU1SUN2+jo9tMJZP+9X1MyA5l
         aVJQcb3/ScH7svIYVYwAoI97X6emEGpZ9Bmee5sRGg3VWxB7KOijSZ7YKOv9yw5Te9/I
         5VdUbBMowH67D6n4LjzvXeYn+RTR75M88GUlkmYVkhqpJfgi3rjh+//fL646rIGedh8Z
         3Kg22Fo/mtS1bnHUtG8sWGXyLsE2O/PuVV50UG7qkv4ZZ8ztCepX5KKyTcrGURWsXyNf
         CaCw==
X-Gm-Message-State: AFqh2koObLSb3DcMZj8VspWxQXNf1AnV7XDt1b2H+f01Ip21WCInAXVP
        jdZ+392bwVR6js/MdXDVzBqq/g==
X-Google-Smtp-Source: AMrXdXvPj8o6cK4T3w01Iw3SMa2JT66hdZ4VXWgIspXrvpNrRkrS7ttzQdxzW3nbzDECQOX/gYTa4A==
X-Received: by 2002:a05:6a20:7f59:b0:ac:af5c:2970 with SMTP id e25-20020a056a207f5900b000acaf5c2970mr2514437pzk.3.1672629512652;
        Sun, 01 Jan 2023 19:18:32 -0800 (PST)
Received: from [2620:15c:29:203:20a4:1331:a6b6:c59b] ([2620:15c:29:203:20a4:1331:a6b6:c59b])
        by smtp.gmail.com with ESMTPSA id 72-20020a63064b000000b00477602ff6a8sm15928374pgg.94.2023.01.01.19.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 19:18:31 -0800 (PST)
Date:   Sun, 1 Jan 2023 19:18:30 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Jarkko Sakkinen <jarkko@profian.com>
cc:     linux-crypto@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Improve sev_platform_init() error
 messages
In-Reply-To: <20221231151106.143121-1-jarkko@profian.com>
Message-ID: <6a16bbe4-4281-fb28-78c4-4ec44c8aa679@google.com>
References: <20221231151106.143121-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 31 Dec 2022, Jarkko Sakkinen wrote:

> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> However, only sev_pci_init() prints out the failed command error code, and
> even there the error message does not specify, SEV which command failed.
> 
> Address this by printing out the SEV command errors inside
> __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> INIT_EX commands.
> 
> This extra information is particularly useful if firmware loading and/or
> initialization is going to be made more robust, e.g. by allowing
> firmware loading to be postponed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 5350eacaba3a..ac7385c12091 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -963,6 +963,7 @@ static int __sev_init_ex_locked(int *error)
>  
>  static int __sev_platform_init_locked(int *error)
>  {
> +	const char *cmd = sev_init_ex_buffer ? "SEV_CMD_INIT_EX" : "SEV_CMD_INIT";
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
>  	int rc = 0, psp_ret = -1;

I think this can just be handled directly in the dev_err() since it's only 
used once.

> @@ -1008,18 +1009,23 @@ static int __sev_platform_init_locked(int *error)
>  	if (error)
>  		*error = psp_ret;
>  
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: %s failed error %#x", cmd, psp_ret);
>  		return rc;
> +	}
>  
>  	sev->state = SEV_STATE_INIT;
>  
>  	/* Prepare for first SEV guest launch after INIT */
>  	wbinvd_on_all_cpus();
> -	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> -	if (rc)
> -		return rc;
> +	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
> +	if (error)
> +		*error = psp_ret;
>  
> -	dev_dbg(sev->dev, "SEV firmware initialized\n");

Any reason to remove this dbg line?  I assume the following dev_info() 
line is deemed sufficient?

> +	if (rc) {
> +		dev_err(sev->dev, "SEV: SEV_CMD_DF_FLUSH failed error %#x", psp_ret);
> +		return rc;
> +	}
>  
>  	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);
> @@ -2354,8 +2360,7 @@ void sev_pci_init(void)
>  	/* Initialize the platform */
>  	rc = sev_platform_init(&error);
>  	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			error, rc);
> +		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
>  
>  skip_legacy:
>  	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
