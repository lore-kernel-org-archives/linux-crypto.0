Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBACC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 17:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2161264F91
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 17:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBCRnx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhBCRnx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 12:43:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D8CC061573;
        Wed,  3 Feb 2021 09:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=iFfY1WaSGJqs+DmSwq5shO9uihFU5ehmjZPvFHOPYIU=; b=IukZhhKbIs0/Diopg6BlqTqtDw
        oQeDokyli3LwhwpCE+dAStYEbtBFIQ3AjS9AqOk2hZiZ7ffQdgHK0QwP/SZpu+XbvG7d+v3PPtXZ3
        EM89oenSnpniNhDvm+7ujlj+ElZsYFKD3yDvPWNa/ciQ32TXx+kuG4mOfY3XteCx7zGa0qerkU7kl
        lu8rov0vLL0v4rX9QxTHLglomjwQ2p/VzlskFhe5NljPbKWwxivI+Ykunzs7sQLo10oF66cJOd3lp
        fylA7YX8UseFC763zpTWjbLMkwDbabU7CdfO04EWB8PB4qklEDzi4C5ASv/A71ijHBzpCAaQ0k+jn
        A31gGMug==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7MBI-0001sU-Lp; Wed, 03 Feb 2021 17:43:08 +0000
Subject: Re: [PATCH] drivers: crypto: qat: qat_common: Two different lines fix
 the same spelling in the file adf_vf2pf_msg.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210203150148.25671-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e152d5c0-dc10-4b75-3709-378b2e6958d7@infradead.org>
Date:   Wed, 3 Feb 2021 09:43:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210203150148.25671-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/3/21 7:01 AM, Bhaskar Chowdhury wrote:
> 
> s/messge/message/  ..two different lines
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> index 2c98fb63f7b7..e85bd62d134a 100644
> --- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> +++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> @@ -8,7 +8,7 @@
>   * adf_vf2pf_init() - send init msg to PF
>   * @accel_dev:  Pointer to acceleration VF device.
>   *
> - * Function sends an init messge from the VF to a PF
> + * Function sends an init message from the VF to a PF
>   *
>   * Return: 0 on success, error code otherwise.
>   */
> @@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_init);
>   * adf_vf2pf_shutdown() - send shutdown msg to PF
>   * @accel_dev:  Pointer to acceleration VF device.
>   *
> - * Function sends a shutdown messge from the VF to a PF
> + * Function sends a shutdown message from the VF to a PF
>   *
>   * Return: void
>   */
> --
> 2.26.2
> 


-- 
~Randy

