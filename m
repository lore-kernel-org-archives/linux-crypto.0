Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5F7C2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF17820882
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seznam.cz header.i=@seznam.cz header.b="dx2NQ4G4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgAUJRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 04:17:54 -0500
Received: from mxs2.seznam.cz ([77.75.76.125]:52620 "EHLO mxs2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgAUJRy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 04:17:54 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2020 04:17:52 EST
Received: from email.seznam.cz
        by email-smtpc10b.ng.seznam.cz (email-smtpc10b.ng.seznam.cz [10.23.14.45])
        id 665b938ad300f29866527659;
        Tue, 21 Jan 2020 10:17:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1579598270; bh=11V/WRJMhVLt/Jk+BSNeFSL8z5NFiwJOOmighuL7pHo=;
        h=Received:Reply-To:Subject:To:Cc:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dx2NQ4G44JTU0iiXzopo/YxfzBHAGrd70V6Zuo3EfCmKeucfbe+vX3mdWVit+Nk8N
         RGodWqhotLrhzc+BosTcn9bSOTeayGybrnuu30V4q56SH+t1wvht0OGdJseyONHHXQ
         CRA3HPg24j1STMQs6GkuuCAUYjrB0slPB+/06s9g=
Received: from [77.75.76.48] (unknown-62-130.xilinx.com [149.199.62.130])
        by email-relay3.ng.seznam.cz (Seznam SMTPD 1.3.108) with ESMTP;
        Tue, 21 Jan 2020 10:15:56 +0100 (CET)  
Reply-To: monstr@monstr.eu
Subject: Re: [PATCH V4 3/4] firmware: xilinx: Add ZynqMP aes API for AES
 functionality
To:     Kalyani Akula <kalyani.akula@xilinx.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <1574235842-7930-4-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <monstr@seznam.cz>
Message-ID: <3357664b-d502-ca0c-c166-679001de5f39@seznam.cz>
Date:   Tue, 21 Jan 2020 10:15:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1574235842-7930-4-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20. 11. 19 8:44, Kalyani Akula wrote:
> Add ZynqMP firmware AES API to perform encryption/decryption of given data.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
>  drivers/firmware/xilinx/zynqmp.c     | 23 +++++++++++++++++++++++
>  include/linux/firmware/xlnx-zynqmp.h |  2 ++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
> index fd3d837..7ddf38e 100644
> --- a/drivers/firmware/xilinx/zynqmp.c
> +++ b/drivers/firmware/xilinx/zynqmp.c
> @@ -664,6 +664,28 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
>  				   qos, ack, NULL);
>  }
>  
> +/**
> + * zynqmp_pm_aes - Access AES hardware to encrypt/decrypt the data using
> + * AES-GCM core.
> + * @address:	Address of the AesParams structure.
> + * @out:	Returned output value
> + *
> + * Return:	Returns status, either success or error code.
> + */
> +static int zynqmp_pm_aes_engine(const u64 address, u32 *out)
> +{
> +	u32 ret_payload[PAYLOAD_ARG_CNT];
> +	int ret;
> +
> +	if (!out)
> +		return -EINVAL;
> +
> +	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, upper_32_bits(address),
> +				  lower_32_bits(address),
> +				  0, 0, ret_payload);
> +	*out = ret_payload[1];

newline here please.

> +	return ret;
> +}


newline here please.

>  static const struct zynqmp_eemi_ops eemi_ops = {
>  	.get_api_version = zynqmp_pm_get_api_version,
>  	.get_chipid = zynqmp_pm_get_chipid,
> @@ -687,6 +709,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
>  	.set_requirement = zynqmp_pm_set_requirement,
>  	.fpga_load = zynqmp_pm_fpga_load,
>  	.fpga_get_status = zynqmp_pm_fpga_get_status,
> +	.aes = zynqmp_pm_aes_engine,
>  };
>  
>  /**
> diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
> index 778abbb..508edd7 100644
> --- a/include/linux/firmware/xlnx-zynqmp.h
> +++ b/include/linux/firmware/xlnx-zynqmp.h
> @@ -77,6 +77,7 @@ enum pm_api_id {
>  	PM_CLOCK_GETRATE,
>  	PM_CLOCK_SETPARENT,
>  	PM_CLOCK_GETPARENT,
> +	PM_SECURE_AES = 47,
>  };
>  
>  /* PMU-FW return status codes */
> @@ -294,6 +295,7 @@ struct zynqmp_eemi_ops {
>  			       const u32 capabilities,
>  			       const u32 qos,
>  			       const enum zynqmp_pm_request_ack ack);
> +	int (*aes)(const u64 address, u32 *out);
>  };
>  
>  int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
> 

Thanks,
Michal
