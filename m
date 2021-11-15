Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B88C43217
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5255A63232
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbhKOUYq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 15:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344284AbhKOTYZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61210C04A193
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:32:44 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id u74so36642752oie.8
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y1TKddjxKZ5v+j9dZNgjQaGVeBF/kGBo0N15AUsK7L8=;
        b=V6Hux7zvB7lremLUtn3yHu5xFS6Z8EBAqeknZZPnplV4XLP/OE/3HdxArTFWXX6277
         HXygrRfJw8tEueaDPl13ofnLYjXcvpVq9QKVJr2siHWIgDnfKouT4kM/6fHU/3VE0e9K
         YvKxo9x8NonLsCzbR0S9c/9YXkV6rm2Ss2NtVPOLBmrPJNC/U1LrcmZgmKv92Ar5RvfS
         Vx+CdQHPENf99vKCeXJa8rO6sByHj3/NVwi3LyU7sr3siPXpNrKq+W+DRA1ua3RZzHz1
         z5bh+KQ9CmqpxX3Kx+Rhb6UgQEueZAaDpm+BTYFJStfvIHOhY42INnCK0rfl9uMRtozT
         +GUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y1TKddjxKZ5v+j9dZNgjQaGVeBF/kGBo0N15AUsK7L8=;
        b=Vp2UmjSobDwjKFFLkDVk3CKiuFf5G6nainx+6Qi/1bXOH1R49wwfwFQlPxFT6HKXLe
         9yk5Lw1zLJh/oU9S8RuT33CLLdaQhmpGoGvHpAH+Hse1RGueh8e8yavWjoOaaB9jpFnE
         jzajBnAftJlg5g6UhpljFaggTguMv9LhMW0P34WzJ72zinv+czXC8Ga+SSMSMciM1U3c
         8yPIk5/QkSYVudmwW2ko8m77fbj5/cYRrvlvyw4R9/a9hlT/lFrDL8hpGJ5ntLsysXLa
         Y3V+ZonXVdj7mWOUFI/ZNU2PJsfOwcR9ePf0qS8NDeJTh3HqDtMciesCYBp2KsnzL2oE
         udDQ==
X-Gm-Message-State: AOAM532C45vUVFh84/wYllViXZBc/WtfTUqHUD9YHO+nwsfp4RsCSnrq
        FOqED3NABPiNFbvtTI6U2eRZhQ==
X-Google-Smtp-Source: ABdhPJx+ctQTPfrO9WziAND3PxHA9yTsBw8L5+tuxONnM43DjPiOhuKuQ66TI40t4uivTyKlYnZp0w==
X-Received: by 2002:a05:6808:2187:: with SMTP id be7mr39151347oib.97.1637001164202;
        Mon, 15 Nov 2021 10:32:44 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w5sm1396878otk.70.2021.11.15.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:32:43 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:32:40 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v5 19/22] crypto: qce: Add 'sm8250-qce' compatible string
 check
Message-ID: <YZKnyAeIsv44DA9Y@builder.lan>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-20-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110105922.217895-20-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 10 Nov 04:59 CST 2021, Bhupesh Sharma wrote:

> Add 'sm8250-qce' compatible string check in qce crypto
> driver as we add support for sm8250 crypto device in the
> device-tree in the subsequent patch.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Both patch 19 and 20 can be squashed with the previous patch adding
sdm845 & ipq6018.

Regards,
Bjorn

> ---
>  drivers/crypto/qce/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 84ed9e253d5d..a7d7d7d5d02f 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -309,6 +309,7 @@ static const struct of_device_id qce_crypto_of_match[] = {
>  	/* Add compatible strings as per updated dt-bindings, here: */
>  	{ .compatible = "qcom,ipq6018-qce", },
>  	{ .compatible = "qcom,sdm845-qce", },
> +	{ .compatible = "qcom,sm8250-qce", },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> -- 
> 2.31.1
> 
